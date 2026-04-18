# generation — RESERVED (v4)

AI image generation UI (Pro Max tier).

- User effect stack translated into a model prompt via GenerationPromptBuilder
- img2img call dispatched through GenerationService + AIModelConfigService
- Returned image treated as a new photo in the editor

Do not build anything in this folder until v4. GenerationService and
AIModelConfigService are stubbed in core/services/ from v1.
