#include <flutter/runtime_effect.glsl>

uniform vec2  uSize;
uniform float uThreshold;
uniform float uSoftness;
uniform vec3  uTint;

uniform sampler2D uTexture;
out vec4 fragColor;

float luminance(vec3 c) { return dot(c, vec3(0.2126, 0.7152, 0.0722)); }

void main() {
  vec2 uv    = FlutterFragCoord().xy / uSize;
  vec2 uvFlp = vec2(uv.x, 1.0 - uv.y);
  vec3 c = texture(uTexture, clamp(uvFlp, 0.001, 0.999)).rgb;
  float mask = smoothstep(uThreshold - uSoftness, uThreshold + uSoftness, luminance(c));
  fragColor = vec4(c * uTint * mask, 1.0);
}
