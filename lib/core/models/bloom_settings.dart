import 'package:freezed_annotation/freezed_annotation.dart';
import 'prompt_contributor.dart';

part 'bloom_settings.freezed.dart';
part 'bloom_settings.g.dart';

/// Parameters for the bloom and halation shader passes.
///
/// Bloom: soft glow spreading outward from bright highlights.
/// Halation: warm red/orange colour bleed around bright edges — classic film.
@freezed
abstract class BloomSettings
    with _$BloomSettings
    implements PromptContributor {
  const BloomSettings._();

  const factory BloomSettings({
    // — Bloom —

    /// Bloom strength. 0 = off.
    @Default(0.0) double bloomIntensity,

    /// Glow spread radius.
    @Default(0.5) double bloomRadius,

    /// Highlight luminance threshold that triggers bloom (0–1).
    @Default(0.8) double bloomThreshold,

    // — Halation —

    /// Halation strength. 0 = off.
    @Default(0.0) double halationIntensity,

    /// Colour temperature of the bleed: 0 = neutral, 1 = warm orange.
    @Default(0.7) double halationWarmth,

    /// How far the bleed spreads from the edge.
    @Default(0.5) double halationSpread,
  }) = _BloomSettings;

  factory BloomSettings.fromJson(Map<String, dynamic> json) =>
      _$BloomSettingsFromJson(json);

  @override
  String toPromptFragment() => '';
}
