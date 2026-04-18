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

// ── Film LUT ────────────────────────────────────────────────────────────────
uniform float uLutSize;
uniform float uLutIntensity;

// ── Grain ───────────────────────────────────────────────────────────────────
uniform float uGrainIntensity;
uniform float uGrainSize;   // 1=fine  2=medium  4=coarse
uniform float uGrainType;   // 0=luminance  1=colour

// ── Lens ────────────────────────────────────────────────────────────────────
uniform float uVignetteIntensity;
uniform float uVignetteShape;       // 0=circular  1=rectangular
uniform float uChromaticAberration;
uniform float uDistortion;          // >0 barrel  <0 pincushion

uniform sampler2D uTexture;
uniform sampler2D uLut;

out vec4 fragColor;

// ── Helpers ────────────────────────────────────────────────────────────────

float luminance(vec3 c) { return dot(c, vec3(0.2126, 0.7152, 0.0722)); }

float hash(vec2 p) {
  return fract(sin(dot(p, vec2(12.9898, 78.233))) * 43758.5453);
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

// Manual trilinear LUT lookup — avoids B-slice boundary artefacts.
vec3 sampleLut(vec3 c) {
  float n  = uLutSize;
  float tw = n * n;
  vec3 sc  = clamp(c, 0.0, 1.0) * (n - 1.0);
  float r0 = floor(sc.r), r1 = min(r0+1.0, n-1.0);
  float g0 = floor(sc.g), g1 = min(g0+1.0, n-1.0);
  float b0 = floor(sc.b), b1 = min(b0+1.0, n-1.0);
  float rf = fract(sc.r), gf = fract(sc.g), bf = fract(sc.b);

  vec3 c000=texture(uLut,vec2((b0*n+r0+0.5)/tw,(g0+0.5)/n)).rgb;
  vec3 c100=texture(uLut,vec2((b0*n+r1+0.5)/tw,(g0+0.5)/n)).rgb;
  vec3 c010=texture(uLut,vec2((b0*n+r0+0.5)/tw,(g1+0.5)/n)).rgb;
  vec3 c110=texture(uLut,vec2((b0*n+r1+0.5)/tw,(g1+0.5)/n)).rgb;
  vec3 c001=texture(uLut,vec2((b1*n+r0+0.5)/tw,(g0+0.5)/n)).rgb;
  vec3 c101=texture(uLut,vec2((b1*n+r1+0.5)/tw,(g0+0.5)/n)).rgb;
  vec3 c011=texture(uLut,vec2((b1*n+r0+0.5)/tw,(g1+0.5)/n)).rgb;
  vec3 c111=texture(uLut,vec2((b1*n+r1+0.5)/tw,(g1+0.5)/n)).rgb;

  return mix(
    mix(mix(c000,c100,rf), mix(c010,c110,rf), gf),
    mix(mix(c001,c101,rf), mix(c011,c111,rf), gf),
    bf
  );
}

// Barrel (k>0) or pincushion (k<0) distortion.
vec2 applyDistortion(vec2 uv, float k) {
  vec2 d = uv - 0.5;
  return uv + d * dot(d, d) * k;
}

// ── Main ───────────────────────────────────────────────────────────────────

void main() {
  vec2 uv = (FlutterFragCoord().xy - uOffset) / uSize;

  // ── Lens: distortion + chromatic aberration (applied at sample time) ──
  vec2  dUV  = applyDistortion(uv, uDistortion);
  vec2  dir  = dUV - 0.5;
  float caOff = uChromaticAberration * 0.015;
  float cr = texture(uTexture, dUV + dir * caOff).r;
  float cg = texture(uTexture, dUV).g;
  float cb = texture(uTexture, dUV - dir * caOff).b;
  float ca = texture(uTexture, dUV).a;
  vec3  c  = vec3(cr, cg, cb);

  // ── Basic editor ──────────────────────────────────────────────────────
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

  // ── Film LUT ──────────────────────────────────────────────────────────
  c = mix(c, sampleLut(c), uLutIntensity);

  // ── Grain (shadow-weighted) ───────────────────────────────────────────
  if (uGrainIntensity > 0.0) {
    float sw = 1.0 - luminance(c) * 0.8;
    vec2  gc = floor(FlutterFragCoord().xy / uGrainSize);
    float base = (hash(gc)                    * 2.0 - 1.0) * uGrainIntensity * sw;
    if (uGrainType < 0.5) {
      c += vec3(base);
    } else {
      float gr = (hash(gc + vec2(17.3,  1.7)) * 2.0 - 1.0) * uGrainIntensity * sw;
      float gb = (hash(gc + vec2(51.3,  7.9)) * 2.0 - 1.0) * uGrainIntensity * sw;
      c += vec3(gr, base, gb);
    }
  }

  // ── Vignette (applied last) ───────────────────────────────────────────
  if (uVignetteIntensity > 0.0) {
    float circ = length(uv - 0.5) * 2.0;
    float rect = max(abs(uv.x - 0.5), abs(uv.y - 0.5)) * 2.828;
    float dist = mix(circ, rect, uVignetteShape);
    c *= clamp(1.0 - uVignetteIntensity * smoothstep(0.3, 1.2, dist), 0.0, 1.0);
  }

  fragColor = vec4(clamp(c, 0.0, 1.0), ca);
}
