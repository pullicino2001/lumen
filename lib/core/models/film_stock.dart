import 'package:freezed_annotation/freezed_annotation.dart';
import 'prompt_contributor.dart';

part 'film_stock.freezed.dart';
part 'film_stock.g.dart';

enum StockTier { free, pro }

/// Parametric film stock — implements pipeline stages 6–10.
///
/// Stages 6-8 run in the main fragment shader (colour matrix → tone curves →
/// hue shifts). Stage 9 (halation tint) feeds into BloomService. Stage 10
/// (grain) is user-controlled via the Grain module.
@freezed
abstract class FilmStock with _$FilmStock implements PromptContributor {
  const FilmStock._();

  const factory FilmStock({
    required String id,
    required String name,
    required String description,
    @Default(StockTier.free) StockTier tier,

    /// Box speed of the emulsion (ISO). Shown on the stock card.
    @Default(400) int iso,

    /// Short catalogue code shown on the stock card, e.g. 'PT-400'.
    /// Empty string → derived from [id] and [iso] by [displayCode].
    @Default('') String code,

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

    // ── AI generation prompt fragment ─────────────────────────────────────
    /// Plain-text prompt fragment for AI generation. Image-agnostic and model-agnostic.
    /// Assembled by GenerationPromptBuilder into the full generation prompt.
    @Default('') String promptFragment,
  }) = _FilmStock;

  factory FilmStock.fromJson(Map<String, dynamic> json) =>
      _$FilmStockFromJson(json);

  @override
  String toPromptFragment() => promptFragment;

  /// Catalogue code for display: [code] if set, else the first two letters of
  /// the id (upper-cased) joined with the ISO, e.g. 'portra_400' → 'PO-400'.
  String get displayCode {
    if (code.isNotEmpty) return code;
    final letters = id.replaceAll(RegExp('[^a-zA-Z]'), '');
    final prefix = (letters.length >= 2 ? letters.substring(0, 2) : letters)
        .toUpperCase();
    return '$prefix-$iso';
  }
}
