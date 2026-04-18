import 'package:freezed_annotation/freezed_annotation.dart';
import 'prompt_contributor.dart';

part 'grain_settings.freezed.dart';
part 'grain_settings.g.dart';

/// Grain size options — maps to shader constants.
enum GrainSize { fine, medium, coarse }

/// Grain type — luminance-only or colour grain.
enum GrainType { luminance, colour }

/// Parameters for the grain simulation shader.
///
/// Grain is shadow-weighted (stronger in shadows, fades in highlights)
/// and randomised per export — never a static texture overlay.
@freezed
abstract class GrainSettings
    with _$GrainSettings
    implements PromptContributor {
  const GrainSettings._();

  const factory GrainSettings({
    /// Grain strength. 0 = off, 100 = maximum.
    @Default(0.0) double intensity,

    /// Physical grain size.
    @Default(GrainSize.medium) GrainSize size,

    /// Luminance-only or colour grain.
    @Default(GrainType.luminance) GrainType type,
  }) = _GrainSettings;

  factory GrainSettings.fromJson(Map<String, dynamic> json) =>
      _$GrainSettingsFromJson(json);

  @override
  String toPromptFragment() => '';
}
