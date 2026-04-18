// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'basic_editor_settings.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$BasicEditorSettingsImpl _$$BasicEditorSettingsImplFromJson(
  Map<String, dynamic> json,
) => _$BasicEditorSettingsImpl(
  exposure: (json['exposure'] as num?)?.toDouble() ?? 0.0,
  contrast: (json['contrast'] as num?)?.toDouble() ?? 0.0,
  highlights: (json['highlights'] as num?)?.toDouble() ?? 0.0,
  shadows: (json['shadows'] as num?)?.toDouble() ?? 0.0,
  whites: (json['whites'] as num?)?.toDouble() ?? 0.0,
  blacks: (json['blacks'] as num?)?.toDouble() ?? 0.0,
  temperature: (json['temperature'] as num?)?.toDouble() ?? kDefaultTemperature,
  tint: (json['tint'] as num?)?.toDouble() ?? 0.0,
  clarity: (json['clarity'] as num?)?.toDouble() ?? 0.0,
  saturation: (json['saturation'] as num?)?.toDouble() ?? 0.0,
  vibrance: (json['vibrance'] as num?)?.toDouble() ?? 0.0,
);

Map<String, dynamic> _$$BasicEditorSettingsImplToJson(
  _$BasicEditorSettingsImpl instance,
) => <String, dynamic>{
  'exposure': instance.exposure,
  'contrast': instance.contrast,
  'highlights': instance.highlights,
  'shadows': instance.shadows,
  'whites': instance.whites,
  'blacks': instance.blacks,
  'temperature': instance.temperature,
  'tint': instance.tint,
  'clarity': instance.clarity,
  'saturation': instance.saturation,
  'vibrance': instance.vibrance,
};
