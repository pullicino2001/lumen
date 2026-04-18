// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'edit_state.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$EditStateImpl _$$EditStateImplFromJson(Map<String, dynamic> json) =>
    _$EditStateImpl(
      originalFilePath: json['originalFilePath'] as String,
      workingFilePath: json['workingFilePath'] as String,
      basicEditor: json['basicEditor'] == null
          ? const BasicEditorSettings()
          : BasicEditorSettings.fromJson(
              json['basicEditor'] as Map<String, dynamic>,
            ),
      lensProfile: json['lensProfile'] == null
          ? null
          : LensProfile.fromJson(json['lensProfile'] as Map<String, dynamic>),
      filmLook: json['filmLook'] == null
          ? null
          : FilmLook.fromJson(json['filmLook'] as Map<String, dynamic>),
      grain: json['grain'] == null
          ? const GrainSettings()
          : GrainSettings.fromJson(json['grain'] as Map<String, dynamic>),
      bloom: json['bloom'] == null
          ? const BloomSettings()
          : BloomSettings.fromJson(json['bloom'] as Map<String, dynamic>),
      lensEnabled: json['lensEnabled'] as bool? ?? true,
      filmLookEnabled: json['filmLookEnabled'] as bool? ?? true,
      grainEnabled: json['grainEnabled'] as bool? ?? true,
      bloomEnabled: json['bloomEnabled'] as bool? ?? true,
      basicEditorEnabled: json['basicEditorEnabled'] as bool? ?? true,
      generatedFilePath: json['generatedFilePath'] as String? ?? null,
    );

Map<String, dynamic> _$$EditStateImplToJson(_$EditStateImpl instance) =>
    <String, dynamic>{
      'originalFilePath': instance.originalFilePath,
      'workingFilePath': instance.workingFilePath,
      'basicEditor': instance.basicEditor,
      'lensProfile': instance.lensProfile,
      'filmLook': instance.filmLook,
      'grain': instance.grain,
      'bloom': instance.bloom,
      'lensEnabled': instance.lensEnabled,
      'filmLookEnabled': instance.filmLookEnabled,
      'grainEnabled': instance.grainEnabled,
      'bloomEnabled': instance.bloomEnabled,
      'basicEditorEnabled': instance.basicEditorEnabled,
      'generatedFilePath': instance.generatedFilePath,
    };
