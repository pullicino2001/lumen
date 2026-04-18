// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'grain_settings.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
  'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models',
);

GrainSettings _$GrainSettingsFromJson(Map<String, dynamic> json) {
  return _GrainSettings.fromJson(json);
}

/// @nodoc
mixin _$GrainSettings {
  /// Grain strength. 0 = off, 100 = maximum.
  double get intensity => throw _privateConstructorUsedError;

  /// Physical grain size.
  GrainSize get size => throw _privateConstructorUsedError;

  /// Luminance-only or colour grain.
  GrainType get type => throw _privateConstructorUsedError;

  /// Serializes this GrainSettings to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of GrainSettings
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $GrainSettingsCopyWith<GrainSettings> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $GrainSettingsCopyWith<$Res> {
  factory $GrainSettingsCopyWith(
    GrainSettings value,
    $Res Function(GrainSettings) then,
  ) = _$GrainSettingsCopyWithImpl<$Res, GrainSettings>;
  @useResult
  $Res call({double intensity, GrainSize size, GrainType type});
}

/// @nodoc
class _$GrainSettingsCopyWithImpl<$Res, $Val extends GrainSettings>
    implements $GrainSettingsCopyWith<$Res> {
  _$GrainSettingsCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of GrainSettings
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? intensity = null,
    Object? size = null,
    Object? type = null,
  }) {
    return _then(
      _value.copyWith(
            intensity: null == intensity
                ? _value.intensity
                : intensity // ignore: cast_nullable_to_non_nullable
                      as double,
            size: null == size
                ? _value.size
                : size // ignore: cast_nullable_to_non_nullable
                      as GrainSize,
            type: null == type
                ? _value.type
                : type // ignore: cast_nullable_to_non_nullable
                      as GrainType,
          )
          as $Val,
    );
  }
}

/// @nodoc
abstract class _$$GrainSettingsImplCopyWith<$Res>
    implements $GrainSettingsCopyWith<$Res> {
  factory _$$GrainSettingsImplCopyWith(
    _$GrainSettingsImpl value,
    $Res Function(_$GrainSettingsImpl) then,
  ) = __$$GrainSettingsImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({double intensity, GrainSize size, GrainType type});
}

/// @nodoc
class __$$GrainSettingsImplCopyWithImpl<$Res>
    extends _$GrainSettingsCopyWithImpl<$Res, _$GrainSettingsImpl>
    implements _$$GrainSettingsImplCopyWith<$Res> {
  __$$GrainSettingsImplCopyWithImpl(
    _$GrainSettingsImpl _value,
    $Res Function(_$GrainSettingsImpl) _then,
  ) : super(_value, _then);

  /// Create a copy of GrainSettings
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? intensity = null,
    Object? size = null,
    Object? type = null,
  }) {
    return _then(
      _$GrainSettingsImpl(
        intensity: null == intensity
            ? _value.intensity
            : intensity // ignore: cast_nullable_to_non_nullable
                  as double,
        size: null == size
            ? _value.size
            : size // ignore: cast_nullable_to_non_nullable
                  as GrainSize,
        type: null == type
            ? _value.type
            : type // ignore: cast_nullable_to_non_nullable
                  as GrainType,
      ),
    );
  }
}

/// @nodoc
@JsonSerializable()
class _$GrainSettingsImpl extends _GrainSettings {
  const _$GrainSettingsImpl({
    this.intensity = 0.0,
    this.size = GrainSize.medium,
    this.type = GrainType.luminance,
  }) : super._();

  factory _$GrainSettingsImpl.fromJson(Map<String, dynamic> json) =>
      _$$GrainSettingsImplFromJson(json);

  /// Grain strength. 0 = off, 100 = maximum.
  @override
  @JsonKey()
  final double intensity;

  /// Physical grain size.
  @override
  @JsonKey()
  final GrainSize size;

  /// Luminance-only or colour grain.
  @override
  @JsonKey()
  final GrainType type;

  @override
  String toString() {
    return 'GrainSettings(intensity: $intensity, size: $size, type: $type)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$GrainSettingsImpl &&
            (identical(other.intensity, intensity) ||
                other.intensity == intensity) &&
            (identical(other.size, size) || other.size == size) &&
            (identical(other.type, type) || other.type == type));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(runtimeType, intensity, size, type);

  /// Create a copy of GrainSettings
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$GrainSettingsImplCopyWith<_$GrainSettingsImpl> get copyWith =>
      __$$GrainSettingsImplCopyWithImpl<_$GrainSettingsImpl>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$GrainSettingsImplToJson(this);
  }
}

abstract class _GrainSettings extends GrainSettings {
  const factory _GrainSettings({
    final double intensity,
    final GrainSize size,
    final GrainType type,
  }) = _$GrainSettingsImpl;
  const _GrainSettings._() : super._();

  factory _GrainSettings.fromJson(Map<String, dynamic> json) =
      _$GrainSettingsImpl.fromJson;

  /// Grain strength. 0 = off, 100 = maximum.
  @override
  double get intensity;

  /// Physical grain size.
  @override
  GrainSize get size;

  /// Luminance-only or colour grain.
  @override
  GrainType get type;

  /// Create a copy of GrainSettings
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$GrainSettingsImplCopyWith<_$GrainSettingsImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
