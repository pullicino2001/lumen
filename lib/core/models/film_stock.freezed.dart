// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'film_stock.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
  'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models',
);

FilmStock _$FilmStockFromJson(Map<String, dynamic> json) {
  return _FilmStock.fromJson(json);
}

/// @nodoc
mixin _$FilmStock {
  String get id => throw _privateConstructorUsedError;
  String get name => throw _privateConstructorUsedError;
  String get description => throw _privateConstructorUsedError;
  StockTier get tier =>
      throw _privateConstructorUsedError; // ── Stage 6: Dye coupler colour matrix ─────────────────────────────────
  // Row-major 3×3 applied in perceptual space.
  // Identity = [1,0,0, 0,1,0, 0,0,1].
  // Row 0 = how R is computed from input (R,G,B).
  // Row 1 = how G is computed. Row 2 = how B is computed.
  List<double> get colourMatrix =>
      throw _privateConstructorUsedError; // ── Stage 7: Per-channel tone curves ───────────────────────────────────
  // Each list = [blackLift, toePow, shoulderStart, shoulderPow].
  // blackLift  0.0–0.06  — raises the absolute black point.
  // toePow     0.75–1.1  — < 1 = soft/bright toe, > 1 = deep/dark toe.
  // shoulderStart 0.70–0.92 — where highlight compression begins (0–1).
  // shoulderPow   1.5–3.5   — how aggressively highlights are compressed.
  List<double> get redCurve => throw _privateConstructorUsedError;
  List<double> get greenCurve => throw _privateConstructorUsedError;
  List<double> get blueCurve =>
      throw _privateConstructorUsedError; // ── Stage 8: Hue crossover shifts ─────────────────────────────────────
  // Degrees to rotate hue in shadow/highlight regions.
  // Positive = toward warm (red-yellow), negative = toward cool (blue-cyan).
  double get shadowHueDeg => throw _privateConstructorUsedError;
  double get shadowHueStrength => throw _privateConstructorUsedError; // 0–1
  double get highlightHueDeg => throw _privateConstructorUsedError;
  double get highlightHueStrength =>
      throw _privateConstructorUsedError; // ── Stage 9: Halation tint (RGB 0–1) ──────────────────────────────────
  // Overrides the warmth-slider tint when this stock is active.
  // Kodak = warm orange [1.0, 0.35, 0.05]. Fuji = cooler [0.8, 0.45, 0.1].
  List<double> get halationTint =>
      throw _privateConstructorUsedError; // ── User intensity blend (0–100) ──────────────────────────────────────
  double get intensity => throw _privateConstructorUsedError;

  /// Serializes this FilmStock to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of FilmStock
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $FilmStockCopyWith<FilmStock> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $FilmStockCopyWith<$Res> {
  factory $FilmStockCopyWith(FilmStock value, $Res Function(FilmStock) then) =
      _$FilmStockCopyWithImpl<$Res, FilmStock>;
  @useResult
  $Res call({
    String id,
    String name,
    String description,
    StockTier tier,
    List<double> colourMatrix,
    List<double> redCurve,
    List<double> greenCurve,
    List<double> blueCurve,
    double shadowHueDeg,
    double shadowHueStrength,
    double highlightHueDeg,
    double highlightHueStrength,
    List<double> halationTint,
    double intensity,
  });
}

/// @nodoc
class _$FilmStockCopyWithImpl<$Res, $Val extends FilmStock>
    implements $FilmStockCopyWith<$Res> {
  _$FilmStockCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of FilmStock
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? name = null,
    Object? description = null,
    Object? tier = null,
    Object? colourMatrix = null,
    Object? redCurve = null,
    Object? greenCurve = null,
    Object? blueCurve = null,
    Object? shadowHueDeg = null,
    Object? shadowHueStrength = null,
    Object? highlightHueDeg = null,
    Object? highlightHueStrength = null,
    Object? halationTint = null,
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
            tier: null == tier
                ? _value.tier
                : tier // ignore: cast_nullable_to_non_nullable
                      as StockTier,
            colourMatrix: null == colourMatrix
                ? _value.colourMatrix
                : colourMatrix // ignore: cast_nullable_to_non_nullable
                      as List<double>,
            redCurve: null == redCurve
                ? _value.redCurve
                : redCurve // ignore: cast_nullable_to_non_nullable
                      as List<double>,
            greenCurve: null == greenCurve
                ? _value.greenCurve
                : greenCurve // ignore: cast_nullable_to_non_nullable
                      as List<double>,
            blueCurve: null == blueCurve
                ? _value.blueCurve
                : blueCurve // ignore: cast_nullable_to_non_nullable
                      as List<double>,
            shadowHueDeg: null == shadowHueDeg
                ? _value.shadowHueDeg
                : shadowHueDeg // ignore: cast_nullable_to_non_nullable
                      as double,
            shadowHueStrength: null == shadowHueStrength
                ? _value.shadowHueStrength
                : shadowHueStrength // ignore: cast_nullable_to_non_nullable
                      as double,
            highlightHueDeg: null == highlightHueDeg
                ? _value.highlightHueDeg
                : highlightHueDeg // ignore: cast_nullable_to_non_nullable
                      as double,
            highlightHueStrength: null == highlightHueStrength
                ? _value.highlightHueStrength
                : highlightHueStrength // ignore: cast_nullable_to_non_nullable
                      as double,
            halationTint: null == halationTint
                ? _value.halationTint
                : halationTint // ignore: cast_nullable_to_non_nullable
                      as List<double>,
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
abstract class _$$FilmStockImplCopyWith<$Res>
    implements $FilmStockCopyWith<$Res> {
  factory _$$FilmStockImplCopyWith(
    _$FilmStockImpl value,
    $Res Function(_$FilmStockImpl) then,
  ) = __$$FilmStockImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({
    String id,
    String name,
    String description,
    StockTier tier,
    List<double> colourMatrix,
    List<double> redCurve,
    List<double> greenCurve,
    List<double> blueCurve,
    double shadowHueDeg,
    double shadowHueStrength,
    double highlightHueDeg,
    double highlightHueStrength,
    List<double> halationTint,
    double intensity,
  });
}

/// @nodoc
class __$$FilmStockImplCopyWithImpl<$Res>
    extends _$FilmStockCopyWithImpl<$Res, _$FilmStockImpl>
    implements _$$FilmStockImplCopyWith<$Res> {
  __$$FilmStockImplCopyWithImpl(
    _$FilmStockImpl _value,
    $Res Function(_$FilmStockImpl) _then,
  ) : super(_value, _then);

  /// Create a copy of FilmStock
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? name = null,
    Object? description = null,
    Object? tier = null,
    Object? colourMatrix = null,
    Object? redCurve = null,
    Object? greenCurve = null,
    Object? blueCurve = null,
    Object? shadowHueDeg = null,
    Object? shadowHueStrength = null,
    Object? highlightHueDeg = null,
    Object? highlightHueStrength = null,
    Object? halationTint = null,
    Object? intensity = null,
  }) {
    return _then(
      _$FilmStockImpl(
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
                  as StockTier,
        colourMatrix: null == colourMatrix
            ? _value._colourMatrix
            : colourMatrix // ignore: cast_nullable_to_non_nullable
                  as List<double>,
        redCurve: null == redCurve
            ? _value._redCurve
            : redCurve // ignore: cast_nullable_to_non_nullable
                  as List<double>,
        greenCurve: null == greenCurve
            ? _value._greenCurve
            : greenCurve // ignore: cast_nullable_to_non_nullable
                  as List<double>,
        blueCurve: null == blueCurve
            ? _value._blueCurve
            : blueCurve // ignore: cast_nullable_to_non_nullable
                  as List<double>,
        shadowHueDeg: null == shadowHueDeg
            ? _value.shadowHueDeg
            : shadowHueDeg // ignore: cast_nullable_to_non_nullable
                  as double,
        shadowHueStrength: null == shadowHueStrength
            ? _value.shadowHueStrength
            : shadowHueStrength // ignore: cast_nullable_to_non_nullable
                  as double,
        highlightHueDeg: null == highlightHueDeg
            ? _value.highlightHueDeg
            : highlightHueDeg // ignore: cast_nullable_to_non_nullable
                  as double,
        highlightHueStrength: null == highlightHueStrength
            ? _value.highlightHueStrength
            : highlightHueStrength // ignore: cast_nullable_to_non_nullable
                  as double,
        halationTint: null == halationTint
            ? _value._halationTint
            : halationTint // ignore: cast_nullable_to_non_nullable
                  as List<double>,
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
class _$FilmStockImpl extends _FilmStock {
  const _$FilmStockImpl({
    required this.id,
    required this.name,
    required this.description,
    this.tier = StockTier.free,
    final List<double> colourMatrix = const [
      1.0,
      0.0,
      0.0,
      0.0,
      1.0,
      0.0,
      0.0,
      0.0,
      1.0,
    ],
    final List<double> redCurve = const [0.02, 0.9, 0.82, 2.0],
    final List<double> greenCurve = const [0.02, 0.9, 0.82, 2.0],
    final List<double> blueCurve = const [0.02, 0.9, 0.82, 2.0],
    this.shadowHueDeg = 0.0,
    this.shadowHueStrength = 0.0,
    this.highlightHueDeg = 0.0,
    this.highlightHueStrength = 0.0,
    final List<double> halationTint = const [1.0, 0.35, 0.05],
    this.intensity = 85.0,
  }) : _colourMatrix = colourMatrix,
       _redCurve = redCurve,
       _greenCurve = greenCurve,
       _blueCurve = blueCurve,
       _halationTint = halationTint,
       super._();

  factory _$FilmStockImpl.fromJson(Map<String, dynamic> json) =>
      _$$FilmStockImplFromJson(json);

  @override
  final String id;
  @override
  final String name;
  @override
  final String description;
  @override
  @JsonKey()
  final StockTier tier;
  // ── Stage 6: Dye coupler colour matrix ─────────────────────────────────
  // Row-major 3×3 applied in perceptual space.
  // Identity = [1,0,0, 0,1,0, 0,0,1].
  // Row 0 = how R is computed from input (R,G,B).
  // Row 1 = how G is computed. Row 2 = how B is computed.
  final List<double> _colourMatrix;
  // ── Stage 6: Dye coupler colour matrix ─────────────────────────────────
  // Row-major 3×3 applied in perceptual space.
  // Identity = [1,0,0, 0,1,0, 0,0,1].
  // Row 0 = how R is computed from input (R,G,B).
  // Row 1 = how G is computed. Row 2 = how B is computed.
  @override
  @JsonKey()
  List<double> get colourMatrix {
    if (_colourMatrix is EqualUnmodifiableListView) return _colourMatrix;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_colourMatrix);
  }

  // ── Stage 7: Per-channel tone curves ───────────────────────────────────
  // Each list = [blackLift, toePow, shoulderStart, shoulderPow].
  // blackLift  0.0–0.06  — raises the absolute black point.
  // toePow     0.75–1.1  — < 1 = soft/bright toe, > 1 = deep/dark toe.
  // shoulderStart 0.70–0.92 — where highlight compression begins (0–1).
  // shoulderPow   1.5–3.5   — how aggressively highlights are compressed.
  final List<double> _redCurve;
  // ── Stage 7: Per-channel tone curves ───────────────────────────────────
  // Each list = [blackLift, toePow, shoulderStart, shoulderPow].
  // blackLift  0.0–0.06  — raises the absolute black point.
  // toePow     0.75–1.1  — < 1 = soft/bright toe, > 1 = deep/dark toe.
  // shoulderStart 0.70–0.92 — where highlight compression begins (0–1).
  // shoulderPow   1.5–3.5   — how aggressively highlights are compressed.
  @override
  @JsonKey()
  List<double> get redCurve {
    if (_redCurve is EqualUnmodifiableListView) return _redCurve;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_redCurve);
  }

  final List<double> _greenCurve;
  @override
  @JsonKey()
  List<double> get greenCurve {
    if (_greenCurve is EqualUnmodifiableListView) return _greenCurve;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_greenCurve);
  }

  final List<double> _blueCurve;
  @override
  @JsonKey()
  List<double> get blueCurve {
    if (_blueCurve is EqualUnmodifiableListView) return _blueCurve;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_blueCurve);
  }

  // ── Stage 8: Hue crossover shifts ─────────────────────────────────────
  // Degrees to rotate hue in shadow/highlight regions.
  // Positive = toward warm (red-yellow), negative = toward cool (blue-cyan).
  @override
  @JsonKey()
  final double shadowHueDeg;
  @override
  @JsonKey()
  final double shadowHueStrength;
  // 0–1
  @override
  @JsonKey()
  final double highlightHueDeg;
  @override
  @JsonKey()
  final double highlightHueStrength;
  // ── Stage 9: Halation tint (RGB 0–1) ──────────────────────────────────
  // Overrides the warmth-slider tint when this stock is active.
  // Kodak = warm orange [1.0, 0.35, 0.05]. Fuji = cooler [0.8, 0.45, 0.1].
  final List<double> _halationTint;
  // ── Stage 9: Halation tint (RGB 0–1) ──────────────────────────────────
  // Overrides the warmth-slider tint when this stock is active.
  // Kodak = warm orange [1.0, 0.35, 0.05]. Fuji = cooler [0.8, 0.45, 0.1].
  @override
  @JsonKey()
  List<double> get halationTint {
    if (_halationTint is EqualUnmodifiableListView) return _halationTint;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_halationTint);
  }

  // ── User intensity blend (0–100) ──────────────────────────────────────
  @override
  @JsonKey()
  final double intensity;

  @override
  String toString() {
    return 'FilmStock(id: $id, name: $name, description: $description, tier: $tier, colourMatrix: $colourMatrix, redCurve: $redCurve, greenCurve: $greenCurve, blueCurve: $blueCurve, shadowHueDeg: $shadowHueDeg, shadowHueStrength: $shadowHueStrength, highlightHueDeg: $highlightHueDeg, highlightHueStrength: $highlightHueStrength, halationTint: $halationTint, intensity: $intensity)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$FilmStockImpl &&
            (identical(other.id, id) || other.id == id) &&
            (identical(other.name, name) || other.name == name) &&
            (identical(other.description, description) ||
                other.description == description) &&
            (identical(other.tier, tier) || other.tier == tier) &&
            const DeepCollectionEquality().equals(
              other._colourMatrix,
              _colourMatrix,
            ) &&
            const DeepCollectionEquality().equals(other._redCurve, _redCurve) &&
            const DeepCollectionEquality().equals(
              other._greenCurve,
              _greenCurve,
            ) &&
            const DeepCollectionEquality().equals(
              other._blueCurve,
              _blueCurve,
            ) &&
            (identical(other.shadowHueDeg, shadowHueDeg) ||
                other.shadowHueDeg == shadowHueDeg) &&
            (identical(other.shadowHueStrength, shadowHueStrength) ||
                other.shadowHueStrength == shadowHueStrength) &&
            (identical(other.highlightHueDeg, highlightHueDeg) ||
                other.highlightHueDeg == highlightHueDeg) &&
            (identical(other.highlightHueStrength, highlightHueStrength) ||
                other.highlightHueStrength == highlightHueStrength) &&
            const DeepCollectionEquality().equals(
              other._halationTint,
              _halationTint,
            ) &&
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
    tier,
    const DeepCollectionEquality().hash(_colourMatrix),
    const DeepCollectionEquality().hash(_redCurve),
    const DeepCollectionEquality().hash(_greenCurve),
    const DeepCollectionEquality().hash(_blueCurve),
    shadowHueDeg,
    shadowHueStrength,
    highlightHueDeg,
    highlightHueStrength,
    const DeepCollectionEquality().hash(_halationTint),
    intensity,
  );

  /// Create a copy of FilmStock
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$FilmStockImplCopyWith<_$FilmStockImpl> get copyWith =>
      __$$FilmStockImplCopyWithImpl<_$FilmStockImpl>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$FilmStockImplToJson(this);
  }
}

abstract class _FilmStock extends FilmStock {
  const factory _FilmStock({
    required final String id,
    required final String name,
    required final String description,
    final StockTier tier,
    final List<double> colourMatrix,
    final List<double> redCurve,
    final List<double> greenCurve,
    final List<double> blueCurve,
    final double shadowHueDeg,
    final double shadowHueStrength,
    final double highlightHueDeg,
    final double highlightHueStrength,
    final List<double> halationTint,
    final double intensity,
  }) = _$FilmStockImpl;
  const _FilmStock._() : super._();

  factory _FilmStock.fromJson(Map<String, dynamic> json) =
      _$FilmStockImpl.fromJson;

  @override
  String get id;
  @override
  String get name;
  @override
  String get description;
  @override
  StockTier get tier; // ── Stage 6: Dye coupler colour matrix ─────────────────────────────────
  // Row-major 3×3 applied in perceptual space.
  // Identity = [1,0,0, 0,1,0, 0,0,1].
  // Row 0 = how R is computed from input (R,G,B).
  // Row 1 = how G is computed. Row 2 = how B is computed.
  @override
  List<double> get colourMatrix; // ── Stage 7: Per-channel tone curves ───────────────────────────────────
  // Each list = [blackLift, toePow, shoulderStart, shoulderPow].
  // blackLift  0.0–0.06  — raises the absolute black point.
  // toePow     0.75–1.1  — < 1 = soft/bright toe, > 1 = deep/dark toe.
  // shoulderStart 0.70–0.92 — where highlight compression begins (0–1).
  // shoulderPow   1.5–3.5   — how aggressively highlights are compressed.
  @override
  List<double> get redCurve;
  @override
  List<double> get greenCurve;
  @override
  List<double> get blueCurve; // ── Stage 8: Hue crossover shifts ─────────────────────────────────────
  // Degrees to rotate hue in shadow/highlight regions.
  // Positive = toward warm (red-yellow), negative = toward cool (blue-cyan).
  @override
  double get shadowHueDeg;
  @override
  double get shadowHueStrength; // 0–1
  @override
  double get highlightHueDeg;
  @override
  double get highlightHueStrength; // ── Stage 9: Halation tint (RGB 0–1) ──────────────────────────────────
  // Overrides the warmth-slider tint when this stock is active.
  // Kodak = warm orange [1.0, 0.35, 0.05]. Fuji = cooler [0.8, 0.45, 0.1].
  @override
  List<double> get halationTint; // ── User intensity blend (0–100) ──────────────────────────────────────
  @override
  double get intensity;

  /// Create a copy of FilmStock
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$FilmStockImplCopyWith<_$FilmStockImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
