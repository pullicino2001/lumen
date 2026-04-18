# camera — RESERVED (v2)

Live camera viewfinder with approximate effect preview.

- CameraX integration (Android)
- Real-time grain + film look in viewfinder
- Manual controls (ISO, shutter, white balance)

Do not build anything in this folder until v2. All effect logic lives in
`core/services/effect_engine.dart` and `core/` models so this module can
consume it without changes to the shared layer.
