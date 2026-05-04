#include <flutter/runtime_effect.glsl>

// ── Geometry ───────────────────────────────────────────────────────────────
uniform vec2  uSize;
uniform vec2  uOffset;

// ── Basic editor ───────────────────────────────────────────────────────────
uniform float uExposure;
uniform float uContrast;
uniform float uHighlights;
uniform float uShadows;
uniform float uWhites;
uniform float uBlacks;
uniform float uTemperature;
uniform float uTint;
uniform float uSaturation;
uniform float uVibrance;

// ── Film stock (stages 6–8) ────────────────────────────────────────────────
uniform float uStockEnabled;   // 0 = bypass, 1 = apply
uniform float uStockIntensity; // 0–1 blend with pre-stock result

uniform vec3  uCMRow0;         // Colour matrix row 0 — how R is built from (R,G,B)
uniform vec3  uCMRow1;         // Colour matrix row 1 — G
uniform vec3  uCMRow2;         // Colour matrix row 2 — B

// Per-channel tone curves: [blackLift, toePow, shoulderStart, shoulderPow]
uniform vec4  uCurveR;
uniform vec4  uCurveG;
uniform vec4  uCurveB;

// Hue crossover shifts: [shadowHueDeg, shadowStr, highlightHueDeg, highlightStr]
uniform vec4  uHueShifts;

// ── Grain ───────────────────────────────────────────────────────────────────
uniform float uGrainIntensity;
uniform float uGrainSize;
uniform float uGrainType;
uniform float uGrainSeed;      // per-render random offset — never a static pattern

// ── Lens ────────────────────────────────────────────────────────────────────
uniform float uVignetteIntensity;
uniform float uVignetteShape;
uniform float uChromaticAberration;
uniform float uDistortion;

uniform sampler2D uTexture;

out vec4 fragColor;

// ── Helpers ────────────────────────────────────────────────────────────────

float luminance(vec3 c) { return dot(c, vec3(0.2126, 0.7152, 0.0722)); }

// Improved hash — avoids sin-based banding on some mobile GPUs
float hash2(vec2 p) {
  p = fract(p * vec2(0.1031, 0.1030));
  p += dot(p, p.yx + 33.33);
  return fract((p.x + p.y) * p.x);
}

// Smooth value noise — bilinear interpolation between cell corners gives
// soft, organic edges instead of hard pixel blocks
float valueNoise(vec2 p) {
  vec2 i = floor(p);
  vec2 f = fract(p);
  vec2 u = f * f * (3.0 - 2.0 * f);          // smoothstep curve
  return mix(
    mix(hash2(i),             hash2(i + vec2(1,0)), u.x),
    mix(hash2(i + vec2(0,1)), hash2(i + vec2(1,1)), u.x),
    u.y
  );
}

// Box-Muller: two uniform samples → one Gaussian sample (σ≈1)
// Gives the rare bright/dark spikes that real silver-halide grains produce
float gaussianNoise(vec2 p) {
  float u1 = clamp(valueNoise(p),              0.001, 0.999);
  float u2 =       valueNoise(p + vec2(13.7, 5.3));
  return sqrt(-2.0 * log(u1)) * cos(6.28318 * u2);
}

vec3 rgb2hsl(vec3 c) {
  float mx = max(c.r, max(c.g, c.b));
  float mn = min(c.r, min(c.g, c.b));
  float l  = (mx + mn) * 0.5;
  float s  = 0.0, h = 0.0, d = mx - mn;
  if (d > 0.001) {
    s = l > 0.5 ? d / (2.0 - mx - mn) : d / (mx + mn);
    if      (mx == c.r) h = (c.g - c.b) / d + (c.g < c.b ? 6.0 : 0.0);
    else if (mx == c.g) h = (c.b - c.r) / d + 2.0;
    else                h = (c.r - c.g) / d + 4.0;
    h /= 6.0;
  }
  return vec3(h, s, l);
}

float hue2rgb(float p, float q, float t) {
  t = fract(t);
  if (t < 1.0/6.0) return p + (q - p) * 6.0 * t;
  if (t < 0.5)     return q;
  if (t < 2.0/3.0) return p + (q - p) * (2.0/3.0 - t) * 6.0;
  return p;
}

vec3 hsl2rgb(vec3 c) {
  if (c.y < 0.001) return vec3(c.z);
  float q = c.z < 0.5 ? c.z*(1.0+c.y) : c.z+c.y-c.z*c.y;
  float p = 2.0*c.z - q;
  return vec3(hue2rgb(p,q,c.x+1.0/3.0), hue2rgb(p,q,c.x), hue2rgb(p,q,c.x-1.0/3.0));
}

// ── Film curve (stage 7) ──────────────────────────────────────────────────
// Parametric tone curve with shadow lift, toe shaping, and shoulder rolloff.
float filmCurve(float x, vec4 p) {
  float blackLift    = p.x;
  float toePow       = p.y;
  float shoulderSt   = p.z;
  float shoulderPow  = p.w;

  // Lift black point
  float y = mix(blackLift, 1.0, clamp(x, 0.0, 1.0));

  // Toe shaping in shadow region
  float toeBlend = 1.0 - smoothstep(0.0, shoulderSt * 0.55, y);
  y = mix(y, pow(max(y, 0.001), toePow), toeBlend);

  // Shoulder compression in highlight region
  float shoulderBlend = smoothstep(shoulderSt, 1.0, y);
  float shouldered    = 1.0 - pow(max(1.0 - y, 0.001), shoulderPow);
  y = mix(y, shouldered, shoulderBlend);

  return clamp(y, 0.0, 1.0);
}

// ── Hue crossover shifts (stage 8) ────────────────────────────────────────
// Rotates hue in shadow and highlight regions independently.
vec3 applyHueShifts(vec3 c, vec4 hs) {
  vec3 hsl = rgb2hsl(c);
  if (hsl.y < 0.015) return c;  // leave achromatic pixels untouched

  float luma       = luminance(c);
  float shadowW    = (1.0 - smoothstep(0.0, 0.45, luma)) * hs.y;
  float highlightW = smoothstep(0.55, 1.0, luma) * hs.w;
  float totalShift = (hs.x * shadowW + hs.z * highlightW) / 360.0;

  hsl.x = fract(hsl.x + totalShift);
  return hsl2rgb(hsl);
}

// ── Lens distortion ────────────────────────────────────────────────────────
vec2 applyDistortion(vec2 uv, float k) {
  vec2 d = uv - 0.5;
  return uv + d * dot(d, d) * k;
}

// ── Main ───────────────────────────────────────────────────────────────────

void main() {
  vec2 uv = (FlutterFragCoord().xy - uOffset) / uSize;

  // ── Lens: distortion + chromatic aberration ───────────────────────────
  vec2  dUV  = applyDistortion(uv, uDistortion);
  vec2  dir  = dUV - 0.5;
  float caOff = uChromaticAberration * 0.015;
  float cr = texture(uTexture, dUV + dir * caOff).r;
  float cg = texture(uTexture, dUV).g;
  float cb = texture(uTexture, dUV - dir * caOff).b;
  float ca = texture(uTexture, dUV).a;
  vec3  c  = vec3(cr, cg, cb);

  // ── Basic editor ─────────────────────────────────────────────────────
  c *= pow(2.0, uExposure);
  c  = (c - 0.5) * (1.0 + uContrast / 100.0) + 0.5;

  float luma = luminance(c);
  c += smoothstep(0.5, 1.0, luma) * (uHighlights / 200.0);
  c += smoothstep(0.5, 0.0, luma) * (uShadows    / 200.0);
  c += pow(c,       vec3(3.0)) * ( uWhites /  150.0);
  c -= pow(1.0 - c, vec3(3.0)) * ( uBlacks / -150.0);

  float temp = (uTemperature - 5500.0) / 3500.0;
  c.r += temp * 0.08;  c.g += temp * 0.02;  c.b -= temp * 0.08;

  float tint = uTint / 100.0;
  c.g += tint * 0.05;  c.r -= tint * 0.025;  c.b -= tint * 0.025;

  vec3 hsl = rgb2hsl(c);
  hsl.y = clamp(hsl.y * (1.0 + uSaturation / 100.0), 0.0, 1.0);
  c = hsl2rgb(hsl);

  hsl = rgb2hsl(c);
  hsl.y = clamp(hsl.y + (1.0 - hsl.y) * (uVibrance / 100.0) * 0.5, 0.0, 1.0);
  c = hsl2rgb(hsl);

  c = clamp(c, 0.0, 1.0);

  // ── Film stock (stages 6–8) ───────────────────────────────────────────
  if (uStockEnabled > 0.5) {
    vec3 pre = c;

    // Stage 6: Dye coupler colour matrix
    c = vec3(dot(c, uCMRow0), dot(c, uCMRow1), dot(c, uCMRow2));
    c = clamp(c, 0.0, 1.0);

    // Stage 7: Per-channel tone curves
    c = vec3(
      filmCurve(c.r, uCurveR),
      filmCurve(c.g, uCurveG),
      filmCurve(c.b, uCurveB)
    );

    // Stage 8: Hue crossover shifts
    c = applyHueShifts(c, uHueShifts);

    // Blend with pre-stock result
    c = mix(pre, c, uStockIntensity);
  }

  // ── Grain ────────────────────────────────────────────────────────────────
  if (uGrainIntensity > 0.0) {
    float luma = luminance(c);
    // Tapers smoothly to near-zero in bright highlights — real grain lives in shadows
    float sw = 1.0 - smoothstep(0.15, 0.95, luma);

    // Per-render seed shifts the sample space so grain is never a static burn-in
    vec2 seedOff = vec2(uGrainSeed * 127.1, uGrainSeed * 311.7);
    vec2 p = FlutterFragCoord().xy / uGrainSize + seedOff;

    // Two octaves: large structure + fine detail within each grain cluster
    float g1 = gaussianNoise(p);
    float g2 = gaussianNoise(p * 2.3 + vec2(5.4, 1.1));
    // Clamp to ±3σ then normalize to [-1, 1] — preserves the occasional spike
    float g  = clamp(g1 * 0.7 + g2 * 0.3, -3.0, 3.0) / 3.0;

    float grainVal = g * uGrainIntensity * sw;

    if (uGrainType < 0.5) {
      c += vec3(grainVal);
    } else {
      // Independent Gaussian per channel for colour grain
      vec2 pr = p + vec2(17.3,  1.7);
      vec2 pb = p + vec2(51.3,  7.9);
      float gr = clamp(gaussianNoise(pr) * 0.7 + gaussianNoise(pr * 2.3) * 0.3, -3.0, 3.0) / 3.0;
      float gb = clamp(gaussianNoise(pb) * 0.7 + gaussianNoise(pb * 2.3) * 0.3, -3.0, 3.0) / 3.0;
      c += vec3(gr * uGrainIntensity * sw, grainVal, gb * uGrainIntensity * sw);
    }
  }

  // ── Vignette ─────────────────────────────────────────────────────────
  if (uVignetteIntensity > 0.0) {
    float circ = length(uv - 0.5) * 2.0;
    float rect = max(abs(uv.x - 0.5), abs(uv.y - 0.5)) * 2.828;
    float dist = mix(circ, rect, uVignetteShape);
    c *= clamp(1.0 - uVignetteIntensity * smoothstep(0.3, 1.2, dist), 0.0, 1.0);
  }

  fragColor = vec4(clamp(c, 0.0, 1.0), ca);
}
