// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'edit_state.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
  'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models',
);

EditState _$EditStateFromJson(Map<String, dynamic> json) {
  return _EditState.fromJson(json);
}

/// @nodoc
mixin _$EditState {
  /// Path to the original imported file. Never modified.
  String get originalFilePath => throw _privateConstructorUsedError;

  /// Path to the decoded working copy in app temp storage.
  String get workingFilePath => throw _privateConstructorUsedError;

  /// Basic editor adjustments — applied as a separate shader pass.
  BasicEditorSettings get basicEditor => throw _privateConstructorUsedError;

  /// Active lens profile. Null means lens layer is bypassed.
  LensProfile? get lensProfile => throw _privateConstructorUsedError;

  /// Active film stock. Null means the stock layer is bypassed.
  FilmStock? get filmStock => throw _privateConstructorUsedError;

  /// Grain simulation parameters.
  GrainSettings get grain => throw _privateConstructorUsedError;

  /// Bloom and halation parameters.
  BloomSettings get bloom =>
      throw _privateConstructorUsedError; // — Layer toggles —
  bool get lensEnabled => throw _privateConstructorUsedError;
  bool get stockEnabled => throw _privateConstructorUsedError;
  bool get grainEnabled => throw _privateConstructorUsedError;
  bool get bloomEnabled => throw _privateConstructorUsedError;
  bool get basicEditorEnabled =>
      throw _privateConstructorUsedError; // — Generation (v4) —
  /// Path to a generated image returned from the AI service.
  /// Non-null only after a successful Pro Max generation.
  String? get generatedFilePath => throw _privateConstructorUsedError;

  /// Serializes this EditState to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of EditState
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $EditStateCopyWith<EditState> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $EditStateCopyWith<$Res> {
  factory $EditStateCopyWith(EditState value, $Res Function(EditState) then) =
      _$EditStateCopyWithImpl<$Res, EditState>;
  @useResult
  $Res call({
    String originalFilePath,
    String workingFilePath,
    BasicEditorSettings basicEditor,
    LensProfile? lensProfile,
    FilmStock? filmStock,
    GrainSettings grain,
    BloomSettings bloom,
    bool lensEnabled,
    bool stockEnabled,
    bool grainEnabled,
    bool bloomEnabled,
    bool basicEditorEnabled,
    String? generatedFilePath,
  });

  $BasicEditorSettingsCopyWith<$Res> get basicEditor;
  $LensProfileCopyWith<$Res>? get lensProfile;
  $FilmStockCopyWith<$Res>? get filmStock;
  $GrainSettingsCopyWith<$Res> get grain;
  $BloomSettingsCopyWith<$Res> get bloom;
}

/// @nodoc
class _$EditStateCopyWithImpl<$Res, $Val extends EditState>
    implements $EditStateCopyWith<$Res> {
  _$EditStateCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of EditState
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? originalFilePath = null,
    Object? workingFilePath = null,
    Object? basicEditor = null,
    Object? lensProfile = freezed,
    Object? filmStock = freezed,
    Object? grain = null,
    Object? bloom = null,
    Object? lensEnabled = null,
    Object? stockEnabled = null,
    Object? grainEnabled = null,
    Object? bloomEnabled = null,
    Object? basicEditorEnabled = null,
    Object? generatedFilePath = freezed,
  }) {
    return _then(
      _value.copyWith(
            originalFilePath: null == originalFilePath
                ? _value.originalFilePath
                : originalFilePath // ignore: cast_nullable_to_non_nullable
                      as String,
            workingFilePath: null == workingFilePath
                ? _value.workingFilePath
                : workingFilePath // ignore: cast_nullable_to_non_nullable
                      as String,
            basicEditor: null == basicEditor
                ? _value.basicEditor
                : basicEditor // ignore: cast_nullable_to_non_nullable
                      as BasicEditorSettings,
            lensProfile: freezed == lensProfile
                ? _value.lensProfile
                : lensProfile // ignore: cast_nullable_to_non_nullable
                      as LensProfile?,
            filmStock: freezed == filmStock
                ? _value.filmStock
                : filmStock // ignore: cast_nullable_to_non_nullable
                      as FilmStock?,
            grain: null == grain
                ? _value.grain
                : grain // ignore: cast_nullable_to_non_nullable
                      as GrainSettings,
            bloom: null == bloom
                ? _value.bloom
                : bloom // ignore: cast_nullable_to_non_nullable
                      as BloomSettings,
            lensEnabled: null == lensEnabled
                ? _value.lensEnabled
                : lensEnabled // ignore: cast_nullable_to_non_nullable
                      as bool,
            stockEnabled: null == stockEnabled
                ? _value.stockEnabled
                : stockEnabled // ignore: cast_nullable_to_non_nullable
                      as bool,
            grainEnabled: null == grainEnabled
                ? _value.grainEnabled
                : grainEnabled // ignore: cast_nullable_to_non_nullable
                      as bool,
            bloomEnabled: null == bloomEnabled
                ? _value.bloomEnabled
                : bloomEnabled // ignore: cast_nullable_to_non_nullable
                      as bool,
            basicEditorEnabled: null == basicEditorEnabled
                ? _value.basicEditorEnabled
                : basicEditorEnabled // ignore: cast_nullable_to_non_nullable
                      as bool,
            generatedFilePath: freezed == generatedFilePath
                ? _value.generatedFilePath
                : generatedFilePath // ignore: cast_nullable_to_non_nullable
                      as String?,
          )
          as $Val,
    );
  }

  /// Create a copy of EditState
  /// with the given fields replaced by the non-null parameter values.
  @override
  @pragma('vm:prefer-inline')
  $BasicEditorSettingsCopyWith<$Res> get basicEditor {
    return $BasicEditorSettingsCopyWith<$Res>(_value.basicEditor, (value) {
      return _then(_value.copyWith(basicEditor: value) as $Val);
    });
  }

  /// Create a copy of EditState
  /// with the given fields replaced by the non-null parameter values.
  @override
  @pragma('vm:prefer-inline')
  $LensProfileCopyWith<$Res>? get lensProfile {
    if (_value.lensProfile == null) {
      return null;
    }

    return $LensProfileCopyWith<$Res>(_value.lensProfile!, (value) {
      return _then(_value.copyWith(lensProfile: value) as $Val);
    });
  }

  /// Create a copy of EditState
  /// with the given fields replaced by the non-null parameter values.
  @override
  @pragma('vm:prefer-inline')
  $FilmStockCopyWith<$Res>? get filmStock {
    if (_value.filmStock == null) {
      return null;
    }

    return $FilmStockCopyWith<$Res>(_value.filmStock!, (value) {
      return _then(_value.copyWith(filmStock: value) as $Val);
    });
  }

  /// Create a copy of EditState
  /// with the given fields replaced by the non-null parameter values.
  @override
  @pragma('vm:prefer-inline')
  $GrainSettingsCopyWith<$Res> get grain {
    return $GrainSettingsCopyWith<$Res>(_value.grain, (value) {
      return _then(_value.copyWith(grain: value) as $Val);
    });
  }

  /// Create a copy of EditState
  /// with the given fields replaced by the non-null parameter values.
  @override
  @pragma('vm:prefer-inline')
  $BloomSettingsCopyWith<$Res> get bloom {
    return $BloomSettingsCopyWith<$Res>(_value.bloom, (value) {
      return _then(_value.copyWith(bloom: value) as $Val);
    });
  }
}

/// @nodoc
abstract class _$$EditStateImplCopyWith<$Res>
    implements $EditStateCopyWith<$Res> {
  factory _$$EditStateImplCopyWith(
    _$EditStateImpl value,
    $Res Function(_$EditStateImpl) then,
  ) = __$$EditStateImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({
    String originalFilePath,
    String workingFilePath,
    BasicEditorSettings basicEditor,
    LensProfile? lensProfile,
    FilmStock? filmStock,
    GrainSettings grain,
    BloomSettings bloom,
    bool lensEnabled,
    bool stockEnabled,
    bool grainEnabled,
    bool bloomEnabled,
    bool basicEditorEnabled,
    String? generatedFilePath,
  });

  @override
  $BasicEditorSettingsCopyWith<$Res> get basicEditor;
  @override
  $LensProfileCopyWith<$Res>? get lensProfile;
  @override
  $FilmStockCopyWith<$Res>? get filmStock;
  @override
  $GrainSettingsCopyWith<$Res> get grain;
  @override
  $BloomSettingsCopyWith<$Res> get bloom;
}

/// @nodoc
class __$$EditStateImplCopyWithImpl<$Res>
    extends _$EditStateCopyWithImpl<$Res, _$EditStateImpl>
    implements _$$EditStateImplCopyWith<$Res> {
  __$$EditStateImplCopyWithImpl(
    _$EditStateImpl _value,
    $Res Function(_$EditStateImpl) _then,
  ) : super(_value, _then);

  /// Create a copy of EditState
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? originalFilePath = null,
    Object? workingFilePath = null,
    Object? basicEditor = null,
    Object? lensProfile = freezed,
    Object? filmStock = freezed,
    Object? grain = null,
    Object? bloom = null,
    Object? lensEnabled = null,
    Object? stockEnabled = null,
    Object? grainEnabled = null,
    Object? bloomEnabled = null,
    Object? basicEditorEnabled = null,
    Object? generatedFilePath = freezed,
  }) {
    return _then(
      _$EditStateImpl(
        originalFilePath: null == originalFilePath
            ? _value.originalFilePath
            : originalFilePath // ignore: cast_nullable_to_non_nullable
                  as String,
        workingFilePath: null == workingFilePath
            ? _value.workingFilePath
            : workingFilePath // ignore: cast_nullable_to_non_nullable
                  as String,
        basicEditor: null == basicEditor
            ? _value.basicEditor
            : basicEditor // ignore: cast_nullable_to_non_nullable
                  as BasicEditorSettings,
        lensProfile: freezed == lensProfile
            ? _value.lensProfile
            : lensProfile // ignore: cast_nullable_to_non_nullable
                  as LensProfile?,
        filmStock: freezed == filmStock
            ? _value.filmStock
            : filmStock // ignore: cast_nullable_to_non_nullable
                  as FilmStock?,
        grain: null == grain
            ? _value.grain
            : grain // ignore: cast_nullable_to_non_nullable
                  as GrainSettings,
        bloom: null == bloom
            ? _value.bloom
            : bloom // ignore: cast_nullable_to_non_nullable
                  as BloomSettings,
        lensEnabled: null == lensEnabled
            ? _value.lensEnabled
            : lensEnabled // ignore: cast_nullable_to_non_nullable
                  as bool,
        stockEnabled: null == stockEnabled
            ? _value.stockEnabled
            : stockEnabled // ignore: cast_nullable_to_non_nullable
                  as bool,
        grainEnabled: null == grainEnabled
            ? _value.grainEnabled
            : grainEnabled // ignore: cast_nullable_to_non_nullable
                  as bool,
        bloomEnabled: null == bloomEnabled
            ? _value.bloomEnabled
            : bloomEnabled // ignore: cast_nullable_to_non_nullable
                  as bool,
        basicEditorEnabled: null == basicEditorEnabled
            ? _value.basicEditorEnabled
            : basicEditorEnabled // ignore: cast_nullable_to_non_nullable
                  as bool,
        generatedFilePath: freezed == generatedFilePath
            ? _value.generatedFilePath
            : generatedFilePath // ignore: cast_nullable_to_non_nullable
                  as String?,
      ),
    );
  }
}

/// @nodoc
@JsonSerializable()
class _$EditStateImpl extends _EditState {
  const _$EditStateImpl({
    required this.originalFilePath,
    required this.workingFilePath,
    this.basicEditor = const BasicEditorSettings(),
    this.lensProfile,
    this.filmStock,
    this.grain = const GrainSettings(),
    this.bloom = const BloomSettings(),
    this.lensEnabled = true,
    this.stockEnabled = true,
    this.grainEnabled = true,
    this.bloomEnabled = true,
    this.basicEditorEnabled = true,
    this.generatedFilePath = null,
  }) : super._();

  factory _$EditStateImpl.fromJson(Map<String, dynamic> json) =>
      _$$EditStateImplFromJson(json);

  /// Path to the original imported file. Never modified.
  @override
  final String originalFilePath;

  /// Path to the decoded working copy in app temp storage.
  @override
  final String workingFilePath;

  /// Basic editor adjustments — applied as a separate shader pass.
  @override
  @JsonKey()
  final BasicEditorSettings basicEditor;

  /// Active lens profile. Null means lens layer is bypassed.
  @override
  final LensProfile? lensProfile;

  /// Active film stock. Null means the stock layer is bypassed.
  @override
  final FilmStock? filmStock;

  /// Grain simulation parameters.
  @override
  @JsonKey()
  final GrainSettings grain;

  /// Bloom and halation parameters.
  @override
  @JsonKey()
  final BloomSettings bloom;
  // — Layer toggles —
  @override
  @JsonKey()
  final bool lensEnabled;
  @override
  @JsonKey()
  final bool stockEnabled;
  @override
  @JsonKey()
  final bool grainEnabled;
  @override
  @JsonKey()
  final bool bloomEnabled;
  @override
  @JsonKey()
  final bool basicEditorEnabled;
  // — Generation (v4) —
  /// Path to a generated image returned from the AI service.
  /// Non-null only after a successful Pro Max generation.
  @override
  @JsonKey()
  final String? generatedFilePath;

  @override
  String toString() {
    return 'EditState(originalFilePath: $originalFilePath, workingFilePath: $workingFilePath, basicEditor: $basicEditor, lensProfile: $lensProfile, filmStock: $filmStock, grain: $grain, bloom: $bloom, lensEnabled: $lensEnabled, stockEnabled: $stockEnabled, grainEnabled: $grainEnabled, bloomEnabled: $bloomEnabled, basicEditorEnabled: $basicEditorEnabled, generatedFilePath: $generatedFilePath)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$EditStateImpl &&
            (identical(other.originalFilePath, originalFilePath) ||
                other.originalFilePath == originalFilePath) &&
            (identical(other.workingFilePath, workingFilePath) ||
                other.workingFilePath == workingFilePath) &&
            (identical(other.basicEditor, basicEditor) ||
                other.basicEditor == basicEditor) &&
            (identical(other.lensProfile, lensProfile) ||
                other.lensProfile == lensProfile) &&
            (identical(other.filmStock, filmStock) ||
                other.filmStock == filmStock) &&
            (identical(other.grain, grain) || other.grain == grain) &&
            (identical(other.bloom, bloom) || other.bloom == bloom) &&
            (identical(other.lensEnabled, lensEnabled) ||
                other.lensEnabled == lensEnabled) &&
            (identical(other.stockEnabled, stockEnabled) ||
                other.stockEnabled == stockEnabled) &&
            (identical(other.grainEnabled, grainEnabled) ||
                other.grainEnabled == grainEnabled) &&
            (identical(other.bloomEnabled, bloomEnabled) ||
                other.bloomEnabled == bloomEnabled) &&
            (identical(other.basicEditorEnabled, basicEditorEnabled) ||
                other.basicEditorEnabled == basicEditorEnabled) &&
            (identical(other.generatedFilePath, generatedFilePath) ||
                other.generatedFilePath == generatedFilePath));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(
    runtimeType,
    originalFilePath,
    workingFilePath,
    basicEditor,
    lensProfile,
    filmStock,
    grain,
    bloom,
    lensEnabled,
    stockEnabled,
    grainEnabled,
    bloomEnabled,
    basicEditorEnabled,
    generatedFilePath,
  );

  /// Create a copy of EditState
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$EditStateImplCopyWith<_$EditStateImpl> get copyWith =>
      __$$EditStateImplCopyWithImpl<_$EditStateImpl>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$EditStateImplToJson(this);
  }
}

abstract class _EditState extends EditState {
  const factory _EditState({
    required final String originalFilePath,
    required final String workingFilePath,
    final BasicEditorSettings basicEditor,
    final LensProfile? lensProfile,
    final FilmStock? filmStock,
    final GrainSettings grain,
    final BloomSettings bloom,
    final bool lensEnabled,
    final bool stockEnabled,
    final bool grainEnabled,
    final bool bloomEnabled,
    final bool basicEditorEnabled,
    final String? generatedFilePath,
  }) = _$EditStateImpl;
  const _EditState._() : super._();

  factory _EditState.fromJson(Map<String, dynamic> json) =
      _$EditStateImpl.fromJson;

  /// Path to the original imported file. Never modified.
  @override
  String get originalFilePath;

  /// Path to the decoded working copy in app temp storage.
  @override
  String get workingFilePath;

  /// Basic editor adjustments — applied as a separate shader pass.
  @override
  BasicEditorSettings get basicEditor;

  /// Active lens profile. Null means lens layer is bypassed.
  @override
  LensProfile? get lensProfile;

  /// Active film stock. Null means the stock layer is bypassed.
  @override
  FilmStock? get filmStock;

  /// Grain simulation parameters.
  @override
  GrainSettings get grain;

  /// Bloom and halation parameters.
  @override
  BloomSettings get bloom; // — Layer toggles —
  @override
  bool get lensEnabled;
  @override
  bool get stockEnabled;
  @override
  bool get grainEnabled;
  @override
  bool get bloomEnabled;
  @override
  bool get basicEditorEnabled; // — Generation (v4) —
  /// Path to a generated image returned from the AI service.
  /// Non-null only after a successful Pro Max generation.
  @override
  String? get generatedFilePath;

  /// Create a copy of EditState
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$EditStateImplCopyWith<_$EditStateImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
