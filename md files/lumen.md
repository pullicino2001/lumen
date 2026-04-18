# LUMEN — Claude Code Session Parameters
> This file is the single source of truth for all development decisions on LUMEN.
> Read this fully at the start of every session before writing any code.
> Never contradict these parameters without explicit instruction from Peter.

---

## 1. Project Identity

| Field | Value |
|---|---|
| App name | LUMEN (placeholder — rename when finalised) |
| Type | Mobile photo editing app |
| Platform target | Android first, iOS second |
| Primary audience | Android photographers on Pixel and Samsung flagships |
| Positioning | *"A darkroom for every camera"* — aesthetic photo editing with film stock + lens character simulation |
| Competitive reference | Leica LUX (iOS only, live camera) — LUMEN is the Android, editor-first counterpart |
| Business model | Free tier + Pro subscription + Pro Max subscription (via RevenueCat) |
| Repo | GitHub (new repo — link to be added when created) |

---

## 2. Tech Stack — Locked Decisions

These are confirmed. Do not suggest alternatives without a strong reason.

| Layer | Choice | Notes |
|---|---|---|
| Framework | Flutter (Dart) | Cross-platform, Peter is already learning via WeddingOS |
| Language | Dart | Consistent across entire app |
| Image processing | `image` package + custom GLSL shaders | GPU-accelerated via Flutter's fragment shader API |
| LUT processing | GLSL fragment shader (.frag files) | `.cube` LUT files loaded and applied on GPU |
| AI generation API | Model-agnostic via `ai_model_config.json` | Active model swapped via config — Flux, Nano Banana, or any img2img API |
| AI enhancement API | Model-agnostic via `ai_model_config.json` | Upscaling + shadow/detail recovery — separate model slot from generation |
| Format ingestion | `image` + native decoders + DNG conversion | All formats converted to DNG as working format before pipeline begins |
| Subscriptions | RevenueCat | Handles Google Play + App Store billing |
| Storage | Local only (v1) | No backend, no cloud sync in v1 |
| State management | Riverpod | Clean, testable, scales well |
| Platform channels | Kotlin (Android) | For Pixel/Samsung native APIs in v2+ |
| Version control | Git / GitHub | New repo |

---

## 3. Architecture Principles

### 3a. The Effect Pipeline
This is the core of the app. Every architectural decision must preserve it.

```
[Photo Input — any format]
      ↓
[Format Ingestion Service]  ← converts to DNG working format
      ↓
[Basic Editor Layer]        ← exposure, contrast, highlights, shadows, whites, blacks,
      ↓                        temperature, tint, clarity, saturation (adjustable at any point)
[Lens Profile Layer]        ← vignette, chromatic aberration, corner softness, distortion
      ↓
[Film Look Layer]           ← LUT-based colour grade (.cube files)
      ↓
[Grain Layer]               ← luminance/colour grain, shadow-weighted
      ↓
[Bloom & Halation Layer]    ← highlight glow + warm edge bleed
      ↓
[AI Enhancement Layer]      ← upscaling + shadow/detail recovery (tier TBD)
      ↓
[Export]                    ← standard output (Free / Pro)

— OR —

[Photo Input — any format]
      ↓
[Format Ingestion Service]  ← converts to DNG working format
      ↓
[Basic Editor Layer]        ← pre-generation adjustments (optional)
      ↓
[Effect Stack Selection]    ← user picks lens profile + film look + grain + bloom settings
      ↓
[Generation Service]        ← settings translated into model prompt + img2img call (Pro Max)
      ↓
[AI Regenerated Image]      ← returned from cloud, treated as new photo in the editor
      ↓
[Basic Editor Layer]        ← post-generation fine-tuning (optional)
      ↓
[Export]
```

**Rules:**
- Every layer is **independent** — changing one never forces a change in another
- Every layer has an **intensity slider** (0–100)
- Every layer can be **toggled off** without losing its settings
- The pipeline must be **non-destructive** — original photo is never modified
- The **Basic Editor layer is always accessible** — before effects, after effects, or after generation. It is never locked to one position in the workflow
- All photos are **converted to DNG** as the working format before the pipeline begins — this is the single internal format throughout
- Pipeline must be designed so **new layers can be added** without refactoring existing ones

### 3b. The Live Camera Window
> **This is not built in v1. But the architecture must leave the door open.**

The app's folder and module structure must anticipate a `camera/` module that will eventually:
- Access the device camera via `camera` Flutter plugin or CameraX (Android native)
- Show a live preview with an **approximate** version of the selected effect stack
- Use depth map data (Pixel / Samsung) for lens simulation in live view
- Improve in accuracy over time — v1 live preview can be low fidelity, that is acceptable

**How to preserve this window:**
- Keep all effect logic in a shared `effects/` module that both the editor AND the future camera module can call
- Never hardcode effects to only work on static images
- The `LensProfile` and `FilmLook` models must be camera-agnostic data structures
- Do not build UI that assumes photo editing is the only entry point

### 3c. The Generation Window
> **This is not built in v1. But the architecture must leave the door open.**

The generation tier uses the user's effect stack selections as structured data that gets **translated into an AI prompt** and sent to a cloud image-to-image API. The AI regenerates the entire image as if it was genuinely captured with those characteristics — not a filter applied on top, but a ground-up reinterpretation.

**The backend is model-agnostic by design.** The active model is controlled by a server-side config file (`ai_model_config.json`) that Peter manages. Swapping from Flux to Nano Banana to any future model requires only a config change — no code change, no app update. See section 3e for the full model config spec.

**How this differs from the simulation pipeline:**
- Simulation (Pro): LUTs + shaders applied on top of the original photo
- Generation (Pro Max): original photo used as structural reference, AI produces a new image *embodying* the chosen aesthetic

**How to preserve this window:**
- The `LensProfile`, `FilmLook`, `GrainSettings`, and `BloomSettings` models must each expose a `toPromptFragment()` method — a plain text description of the aesthetic — even if it returns an empty string in v1
- A `GenerationService` class must be stubbed out in `core/services/` from the start, even if it does nothing in v1
- The editor UI must have a placeholder `Generate` button path that is gated behind Pro Max — never assume export is the only output
- Generated images are returned and treated as a **new photo** in the editor — they can then have simulation effects applied on top if desired

### 3e. Model-Agnostic AI Backend
> **This applies to both generation (Pro Max) and AI enhancement (upscaling/detail recovery).**

All AI model calls are routed through a single `AIModelConfig` system. Peter controls which model is active via a config file — no app updates required to swap models.

**Config file location:** `assets/config/ai_model_config.json`

**Structure:**
```json
{
  "generation": {
    "provider": "replicate",
    "model_id": "black-forest-labs/flux-1.1-pro",
    "endpoint": "https://api.replicate.com/v1/predictions",
    "api_key_env": "LUMEN_GENERATION_API_KEY",
    "parameters": {
      "strength": 0.75,
      "guidance_scale": 7.5
    }
  },
  "enhancement": {
    "provider": "replicate",
    "model_id": "nightmareai/real-esrgan",
    "endpoint": "https://api.replicate.com/v1/predictions",
    "api_key_env": "LUMEN_ENHANCEMENT_API_KEY",
    "parameters": {
      "scale": 2,
      "face_enhance": false
    }
  }
}
```

**Rules:**
- The app **never hardcodes a model name or provider URL** anywhere in Dart code
- `AIModelConfigService` reads this config at startup and exposes it to `GenerationService` and `EnhancementService`
- Swapping a model = update the config file only. No Dart changes needed.
- Each model slot (`generation`, `enhancement`) is independent — they can use different providers
- If a config key is missing or malformed, the relevant feature is **gracefully disabled** with a logged warning — never a crash
- API keys are **never stored in the config file in the repo** — use environment variables or a secure secrets manager

### 3f. AI Enhancement Window
> **This is not built in v1. But the architecture must leave the door open.**

The enhancement layer handles two distinct operations, both cloud-based:
- **Upscaling:** increase output resolution beyond the original (e.g. 2x, 4x)
- **Detail/shadow recovery:** AI inference to recover lost detail in crushed shadows, blown highlights, or compressed images

**How to preserve this window:**
- An `EnhancementService` class must be stubbed out in `core/services/` from day one
- The export flow must have a placeholder for enhancement options — even if greyed out in v1
- Enhancement runs **after** the full simulation pipeline, immediately before export
- Enhancement and generation are **separate features** — a user can enhance a simulated image OR enhance a generated image


The app detects hardware at launch and unlocks capabilities accordingly:

| Tier | Devices | Capabilities |
|---|---|---|
| **Full** | Pixel 8 Pro+, Samsung S23+, Z Fold/Flip | Full effect stack, depth-based bokeh (v2+), RAW support |
| **Standard** | Most mid-range Android | Full colour/grain/bloom stack, software vignette only |
| **Basic** | Older / low-power devices | Film looks + grain only, no real-time preview |

This tiering must be **graceful** — the app never crashes or shows errors on lower tiers, it simply shows fewer options.

---

## 4. Effect & Feature Specifications

### Format Ingestion
All imported photos are converted to **DNG** as the internal working format before anything else happens. This is non-negotiable — it ensures the pipeline always works on a known, lossless format regardless of source.

**Supported input formats:**
| Category | Formats |
|---|---|
| Compressed | JPEG, HEIC, HEIF, WebP, PNG, AVIF |
| Uncompressed | TIFF, BMP |
| RAW — Android native | DNG (passthrough) |
| RAW — Camera manufacturers | CR2, CR3 (Canon), NEF, NRW (Nikon), ARW, SRF (Sony), RW2 (Panasonic), ORF (Olympus), RAF (Fuji), PEF (Pentax), 3FR (Hasselblad), IIQ (Phase One) |
| RAW — Other | RAW, RWL, MRW, DCR, KDC, SRW, ERF |

- Conversion handled by `FormatIngestionService`
- If a format cannot be decoded, user sees a clear error — never a silent failure
- Original file is **never modified** — conversion produces a new working DNG in app's temp storage
- Metadata (EXIF, GPS, camera model) is **preserved** through conversion

### Basic Editor
Non-destructive adjustments accessible at any point in the workflow — before effects, after effects, or after generation. Parameters are stored separately from the effect stack and applied as a distinct pipeline layer.

**Parameters:**
| Control | Range | Notes |
|---|---|---|
| Exposure | -5 to +5 EV | Overall brightness |
| Contrast | -100 to +100 | Midtone contrast |
| Highlights | -100 to +100 | Recover blown highlights |
| Shadows | -100 to +100 | Lift or crush shadows |
| Whites | -100 to +100 | White point |
| Blacks | -100 to +100 | Black point |
| Temperature | 2000K–16000K | Warm/cool |
| Tint | -150 to +150 | Green/magenta |
| Clarity | -100 to +100 | Midtone contrast/texture |
| Saturation | -100 to +100 | Global colour intensity |
| Vibrance | -100 to +100 | Intelligent saturation (protects skin tones) |

- Applied via GLSL shader pass
- All values default to neutral (0 or midpoint) — no invisible adjustments
- Stored as `BasicEditorSettings` model with its own `toPromptFragment()` method

### AI Enhancement
> Tier: TBD. Stubbed in v1.

Two sub-features, both routed through `EnhancementService` and the model-agnostic config:

- **Upscaling:** 2x or 4x resolution increase. Applied post-pipeline, pre-export.
- **Shadow & detail recovery:** AI inference to recover detail lost to compression, shadow crushing, or highlight clipping. Applied as a pre-processing step before the simulation pipeline begins, so the effects work on the best possible source data.


- Stored as `.cube` files in `assets/luts/`
- Applied via GLSL fragment shader
- Naming convention: `look_[name]_[variant].cube` e.g. `look_leica_classic.cube`
- Free tier: 3 looks unlocked
- Each look has: name, description, a preview thumbnail, and a `tier` (free/pro)
- Inspired by (not copying): Leica Classic, Contemporary, Vivid, B&W, Kodak Portra, Fuji Velvia, Ilford HP5

### Grain Simulation
- Parameters: `intensity` (0–100), `size` (fine/medium/coarse), `type` (luminance/colour)
- Grain must be **shadow-weighted** — stronger in shadows, fades in highlights (film-accurate)
- Grain must be **randomised per export** — not a static texture overlay
- GLSL shader handles generation

### Bloom & Halation
- **Bloom:** soft glow spreading outward from bright highlights
  - Parameters: `intensity`, `radius`, `threshold` (which highlights trigger it)
- **Halation:** warm red/orange colour bleed around bright edges — classic film characteristic
  - Parameters: `intensity`, `colour temperature` (warm/neutral), `spread`
- Both applied as GLSL post-processing passes

### Lens Profiles
- Parameters: `vignette` (intensity, shape), `chromatic_aberration` (intensity), `corner_softness` (intensity), `distortion` (barrel/pincushion amount)
- Profiles are **named by character** not brand — e.g. "Classic 35", "Wide Open 50", "Modern 28"
- Stored as JSON in `assets/lens_profiles/`
- Future: depth map bokeh added to this layer (v2+) — model must have a `bokeh` field ready even if null in v1

---

## 5. Folder Structure

```
lumen/
├── lib/
│   ├── main.dart
│   ├── app.dart                              # Root widget, theme, routing
│   ├── core/
│   │   ├── models/
│   │   │   ├── lens_profile.dart             # implements toPromptFragment()
│   │   │   ├── film_look.dart                # implements toPromptFragment()
│   │   │   ├── grain_settings.dart           # implements toPromptFragment()
│   │   │   ├── bloom_settings.dart           # implements toPromptFragment()
│   │   │   ├── basic_editor_settings.dart    # implements toPromptFragment()
│   │   │   └── edit_state.dart               # Full non-destructive edit state — all layers combined
│   │   ├── providers/                        # Riverpod providers
│   │   ├── services/
│   │   │   ├── effect_engine.dart            # Orchestrates full simulation pipeline
│   │   │   ├── lut_service.dart              # Loads + applies .cube LUTs via GLSL
│   │   │   ├── format_ingestion_service.dart # Converts any input format → DNG
│   │   │   ├── export_service.dart           # Full-res export
│   │   │   ├── generation_service.dart       # STUBBED v1 — AI img2img (Pro Max)
│   │   │   ├── enhancement_service.dart      # STUBBED v1 — AI upscale + detail recovery
│   │   │   ├── generation_prompt_builder.dart # Translates EditState → AI model prompt
│   │   │   ├── ai_model_config_service.dart  # Reads ai_model_config.json, exposes active models
│   │   │   └── device_tier_service.dart      # Detects device capability tier
│   │   └── constants.dart
│   ├── features/
│   │   ├── editor/                           # Photo import + edit screen (v1 core)
│   │   │   ├── screens/
│   │   │   ├── widgets/
│   │   │   │   ├── basic_editor_panel.dart   # Exposure/contrast/highlights etc.
│   │   │   │   ├── effects_panel.dart        # Lens/film/grain/bloom controls
│   │   │   │   └── generate_button.dart      # Gated Pro Max button (stubbed v1)
│   │   │   └── providers/
│   │   ├── camera/                           # RESERVED — live camera (v2+)
│   │   │   └── README.md
│   │   ├── generation/                       # RESERVED — AI generation UI (v4+)
│   │   │   └── README.md
│   │   ├── library/                          # Preset/look browser
│   │   ├── export/                           # Export flow + enhancement options (stubbed v1)
│   │   └── subscription/                     # RevenueCat paywall + management
│   └── shared/
│       ├── widgets/
│       ├── theme/
│       └── extensions/
├── assets/
│   ├── luts/                                 # .cube LUT files
│   ├── lens_profiles/                        # .json lens profile definitions
│   ├── shaders/                              # .frag GLSL shader files
│   └── config/
│       └── ai_model_config.json              # Active AI model config — swapped by Peter
├── android/                                  # Android native — Kotlin platform channels here
├── ios/                                      # iOS native
├── test/
└── CLAUDE.md                                 # ← this file
```

---

## 6. Subscription & Tier Gating

### Tier Structure

| Tier | Price | What's included |
|---|---|---|
| **Free** | $0 | 3 film looks, 1 lens profile, basic grain (intensity only), no bloom/halation, basic editor (all controls) |
| **Pro** | TBD/month | Full look library, all lens profiles, full grain controls, bloom + halation, full basic editor, RAW export, AI enhancement (TBD) |
| **Pro Max** | TBD/month | Everything in Pro + AI generation (img2img via active model), TBD generations/month |

### Rules
- Gate checks handled by a single `SubscriptionService` — never scattered through the codebase
- RevenueCat manages entitlements — never check subscription status manually
- Paywall shown as a **bottom sheet**, never a full screen interrupt during editing
- Generation limit tracked server-side via the generation API — not client-side
- Pro Max is a **separate RevenueCat entitlement** from Pro, not just a higher plan level
- If a Pro Max user hits their generation limit, they see a clear counter and a graceful message — never a crash or silent failure
- Generated images count against the monthly limit only on successful return from the API — failed generations do not consume credits

---

## 7. Versioning Roadmap

Use this to understand scope boundaries. Never build v2+ features in v1.

### v1 — The Darkroom (current focus)
- Photo import from camera roll
- Format ingestion — all formats converted to DNG as working format
- Basic editor (exposure, contrast, highlights, shadows, whites, blacks, temperature, tint, clarity, saturation, vibrance)
- Full simulation pipeline (film look + grain + bloom/halation + lens profile)
- Basic editor accessible before and after effects (non-destructive)
- Export full resolution
- Subscription gating via RevenueCat (Free + Pro)
- Pixel + Samsung optimised
- `GenerationService`, `EnhancementService`, `AIModelConfigService` stubbed but not active
- `Generate` button visible in UI but gated/disabled

### v2 — The Camera
- Live camera viewfinder with approximate effect preview
- CameraX integration (Android)
- Approximate real-time grain + film look in viewfinder
- Manual controls (ISO, shutter, white balance)

### v3 — The Lens
- Depth map extraction (Pixel / Samsung)
- Real bokeh simulation in editor using depth data
- Live depth-based lens simulation in viewfinder
- Lens simulation accuracy improvements

### v4 — The Generator (Pro Max tier launch)
- `AIModelConfigService` fully implemented — reads `ai_model_config.json`
- `GenerationService` fully implemented — model-agnostic, swappable via config
- `generation_prompt_builder.dart` translates full `EditState` to model prompt
- Pro Max subscription tier activated in RevenueCat
- Generation limit counter UI
- Generated image returned to editor for optional further simulation + basic editing
- Failed generation handling + retry logic
- Initial active model: Flux (via Replicate or fal.ai) — swappable without code changes

### v5 — The Enhancer
- `EnhancementService` fully implemented
- AI upscaling (2x / 4x) at export
- Shadow and detail recovery as pre-processing step
- Active enhancement model configurable via `ai_model_config.json`

### v6+
- iOS launch
- Artist collaboration looks
- Film scan workflow
- Generation strength slider (how far AI departs from original)

---

## 8. Code Style & Conventions

- **Dart style:** follow `flutter_lints` — no exceptions
- **Naming:** `snake_case` for files, `camelCase` for variables, `PascalCase` for classes
- **Comments:** every public method and class gets a doc comment (`///`)
- **No magic numbers:** all constants in `constants.dart` or within the relevant model
- **Shaders:** kept in `assets/shaders/`, one file per effect (`grain.frag`, `bloom.frag`, `lut.frag`, `lens.frag`)
- **Never** embed effect logic in UI widgets — always in `core/services/` or `core/providers/`
- **Never** let subscription checks leak into feature code — always through `SubscriptionService`

---

## 9. About the Developer

- **Name:** Peter
- **Experience level:** Beginner-intermediate. Understands concepts, builds with guidance. Has experience with Flutter/Dart via WeddingOS project.
- **Setup:** MacBook Pro (Apple Silicon) + Razer Blade (Windows), VS Code, Claude Code terminal
- **Preferred style:** Explain *why* before *how*. Flag when something is complex before diving in.
- **When stuck:** Always suggest the simplest working solution first, then offer to refine.

---

## 10. Session Startup Checklist

At the start of every Claude Code session, confirm:
- [ ] Which phase/version are we building? (default: v1)
- [ ] What was the last thing completed?
- [ ] What is the goal for this session?
- [ ] Are we introducing anything that could conflict with the camera window? (section 3b)
- [ ] Are we introducing anything that could conflict with the generation window? (section 3c)
- [ ] Are we introducing anything that could conflict with the enhancement window? (section 3f)
- [ ] Do all new models implement `toPromptFragment()`?
- [ ] Are any AI model names or endpoint URLs being hardcoded? (they must not be)
- [ ] Is format ingestion happening before any pipeline processing? (it must be)

---

*Last updated: April 2026 — Peter / Claude. Basic editor, format ingestion, AI enhancement, and model-agnostic backend added.*
*App name LUMEN is a placeholder. Update this file when final name is confirmed.*
