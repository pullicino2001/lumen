#include <flutter/runtime_effect.glsl>

uniform vec2  uSize;
uniform vec2  uDirection;  // (1,0) horizontal  (0,1) vertical
uniform float uSigma;      // blur radius in pixels

uniform sampler2D uTexture;
out vec4 fragColor;

void main() {
  vec2 uv     = FlutterFragCoord().xy / uSize;
  vec2 baseUV = vec2(uv.x, 1.0 - uv.y);
  vec3 result = vec3(0.0);
  float total = 0.0;

  // 21-tap separable Gaussian (-10 … +10)
  for (int i = -10; i <= 10; i++) {
    float x = float(i);
    float w = exp(-x * x / (2.0 * uSigma * uSigma + 0.001));
    vec2 sampleUV = clamp(baseUV + uDirection * x / uSize, 0.001, 0.999);
    result += texture(uTexture, sampleUV).rgb * w;
    total  += w;
  }

  fragColor = vec4(result / total, 1.0);
}
