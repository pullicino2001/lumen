// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'grain_settings.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$GrainSettingsImpl _$$GrainSettingsImplFromJson(Map<String, dynamic> json) =>
    _$GrainSettingsImpl(
      intensity: (json['intensity'] as num?)?.toDouble() ?? 0.0,
      size:
          $enumDecodeNullable(_$GrainSizeEnumMap, json['size']) ??
          GrainSize.medium,
      type:
          $enumDecodeNullable(_$GrainTypeEnumMap, json['type']) ??
          GrainType.luminance,
    );

Map<String, dynamic> _$$GrainSettingsImplToJson(_$GrainSettingsImpl instance) =>
    <String, dynamic>{
      'intensity': instance.intensity,
      'size': _$GrainSizeEnumMap[instance.size]!,
      'type': _$GrainTypeEnumMap[instance.type]!,
    };

const _$GrainSizeEnumMap = {
  GrainSize.fine: 'fine',
  GrainSize.medium: 'medium',
  GrainSize.coarse: 'coarse',
};

const _$GrainTypeEnumMap = {
  GrainType.luminance: 'luminance',
  GrainType.colour: 'colour',
};
