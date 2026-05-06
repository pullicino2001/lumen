import '../models/camera_profile.dart';
import '../models/lens_profile.dart';

/// All camera profiles available in the app, in display order.
///
/// Sensor characteristics (warmthBias, contrastBias, etc.) inform colour-matrix
/// bias applied at the camera layer. [promptFragment] is the direct AI generation
/// text, assembled from research profile data.
const List<CameraProfile> kCameraProfiles = [
  // ── Leica M11 ─────────────────────────────────────────────────────────────
  // 60MP BSI CMOS. Leica's most capable M. Precise warm colour science,
  // exceptional tonal graduation, film-like highlight rolloff.
  CameraProfile(
    id: 'leica_m11',
    name: 'Leica M11',
    description: '60MP Leica M — exceptional tonal graduation, precise warm colour science',
    tier: ProfileTier.pro,
    warmthBias: 0.20,
    contrastBias: -0.20,
    shadowLift: 0.00,
    highlightRolloff: 0.85,
    promptFragment:
        'shot on Leica M11, 60-megapixel BSI CMOS full-frame sensor, Leica colour '
        'science with precise warm skin tones, rich saturated reds, clean neutral '
        'shadow rendering, film-like gradual highlight rolloff, exceptional tonal '
        'graduation in midtones and gradients, razor-sharp detail without digital '
        'artefacts, medium-low native contrast with full tonal latitude',
  ),

  // ── Leica M10 ─────────────────────────────────────────────────────────────
  // 24MP CMOS. The sweet-spot digital M. Warm natural skin tones, balanced
  // contrast, excellent shadow recovery, Leica's house colour science.
  CameraProfile(
    id: 'leica_m10',
    name: 'Leica M10',
    description: '24MP Leica M — warm natural colour, balanced contrast, classic M rendering',
    tier: ProfileTier.pro,
    warmthBias: 0.25,
    contrastBias: 0.00,
    shadowLift: 0.05,
    highlightRolloff: 0.75,
    promptFragment:
        'shot on Leica M10, full-frame CMOS sensor with Leica colour science, '
        'warm natural skin tones, rich reds with depth and detail retention, clean '
        'neutral greys, gradual highlight rolloff with recovery headroom, smooth '
        'shadow transitions, medium contrast with even tonal distribution, Leica '
        'M-mount rendering — clinical sharpness softened by natural lens character',
  ),

  // ── Leica M9 ──────────────────────────────────────────────────────────────
  // 18MP CCD. The mythologised digital M. Warm amber-analogue colour,
  // elevated micro-contrast, dense shadows, abrupt highlight rolloff.
  CameraProfile(
    id: 'leica_m9',
    name: 'Leica M9',
    description: 'CCD Leica — analogue-warm colour, elevated micro-contrast, the M9 magic',
    tier: ProfileTier.pro,
    warmthBias: 0.35,
    contrastBias: 0.35,
    shadowLift: -0.20,
    highlightRolloff: 0.40,
    promptFragment:
        'shot on Leica M9, full-frame CCD sensor, analogue-digital hybrid colour '
        'rendering, warm amber skin tones, slightly cyan blues, elevated '
        'micro-contrast, deep compressed shadows with limited recovery, abrupt '
        'highlight rolloff, medium-high contrast, painterly tonal transitions '
        'reminiscent of fine colour film, no digital neutrality',
  ),

  // ── Leica M6 ──────────────────────────────────────────────────────────────
  // 35mm film rangefinder. No sensor — rendering is entirely the film stock.
  // Contributes deliberate single-frame composition, rangefinder perspective.
  CameraProfile(
    id: 'leica_m6',
    name: 'Leica M6',
    description: '35mm film rangefinder — pure lens + film rendering, no in-camera processing',
    tier: ProfileTier.pro,
    warmthBias: 0.00,
    contrastBias: 0.00,
    shadowLift: 0.00,
    highlightRolloff: 0.70,
    isFilmCamera: true,
    promptFragment:
        'shot on Leica M6, 35mm film rangefinder, mechanically precise exposure, '
        'no in-camera processing, pure film rendering, deliberate single-frame '
        'composition, rangefinder perspective with natural breathing room around '
        'subject, fine detail without digital over-sharpening',
  ),

  // ── Leica Q2 ──────────────────────────────────────────────────────────────
  // 47MP CMOS. Fixed 28mm Summilux f/1.7. Corner-to-corner sharpness,
  // environmental 28mm perspective, Leica colour science.
  CameraProfile(
    id: 'leica_q2',
    name: 'Leica Q2',
    description: '47MP fixed 28mm Leica — environmental perspective, corner-to-corner sharpness',
    tier: ProfileTier.pro,
    warmthBias: 0.20,
    contrastBias: 0.05,
    shadowLift: 0.05,
    highlightRolloff: 0.80,
    promptFragment:
        'shot on Leica Q2, 47-megapixel full-frame sensor with Leica colour '
        'science, fixed 28mm Summilux perspective — subject within environment, '
        'corner-to-corner sharpness, slightly warm skin tones, rich blues in sky '
        'and shadow, deliberate vignette light falloff at frame edges, wide-angle '
        'intimacy without distortion, clean and detailed throughout the frame',
  ),

  // ── Leica Q3 ──────────────────────────────────────────────────────────────
  // 60MP BSI CMOS. Fixed 28mm Summilux f/1.7. Same sensor as M11.
  // Exceptional dynamic range, film-like highlight rolloff.
  CameraProfile(
    id: 'leica_q3',
    name: 'Leica Q3',
    description: '60MP fixed 28mm Leica — M11 sensor quality, immersive wide perspective',
    tier: ProfileTier.pro,
    warmthBias: 0.20,
    contrastBias: -0.10,
    shadowLift: 0.05,
    highlightRolloff: 0.85,
    promptFragment:
        'shot on Leica Q3, 60-megapixel BSI full-frame sensor, fixed 28mm '
        'Summilux rendering — precise and immersive wide-angle perspective, '
        'exceptional dynamic range, film-like highlight rolloff, warm Leica colour '
        'science, extremely sharp across the entire frame from centre to corners, '
        'excellent low-light rendering with fine noise character',
  ),

  // ── Canon AE-1 ────────────────────────────────────────────────────────────
  // 35mm film SLR. No sensor — rendering is film + Canon lens character.
  // Centre-weighted metering, analogue nostalgia aesthetic.
  CameraProfile(
    id: 'canon_ae1',
    name: 'Canon AE-1',
    description: '35mm film SLR — analogue nostalgia, consumer film era aesthetic',
    warmthBias: 0.00,
    contrastBias: 0.00,
    shadowLift: 0.00,
    highlightRolloff: 0.60,
    isFilmCamera: true,
    promptFragment:
        'shot on Canon AE-1, 35mm film SLR, consumer photography era rendering, '
        'centre-weighted exposure prioritising subject over environment, slight '
        'candid documentary quality with minor natural softness at marginal shutter '
        'speeds, analogue nostalgia colour characteristic of consumer film stocks, '
        '1976–1985 visual era',
  ),

  // ── Canon 5D Mark IV ──────────────────────────────────────────────────────
  // 30MP CMOS DSLR. Canon's professional workhorse. Warm pleasant skin tones,
  // slightly enriched reds, technically reliable.
  CameraProfile(
    id: 'canon_5d_iv',
    name: 'Canon 5D IV',
    description: '30MP Canon DSLR — warm professional colour, reliable event photography quality',
    tier: ProfileTier.pro,
    warmthBias: 0.30,
    contrastBias: 0.10,
    shadowLift: 0.10,
    highlightRolloff: 0.65,
    promptFragment:
        'shot on Canon 5D Mark IV, 30-megapixel full-frame CMOS with Canon colour '
        'science, warm pleasant skin tones, slightly enriched reds and oranges, '
        'clean punchy blues, overall warm colour rendering, technically precise '
        'medium-contrast rendering with good dynamic range, professional DSLR '
        'quality without distinctive optical personality',
  ),

  // ── Fujifilm X100V ────────────────────────────────────────────────────────
  // 26MP APS-C X-Trans. Fixed 23mm f/2 (35mm equivalent). The "Fuji look" —
  // muted filmic colour, teal shadows, Classic Chrome character.
  CameraProfile(
    id: 'fuji_x100v',
    name: 'Fuji X100V',
    description: 'Fixed-lens Fuji compact — Classic Chrome filmic palette, teal shadow character',
    warmthBias: -0.10,
    contrastBias: 0.10,
    shadowLift: 0.10,
    highlightRolloff: 0.70,
    promptFragment:
        'shot on Fujifilm X100V with Classic Chrome film simulation, 35mm-equivalent '
        'APS-C rendering, characteristically muted filmic colour palette, compressed '
        'highlights with slight rolloff, lifted shadow register, teal-shifted shadows '
        'with desaturated warm midtones, slight colour fade reminiscent of processed '
        'colour negative film, cool skin tone rendering, rich saturated greens and '
        'deep blues — the contemporary filmic digital aesthetic',
  ),

  // ── Fujifilm GFX 100S ─────────────────────────────────────────────────────
  // 102MP medium-format CMOS. Maximum tonal depth, continuous gradient
  // rendering, medium-format dimensionality.
  CameraProfile(
    id: 'fuji_gfx100s',
    name: 'Fuji GFX 100S',
    description: '102MP medium format — exceptional tonal graduation, medium-format dimensionality',
    tier: ProfileTier.pro,
    warmthBias: -0.05,
    contrastBias: 0.00,
    shadowLift: 0.05,
    highlightRolloff: 0.80,
    promptFragment:
        'shot on Fujifilm GFX 100S, 102-megapixel medium-format sensor, continuous '
        'tonal graduation in smooth surfaces and skin, deep colour depth with precise '
        'subtle colour gradient retention, medium-format dimensionality — subject '
        'presence with environmental sharpness, exceptional detail resolution '
        'approaching large-format photographic quality, Fujifilm colour science '
        'with extended tonal range',
  ),

  // ── Nikon FM2 ─────────────────────────────────────────────────────────────
  // 35mm film SLR. No sensor — rendering is entirely film + Nikkor lens.
  // Photojournalistic documentary aesthetic.
  CameraProfile(
    id: 'nikon_fm2',
    name: 'Nikon FM2',
    description: '35mm film SLR — photojournalistic documentary, 1980s–1990s press aesthetic',
    warmthBias: 0.00,
    contrastBias: 0.00,
    shadowLift: 0.00,
    highlightRolloff: 0.65,
    isFilmCamera: true,
    promptFragment:
        'shot on Nikon FM2, 35mm film SLR, photojournalistic documentary rendering, '
        'SLR perspective directly through the lens, slight mechanical camera presence '
        'in hand-held images at marginal speeds, Nikkor lens colour science with '
        'neutral-to-cool transmission, professional reportage aesthetic from the '
        '1980s–1990s press photography era',
  ),
];
