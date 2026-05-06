import '../models/lens_profile.dart';

/// All lens profiles available in the app, in display order.
///
/// Generic character profiles (no brand) come first, followed by real named
/// profiles derived from optical research data.
const List<LensProfile> kLensProfiles = [
  // ── Generic character profiles ───────────────────────────────────────────

  LensProfile(
    id: 'classic_50',
    name: 'Classic 50',
    description: 'Clean 50mm character with subtle vignette',
    vignetteIntensity: 0.30,
    vignetteShape: 0.0,
    chromaticAberration: 0.02,
    distortion: 0.0,
    promptFragment:
        'classic 50mm lens rendering — clean standard perspective, subtle vignette '
        'falloff toward frame edges, minimal chromatic aberration, natural colour '
        'transmission',
  ),
  LensProfile(
    id: 'portrait_85',
    name: 'Portrait 85',
    description: 'Flattering 85mm with smooth corner falloff',
    vignetteIntensity: 0.20,
    vignetteShape: 0.0,
    chromaticAberration: 0.01,
    distortion: 0.0,
    promptFragment:
        'portrait 85mm lens rendering — flattering telephoto compression with '
        'smooth corner falloff, subtle vignette framing, gradual depth-of-field '
        'transition, natural skin tone rendering without optical personality',
  ),
  LensProfile(
    id: 'wide_24',
    name: 'Wide 24',
    description: 'Wide angle with barrel distortion and strong vignette',
    vignetteIntensity: 0.55,
    vignetteShape: 0.1,
    chromaticAberration: 0.06,
    distortion: 0.08,
    promptFragment:
        'wide 24mm lens rendering — dramatic barrel distortion with strong vignette '
        'darkening at corners, notable chromatic fringing toward edges, expansive '
        'wide-angle environmental perspective',
  ),
  LensProfile(
    id: 'vintage_35',
    name: 'Vintage 35',
    description: 'Vintage character with warm vignette and colour fringing',
    vignetteIntensity: 0.50,
    vignetteShape: 0.0,
    chromaticAberration: 0.08,
    distortion: 0.02,
    promptFragment:
        'vintage 35mm lens rendering — warm vignette darkening toward frame edges, '
        'notable colour fringing at high-contrast zones, organic softness with '
        'vintage optical character and gentle barrel curvature',
  ),
  LensProfile(
    id: 'anamorphic',
    name: 'Anamorphic',
    description: 'Cinematic oval vignette with horizontal colour fringing',
    vignetteIntensity: 0.65,
    vignetteShape: 0.70,
    chromaticAberration: 0.12,
    distortion: -0.02,
    promptFragment:
        'anamorphic lens rendering — cinematic oval vignette with horizontal '
        'lens-streak flare character, pronounced chromatic fringing, widescreen '
        'cinematic perspective, cinematic bokeh with ovoid highlight shapes',
  ),

  // ── Leica Summilux-M 50mm f/1.4 ASPH — wide open ────────────────────────
  // f/1.4 rendering: heavy vignette (~2 stops), chromatic fringing,
  // smooth painterly bokeh, luminous 3D subject presence.
  LensProfile(
    id: 'summilux_50_wide',
    name: 'Summilux 50 f/1.4',
    description: 'Wide-open Summilux: painterly bokeh, warm vignette, luminous subject presence',
    tier: ProfileTier.pro,
    vignetteIntensity: 0.55,
    vignetteShape: 0.0,
    chromaticAberration: 0.06,
    cornerSoftness: 0.20,
    distortion: 0.02,
    promptFragment:
        'Leica Summilux-M 50mm f/1.4 ASPH lens rendering — three-dimensional '
        'subject presence with precise focus and smooth background dissolution, '
        'painterly wide-open bokeh with soft-edged highlight circles, slight warm '
        'colour transmission with exceptional micro-contrast, subject appears to '
        'stand forward from receding background, fine subject detail rendered with '
        'weight and depth rather than clinical sharpness',
  ),

  // ── Leica Summilux-M 50mm f/1.4 ASPH — stopped down ────────────────────
  // f/4–f/5.6 rendering: near-zero vignette, maximum resolution, clean.
  LensProfile(
    id: 'summilux_50_mid',
    name: 'Summilux 50 f/5.6',
    description: 'Stopped-down Summilux: razor-sharp across frame, maximum micro-contrast',
    tier: ProfileTier.pro,
    vignetteIntensity: 0.05,
    vignetteShape: 0.0,
    chromaticAberration: 0.00,
    cornerSoftness: 0.00,
    distortion: 0.02,
    promptFragment:
        'Leica Summilux-M 50mm f/1.4 ASPH stopped-down rendering — razor-sharp '
        'across full frame at working aperture, maximum micro-contrast, clean '
        'neutral rendering, precise architectural and street detail, exceptional '
        'tonal separation without optical impressionism',
  ),

  // ── Leica Summicron-M 50mm f/2 ───────────────────────────────────────────
  // f/2 rendering: precise micro-contrast, moderate vignette, very low CA.
  // Authoritative documentary sharpness.
  LensProfile(
    id: 'summicron_50',
    name: 'Summicron 50 f/2',
    description: 'Precise Summicron: authoritative micro-contrast, documentary sharpness',
    tier: ProfileTier.pro,
    vignetteIntensity: 0.30,
    vignetteShape: 0.0,
    chromaticAberration: 0.01,
    cornerSoftness: 0.05,
    distortion: 0.01,
    promptFragment:
        'Leica Summicron-M 50mm f/2 lens rendering — exceptionally precise '
        'micro-contrast with crisp subject-to-background separation, colour-neutral '
        'accurate transmission, high contrast with deep blacks and clean highlights, '
        'natural 50mm perspective with no focal length distortion, clean rendering '
        'at all apertures without impressionistic qualities, authoritative sharpness '
        'with documentary precision',
  ),

  // ── Leica Summicron-M 35mm f/2 ASPH ─────────────────────────────────────
  // f/2 rendering: environmental 35mm perspective, slight warmth, good corners.
  LensProfile(
    id: 'summicron_35',
    name: 'Summicron 35 f/2',
    description: 'Environmental 35mm perspective — subject in world, micro-contrast sharpness',
    tier: ProfileTier.pro,
    vignetteIntensity: 0.40,
    vignetteShape: 0.0,
    chromaticAberration: 0.02,
    cornerSoftness: 0.10,
    distortion: 0.03,
    promptFragment:
        'Leica Summicron-M 35mm f/2 ASPH lens rendering — environmental 35mm '
        'perspective placing subject within world-context, three-dimensional '
        'spatial depth with micro-contrast sharpness at focus plane, slight warmth '
        'in midtone colour transmission, moderate depth of field retaining '
        'background context even at maximum aperture, clean documentary rendering '
        'with crisp detail, characteristic close-working street-photography '
        'intimacy',
  ),

  // ── Leica Noctilux-M 50mm f/0.95 ASPH ───────────────────────────────────
  // f/0.95 rendering: extreme vignette (~3 stops), noticeable CA,
  // paper-thin depth of field, swirling bokeh, luminous glow at edges.
  LensProfile(
    id: 'noctilux_50',
    name: 'Noctilux 50 f/0.95',
    description: 'Extreme impressionism — paper-thin DOF, swirling bokeh, heavy vignette',
    tier: ProfileTier.pro,
    vignetteIntensity: 0.75,
    vignetteShape: 0.0,
    chromaticAberration: 0.10,
    cornerSoftness: 0.30,
    distortion: 0.02,
    promptFragment:
        'Leica Noctilux-M 50mm f/0.95 ASPH lens rendering — extreme subject '
        'isolation with paper-thin depth of field, impressionistic background '
        'dissolution, swirling bokeh with soft glowing highlight discs, heavy '
        'natural vignette darkening toward frame edges creating a spotlight '
        'atmosphere, luminous glow at focus edges, night light sources rendered '
        'as large soft circles, dreamlike separation between sharp subject and '
        'melting background',
  ),

  // ── Leica APO-Summicron-M 50mm f/2 ASPH ──────────────────────────────────
  // f/2 rendering: near-zero vignette, zero CA, clinical perfection.
  // Technically the finest 50mm lens ever made.
  LensProfile(
    id: 'apo_summicron_50',
    name: 'APO-Summicron 50 f/2',
    description: 'Apochromatic perfection — zero aberrations, scientific optical transparency',
    tier: ProfileTier.pro,
    vignetteIntensity: 0.08,
    vignetteShape: 0.0,
    chromaticAberration: 0.00,
    cornerSoftness: 0.00,
    distortion: 0.00,
    promptFragment:
        'Leica APO-Summicron-M 50mm f/2 ASPH lens rendering — apochromatic '
        'optical perfection with zero chromatic aberration at any aperture, '
        'razor-precise micro-contrast resolving fine detail with scientific '
        'accuracy, completely neutral colour transmission, geometric precision, '
        'maximum sharpness from corner to corner at wide aperture, spatial depth '
        'conveyed through precision rather than impressionism — technically '
        'flawless, optically transparent',
  ),

  // ── Canon EF 85mm f/1.2L II USM ──────────────────────────────────────────
  // f/1.2 rendering: strong vignette (~2 stops), warm Canon colour science,
  // exceptionally smooth circular bokeh, slight spherical softness.
  LensProfile(
    id: 'canon_85_l',
    name: 'Canon 85 f/1.2L',
    description: 'Classic portrait lens — smooth circular bokeh, warm Canon colour, strong vignette',
    tier: ProfileTier.pro,
    vignetteIntensity: 0.55,
    vignetteShape: 0.0,
    chromaticAberration: 0.04,
    cornerSoftness: 0.25,
    distortion: 0.01,
    promptFragment:
        'Canon EF 85mm f/1.2L lens rendering — telephoto portrait compression '
        'with extreme subject isolation, smooth creamy background dissolution with '
        'circular bokeh, slight warm-luminous spherical softness at maximum '
        'aperture flattering skin tones, Canon\'s warm colour science enriching '
        'warm tones, heavy natural vignette framing the subject, 85mm telephoto '
        'separation between subject and environment',
  ),

  // ── Voigtländer Nokton 50mm f/1.5 ────────────────────────────────────────
  // f/1.5 rendering: moderate vignette (~1.5 stops), slight CA, vintage
  // spherical softness, distinctive swirling bokeh character.
  LensProfile(
    id: 'nokton_50',
    name: 'Nokton 50 f/1.5',
    description: 'Vintage Voigtländer character — swirling bokeh, romantic spherical softness',
    tier: ProfileTier.pro,
    vignetteIntensity: 0.45,
    vignetteShape: 0.0,
    chromaticAberration: 0.04,
    cornerSoftness: 0.15,
    distortion: 0.02,
    promptFragment:
        'Voigtländer Nokton 50mm f/1.5 lens rendering — vintage-character soft '
        'rendering at wide apertures with gentle spherical softness and luminous '
        'subject presence, distinctive swirling bokeh with glowing highlight '
        'circles, slightly cooler colour transmission than Leica equivalents, '
        'romantic impressionistic quality at maximum aperture clearing to clean '
        'precise rendering at f/4 and beyond',
  ),
];
