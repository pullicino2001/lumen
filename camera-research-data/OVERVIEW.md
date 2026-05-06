# LUMEN — Camera, Lens & Film Stock Research Database
> Last updated: May 2026
> Purpose: Reference library for building model-agnostic, image-agnostic AI generation prompts.
> Each profile feeds the `toPromptFragment()` method in the app's data models.

---

## How This Database Works

When a user selects a camera + lens + film stock combination and hits Generate, the app assembles a prompt from three independent prompt fragments:

```
[Camera Fragment] + [Lens Fragment] + [Film Stock Fragment] = Final Prompt
```

Each fragment describes **rendering characteristics only** — not subject matter, not composition, not lighting. This keeps the prompt image-agnostic (works on any photo) and model-agnostic (works with any AI model we plug in).

The goal is to describe how a combination **renders light** — not what it photographs.

---

## Research Status

### Cameras

#### 🔴 Leica (Primary Focus)
| Camera | Type | Era | Profile Status | In App |
|--------|------|-----|----------------|--------|
| Leica M6 | Film Rangefinder | 1984–2002 (reissued 2022) | ✅ Complete | Planned |
| Leica M7 | Film Rangefinder (AE) | 2002–present | ✅ Complete | Planned |
| Leica M9 | Digital Rangefinder (CCD) | 2009–2012 | ✅ Complete | Planned |
| Leica M10 | Digital Rangefinder (CMOS) | 2017–2020 | ✅ Complete | Planned |
| Leica M10-R | Digital Rangefinder (40MP) | 2020–2022 | ✅ Complete | Planned |
| Leica M11 | Digital Rangefinder (60MP) | 2022–present | ✅ Complete | Priority |
| Leica Q2 | Fixed-Lens (28mm) | 2019–present | ✅ Complete | Priority |
| Leica Q3 | Fixed-Lens (28mm) | 2023–present | ✅ Complete | Priority |
| Leica SL2 | Mirrorless | 2019–present | ✅ Complete | Planned |
| Leica SL2-S | Mirrorless (24MP) | 2020–present | ⬜ Pending | Future |

#### 🟡 Canon
| Camera | Type | Era | Profile Status | In App |
|--------|------|-----|----------------|--------|
| Canon AE-1 | Film SLR | 1976–1984 | ✅ Complete | Planned |
| Canon AE-1 Program | Film SLR | 1981–1987 | ✅ Complete | Planned |
| Canon F-1 | Film SLR (Pro) | 1971–1981 | ✅ Complete | Planned |
| Canon EOS 5D Mark II | Digital SLR | 2008–2012 | ✅ Complete | Planned |
| Canon EOS 5D Mark IV | Digital SLR | 2016–present | ✅ Complete | Planned |
| Canon EOS R5 | Mirrorless | 2020–present | ✅ Complete | Planned |
| Canon EOS R6 Mark II | Mirrorless | 2022–present | ⬜ Pending | Future |

#### 🟡 Fujifilm
| Camera | Type | Era | Profile Status | In App |
|--------|------|-----|----------------|--------|
| Fujifilm X100V | Fixed-Lens (35mm eq.) | 2020–2023 | ✅ Complete | Priority |
| Fujifilm X100VI | Fixed-Lens (35mm eq.) | 2024–present | ✅ Complete | Priority |
| Fujifilm X-T4 | Mirrorless | 2020–2022 | ✅ Complete | Planned |
| Fujifilm X-T5 | Mirrorless | 2022–present | ✅ Complete | Planned |
| Fujifilm X-Pro3 | Mirrorless (Rangefinder style) | 2019–present | ✅ Complete | Planned |
| Fujifilm GFX 50S | Medium Format | 2017–2021 | ✅ Complete | Planned |
| Fujifilm GFX 100S | Medium Format | 2021–present | ✅ Complete | Planned |

#### 🟢 Nikon
| Camera | Type | Era | Profile Status | In App |
|--------|------|-----|----------------|--------|
| Nikon FM2 | Film SLR | 1982–2001 | ✅ Complete | Planned |
| Nikon F3 | Film SLR (Pro) | 1980–2001 | ✅ Complete | Planned |
| Nikon D800 | Digital SLR | 2012–2014 | ✅ Complete | Planned |
| Nikon D850 | Digital SLR | 2017–present | ✅ Complete | Planned |
| Nikon Z7 II | Mirrorless | 2020–present | ⬜ Pending | Future |

---

### Lenses

#### 🔴 Leica (Primary Focus)
| Lens | Focal Length | Max Aperture | Profile Status | In App |
|------|-------------|--------------|----------------|--------|
| Summilux-M 50mm f/1.4 ASPH | 50mm | f/1.4 | ✅ Complete | Priority |
| Summilux-M 35mm f/1.4 ASPH | 35mm | f/1.4 | ✅ Complete | Priority |
| Summilux-M 21mm f/1.4 ASPH | 21mm | f/1.4 | ✅ Complete | Planned |
| Summicron-M 50mm f/2 (current) | 50mm | f/2 | ✅ Complete | Priority |
| Summicron-M 35mm f/2 ASPH | 35mm | f/2 | ✅ Complete | Priority |
| APO-Summicron-M 50mm f/2 ASPH | 50mm | f/2 | ✅ Complete | Planned |
| Noctilux-M 50mm f/0.95 ASPH | 50mm | f/0.95 | ✅ Complete | Priority |
| Elmarit-M 28mm f/2.8 ASPH | 28mm | f/2.8 | ✅ Complete | Planned |
| Elmarit-M 90mm f/2.8 | 90mm | f/2.8 | ⬜ Pending | Future |
| Summarit-M 75mm f/2.5 | 75mm | f/2.5 | ✅ Complete | Planned |
| Tri-Elmar-M 16-18-21mm | 16/18/21mm | f/4 | ⬜ Pending | Future |

#### 🟡 Canon
| Lens | Focal Length | Max Aperture | Profile Status | In App |
|------|-------------|--------------|----------------|--------|
| Canon EF 50mm f/1.2L USM | 50mm | f/1.2 | ✅ Complete | Planned |
| Canon EF 85mm f/1.2L II USM | 85mm | f/1.2 | ✅ Complete | Planned |
| Canon EF 35mm f/1.4L II USM | 35mm | f/1.4 | ✅ Complete | Planned |
| Canon RF 85mm f/1.2L USM | 85mm | f/1.2 | ⬜ Pending | Future |

#### 🟡 Zeiss
| Lens | Focal Length | Max Aperture | Profile Status | In App |
|------|-------------|--------------|----------------|--------|
| Zeiss Otus 55mm f/1.4 | 55mm | f/1.4 | ✅ Complete | Planned |
| Zeiss Otus 85mm f/1.4 | 85mm | f/1.4 | ✅ Complete | Planned |
| Zeiss Milvus 35mm f/1.4 | 35mm | f/1.4 | ✅ Complete | Planned |
| Zeiss Loxia 35mm f/2 | 35mm | f/2 | ⬜ Pending | Future |

#### 🟢 Voigtländer
| Lens | Focal Length | Max Aperture | Profile Status | In App |
|------|-------------|--------------|----------------|--------|
| Voigtländer Nokton 50mm f/1.5 | 50mm | f/1.5 | ✅ Complete | Planned |
| Voigtländer Nokton 35mm f/1.4 | 35mm | f/1.4 | ✅ Complete | Planned |
| Voigtländer APO-Lanthar 50mm f/2 | 50mm | f/2 | ⬜ Pending | Future |

---

### Film Stocks

#### 🟡 Kodak
| Stock | Type | ISO | Profile Status | In App |
|-------|------|-----|----------------|--------|
| Kodak Portra 160 | Colour Negative | 160 | ✅ Complete | Priority |
| Kodak Portra 400 | Colour Negative | 400 | ✅ Complete | ✅ In App |
| Kodak Ektar 100 | Colour Negative | 100 | ✅ Complete | Planned |
| Kodak Gold 200 | Colour Negative | 200 | ✅ Complete | ✅ In App |
| Kodak Ultramax 400 | Colour Negative | 400 | ✅ Complete | Planned |
| Kodak Tri-X 400 | Black & White | 400 | ✅ Complete | ✅ In App |
| Kodak T-Max 100 | Black & White | 100 | ✅ Complete | Planned |
| Kodak T-Max 400 | Black & White | 400 | ✅ Complete | Planned |

#### 🟡 Fujifilm
| Stock | Type | ISO | Profile Status | In App |
|-------|------|-----|----------------|--------|
| Fuji Velvia 50 | Colour Slide (E6) | 50 | ✅ Complete | Planned |
| Fuji Velvia 100 | Colour Slide (E6) | 100 | ✅ Complete | Planned |
| Fuji Provia 100F | Colour Slide (E6) | 100 | ✅ Complete | Planned |
| Fuji Superia 400 | Colour Negative | 400 | ✅ Complete | ✅ In App |
| Fuji Fujicolor 200 | Colour Negative | 200 | ⬜ Pending | Future |
| Fuji Acros 100 II | Black & White | 100 | ✅ Complete | Planned |

#### 🟢 Ilford
| Stock | Type | ISO | Profile Status | In App |
|-------|------|-----|----------------|--------|
| Ilford HP5 Plus 400 | Black & White | 400 | ✅ Complete | Planned |
| Ilford Delta 400 Professional | Black & White | 400 | ✅ Complete | Planned |
| Ilford Pan-F Plus 50 | Black & White | 50 | ✅ Complete | Planned |
| Ilford XP2 Super 400 | B&W Chromogenic | 400 | ⬜ Pending | Future |
| Ilford Delta 3200 | Black & White | 3200 | ✅ Complete | Planned |

#### 🟢 Cinestill
| Stock | Type | ISO | Profile Status | In App |
|-------|------|-----|----------------|--------|
| Cinestill 800T | Colour Negative (Tungsten) | 800 | ✅ Complete | ✅ In App |
| Cinestill 400D | Colour Negative (Daylight) | 400 | ✅ Complete | Planned |

---

## Prompt Fragment Structure

Every profile contains a `PROMPT_FRAGMENT` section. This is the final text used by the app.

**Fragment rules:**
- Maximum ~60 words per fragment
- Describes rendering only — no subject, no composition, no lighting conditions
- Uses layered descriptors: overall character → colour → tone → texture/optical
- Composable with other fragments — no contradictions, no redundancy
- Works with img2img models (Flux, SD, etc.) — proven through testing

---

## Shooting Conditions Matrix

When testing combinations, we log responses across these conditions:

| Condition | Notes |
|-----------|-------|
| Golden hour — exterior | Warm directional light, rich tones |
| Overcast — exterior | Flat, even light, true colour test |
| Harsh midday sun | High contrast, deep shadows |
| Indoor tungsten | Colour balance stress test |
| Indoor mixed light | Colour cast challenge |
| Night / low light | Grain, shadow noise, highlight halation |
| Portrait — studio | Skin tone rendering, bokeh quality |
| Portrait — natural light | Tonal rolloff, colour accuracy |
| Landscape — wide | Corner sharpness, distortion, colour depth |
| Architecture | Rectilinear rendering, sharpness across frame |
| Street — daytime | Contrast, snap, tonal depth |
| Street — night | Grain character, highlight bloom |

---

## Combination Log

High-priority combinations to test and document:

| Camera | Lens | Film Stock | Priority | Notes |
|--------|------|------------|----------|-------|
| Leica M11 | Summilux 50mm f/1.4 | Kodak Portra 400 | 🔴 High | The "Leica portrait" combo |
| Leica M11 | Summicron 35mm f/2 | Kodak Tri-X 400 | 🔴 High | Classic street |
| Leica M9 | Summilux 50mm f/1.4 | Kodak Portra 400 | 🔴 High | CCD magic |
| Leica Q2 | (fixed 28mm) | Cinestill 800T | 🔴 High | Night street |
| Leica M11 | Noctilux 50mm f/0.95 | Kodak Gold 200 | 🔴 High | Dreamy / wide open |
| Canon AE-1 | Canon 50mm f/1.4 | Kodak Gold 200 | 🟡 Medium | Retro consumer |
| Fuji X100V | (fixed 23mm) | Fuji Velvia 50 | 🟡 Medium | Fuji signature |
| Nikon FM2 | Nikkor 50mm f/1.4 | Ilford HP5 | 🟡 Medium | Classic B&W street |
| Leica M6 | Summicron 35mm f/2 | Kodak Tri-X 400 | 🔴 High | Pure film rangefinder |
| Leica SL2 | Summilux 50mm f/1.4 | Cinestill 400D | 🟡 Medium | Modern Leica digital |
