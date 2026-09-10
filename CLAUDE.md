# LUMEN

## SNAPSHOT
**Status:** Active
**Last worked on:** 2026-09-10
**What works:** Full simulation pipeline, basic editor, grain/bloom/lens/film layers, HUD gestures, histogram, EXIF, export with format selector. `toPromptFragment()` wired for all models — camera + film stock + lens fragments assemble into real AI prompts via `GenerationPromptBuilder`. Simulation tab talks to Atlas Cloud (config-gated to provider `atlas`, injectable HTTP client, 68 unit tests, all green).
**What's broken / in progress:** Grain/Bloom `toPromptFragment()` still return ''. DeviceTierService model detection never matches on Android (reads `Platform.operatingSystemVersion`, needs device_info_plus) and `deviceTierProvider` is unused. An AI result loaded via "Use in editor" is lost when the entry is reopened from the gallery (paths are patched back to the source on save). `.env` is bundled as an asset, so the Atlas key ships inside the APK.
**Testing:** No Flutter on the host — run `flutter analyze`/`flutter test`/`build_runner` inside `ghcr.io/cirruslabs/flutter:stable` (root + chown, `lumen-pubcache` volume). `build.yaml` sets `explicit_to_json: true`; regenerate after touching any freezed model.
**Next step:** Wire `CameraProfile` and new film/lens profiles into the editor UI picker panels so users can select them.

## DECISIONS
- 2026-04-18 Grain + lens profiles integrated as pipeline stages
- 2026-04-18 LUT integration for film stock rendering
- 2026-04-19 Edit approach refactored to non-destructive EditState
- 2026-05-04 Parametric FilmStock model replacing LUT-only approach
- 2026-05-06 v4 prompt system: CameraProfile model added, promptFragment on all models, GenerationPromptBuilder assembles camera→film→lens order
- 2026-09-10 AtlasCloudService only honours `ai_model_config.json` when provider == `atlas`; anything else logs once and uses built-in defaults. Config `parameters` can never override model/image/prompt/strength.
- 2026-09-10 Gallery index mutations are serialised through a Future chain and written atomically (tmp + rename); stored EditState JSON is normalised to plain maps.
- 2026-09-10 Legacy panel widgets (BasicEditorPanel, BloomPanel, GrainPanel, LensProfileStrip, StockStrip, GenerateButton) and simulation_presets.dart removed — Mod* modules are the only editor UI.

## LOG
- 2026-04-18 Initial grain, lens profiles, LUT integration
- 2026-04-19 Non-destructive edit approach, bug fixes
- 2026-04-30 Big update (details in commit)
- 2026-05-02 General fixes
- 2026-05-03 Fullscreen preview on single tap, export format selector
- 2026-05-04 Major update
- 2026-05-06 HUD gestures, live histogram, real EXIF, compare panel, version bump
- 2026-05-06 Fix swipe-to-hide HUDs and histogram computation
- 2026-05-06 v4 Generator: promptFragment on FilmStock + LensProfile, CameraProfile model + 11 profiles, 12 film stocks with real fragments, 10 real named lens profiles, GenerationPromptBuilder updated, unit test passes
- 2026-09-10 Review pass, 14 fixes in 14 commits: .env optional at launch; Atlas config/poll-URL/param-precedence + HTTP timeouts; simulation cancel race; LUMEN proxy regeneration on image change; sheet height jump; prompt fragment ordering; gallery write serialisation + atomic index; crash reopening a fresh import (explicit_to_json); baseline curve hardening; film stock ISO/code fields; lens aperture label; dead widgets removed; typed sheet meta + model label. Tests 37 → 68.
