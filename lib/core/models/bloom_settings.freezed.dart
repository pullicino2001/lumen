// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'bloom_settings.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
  'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models',
);

BloomSettings _$BloomSettingsFromJson(Map<String, dynamic> json) {
  return _BloomSettings.fromJson(json);
}

/// @nodoc
mixin _$BloomSettings {
  // — Bloom —
  /// Bloom strength. 0 = off.
  double get bloomIntensity => throw _privateConstructorUsedError;

  /// Glow spread radius.
  double get bloomRadius => throw _privateConstructorUsedError;

  /// Highlight luminance threshold that triggers bloom (0–1).
  double get bloomThreshold =>
      throw _privateConstructorUsedError; // — Halation —
  /// Halation strength. 0 = off.
  double get halationIntensity => throw _privateConstructorUsedError;

  /// Colour temperature of the bleed: 0 = neutral, 1 = warm orange.
  double get halationWarmth => throw _privateConstructorUsedError;

  /// How far the bleed spreads from the edge.
  double get halationSpread => throw _privateConstructorUsedError;

  /// Serializes this BloomSettings to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of BloomSettings
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $BloomSettingsCopyWith<BloomSettings> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $BloomSettingsCopyWith<$Res> {
  factory $BloomSettingsCopyWith(
    BloomSettings value,
    $Res Function(BloomSettings) then,
  ) = _$BloomSettingsCopyWithImpl<$Res, BloomSettings>;
  @useResult
  $Res call({
    double bloomIntensity,
    double bloomRadius,
    double bloomThreshold,
    double halationIntensity,
    double halationWarmth,
    double halationSpread,
  });
}

/// @nodoc
class _$BloomSettingsCopyWithImpl<$Res, $Val extends BloomSettings>
    implements $BloomSettingsCopyWith<$Res> {
  _$BloomSettingsCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of BloomSettings
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? bloomIntensity = null,
    Object? bloomRadius = null,
    Object? bloomThreshold = null,
    Object? halationIntensity = null,
    Object? halationWarmth = null,
    Object? halationSpread = null,
  }) {
    return _then(
      _value.copyWith(
            bloomIntensity: null == bloomIntensity
                ? _value.bloomIntensity
                : bloomIntensity // ignore: cast_nullable_to_non_nullable
                      as double,
            bloomRadius: null == bloomRadius
                ? _value.bloomRadius
                : bloomRadius // ignore: cast_nullable_to_non_nullable
                      as double,
            bloomThreshold: null == bloomThreshold
                ? _value.bloomThreshold
                : bloomThreshold // ignore: cast_nullable_to_non_nullable
                      as double,
            halationIntensity: null == halationIntensity
                ? _value.halationIntensity
                : halationIntensity // ignore: cast_nullable_to_non_nullable
                      as double,
            halationWarmth: null == halationWarmth
                ? _value.halationWarmth
                : halationWarmth // ignore: cast_nullable_to_non_nullable
                      as double,
            halationSpread: null == halationSpread
                ? _value.halationSpread
                : halationSpread // ignore: cast_nullable_to_non_nullable
                      as double,
          )
          as $Val,
    );
  }
}

/// @nodoc
abstract class _$$BloomSettingsImplCopyWith<$Res>
    implements $BloomSettingsCopyWith<$Res> {
  factory _$$BloomSettingsImplCopyWith(
    _$BloomSettingsImpl value,
    $Res Function(_$BloomSettingsImpl) then,
  ) = __$$BloomSettingsImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({
    double bloomIntensity,
    double bloomRadius,
    double bloomThreshold,
    double halationIntensity,
    double halationWarmth,
    double halationSpread,
  });
}

/// @nodoc
class __$$BloomSettingsImplCopyWithImpl<$Res>
    extends _$BloomSettingsCopyWithImpl<$Res, _$BloomSettingsImpl>
    implements _$$BloomSettingsImplCopyWith<$Res> {
  __$$BloomSettingsImplCopyWithImpl(
    _$BloomSettingsImpl _value,
    $Res Function(_$BloomSettingsImpl) _then,
  ) : super(_value, _then);

  /// Create a copy of BloomSettings
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? bloomIntensity = null,
    Object? bloomRadius = null,
    Object? bloomThreshold = null,
    Object? halationIntensity = null,
    Object? halationWarmth = null,
    Object? halationSpread = null,
  }) {
    return _then(
      _$BloomSettingsImpl(
        bloomIntensity: null == bloomIntensity
            ? _value.bloomIntensity
            : bloomIntensity // ignore: cast_nullable_to_non_nullable
                  as double,
        bloomRadius: null == bloomRadius
            ? _value.bloomRadius
            : bloomRadius // ignore: cast_nullable_to_non_nullable
                  as double,
        bloomThreshold: null == bloomThreshold
            ? _value.bloomThreshold
            : bloomThreshold // ignore: cast_nullable_to_non_nullable
                  as double,
        halationIntensity: null == halationIntensity
            ? _value.halationIntensity
            : halationIntensity // ignore: cast_nullable_to_non_nullable
                  as double,
        halationWarmth: null == halationWarmth
            ? _value.halationWarmth
            : halationWarmth // ignore: cast_nullable_to_non_nullable
                  as double,
        halationSpread: null == halationSpread
            ? _value.halationSpread
            : halationSpread // ignore: cast_nullable_to_non_nullable
                  as double,
      ),
    );
  }
}

/// @nodoc
@JsonSerializable()
class _$BloomSettingsImpl extends _BloomSettings {
  const _$BloomSettingsImpl({
    this.bloomIntensity = 0.0,
    this.bloomRadius = 0.5,
    this.bloomThreshold = 0.8,
    this.halationIntensity = 0.0,
    this.halationWarmth = 0.7,
    this.halationSpread = 0.5,
  }) : super._();

  factory _$BloomSettingsImpl.fromJson(Map<String, dynamic> json) =>
      _$$BloomSettingsImplFromJson(json);

  // — Bloom —
  /// Bloom strength. 0 = off.
  @override
  @JsonKey()
  final double bloomIntensity;

  /// Glow spread radius.
  @override
  @JsonKey()
  final double bloomRadius;

  /// Highlight luminance threshold that triggers bloom (0–1).
  @override
  @JsonKey()
  final double bloomThreshold;
  // — Halation —
  /// Halation strength. 0 = off.
  @override
  @JsonKey()
  final double halationIntensity;

  /// Colour temperature of the bleed: 0 = neutral, 1 = warm orange.
  @override
  @JsonKey()
  final double halationWarmth;

  /// How far the bleed spreads from the edge.
  @override
  @JsonKey()
  final double halationSpread;

  @override
  String toString() {
    return 'BloomSettings(bloomIntensity: $bloomIntensity, bloomRadius: $bloomRadius, bloomThreshold: $bloomThreshold, halationIntensity: $halationIntensity, halationWarmth: $halationWarmth, halationSpread: $halationSpread)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$BloomSettingsImpl &&
            (identical(other.bloomIntensity, bloomIntensity) ||
                other.bloomIntensity == bloomIntensity) &&
            (identical(other.bloomRadius, bloomRadius) ||
                other.bloomRadius == bloomRadius) &&
            (identical(other.bloomThreshold, bloomThreshold) ||
                other.bloomThreshold == bloomThreshold) &&
            (identical(other.halationIntensity, halationIntensity) ||
                other.halationIntensity == halationIntensity) &&
            (identical(other.halationWarmth, halationWarmth) ||
                other.halationWarmth == halationWarmth) &&
            (identical(other.halationSpread, halationSpread) ||
                other.halationSpread == halationSpread));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(
    runtimeType,
    bloomIntensity,
    bloomRadius,
    bloomThreshold,
    halationIntensity,
    halationWarmth,
    halationSpread,
  );

  /// Create a copy of BloomSettings
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$BloomSettingsImplCopyWith<_$BloomSettingsImpl> get copyWith =>
      __$$BloomSettingsImplCopyWithImpl<_$BloomSettingsImpl>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$BloomSettingsImplToJson(this);
  }
}

abstract class _BloomSettings extends BloomSettings {
  const factory _BloomSettings({
    final double bloomIntensity,
    final double bloomRadius,
    final double bloomThreshold,
    final double halationIntensity,
    final double halationWarmth,
    final double halationSpread,
  }) = _$BloomSettingsImpl;
  const _BloomSettings._() : super._();

  factory _BloomSettings.fromJson(Map<String, dynamic> json) =
      _$BloomSettingsImpl.fromJson;

  // — Bloom —
  /// Bloom strength. 0 = off.
  @override
  double get bloomIntensity;

  /// Glow spread radius.
  @override
  double get bloomRadius;

  /// Highlight luminance threshold that triggers bloom (0–1).
  @override
  double get bloomThreshold; // — Halation —
  /// Halation strength. 0 = off.
  @override
  double get halationIntensity;

  /// Colour temperature of the bleed: 0 = neutral, 1 = warm orange.
  @override
  double get halationWarmth;

  /// How far the bleed spreads from the edge.
  @override
  double get halationSpread;

  /// Create a copy of BloomSettings
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$BloomSettingsImplCopyWith<_$BloomSettingsImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
