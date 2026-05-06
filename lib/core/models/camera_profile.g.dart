// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'camera_profile.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$CameraProfileImpl _$$CameraProfileImplFromJson(Map<String, dynamic> json) =>
    _$CameraProfileImpl(
      id: json['id'] as String,
      name: json['name'] as String,
      description: json['description'] as String,
      tier:
          $enumDecodeNullable(_$ProfileTierEnumMap, json['tier']) ??
          ProfileTier.free,
      warmthBias: (json['warmthBias'] as num?)?.toDouble() ?? 0.0,
      contrastBias: (json['contrastBias'] as num?)?.toDouble() ?? 0.0,
      shadowLift: (json['shadowLift'] as num?)?.toDouble() ?? 0.0,
      highlightRolloff: (json['highlightRolloff'] as num?)?.toDouble() ?? 0.0,
      isFilmCamera: json['isFilmCamera'] as bool? ?? false,
      promptFragment: json['promptFragment'] as String? ?? '',
    );

Map<String, dynamic> _$$CameraProfileImplToJson(_$CameraProfileImpl instance) =>
    <String, dynamic>{
      'id': instance.id,
      'name': instance.name,
      'description': instance.description,
      'tier': _$ProfileTierEnumMap[instance.tier]!,
      'warmthBias': instance.warmthBias,
      'contrastBias': instance.contrastBias,
      'shadowLift': instance.shadowLift,
      'highlightRolloff': instance.highlightRolloff,
      'isFilmCamera': instance.isFilmCamera,
      'promptFragment': instance.promptFragment,
    };

const _$ProfileTierEnumMap = {ProfileTier.free: 'free', ProfileTier.pro: 'pro'};
