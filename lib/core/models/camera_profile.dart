import 'package:freezed_annotation/freezed_annotation.dart';
import 'lens_profile.dart';
import 'prompt_contributor.dart';

part 'camera_profile.freezed.dart';
part 'camera_profile.g.dart';

/// A named camera body profile describing sensor and rendering character.
///
/// Implements [PromptContributor] so it feeds into the GenerationPromptBuilder.
/// Sensor bias fields inform colour-matrix adjustments; [promptFragment] is
/// the direct AI generation text assembled from research profiles.
@freezed
abstract class CameraProfile with _$CameraProfile implements PromptContributor {
  const CameraProfile._();

  const factory CameraProfile({
    /// Unique identifier — snake_case.
    required String id,

    /// Display name shown in the UI.
    required String name,

    /// Short description of the camera character.
    required String description,

    /// Subscription tier required to use this profile.
    @Default(ProfileTier.free) ProfileTier tier,

    // — Sensor characteristics —

    /// Warm/cool bias of the sensor colour science. -1.0 (cool) to +1.0 (warm).
    @Default(0.0) double warmthBias,

    /// Contrast character. -1.0 (flat/log) to +1.0 (punchy/vivid).
    @Default(0.0) double contrastBias,

    /// Shadow floor lift. 0 = deep blacks, 1.0 = lifted shadow floor.
    @Default(0.0) double shadowLift,

    /// Highlight rolloff character. 0 = abrupt clip, 1.0 = film-like gradual rolloff.
    @Default(0.0) double highlightRolloff,

    /// True for film cameras — rendering is entirely the film stock's domain.
    @Default(false) bool isFilmCamera,

    // — AI generation prompt fragment —

    /// Plain-text prompt fragment for AI generation. Image-agnostic and model-agnostic.
    /// Assembled by GenerationPromptBuilder into the full generation prompt.
    @Default('') String promptFragment,
  }) = _CameraProfile;

  factory CameraProfile.fromJson(Map<String, dynamic> json) =>
      _$CameraProfileFromJson(json);

  @override
  String toPromptFragment() => promptFragment;
}
