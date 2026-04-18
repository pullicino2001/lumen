import 'package:freezed_annotation/freezed_annotation.dart';
import 'prompt_contributor.dart';
import '../constants.dart';

part 'basic_editor_settings.freezed.dart';
part 'basic_editor_settings.g.dart';

/// Non-destructive basic editor adjustments.
///
/// All values default to neutral (0 / midpoint). Applied as a distinct
/// shader pass — can be positioned before or after the effect stack.
@freezed
abstract class BasicEditorSettings
    with _$BasicEditorSettings
    implements PromptContributor {
  const BasicEditorSettings._();

  const factory BasicEditorSettings({
    /// Overall brightness — EV units.
    @Default(0.0) double exposure,

    /// Midtone contrast.
    @Default(0.0) double contrast,

    /// Recover or boost bright tones.
    @Default(0.0) double highlights,

    /// Lift or crush dark tones.
    @Default(0.0) double shadows,

    /// White point adjustment.
    @Default(0.0) double whites,

    /// Black point adjustment.
    @Default(0.0) double blacks,

    /// Colour temperature in Kelvin.
    @Default(kDefaultTemperature) double temperature,

    /// Green/magenta balance.
    @Default(0.0) double tint,

    /// Midtone contrast and texture.
    @Default(0.0) double clarity,

    /// Global colour intensity.
    @Default(0.0) double saturation,

    /// Intelligent saturation — protects skin tones.
    @Default(0.0) double vibrance,
  }) = _BasicEditorSettings;

  factory BasicEditorSettings.fromJson(Map<String, dynamic> json) =>
      _$BasicEditorSettingsFromJson(json);

  /// Returns true if every parameter is at its neutral/default value.
  bool get isNeutral =>
      exposure == 0.0 &&
      contrast == 0.0 &&
      highlights == 0.0 &&
      shadows == 0.0 &&
      whites == 0.0 &&
      blacks == 0.0 &&
      temperature == kDefaultTemperature &&
      tint == 0.0 &&
      clarity == 0.0 &&
      saturation == 0.0 &&
      vibrance == 0.0;

  @override
  String toPromptFragment() => '';
}
