#include <flutter/runtime_effect.glsl>

uniform vec2 uSize;
uniform vec2 uOffset;
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
uniform sampler2D uTexture;

out vec4 fragColor;

float luminance(vec3 c) {
  return dot(c, vec3(0.2126, 0.7152, 0.0722));
}

vec3 rgb2hsl(vec3 c) {
  float maxC = max(c.r, max(c.g, c.b));
  float minC = min(c.r, min(c.g, c.b));
  float l = (maxC + minC) * 0.5;
  float s = 0.0;
  float h = 0.0;
  float d = maxC - minC;
  if (d > 0.001) {
    s = l > 0.5 ? d / (2.0 - maxC - minC) : d / (maxC + minC);
    if (maxC == c.r)      h = (c.g - c.b) / d + (c.g < c.b ? 6.0 : 0.0);
    else if (maxC == c.g) h = (c.b - c.r) / d + 2.0;
    else                  h = (c.r - c.g) / d + 4.0;
    h /= 6.0;
  }
  return vec3(h, s, l);
}

float hue2rgb(float p, float q, float t) {
  t = fract(t);
  if (t < 1.0 / 6.0) return p + (q - p) * 6.0 * t;
  if (t < 0.5)        return q;
  if (t < 2.0 / 3.0)  return p + (q - p) * (2.0 / 3.0 - t) * 6.0;
  return p;
}

vec3 hsl2rgb(vec3 c) {
  if (c.y < 0.001) return vec3(c.z);
  float q = c.z < 0.5 ? c.z * (1.0 + c.y) : c.z + c.y - c.z * c.y;
  float p = 2.0 * c.z - q;
  return vec3(
    hue2rgb(p, q, c.x + 1.0 / 3.0),
    hue2rgb(p, q, c.x),
    hue2rgb(p, q, c.x - 1.0 / 3.0)
  );
}

void main() {
  vec2 uv = (FlutterFragCoord().xy - uOffset) / uSize;
  vec4 original = texture(uTexture, uv);
  vec3 c = original.rgb;

  // Exposure (EV stops)
  c *= pow(2.0, uExposure);

  // Contrast (pivot at mid-grey)
  c = (c - 0.5) * (1.0 + uContrast / 100.0) + 0.5;

  // Highlights & Shadows (luminance-weighted)
  float luma = luminance(c);
  c += smoothstep(0.5, 1.0, luma) * (uHighlights / 200.0);
  c += smoothstep(0.5, 0.0, luma) * (uShadows   / 200.0);

  // Whites & Blacks (cubic weighting — strong effect near endpoints)
  c += pow(c,       vec3(3.0)) * (uWhites /  150.0);
  c -= pow(1.0 - c, vec3(3.0)) * (uBlacks / -150.0);

  // Temperature (blue-yellow axis; neutral = 5500 K)
  float temp = (uTemperature - 5500.0) / 3500.0;
  c.r += temp * 0.08;
  c.g += temp * 0.02;
  c.b -= temp * 0.08;

  // Tint (magenta-green axis)
  float tint = uTint / 100.0;
  c.g += tint * 0.05;
  c.r -= tint * 0.025;
  c.b -= tint * 0.025;

  // Saturation
  vec3 hsl = rgb2hsl(c);
  hsl.y = clamp(hsl.y * (1.0 + uSaturation / 100.0), 0.0, 1.0);
  c = hsl2rgb(hsl);

  // Vibrance (boosts less-saturated pixels more)
  hsl = rgb2hsl(c);
  hsl.y = clamp(hsl.y + (1.0 - hsl.y) * (uVibrance / 100.0) * 0.5, 0.0, 1.0);
  c = hsl2rgb(hsl);

  fragColor = vec4(clamp(c, 0.0, 1.0), original.a);
}
