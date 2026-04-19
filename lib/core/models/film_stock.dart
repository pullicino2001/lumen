import 'package:freezed_annotation/freezed_annotation.dart';
import 'prompt_contributor.dart';

part 'film_stock.freezed.dart';
part 'film_stock.g.dart';

enum StockTier { free, pro }

/// Parametric film stock — implements pipeline stages 6–10.
///
/// Stages 6-8 run in the main fragment shader (colour matrix → tone curves →
/// hue shifts). Stage 9 (halation tint) feeds into BloomService. Stage 10
/// (grain) is user-controlled via GrainPanel; grainProfile defines the
/// stock's natural defaults only.
@freezed
abstract class FilmStock with _$FilmStock implements PromptContributor {
  const FilmStock._();

  const factory FilmStock({
    required String id,
    required String name,
    required String description,
    @Default(StockTier.free) StockTier tier,

    // ── Stage 6: Dye coupler colour matrix ─────────────────────────────────
    // Row-major 3×3 applied in perceptual space.
    // Identity = [1,0,0, 0,1,0, 0,0,1].
    // Row 0 = how R is computed from input (R,G,B).
    // Row 1 = how G is computed. Row 2 = how B is computed.
    @Default([1.0,0.0,0.0, 0.0,1.0,0.0, 0.0,0.0,1.0])
    List<double> colourMatrix,

    // ── Stage 7: Per-channel tone curves ───────────────────────────────────
    // Each list = [blackLift, toePow, shoulderStart, shoulderPow].
    // blackLift  0.0–0.06  — raises the absolute black point.
    // toePow     0.75–1.1  — < 1 = soft/bright toe, > 1 = deep/dark toe.
    // shoulderStart 0.70–0.92 — where highlight compression begins (0–1).
    // shoulderPow   1.5–3.5   — how aggressively highlights are compressed.
    @Default([0.02, 0.9, 0.82, 2.0]) List<double> redCurve,
    @Default([0.02, 0.9, 0.82, 2.0]) List<double> greenCurve,
    @Default([0.02, 0.9, 0.82, 2.0]) List<double> blueCurve,

    // ── Stage 8: Hue crossover shifts ─────────────────────────────────────
    // Degrees to rotate hue in shadow/highlight regions.
    // Positive = toward warm (red-yellow), negative = toward cool (blue-cyan).
    @Default(0.0) double shadowHueDeg,
    @Default(0.0) double shadowHueStrength,   // 0–1
    @Default(0.0) double highlightHueDeg,
    @Default(0.0) double highlightHueStrength,

    // ── Stage 9: Halation tint (RGB 0–1) ──────────────────────────────────
    // Overrides the warmth-slider tint when this stock is active.
    // Kodak = warm orange [1.0, 0.35, 0.05]. Fuji = cooler [0.8, 0.45, 0.1].
    @Default([1.0, 0.35, 0.05]) List<double> halationTint,

    // ── User intensity blend (0–100) ──────────────────────────────────────
    @Default(85.0) double intensity,
  }) = _FilmStock;

  factory FilmStock.fromJson(Map<String, dynamic> json) =>
      _$FilmStockFromJson(json);

  @override
  String toPromptFragment() => '';
}
