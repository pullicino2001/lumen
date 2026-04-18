import '../models/lens_profile.dart';

/// All lens profiles available in the app, in display order.
const List<LensProfile> kLensProfiles = [
  LensProfile(
    id: 'classic_50',
    name: 'Classic 50',
    description: 'Clean 50mm character with subtle vignette',
    vignetteIntensity: 0.30,
    vignetteShape: 0.0,
    chromaticAberration: 0.02,
    distortion: 0.0,
  ),
  LensProfile(
    id: 'portrait_85',
    name: 'Portrait 85',
    description: 'Flattering 85mm with smooth corner falloff',
    vignetteIntensity: 0.20,
    vignetteShape: 0.0,
    chromaticAberration: 0.01,
    distortion: 0.0,
  ),
  LensProfile(
    id: 'wide_24',
    name: 'Wide 24',
    description: 'Wide angle with barrel distortion and strong vignette',
    vignetteIntensity: 0.55,
    vignetteShape: 0.1,
    chromaticAberration: 0.06,
    distortion: 0.08,
  ),
  LensProfile(
    id: 'vintage_35',
    name: 'Vintage 35',
    description: 'Vintage character with warm vignette and colour fringing',
    vignetteIntensity: 0.50,
    vignetteShape: 0.0,
    chromaticAberration: 0.08,
    distortion: 0.02,
  ),
  LensProfile(
    id: 'anamorphic',
    name: 'Anamorphic',
    description: 'Cinematic oval vignette with horizontal colour fringing',
    vignetteIntensity: 0.65,
    vignetteShape: 0.70,
    chromaticAberration: 0.12,
    distortion: -0.02,
  ),
];
