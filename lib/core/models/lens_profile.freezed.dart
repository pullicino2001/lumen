// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'lens_profile.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
  'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models',
);

LensProfile _$LensProfileFromJson(Map<String, dynamic> json) {
  return _LensProfile.fromJson(json);
}

/// @nodoc
mixin _$LensProfile {
  /// Unique identifier — matches the JSON filename without extension.
  String get id => throw _privateConstructorUsedError;

  /// Display name shown in the UI.
  String get name => throw _privateConstructorUsedError;

  /// Short description of the character.
  String get description => throw _privateConstructorUsedError;

  /// Subscription tier required to use this profile.
  ProfileTier get tier =>
      throw _privateConstructorUsedError; // — Shader parameters —
  /// Vignette intensity. 0 = none, 1 = maximum.
  double get vignetteIntensity => throw _privateConstructorUsedError;

  /// Vignette shape: 0 = circular, 1 = rectangular.
  double get vignetteShape => throw _privateConstructorUsedError;

  /// Lateral chromatic aberration intensity.
  double get chromaticAberration => throw _privateConstructorUsedError;

  /// Corner softness / focus falloff.
  double get cornerSoftness => throw _privateConstructorUsedError;

  /// Barrel (positive) or pincushion (negative) distortion.
  double get distortion =>
      throw _privateConstructorUsedError; // — Reserved for v3 —
  /// Bokeh simulation parameters. Null until v3 depth-map work.
  Map<String, dynamic>? get bokeh => throw _privateConstructorUsedError;

  /// Serializes this LensProfile to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of LensProfile
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $LensProfileCopyWith<LensProfile> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $LensProfileCopyWith<$Res> {
  factory $LensProfileCopyWith(
    LensProfile value,
    $Res Function(LensProfile) then,
  ) = _$LensProfileCopyWithImpl<$Res, LensProfile>;
  @useResult
  $Res call({
    String id,
    String name,
    String description,
    ProfileTier tier,
    double vignetteIntensity,
    double vignetteShape,
    double chromaticAberration,
    double cornerSoftness,
    double distortion,
    Map<String, dynamic>? bokeh,
  });
}

/// @nodoc
class _$LensProfileCopyWithImpl<$Res, $Val extends LensProfile>
    implements $LensProfileCopyWith<$Res> {
  _$LensProfileCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of LensProfile
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? name = null,
    Object? description = null,
    Object? tier = null,
    Object? vignetteIntensity = null,
    Object? vignetteShape = null,
    Object? chromaticAberration = null,
    Object? cornerSoftness = null,
    Object? distortion = null,
    Object? bokeh = freezed,
  }) {
    return _then(
      _value.copyWith(
            id: null == id
                ? _value.id
                : id // ignore: cast_nullable_to_non_nullable
                      as String,
            name: null == name
                ? _value.name
                : name // ignore: cast_nullable_to_non_nullable
                      as String,
            description: null == description
                ? _value.description
                : description // ignore: cast_nullable_to_non_nullable
                      as String,
            tier: null == tier
                ? _value.tier
                : tier // ignore: cast_nullable_to_non_nullable
                      as ProfileTier,
            vignetteIntensity: null == vignetteIntensity
                ? _value.vignetteIntensity
                : vignetteIntensity // ignore: cast_nullable_to_non_nullable
                      as double,
            vignetteShape: null == vignetteShape
                ? _value.vignetteShape
                : vignetteShape // ignore: cast_nullable_to_non_nullable
                      as double,
            chromaticAberration: null == chromaticAberration
                ? _value.chromaticAberration
                : chromaticAberration // ignore: cast_nullable_to_non_nullable
                      as double,
            cornerSoftness: null == cornerSoftness
                ? _value.cornerSoftness
                : cornerSoftness // ignore: cast_nullable_to_non_nullable
                      as double,
            distortion: null == distortion
                ? _value.distortion
                : distortion // ignore: cast_nullable_to_non_nullable
                      as double,
            bokeh: freezed == bokeh
                ? _value.bokeh
                : bokeh // ignore: cast_nullable_to_non_nullable
                      as Map<String, dynamic>?,
          )
          as $Val,
    );
  }
}

/// @nodoc
abstract class _$$LensProfileImplCopyWith<$Res>
    implements $LensProfileCopyWith<$Res> {
  factory _$$LensProfileImplCopyWith(
    _$LensProfileImpl value,
    $Res Function(_$LensProfileImpl) then,
  ) = __$$LensProfileImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({
    String id,
    String name,
    String description,
    ProfileTier tier,
    double vignetteIntensity,
    double vignetteShape,
    double chromaticAberration,
    double cornerSoftness,
    double distortion,
    Map<String, dynamic>? bokeh,
  });
}

/// @nodoc
class __$$LensProfileImplCopyWithImpl<$Res>
    extends _$LensProfileCopyWithImpl<$Res, _$LensProfileImpl>
    implements _$$LensProfileImplCopyWith<$Res> {
  __$$LensProfileImplCopyWithImpl(
    _$LensProfileImpl _value,
    $Res Function(_$LensProfileImpl) _then,
  ) : super(_value, _then);

  /// Create a copy of LensProfile
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? name = null,
    Object? description = null,
    Object? tier = null,
    Object? vignetteIntensity = null,
    Object? vignetteShape = null,
    Object? chromaticAberration = null,
    Object? cornerSoftness = null,
    Object? distortion = null,
    Object? bokeh = freezed,
  }) {
    return _then(
      _$LensProfileImpl(
        id: null == id
            ? _value.id
            : id // ignore: cast_nullable_to_non_nullable
                  as String,
        name: null == name
            ? _value.name
            : name // ignore: cast_nullable_to_non_nullable
                  as String,
        description: null == description
            ? _value.description
            : description // ignore: cast_nullable_to_non_nullable
                  as String,
        tier: null == tier
            ? _value.tier
            : tier // ignore: cast_nullable_to_non_nullable
                  as ProfileTier,
        vignetteIntensity: null == vignetteIntensity
            ? _value.vignetteIntensity
            : vignetteIntensity // ignore: cast_nullable_to_non_nullable
                  as double,
        vignetteShape: null == vignetteShape
            ? _value.vignetteShape
            : vignetteShape // ignore: cast_nullable_to_non_nullable
                  as double,
        chromaticAberration: null == chromaticAberration
            ? _value.chromaticAberration
            : chromaticAberration // ignore: cast_nullable_to_non_nullable
                  as double,
        cornerSoftness: null == cornerSoftness
            ? _value.cornerSoftness
            : cornerSoftness // ignore: cast_nullable_to_non_nullable
                  as double,
        distortion: null == distortion
            ? _value.distortion
            : distortion // ignore: cast_nullable_to_non_nullable
                  as double,
        bokeh: freezed == bokeh
            ? _value._bokeh
            : bokeh // ignore: cast_nullable_to_non_nullable
                  as Map<String, dynamic>?,
      ),
    );
  }
}

/// @nodoc
@JsonSerializable()
class _$LensProfileImpl extends _LensProfile {
  const _$LensProfileImpl({
    required this.id,
    required this.name,
    required this.description,
    this.tier = ProfileTier.free,
    this.vignetteIntensity = 0.0,
    this.vignetteShape = 0.0,
    this.chromaticAberration = 0.0,
    this.cornerSoftness = 0.0,
    this.distortion = 0.0,
    final Map<String, dynamic>? bokeh = null,
  }) : _bokeh = bokeh,
       super._();

  factory _$LensProfileImpl.fromJson(Map<String, dynamic> json) =>
      _$$LensProfileImplFromJson(json);

  /// Unique identifier — matches the JSON filename without extension.
  @override
  final String id;

  /// Display name shown in the UI.
  @override
  final String name;

  /// Short description of the character.
  @override
  final String description;

  /// Subscription tier required to use this profile.
  @override
  @JsonKey()
  final ProfileTier tier;
  // — Shader parameters —
  /// Vignette intensity. 0 = none, 1 = maximum.
  @override
  @JsonKey()
  final double vignetteIntensity;

  /// Vignette shape: 0 = circular, 1 = rectangular.
  @override
  @JsonKey()
  final double vignetteShape;

  /// Lateral chromatic aberration intensity.
  @override
  @JsonKey()
  final double chromaticAberration;

  /// Corner softness / focus falloff.
  @override
  @JsonKey()
  final double cornerSoftness;

  /// Barrel (positive) or pincushion (negative) distortion.
  @override
  @JsonKey()
  final double distortion;
  // — Reserved for v3 —
  /// Bokeh simulation parameters. Null until v3 depth-map work.
  final Map<String, dynamic>? _bokeh;
  // — Reserved for v3 —
  /// Bokeh simulation parameters. Null until v3 depth-map work.
  @override
  @JsonKey()
  Map<String, dynamic>? get bokeh {
    final value = _bokeh;
    if (value == null) return null;
    if (_bokeh is EqualUnmodifiableMapView) return _bokeh;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableMapView(value);
  }

  @override
  String toString() {
    return 'LensProfile(id: $id, name: $name, description: $description, tier: $tier, vignetteIntensity: $vignetteIntensity, vignetteShape: $vignetteShape, chromaticAberration: $chromaticAberration, cornerSoftness: $cornerSoftness, distortion: $distortion, bokeh: $bokeh)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$LensProfileImpl &&
            (identical(other.id, id) || other.id == id) &&
            (identical(other.name, name) || other.name == name) &&
            (identical(other.description, description) ||
                other.description == description) &&
            (identical(other.tier, tier) || other.tier == tier) &&
            (identical(other.vignetteIntensity, vignetteIntensity) ||
                other.vignetteIntensity == vignetteIntensity) &&
            (identical(other.vignetteShape, vignetteShape) ||
                other.vignetteShape == vignetteShape) &&
            (identical(other.chromaticAberration, chromaticAberration) ||
                other.chromaticAberration == chromaticAberration) &&
            (identical(other.cornerSoftness, cornerSoftness) ||
                other.cornerSoftness == cornerSoftness) &&
            (identical(other.distortion, distortion) ||
                other.distortion == distortion) &&
            const DeepCollectionEquality().equals(other._bokeh, _bokeh));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(
    runtimeType,
    id,
    name,
    description,
    tier,
    vignetteIntensity,
    vignetteShape,
    chromaticAberration,
    cornerSoftness,
    distortion,
    const DeepCollectionEquality().hash(_bokeh),
  );

  /// Create a copy of LensProfile
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$LensProfileImplCopyWith<_$LensProfileImpl> get copyWith =>
      __$$LensProfileImplCopyWithImpl<_$LensProfileImpl>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$LensProfileImplToJson(this);
  }
}

abstract class _LensProfile extends LensProfile {
  const factory _LensProfile({
    required final String id,
    required final String name,
    required final String description,
    final ProfileTier tier,
    final double vignetteIntensity,
    final double vignetteShape,
    final double chromaticAberration,
    final double cornerSoftness,
    final double distortion,
    final Map<String, dynamic>? bokeh,
  }) = _$LensProfileImpl;
  const _LensProfile._() : super._();

  factory _LensProfile.fromJson(Map<String, dynamic> json) =
      _$LensProfileImpl.fromJson;

  /// Unique identifier — matches the JSON filename without extension.
  @override
  String get id;

  /// Display name shown in the UI.
  @override
  String get name;

  /// Short description of the character.
  @override
  String get description;

  /// Subscription tier required to use this profile.
  @override
  ProfileTier get tier; // — Shader parameters —
  /// Vignette intensity. 0 = none, 1 = maximum.
  @override
  double get vignetteIntensity;

  /// Vignette shape: 0 = circular, 1 = rectangular.
  @override
  double get vignetteShape;

  /// Lateral chromatic aberration intensity.
  @override
  double get chromaticAberration;

  /// Corner softness / focus falloff.
  @override
  double get cornerSoftness;

  /// Barrel (positive) or pincushion (negative) distortion.
  @override
  double get distortion; // — Reserved for v3 —
  /// Bokeh simulation parameters. Null until v3 depth-map work.
  @override
  Map<String, dynamic>? get bokeh;

  /// Create a copy of LensProfile
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$LensProfileImplCopyWith<_$LensProfileImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
