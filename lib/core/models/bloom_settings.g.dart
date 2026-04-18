// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'bloom_settings.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$BloomSettingsImpl _$$BloomSettingsImplFromJson(Map<String, dynamic> json) =>
    _$BloomSettingsImpl(
      bloomIntensity: (json['bloomIntensity'] as num?)?.toDouble() ?? 0.0,
      bloomRadius: (json['bloomRadius'] as num?)?.toDouble() ?? 0.5,
      bloomThreshold: (json['bloomThreshold'] as num?)?.toDouble() ?? 0.8,
      halationIntensity: (json['halationIntensity'] as num?)?.toDouble() ?? 0.0,
      halationWarmth: (json['halationWarmth'] as num?)?.toDouble() ?? 0.7,
      halationSpread: (json['halationSpread'] as num?)?.toDouble() ?? 0.5,
    );

Map<String, dynamic> _$$BloomSettingsImplToJson(_$BloomSettingsImpl instance) =>
    <String, dynamic>{
      'bloomIntensity': instance.bloomIntensity,
      'bloomRadius': instance.bloomRadius,
      'bloomThreshold': instance.bloomThreshold,
      'halationIntensity': instance.halationIntensity,
      'halationWarmth': instance.halationWarmth,
      'halationSpread': instance.halationSpread,
    };
