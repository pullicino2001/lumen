import 'package:freezed_annotation/freezed_annotation.dart';
import 'prompt_contributor.dart';

part 'lens_profile.freezed.dart';
part 'lens_profile.g.dart';

/// Subscription tier a lens profile belongs to.
enum ProfileTier { free, pro }

/// A named lens character profile.
///
/// Profiles are named by character, not brand — e.g. "Classic 35".
/// The [bokeh] field is reserved for v3 depth-map bokeh simulation.
/// Stored as JSON in assets/lens_profiles/.
@freezed
abstract class LensProfile with _$LensProfile implements PromptContributor {
  const LensProfile._();

  const factory LensProfile({
    /// Unique identifier — matches the JSON filename without extension.
    required String id,

    /// Display name shown in the UI.
    required String name,

    /// Short description of the character.
    required String description,

    /// Subscription tier required to use this profile.
    @Default(ProfileTier.free) ProfileTier tier,

    // — Shader parameters —

    /// Vignette intensity. 0 = none, 1 = maximum.
    @Default(0.0) double vignetteIntensity,

    /// Vignette shape: 0 = circular, 1 = rectangular.
    @Default(0.0) double vignetteShape,

    /// Lateral chromatic aberration intensity.
    @Default(0.0) double chromaticAberration,

    /// Corner softness / focus falloff.
    @Default(0.0) double cornerSoftness,

    /// Barrel (positive) or pincushion (negative) distortion.
    @Default(0.0) double distortion,

    // — Reserved for v3 —

    /// Bokeh simulation parameters. Null until v3 depth-map work.
    @Default(null) Map<String, dynamic>? bokeh,
  }) = _LensProfile;

  factory LensProfile.fromJson(Map<String, dynamic> json) =>
      _$LensProfileFromJson(json);

  @override
  String toPromptFragment() => '';
}
