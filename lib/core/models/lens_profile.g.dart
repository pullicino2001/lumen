// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'lens_profile.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$LensProfileImpl _$$LensProfileImplFromJson(Map<String, dynamic> json) =>
    _$LensProfileImpl(
      id: json['id'] as String,
      name: json['name'] as String,
      description: json['description'] as String,
      tier:
          $enumDecodeNullable(_$ProfileTierEnumMap, json['tier']) ??
          ProfileTier.free,
      vignetteIntensity: (json['vignetteIntensity'] as num?)?.toDouble() ?? 0.0,
      vignetteShape: (json['vignetteShape'] as num?)?.toDouble() ?? 0.0,
      chromaticAberration:
          (json['chromaticAberration'] as num?)?.toDouble() ?? 0.0,
      cornerSoftness: (json['cornerSoftness'] as num?)?.toDouble() ?? 0.0,
      distortion: (json['distortion'] as num?)?.toDouble() ?? 0.0,
      bokeh: json['bokeh'] as Map<String, dynamic>? ?? null,
    );

Map<String, dynamic> _$$LensProfileImplToJson(_$LensProfileImpl instance) =>
    <String, dynamic>{
      'id': instance.id,
      'name': instance.name,
      'description': instance.description,
      'tier': _$ProfileTierEnumMap[instance.tier]!,
      'vignetteIntensity': instance.vignetteIntensity,
      'vignetteShape': instance.vignetteShape,
      'chromaticAberration': instance.chromaticAberration,
      'cornerSoftness': instance.cornerSoftness,
      'distortion': instance.distortion,
      'bokeh': instance.bokeh,
    };

const _$ProfileTierEnumMap = {ProfileTier.free: 'free', ProfileTier.pro: 'pro'};
