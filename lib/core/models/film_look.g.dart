// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'film_look.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$FilmLookImpl _$$FilmLookImplFromJson(Map<String, dynamic> json) =>
    _$FilmLookImpl(
      id: json['id'] as String,
      name: json['name'] as String,
      description: json['description'] as String,
      lutAssetPath: json['lutAssetPath'] as String,
      thumbnailAssetPath: json['thumbnailAssetPath'] as String,
      tier:
          $enumDecodeNullable(_$LookTierEnumMap, json['tier']) ?? LookTier.free,
      intensity: (json['intensity'] as num?)?.toDouble() ?? 100.0,
    );

Map<String, dynamic> _$$FilmLookImplToJson(_$FilmLookImpl instance) =>
    <String, dynamic>{
      'id': instance.id,
      'name': instance.name,
      'description': instance.description,
      'lutAssetPath': instance.lutAssetPath,
      'thumbnailAssetPath': instance.thumbnailAssetPath,
      'tier': _$LookTierEnumMap[instance.tier]!,
      'intensity': instance.intensity,
    };

const _$LookTierEnumMap = {LookTier.free: 'free', LookTier.pro: 'pro'};
