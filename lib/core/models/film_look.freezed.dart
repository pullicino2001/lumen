// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'film_look.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
  'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models',
);

FilmLook _$FilmLookFromJson(Map<String, dynamic> json) {
  return _FilmLook.fromJson(json);
}

/// @nodoc
mixin _$FilmLook {
  /// Unique identifier.
  String get id => throw _privateConstructorUsedError;

  /// Display name shown in the UI.
  String get name => throw _privateConstructorUsedError;

  /// Short description of the aesthetic.
  String get description => throw _privateConstructorUsedError;

  /// Asset path to the .cube LUT file.
  String get lutAssetPath => throw _privateConstructorUsedError;

  /// Asset path to the preview thumbnail image.
  String get thumbnailAssetPath => throw _privateConstructorUsedError;

  /// Subscription tier required to use this look.
  LookTier get tier => throw _privateConstructorUsedError;

  /// Overall look intensity applied on top of the raw LUT. 0–100.
  double get intensity => throw _privateConstructorUsedError;

  /// Serializes this FilmLook to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of FilmLook
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $FilmLookCopyWith<FilmLook> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $FilmLookCopyWith<$Res> {
  factory $FilmLookCopyWith(FilmLook value, $Res Function(FilmLook) then) =
      _$FilmLookCopyWithImpl<$Res, FilmLook>;
  @useResult
  $Res call({
    String id,
    String name,
    String description,
    String lutAssetPath,
    String thumbnailAssetPath,
    LookTier tier,
    double intensity,
  });
}

/// @nodoc
class _$FilmLookCopyWithImpl<$Res, $Val extends FilmLook>
    implements $FilmLookCopyWith<$Res> {
  _$FilmLookCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of FilmLook
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? name = null,
    Object? description = null,
    Object? lutAssetPath = null,
    Object? thumbnailAssetPath = null,
    Object? tier = null,
    Object? intensity = null,
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
            lutAssetPath: null == lutAssetPath
                ? _value.lutAssetPath
                : lutAssetPath // ignore: cast_nullable_to_non_nullable
                      as String,
            thumbnailAssetPath: null == thumbnailAssetPath
                ? _value.thumbnailAssetPath
                : thumbnailAssetPath // ignore: cast_nullable_to_non_nullable
                      as String,
            tier: null == tier
                ? _value.tier
                : tier // ignore: cast_nullable_to_non_nullable
                      as LookTier,
            intensity: null == intensity
                ? _value.intensity
                : intensity // ignore: cast_nullable_to_non_nullable
                      as double,
          )
          as $Val,
    );
  }
}

/// @nodoc
abstract class _$$FilmLookImplCopyWith<$Res>
    implements $FilmLookCopyWith<$Res> {
  factory _$$FilmLookImplCopyWith(
    _$FilmLookImpl value,
    $Res Function(_$FilmLookImpl) then,
  ) = __$$FilmLookImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({
    String id,
    String name,
    String description,
    String lutAssetPath,
    String thumbnailAssetPath,
    LookTier tier,
    double intensity,
  });
}

/// @nodoc
class __$$FilmLookImplCopyWithImpl<$Res>
    extends _$FilmLookCopyWithImpl<$Res, _$FilmLookImpl>
    implements _$$FilmLookImplCopyWith<$Res> {
  __$$FilmLookImplCopyWithImpl(
    _$FilmLookImpl _value,
    $Res Function(_$FilmLookImpl) _then,
  ) : super(_value, _then);

  /// Create a copy of FilmLook
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? name = null,
    Object? description = null,
    Object? lutAssetPath = null,
    Object? thumbnailAssetPath = null,
    Object? tier = null,
    Object? intensity = null,
  }) {
    return _then(
      _$FilmLookImpl(
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
        lutAssetPath: null == lutAssetPath
            ? _value.lutAssetPath
            : lutAssetPath // ignore: cast_nullable_to_non_nullable
                  as String,
        thumbnailAssetPath: null == thumbnailAssetPath
            ? _value.thumbnailAssetPath
            : thumbnailAssetPath // ignore: cast_nullable_to_non_nullable
                  as String,
        tier: null == tier
            ? _value.tier
            : tier // ignore: cast_nullable_to_non_nullable
                  as LookTier,
        intensity: null == intensity
            ? _value.intensity
            : intensity // ignore: cast_nullable_to_non_nullable
                  as double,
      ),
    );
  }
}

/// @nodoc
@JsonSerializable()
class _$FilmLookImpl extends _FilmLook {
  const _$FilmLookImpl({
    required this.id,
    required this.name,
    required this.description,
    required this.lutAssetPath,
    required this.thumbnailAssetPath,
    this.tier = LookTier.free,
    this.intensity = 100.0,
  }) : super._();

  factory _$FilmLookImpl.fromJson(Map<String, dynamic> json) =>
      _$$FilmLookImplFromJson(json);

  /// Unique identifier.
  @override
  final String id;

  /// Display name shown in the UI.
  @override
  final String name;

  /// Short description of the aesthetic.
  @override
  final String description;

  /// Asset path to the .cube LUT file.
  @override
  final String lutAssetPath;

  /// Asset path to the preview thumbnail image.
  @override
  final String thumbnailAssetPath;

  /// Subscription tier required to use this look.
  @override
  @JsonKey()
  final LookTier tier;

  /// Overall look intensity applied on top of the raw LUT. 0–100.
  @override
  @JsonKey()
  final double intensity;

  @override
  String toString() {
    return 'FilmLook(id: $id, name: $name, description: $description, lutAssetPath: $lutAssetPath, thumbnailAssetPath: $thumbnailAssetPath, tier: $tier, intensity: $intensity)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$FilmLookImpl &&
            (identical(other.id, id) || other.id == id) &&
            (identical(other.name, name) || other.name == name) &&
            (identical(other.description, description) ||
                other.description == description) &&
            (identical(other.lutAssetPath, lutAssetPath) ||
                other.lutAssetPath == lutAssetPath) &&
            (identical(other.thumbnailAssetPath, thumbnailAssetPath) ||
                other.thumbnailAssetPath == thumbnailAssetPath) &&
            (identical(other.tier, tier) || other.tier == tier) &&
            (identical(other.intensity, intensity) ||
                other.intensity == intensity));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(
    runtimeType,
    id,
    name,
    description,
    lutAssetPath,
    thumbnailAssetPath,
    tier,
    intensity,
  );

  /// Create a copy of FilmLook
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$FilmLookImplCopyWith<_$FilmLookImpl> get copyWith =>
      __$$FilmLookImplCopyWithImpl<_$FilmLookImpl>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$FilmLookImplToJson(this);
  }
}

abstract class _FilmLook extends FilmLook {
  const factory _FilmLook({
    required final String id,
    required final String name,
    required final String description,
    required final String lutAssetPath,
    required final String thumbnailAssetPath,
    final LookTier tier,
    final double intensity,
  }) = _$FilmLookImpl;
  const _FilmLook._() : super._();

  factory _FilmLook.fromJson(Map<String, dynamic> json) =
      _$FilmLookImpl.fromJson;

  /// Unique identifier.
  @override
  String get id;

  /// Display name shown in the UI.
  @override
  String get name;

  /// Short description of the aesthetic.
  @override
  String get description;

  /// Asset path to the .cube LUT file.
  @override
  String get lutAssetPath;

  /// Asset path to the preview thumbnail image.
  @override
  String get thumbnailAssetPath;

  /// Subscription tier required to use this look.
  @override
  LookTier get tier;

  /// Overall look intensity applied on top of the raw LUT. 0–100.
  @override
  double get intensity;

  /// Create a copy of FilmLook
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$FilmLookImplCopyWith<_$FilmLookImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
