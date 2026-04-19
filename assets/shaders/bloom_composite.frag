#include <flutter/runtime_effect.glsl>

uniform vec2  uSize;
uniform float uBloomIntensity;
uniform float uHalationIntensity;

uniform sampler2D uOriginal;
uniform sampler2D uBloom;
uniform sampler2D uHalation;

out vec4 fragColor;

void main() {
  vec2 uv  = FlutterFragCoord().xy / uSize;
  vec2 fuv = vec2(uv.x, 1.0 - uv.y);

  vec3 orig     = texture(uOriginal,  fuv).rgb;
  vec3 bloom    = texture(uBloom,     fuv).rgb;
  vec3 halation = texture(uHalation,  fuv).rgb;

  // Screen blend for bloom (brightens without washing out)
  vec3 result = orig + bloom * uBloomIntensity - orig * bloom * uBloomIntensity;

  // Additive for halation (warm film bleed)
  result += halation * uHalationIntensity;

  fragColor = vec4(clamp(result, 0.0, 1.0), 1.0);
}
