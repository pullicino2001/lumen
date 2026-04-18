import '../models/film_look.dart';

/// All film looks available in the app, in display order.
/// Swap or extend by adding/replacing .cube files in assets/luts/.
const List<FilmLook> kFilmLooks = [
  FilmLook(
    id: 'warm_fade',
    name: 'Warm Fade',
    description: 'Lifted shadows with warm, faded tones',
    lutAssetPath: 'assets/luts/warm_fade.cube',
    thumbnailAssetPath: '',
    tier: LookTier.free,
  ),
  FilmLook(
    id: 'cool_mist',
    name: 'Cool Mist',
    description: 'Soft mist with cool, airy tones',
    lutAssetPath: 'assets/luts/cool_mist.cube',
    thumbnailAssetPath: '',
    tier: LookTier.free,
  ),
  FilmLook(
    id: 'noir',
    name: 'Noir',
    description: 'High-contrast black and white with warm highlights',
    lutAssetPath: 'assets/luts/noir.cube',
    thumbnailAssetPath: '',
    tier: LookTier.free,
  ),
];
