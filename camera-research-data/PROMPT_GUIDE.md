# LUMEN — Prompt Engineering Guide
> How to build model-agnostic, image-agnostic AI generation prompts from camera + lens + film stock profiles.

---

## Core Principle

The generation prompt is assembled from **three independent layers** — one per selection the user has made. Each layer describes **rendering only** — how light and colour and texture behave — never subject, composition, or lighting conditions.

```
[Film Stock Fragment]
+ [Camera Fragment]
+ [Lens Fragment]
= Final Generation Prompt
```

Each fragment stands alone and combines cleanly with others. There should be no contradiction between fragments (e.g., one saying "warm" and another saying "cool") — the fragments describe different aspects of the rendering and complement each other.

---

## Why Image-Agnostic?

The prompt must work on **any image the user feeds it** — a portrait, a landscape, a street scene, an abstract. This means:

✅ DO describe: colour palette, tonal response, grain texture, bokeh quality, contrast, lens character, optical properties  
❌ DON'T describe: subjects, people, compositions, specific environments, lighting setups, weather

**Bad:** "portrait of a woman in warm sunlight with shallow depth of field"  
**Good:** "warm amber skin tone rendering, gradual shadow-to-midtone transition, shallow depth of field with smooth background dissolution"

The model will apply the rendering description to *whatever image is provided*. The content of the image is already there — we are asking the model to *re-render it* with a specific optical and chemical character.

---

## Why Model-Agnostic?

Different AI models (Flux, Stable Diffusion, Midjourney, future models) respond differently to identical prompts. The prompt must be written in language that communicates the *visual result* rather than model-specific trigger words.

**Avoid:** Model-specific tokens or concepts that only work in one system  
**Prefer:** Descriptive visual language that any vision model can interpret

Testing across models is important — see the Testing Protocol section below.

---

## Fragment Structure

Each fragment follows this pattern:

```
[Source identifier], [primary visual character], [colour description], 
[tonal response], [optical/texture details], [specific distinguishing characteristic]
```

**Example — Leica M11 camera fragment:**
```
shot on Leica M11 60-megapixel full-frame sensor, precise warm skin tone 
rendering with Leica colour science, gradual film-like highlight rolloff, 
exceptional tonal graduation in smooth surfaces, razor-sharp micro-contrast 
detail without artefacts
```

**Example — Summilux 50mm f/1.4 ASPH lens fragment:**
```
Leica Summilux-M 50mm f/1.4 ASPH rendering — three-dimensional subject 
presence, smooth background dissolution, slight warm colour transmission, 
painterly wide-open bokeh with soft-edged highlight circles, subject appears 
forward from receding background
```

**Example — Kodak Portra 400 film stock fragment:**
```
Kodak Portra 400 colour science — warm amber-golden skin tones, rich 
saturated reds and oranges, slightly muted blues, characteristic fine 
Kodak grain shadow-weighted in darker areas, generous gradual highlight 
rolloff, organic tonal depth
```

---

## Assembly Rules

### Rule 1: Film stock first
The film stock establishes the colour and tonal foundation. Camera and lens fragments modify it. Order in the prompt matters — the first concept establishes the baseline.

### Rule 2: Camera is the rendering engine
The camera fragment describes the sensor/film behaviour — dynamic range, colour matrix, noise character. This sits between the film stock (colour) and lens (optics).

### Rule 3: Lens is the optical character
The lens fragment adds the optical rendering on top — bokeh, sharpness style, vignette, distortion, colour fringing if present.

### Rule 4: Intensity matters
For AI generation: film stock effects tend to be strong and clearly understood by models. Lens effects are subtler and may need stronger language to communicate clearly. Camera sensor differences are the subtlest and may need testing to verify model comprehension.

### Rule 5: Avoid direct contradiction
If the film stock is "warm amber" and the lens is "warm golden", these reinforce each other. If the film stock is "cool blue tungsten" (Cinestill) and the lens is "warm golden" (Summilux), the result is a complex warm-cool tension — which may be intentional (that's the Cinestill + Summilux combination), but must be tested.

---

## Full Prompt Examples

### Example 1: Leica Portrait — Warm Classic
**Camera:** Leica M11  
**Lens:** Summilux 50mm f/1.4 ASPH  
**Stock:** Kodak Portra 400

```
Kodak Portra 400 colour science — warm amber-golden skin tones, rich 
saturated reds, slightly muted blues, characteristic fine Kodak grain 
shadow-weighted in darker areas, gradual highlight rolloff. Shot on Leica 
M11 full-frame sensor with Leica colour science, warm precise skin tones, 
film-like highlight rolloff, exceptional tonal graduation. Leica Summilux-M 
50mm f/1.4 ASPH rendering — three-dimensional subject presence, smooth 
background dissolution, painterly bokeh with soft-edged highlight circles, 
warm colour transmission, subject appears forward from receding background.
```

---

### Example 2: Night Street — Cinematic
**Camera:** Leica M11  
**Lens:** Noctilux 50mm f/0.95 ASPH  
**Stock:** Cinestill 800T

```
Cinestill 800T film rendering — tungsten-balanced colour with deep blue-teal 
shadows, warm orange halation glow surrounding bright light sources, 
characteristic motion-picture film without anti-halation backing, cool ambient 
colour contrasting warm halation blooms. Leica M11 full-frame sensor, precise 
colour rendering, excellent shadow detail at high ISO with fine luminance noise. 
Leica Noctilux-M 50mm f/0.95 rendering — extreme subject isolation with 
paper-thin depth of field, impressionistic background dissolution, swirling bokeh 
with glowing highlight discs, heavy natural vignette darkening toward frame edges, 
night light sources rendered as large soft glowing circles.
```

---

### Example 3: Documentary B&W
**Camera:** Leica M6 (film)  
**Lens:** Summicron 35mm f/2 ASPH  
**Stock:** Kodak Tri-X 400

```
Kodak Tri-X 400 film rendering — high-contrast photojournalistic black and 
white, deep dense blacks with compressed shadow transitions, full midtone 
separation, chunky irregular silver-halide grain shadow-weighted in dark regions, 
documentary authority. Shot on Leica M6 35mm film rangefinder, mechanically 
precise exposure, no in-camera processing, deliberate single-frame composition, 
rangefinder perspective with natural breathing room around subject. Leica 
Summicron-M 35mm f/2 ASPH rendering — environmental 35mm perspective placing 
subject within world-context, precise micro-contrast sharpness at focus plane, 
slight warmth in midtone colour, characteristic street-photography intimacy.
```

---

### Example 4: Landscape Maximum Quality
**Camera:** Fujifilm GFX 100S  
**Lens:** (GFX native standard lens)  
**Stock:** Fujifilm Velvia 50

```
Fujifilm Velvia 50 slide film rendering — hyper-saturated vivid colour, 
extraordinary deep blue sky and water saturation, luminous intense green 
foliage, deep blue-teal shadow rendering, steep contrast with rich midtones, 
near-invisible fine grain. Fujifilm GFX 100S 102-megapixel medium-format 
sensor, continuous tonal graduation in smooth surfaces, deep colour depth with 
precise subtle gradient retention, medium-format dimensionality with exceptional 
detail resolution.
```

---

## Condition-Specific Addendums

Some conditions require appending additional context. These are **not part of the core fragment** but can be optionally appended:

| Condition | Addendum |
|-----------|----------|
| Night / available light | "available light rendering, ISO pushed to [800/1600/3200]" |
| Overcast / flat light | "flat even lighting, accurate colour temperature rendering" |
| Harsh midday | "high-contrast directional light, deep hard shadows" |
| Indoor tungsten | "tungsten artificial light, [warm/corrected] rendering" |
| Portrait close-focus | "close portrait focus distance, maximum lens rendering" |
| Push-processed film | "push-processed [1/2/3 stops], elevated contrast and grain" |

---

## Testing Protocol

Each new prompt fragment must be tested across at minimum:
1. **Portrait subject** — face and skin tones
2. **Landscape / exterior** — colour, sky, foliage
3. **Indoor / available light** — colour cast, shadow handling
4. **Monochrome subjects** (for B&W stocks) — tonal separation, grain

For each test, verify:
- Does the model produce the described colour rendering?
- Does the grain/texture appear as described?
- Does the tonal contrast match the profile?
- Does the bokeh/depth character appear when relevant?

Testing should be done across at minimum: **Flux 1.1 Pro** (primary) and one secondary model. Note differences and update prompts accordingly.

---

## toPromptFragment() Implementation Notes

In the app's Dart code, each model's `toPromptFragment()` method should return the **PROMPT_FRAGMENT** section from the relevant profile.

For conditional prompts (e.g., wide-open vs stopped-down lens), the `toPromptFragment()` method may need the current aperture setting as a parameter. This is a v4 enhancement — for initial implementation, use the wide-open fragment as the default.

**Fragment character limits:** Aim for 40–70 words per fragment. The combined prompt (all three fragments assembled) should be 120–200 words. Models perform better with focused prompts — more is not always better.

---

## Fragment Quality Checklist

Before finalising a prompt fragment, verify it:

- [ ] Describes rendering only — no subject matter
- [ ] Is image-agnostic — works on portrait, landscape, street equally
- [ ] Has no internal contradictions
- [ ] Combines cleanly with other layer types
- [ ] Is 40–70 words
- [ ] Has been tested against at least one model
- [ ] Produces visually distinguishable results from other similar profiles

---

## Known Challenges

**Challenge 1: CCD vs CMOS**  
The Leica M9 CCD look is important and distinctive but hard to communicate to models that may have been trained primarily on digital CMOS photography. Testing required — may need strong, explicit language ("CCD sensor analogue-digital warmth").

**Challenge 2: Bokeh description**  
Bokeh quality is subtle and models vary in how precisely they interpret it. "Smooth creamy background dissolution" and "swirling impressionistic background" are intended to trigger different responses but may need refinement through testing.

**Challenge 3: Film grain vs digital noise**  
Explicitly describing grain as "silver-halide grain" or "film grain shadow-weighted" helps distinguish from digital sensor noise. Test this distinction carefully — models should produce organic grain patterns, not digital Gaussian noise.

**Challenge 4: Colour cast intensity**  
Terms like "slightly warm," "warm," and "very warm" need calibration. Start with explicit reference ("warm amber skin tones similar to early-afternoon golden light") rather than relative terms alone.
