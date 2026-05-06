# LUMEN

## SNAPSHOT
**Status:** Active
**Last worked on:** 2026-05-06
**What works:** Full simulation pipeline, basic editor, grain/bloom/lens/film layers, HUD gestures, histogram, EXIF, export with format selector. `toPromptFragment()` wired for all models — camera + film stock + lens fragments assemble into real AI prompts via `GenerationPromptBuilder`.
**What's broken / in progress:** GenerationService + AIModelConfigService still stubbed (v4 feature — prompt assembly is now ready).
**Next step:** Wire `CameraProfile` and new film/lens profiles into the editor UI picker panels so users can select them.

## DECISIONS
- 2026-04-18 Grain + lens profiles integrated as pipeline stages
- 2026-04-18 LUT integration for film stock rendering
- 2026-04-19 Edit approach refactored to non-destructive EditState
- 2026-05-04 Parametric FilmStock model replacing LUT-only approach
- 2026-05-06 v4 prompt system: CameraProfile model added, promptFragment on all models, GenerationPromptBuilder assembles camera→film→lens order

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
