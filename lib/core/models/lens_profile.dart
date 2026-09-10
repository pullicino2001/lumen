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

    /// Vignette center X (0–1, default 0.5 = image centre).
    @Default(0.5) double vignetteOffsetX,

    /// Vignette center Y (0–1, default 0.5 = image centre).
    @Default(0.5) double vignetteOffsetY,

    // — Reserved for v3 —

    /// Bokeh simulation parameters. Null until v3 depth-map work.
    @Default(null) Map<String, dynamic>? bokeh,

    // — AI generation prompt fragment —

    /// Plain-text prompt fragment for AI generation. Image-agnostic and model-agnostic.
    /// Assembled by GenerationPromptBuilder into the full generation prompt.
    @Default('') String promptFragment,
  }) = _LensProfile;

  factory LensProfile.fromJson(Map<String, dynamic> json) =>
      _$LensProfileFromJson(json);

  @override
  String toPromptFragment() => promptFragment;

  /// Aperture label for display, e.g. 'f/1.4', parsed from [name]
  /// ('Summilux 50 f/1.4'). Falls back to known character-profile apertures
  /// for the legacy profiles, then to 'f/—'.
  String get apertureLabel {
    final m = RegExp(r'f/\s*(\d+(?:\.\d+)?)', caseSensitive: false)
        .firstMatch(name);
    if (m != null) return 'f/${m.group(1)}';
    return switch (id) {
      'classic_50'  => 'f/1.8',
      'portrait_85' => 'f/1.4',
      'wide_24'     => 'f/2.8',
      'vintage_35'  => 'f/2.8',
      'anamorphic'  => 'f/2.0',
      _             => 'f/—',
    };
  }
}
