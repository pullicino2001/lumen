// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'camera_profile.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
  'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models',
);

CameraProfile _$CameraProfileFromJson(Map<String, dynamic> json) {
  return _CameraProfile.fromJson(json);
}

/// @nodoc
mixin _$CameraProfile {
  /// Unique identifier — snake_case.
  String get id => throw _privateConstructorUsedError;

  /// Display name shown in the UI.
  String get name => throw _privateConstructorUsedError;

  /// Short description of the camera character.
  String get description => throw _privateConstructorUsedError;

  /// Subscription tier required to use this profile.
  ProfileTier get tier =>
      throw _privateConstructorUsedError; // — Sensor characteristics —
  /// Warm/cool bias of the sensor colour science. -1.0 (cool) to +1.0 (warm).
  double get warmthBias => throw _privateConstructorUsedError;

  /// Contrast character. -1.0 (flat/log) to +1.0 (punchy/vivid).
  double get contrastBias => throw _privateConstructorUsedError;

  /// Shadow floor lift. 0 = deep blacks, 1.0 = lifted shadow floor.
  double get shadowLift => throw _privateConstructorUsedError;

  /// Highlight rolloff character. 0 = abrupt clip, 1.0 = film-like gradual rolloff.
  double get highlightRolloff => throw _privateConstructorUsedError;

  /// True for film cameras — rendering is entirely the film stock's domain.
  bool get isFilmCamera =>
      throw _privateConstructorUsedError; // — AI generation prompt fragment —
  /// Plain-text prompt fragment for AI generation. Image-agnostic and model-agnostic.
  /// Assembled by GenerationPromptBuilder into the full generation prompt.
  String get promptFragment => throw _privateConstructorUsedError;

  /// Serializes this CameraProfile to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of CameraProfile
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $CameraProfileCopyWith<CameraProfile> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $CameraProfileCopyWith<$Res> {
  factory $CameraProfileCopyWith(
    CameraProfile value,
    $Res Function(CameraProfile) then,
  ) = _$CameraProfileCopyWithImpl<$Res, CameraProfile>;
  @useResult
  $Res call({
    String id,
    String name,
    String description,
    ProfileTier tier,
    double warmthBias,
    double contrastBias,
    double shadowLift,
    double highlightRolloff,
    bool isFilmCamera,
    String promptFragment,
  });
}

/// @nodoc
class _$CameraProfileCopyWithImpl<$Res, $Val extends CameraProfile>
    implements $CameraProfileCopyWith<$Res> {
  _$CameraProfileCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of CameraProfile
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? name = null,
    Object? description = null,
    Object? tier = null,
    Object? warmthBias = null,
    Object? contrastBias = null,
    Object? shadowLift = null,
    Object? highlightRolloff = null,
    Object? isFilmCamera = null,
    Object? promptFragment = null,
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
            warmthBias: null == warmthBias
                ? _value.warmthBias
                : warmthBias // ignore: cast_nullable_to_non_nullable
                      as double,
            contrastBias: null == contrastBias
                ? _value.contrastBias
                : contrastBias // ignore: cast_nullable_to_non_nullable
                      as double,
            shadowLift: null == shadowLift
                ? _value.shadowLift
                : shadowLift // ignore: cast_nullable_to_non_nullable
                      as double,
            highlightRolloff: null == highlightRolloff
                ? _value.highlightRolloff
                : highlightRolloff // ignore: cast_nullable_to_non_nullable
                      as double,
            isFilmCamera: null == isFilmCamera
                ? _value.isFilmCamera
                : isFilmCamera // ignore: cast_nullable_to_non_nullable
                      as bool,
            promptFragment: null == promptFragment
                ? _value.promptFragment
                : promptFragment // ignore: cast_nullable_to_non_nullable
                      as String,
          )
          as $Val,
    );
  }
}

/// @nodoc
abstract class _$$CameraProfileImplCopyWith<$Res>
    implements $CameraProfileCopyWith<$Res> {
  factory _$$CameraProfileImplCopyWith(
    _$CameraProfileImpl value,
    $Res Function(_$CameraProfileImpl) then,
  ) = __$$CameraProfileImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({
    String id,
    String name,
    String description,
    ProfileTier tier,
    double warmthBias,
    double contrastBias,
    double shadowLift,
    double highlightRolloff,
    bool isFilmCamera,
    String promptFragment,
  });
}

/// @nodoc
class __$$CameraProfileImplCopyWithImpl<$Res>
    extends _$CameraProfileCopyWithImpl<$Res, _$CameraProfileImpl>
    implements _$$CameraProfileImplCopyWith<$Res> {
  __$$CameraProfileImplCopyWithImpl(
    _$CameraProfileImpl _value,
    $Res Function(_$CameraProfileImpl) _then,
  ) : super(_value, _then);

  /// Create a copy of CameraProfile
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? name = null,
    Object? description = null,
    Object? tier = null,
    Object? warmthBias = null,
    Object? contrastBias = null,
    Object? shadowLift = null,
    Object? highlightRolloff = null,
    Object? isFilmCamera = null,
    Object? promptFragment = null,
  }) {
    return _then(
      _$CameraProfileImpl(
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
        warmthBias: null == warmthBias
            ? _value.warmthBias
            : warmthBias // ignore: cast_nullable_to_non_nullable
                  as double,
        contrastBias: null == contrastBias
            ? _value.contrastBias
            : contrastBias // ignore: cast_nullable_to_non_nullable
                  as double,
        shadowLift: null == shadowLift
            ? _value.shadowLift
            : shadowLift // ignore: cast_nullable_to_non_nullable
                  as double,
        highlightRolloff: null == highlightRolloff
            ? _value.highlightRolloff
            : highlightRolloff // ignore: cast_nullable_to_non_nullable
                  as double,
        isFilmCamera: null == isFilmCamera
            ? _value.isFilmCamera
            : isFilmCamera // ignore: cast_nullable_to_non_nullable
                  as bool,
        promptFragment: null == promptFragment
            ? _value.promptFragment
            : promptFragment // ignore: cast_nullable_to_non_nullable
                  as String,
      ),
    );
  }
}

/// @nodoc
@JsonSerializable()
class _$CameraProfileImpl extends _CameraProfile {
  const _$CameraProfileImpl({
    required this.id,
    required this.name,
    required this.description,
    this.tier = ProfileTier.free,
    this.warmthBias = 0.0,
    this.contrastBias = 0.0,
    this.shadowLift = 0.0,
    this.highlightRolloff = 0.0,
    this.isFilmCamera = false,
    this.promptFragment = '',
  }) : super._();

  factory _$CameraProfileImpl.fromJson(Map<String, dynamic> json) =>
      _$$CameraProfileImplFromJson(json);

  /// Unique identifier — snake_case.
  @override
  final String id;

  /// Display name shown in the UI.
  @override
  final String name;

  /// Short description of the camera character.
  @override
  final String description;

  /// Subscription tier required to use this profile.
  @override
  @JsonKey()
  final ProfileTier tier;
  // — Sensor characteristics —
  /// Warm/cool bias of the sensor colour science. -1.0 (cool) to +1.0 (warm).
  @override
  @JsonKey()
  final double warmthBias;

  /// Contrast character. -1.0 (flat/log) to +1.0 (punchy/vivid).
  @override
  @JsonKey()
  final double contrastBias;

  /// Shadow floor lift. 0 = deep blacks, 1.0 = lifted shadow floor.
  @override
  @JsonKey()
  final double shadowLift;

  /// Highlight rolloff character. 0 = abrupt clip, 1.0 = film-like gradual rolloff.
  @override
  @JsonKey()
  final double highlightRolloff;

  /// True for film cameras — rendering is entirely the film stock's domain.
  @override
  @JsonKey()
  final bool isFilmCamera;
  // — AI generation prompt fragment —
  /// Plain-text prompt fragment for AI generation. Image-agnostic and model-agnostic.
  /// Assembled by GenerationPromptBuilder into the full generation prompt.
  @override
  @JsonKey()
  final String promptFragment;

  @override
  String toString() {
    return 'CameraProfile(id: $id, name: $name, description: $description, tier: $tier, warmthBias: $warmthBias, contrastBias: $contrastBias, shadowLift: $shadowLift, highlightRolloff: $highlightRolloff, isFilmCamera: $isFilmCamera, promptFragment: $promptFragment)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$CameraProfileImpl &&
            (identical(other.id, id) || other.id == id) &&
            (identical(other.name, name) || other.name == name) &&
            (identical(other.description, description) ||
                other.description == description) &&
            (identical(other.tier, tier) || other.tier == tier) &&
            (identical(other.warmthBias, warmthBias) ||
                other.warmthBias == warmthBias) &&
            (identical(other.contrastBias, contrastBias) ||
                other.contrastBias == contrastBias) &&
            (identical(other.shadowLift, shadowLift) ||
                other.shadowLift == shadowLift) &&
            (identical(other.highlightRolloff, highlightRolloff) ||
                other.highlightRolloff == highlightRolloff) &&
            (identical(other.isFilmCamera, isFilmCamera) ||
                other.isFilmCamera == isFilmCamera) &&
            (identical(other.promptFragment, promptFragment) ||
                other.promptFragment == promptFragment));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(
    runtimeType,
    id,
    name,
    description,
    tier,
    warmthBias,
    contrastBias,
    shadowLift,
    highlightRolloff,
    isFilmCamera,
    promptFragment,
  );

  /// Create a copy of CameraProfile
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$CameraProfileImplCopyWith<_$CameraProfileImpl> get copyWith =>
      __$$CameraProfileImplCopyWithImpl<_$CameraProfileImpl>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$CameraProfileImplToJson(this);
  }
}

abstract class _CameraProfile extends CameraProfile {
  const factory _CameraProfile({
    required final String id,
    required final String name,
    required final String description,
    final ProfileTier tier,
    final double warmthBias,
    final double contrastBias,
    final double shadowLift,
    final double highlightRolloff,
    final bool isFilmCamera,
    final String promptFragment,
  }) = _$CameraProfileImpl;
  const _CameraProfile._() : super._();

  factory _CameraProfile.fromJson(Map<String, dynamic> json) =
      _$CameraProfileImpl.fromJson;

  /// Unique identifier — snake_case.
  @override
  String get id;

  /// Display name shown in the UI.
  @override
  String get name;

  /// Short description of the camera character.
  @override
  String get description;

  /// Subscription tier required to use this profile.
  @override
  ProfileTier get tier; // — Sensor characteristics —
  /// Warm/cool bias of the sensor colour science. -1.0 (cool) to +1.0 (warm).
  @override
  double get warmthBias;

  /// Contrast character. -1.0 (flat/log) to +1.0 (punchy/vivid).
  @override
  double get contrastBias;

  /// Shadow floor lift. 0 = deep blacks, 1.0 = lifted shadow floor.
  @override
  double get shadowLift;

  /// Highlight rolloff character. 0 = abrupt clip, 1.0 = film-like gradual rolloff.
  @override
  double get highlightRolloff;

  /// True for film cameras — rendering is entirely the film stock's domain.
  @override
  bool get isFilmCamera; // — AI generation prompt fragment —
  /// Plain-text prompt fragment for AI generation. Image-agnostic and model-agnostic.
  /// Assembled by GenerationPromptBuilder into the full generation prompt.
  @override
  String get promptFragment;

  /// Create a copy of CameraProfile
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$CameraProfileImplCopyWith<_$CameraProfileImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
