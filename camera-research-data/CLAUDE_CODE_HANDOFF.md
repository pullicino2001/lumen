# Claude Code Session — Implement toPromptFragment() for Generation System

## Context

This is a Flutter/Dart mobile photo editing app called LUMEN. Read the full project spec before touching anything:

```
/Users/pete/Git/lumen/md files/lumen.md
```

We are implementing **v4 — The Generator**. The goal of this session is to wire real AI prompt text into the models so that when a user selects a lens profile, film stock, and camera body, the `GenerationPromptBuilder` assembles an accurate, model-agnostic, image-agnostic prompt ready to send to the AI generation API.

---

## Research Data Location

All prompt research is in:

```
/Users/pete/Git/lumen/camera-research-data/
```

Before writing any code, read these two files in full:

```
/Users/pete/Git/lumen/camera-research-data/PROMPT_GUIDE.md
/Users/pete/Git/lumen/camera-research-data/OVERVIEW.md
```

The PROMPT_GUIDE.md explains the assembly rules, fragment structure, and full worked examples.
The OVERVIEW.md shows every camera, lens, and film stock that has been profiled.

Individual profiles (each contains a PROMPT_FRAGMENT section):

```
/Users/pete/Git/lumen/camera-research-data/lenses/leica/summilux_50mm_f1.4.md
/Users/pete/Git/lumen/camera-research-data/lenses/leica/summilux_35mm_f1.4.md
/Users/pete/Git/lumen/camera-research-data/lenses/leica/summicron_50mm_f2.md
/Users/pete/Git/lumen/camera-research-data/lenses/leica/summicron_35mm_f2.md
/Users/pete/Git/lumen/camera-research-data/lenses/leica/apo_summicron_50mm_f2.md
/Users/pete/Git/lumen/camera-research-data/lenses/leica/noctilux_50mm_f0.95.md
/Users/pete/Git/lumen/camera-research-data/lenses/leica/elmarit_28mm_f2.8.md
/Users/pete/Git/lumen/camera-research-data/lenses/canon/EF_85mm_f1.2L.md
/Users/pete/Git/lumen/camera-research-data/lenses/zeiss/otus_55mm_f1.4.md
/Users/pete/Git/lumen/camera-research-data/lenses/voigtlander/nokton_50mm_f1.5.md

/Users/pete/Git/lumen/camera-research-data/film_stocks/kodak/portra_400.md
/Users/pete/Git/lumen/camera-research-data/film_stocks/kodak/portra_160.md
/Users/pete/Git/lumen/camera-research-data/film_stocks/kodak/ektar_100.md
/Users/pete/Git/lumen/camera-research-data/film_stocks/kodak/trix_400.md
/Users/pete/Git/lumen/camera-research-data/film_stocks/fuji/velvia_50.md
/Users/pete/Git/lumen/camera-research-data/film_stocks/fuji/acros_100.md
/Users/pete/Git/lumen/camera-research-data/film_stocks/ilford/hp5_plus.md
/Users/pete/Git/lumen/camera-research-data/film_stocks/ilford/delta_400.md
/Users/pete/Git/lumen/camera-research-data/film_stocks/cinestill/cinestill_800T.md

/Users/pete/Git/lumen/camera-research-data/cameras/leica/M6.md
/Users/pete/Git/lumen/camera-research-data/cameras/leica/M9.md
/Users/pete/Git/lumen/camera-research-data/cameras/leica/M10.md
/Users/pete/Git/lumen/camera-research-data/cameras/leica/M11.md
/Users/pete/Git/lumen/camera-research-data/cameras/leica/Q2.md
/Users/pete/Git/lumen/camera-research-data/cameras/leica/SL2.md
/Users/pete/Git/lumen/camera-research-data/cameras/canon/AE1.md
/Users/pete/Git/lumen/camera-research-data/cameras/canon/5D_Mark_IV.md
/Users/pete/Git/lumen/camera-research-data/cameras/fuji/X100V.md
/Users/pete/Git/lumen/camera-research-data/cameras/fuji/GFX100S.md
/Users/pete/Git/lumen/camera-research-data/cameras/nikon/FM2.md
```

---

## Existing App Code to Read First

Read these files before writing anything:

```
/Users/pete/Git/lumen/lib/core/models/lens_profile.dart
/Users/pete/Git/lumen/lib/core/models/film_stock.dart
/Users/pete/Git/lumen/lib/core/models/prompt_contributor.dart
/Users/pete/Git/lumen/lib/core/data/lens_profiles.dart
/Users/pete/Git/lumen/lib/core/data/film_stocks.dart
/Users/pete/Git/lumen/lib/core/services/generation_prompt_builder.dart
```

---

## What Needs to Be Done

### Task 1 — Implement `toPromptFragment()` in `FilmStock`

File: `/Users/pete/Git/lumen/lib/core/models/film_stock.dart`

The method currently returns `''`. It needs to return the film stock's prompt fragment.

The `FilmStock` model does not currently have a `promptFragment` field. Add one:

```dart
/// Plain-text prompt fragment for AI generation. Image-agnostic and model-agnostic.
/// Assembled by GenerationPromptBuilder into the full generation prompt.
@Default('') String promptFragment,
```

Then implement `toPromptFragment()`:

```dart
@override
String toPromptFragment() => promptFragment;
```

Run the Freezed code generator after modifying the model:
```
dart run build_runner build --delete-conflicting-outputs
```

---

### Task 2 — Implement `toPromptFragment()` in `LensProfile`

File: `/Users/pete/Git/lumen/lib/core/models/lens_profile.dart`

Same pattern as FilmStock. Add a `promptFragment` field and implement the method.

---

### Task 3 — Update `kFilmStocks` with prompt fragments

File: `/Users/pete/Git/lumen/lib/core/data/film_stocks.dart`

The existing film stocks (Portra 400, Gold 200, Cinestill 800T, Superia 400, Tri-X 400) need their `promptFragment` field populated from the PROMPT_FRAGMENT sections in the research profiles.

Also add the following new film stocks (profiles exist in the research data):
- Kodak Portra 160
- Kodak Ektar 100
- Fujifilm Velvia 50
- Fujifilm Acros 100 II
- Ilford HP5 Plus 400
- Ilford Delta 400 Professional
- Cinestill 400D (use the brief description from the Cinestill 800T profile's comparison section)

For each new stock, populate:
- `id` — snake_case, e.g. `portra_160`
- `name` — display name
- `description` — short UI description (1 sentence)
- `promptFragment` — the PROMPT_FRAGMENT text from the research file
- `colourMatrix`, `redCurve`, `greenCurve`, `blueCurve`, `shadowHueDeg`, etc. — use the values already set for the closest existing stock as a starting point, then adjust based on the rendering description in the profile. For example, Ektar 100 is cool and saturated so blues should be boosted; Velvia 50 is hyper-saturated so the colour matrix should push all channels further than Portra.
- `tier` — set all new stocks to `StockTier.pro` except keep existing free ones as they are

---

### Task 4 — Update `kLensProfiles` with real Leica profiles

File: `/Users/pete/Git/lumen/lib/core/data/lens_profiles.dart`

The existing profiles (Classic 50, Portrait 85, Wide 24, Vintage 35, Anamorphic) are generic placeholders. Replace or supplement them with real named Leica profiles based on the research data.

Add the following real lens profiles. For each, read the research file and set the shader parameters based on the optical description:

| Profile ID | Research File | Notes |
|------------|--------------|-------|
| `summilux_50_wide` | summilux_50mm_f1.4.md | f/1.4 rendering — heavy vignette, chromatic aberration, smooth bokeh |
| `summilux_50_mid` | summilux_50mm_f1.4.md | f/4–f/5.6 rendering — clean, sharp, no vignette |
| `summicron_50` | summicron_50mm_f2.md | f/2 rendering — moderate vignette, very low CA, precise |
| `summicron_35` | summicron_35mm_f2.md | f/2 rendering — slight warmth, environmental perspective |
| `noctilux_50` | noctilux_50mm_f0.95.md | f/0.95 — extreme vignette, noticeable CA, wide open |
| `apo_summicron_50` | apo_summicron_50mm_f2.md | f/2 — near-zero everything, clinical perfection |
| `canon_85_l` | EF_85mm_f1.2L.md | f/1.2 — strong vignette, warm, smooth |
| `nokton_50` | nokton_50mm_f1.5.md | f/1.5 — moderate vignette, slight CA, vintage character |

Keep the existing generic profiles too (Classic 50, Portrait 85, etc.) — they remain useful as non-branded options. Add real profiles as additional entries in the list.

Populate the `promptFragment` field for every profile — both new and existing generic ones.

For the generic profiles, write simple prompt fragments based on the shader parameters already set:
- `classic_50`: "classic 50mm lens rendering — clean standard perspective, subtle vignette falloff toward frame edges, minimal chromatic aberration, natural colour transmission"
- etc.

---

### Task 5 — Create `CameraProfile` model and data file

This is a new model that does not yet exist in the app. Leica cameras are a key differentiator for the generation system.

**New file:** `/Users/pete/Git/lumen/lib/core/models/camera_profile.dart`

Model the `CameraProfile` similarly to `LensProfile` and `FilmStock` — Freezed, JSON-serialisable, implements `PromptContributor`.

Fields needed:
```dart
required String id,
required String name,
required String description,
@Default(ProfileTier.free) ProfileTier tier,

// Sensor characteristics — inform colour matrix bias
@Default(0.0) double warmthBias,       // -1.0 (cool) to +1.0 (warm), 0 = neutral
@Default(0.0) double contrastBias,     // -1.0 (flat) to +1.0 (punchy), 0 = neutral
@Default(0.0) double shadowLift,       // 0 = deep blacks, 1.0 = lifted shadow floor
@Default(0.0) double highlightRolloff, // 0 = abrupt clip, 1.0 = film-like gradual rolloff

// For film cameras — indicates no in-camera processing character
@Default(false) bool isFilmCamera,

// Prompt fragment
@Default('') String promptFragment,
```

Run `dart run build_runner build --delete-conflicting-outputs` after creating the model.

---

### Task 6 — Create `camera_profiles.dart` data file

**New file:** `/Users/pete/Git/lumen/lib/core/data/camera_profiles.dart`

Populate from the camera research profiles. Include:

| ID | Research File | Tier |
|----|--------------|------|
| `leica_m11` | M11.md | pro |
| `leica_m10` | M10.md | pro |
| `leica_m9` | M9.md | pro |
| `leica_m6` | M6.md | pro |
| `leica_q2` | Q2.md | pro |
| `leica_q3` | Q2.md (same file, Q3 section) | pro |
| `canon_ae1` | AE1.md | free |
| `canon_5d_iv` | 5D_Mark_IV.md | pro |
| `fuji_x100v` | X100V.md | free |
| `fuji_gfx100s` | GFX100S.md | pro |
| `nikon_fm2` | FM2.md | free |

---

### Task 7 — Update `GenerationPromptBuilder`

File: `/Users/pete/Git/lumen/lib/core/services/generation_prompt_builder.dart`

The builder currently assembles fragments from `lensProfile`, `filmStock`, `grain`, `bloom`, and `basicEditor`. Add camera to the assembly.

The `EditState` may not yet have a `cameraProfile` field — check `/Users/pete/Git/lumen/lib/core/models/edit_state.dart`. If it does not exist, add:

```dart
CameraProfile? cameraProfile,
@Default(true) bool cameraEnabled,
```

Then update `GenerationPromptBuilder.build()` to include the camera fragment:

```dart
String build(EditState state) {
  final parts = <String>[
    // Camera establishes the sensor/rendering base
    if (state.cameraProfile != null && state.cameraEnabled)
      state.cameraProfile!.toPromptFragment(),
    
    // Film stock establishes colour and tonal character
    if (state.filmStock != null && state.stockEnabled)
      state.filmStock!.toPromptFragment(),
    
    // Lens adds optical character on top
    if (state.lensProfile != null && state.lensEnabled)
      state.lensProfile!.toPromptFragment(),
    
    // Fine-tuning layers
    if (state.grainEnabled) state.grain.toPromptFragment(),
    if (state.bloomEnabled) state.bloom.toPromptFragment(),
    if (state.basicEditorEnabled) state.basicEditor.toPromptFragment(),
  ].where((s) => s.isNotEmpty).toList();

  return parts.join(', ');
}
```

Note the order: camera → film stock → lens. This matches the PROMPT_GUIDE.md assembly rules.

---

### Task 8 — Write a unit test for `GenerationPromptBuilder`

File (new): `/Users/pete/Git/lumen/test/core/services/generation_prompt_builder_test.dart`

Write a test that:
1. Constructs an `EditState` with the Leica M11 camera, Summilux 50mm f/1.4 lens, and Portra 400 film stock
2. Calls `GenerationPromptBuilder().build(state)`
3. Asserts the returned string is non-empty
4. Asserts it contains key phrases from all three fragments (e.g., "Leica M11", "Summilux", "Portra")
5. Prints the assembled prompt to console so it can be reviewed

Run with: `flutter test test/core/services/generation_prompt_builder_test.dart`

---

## Rules for This Session

- Read `lumen.md` first. Follow it strictly.
- Read the PROMPT_GUIDE.md before writing any prompt fragment text.
- Do not hallucinate optical specifications — all shader parameter values (vignetteIntensity, chromaticAberration etc.) must be grounded in the rendering descriptions in the research profiles.
- The `toPromptFragment()` method must return text, not empty string, for every profile that has a research file.
- All new models must implement `PromptContributor`.
- Run the code generator after every model change.
- The app must compile and run after this session. Do not leave broken Dart.
- Do not build any UI changes in this session — data models and services only.

---

## Definition of Done

- [ ] `FilmStock.toPromptFragment()` returns real text for all stocks in `kFilmStocks`
- [ ] `LensProfile.toPromptFragment()` returns real text for all profiles in `kLensProfiles`
- [ ] `CameraProfile` model exists, compiles, implements `PromptContributor`
- [ ] `kCameraProfiles` data file exists with all profiles listed above
- [ ] `GenerationPromptBuilder` assembles camera + film stock + lens fragments in the correct order
- [ ] Unit test passes and prints a readable assembled prompt
- [ ] `flutter analyze` runs clean — no errors, no warnings
- [ ] `flutter build apk --debug` succeeds
