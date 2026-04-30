import 'dart:convert';
import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';

/// The LUMEN Look — the foundation rendering profile applied to every image.
///
/// This class models Leica camera colour science derived from measured LibRaw/
/// dcraw colour matrices across 15 Leica cameras. Its purpose is to make phone
/// sensor output feel like a dedicated camera before any creative stock is applied.
///
/// Pipeline position: Stage 5.5 — sits between the camera colour matrix (stage 5)
/// and any future creative stocks/looks (stage 6+). It is not user-selectable;
/// it runs automatically on every image.
///
/// All future creative stocks layer ON TOP of this profile — they are additive
/// to the LUMEN Look, not replacements for it.
///
/// To adjust the look, edit `assets/baseline/lumen_look.json`. No Dart changes
/// are needed for numeric tuning. To add alternative base looks in the future,
/// add more JSON files to `assets/baseline/` and extend [load] with a path param.
@immutable
class BaselineProfile {
  const BaselineProfile({
    required this.name,
    required this.version,
    required this.description,
    required this.gradingMatrix,
    required this.toneCurvePoints,
    required this.saturationMultiplier,
    required this.vignetteEnabled,
    required this.vignetteStrength,
    required this.vignetteRadius,
    required this.vignetteFeather,
    required this.sharpeningRadius,
    required this.sharpeningAmount,
    required this.sharpeningThreshold,
  });

  final String name;
  final String version;
  final String description;

  /// Stage 5.5: 3×3 colour grading matrix, row-major, applied in linear light.
  /// Layout: [[r0c0, r0c1, r0c2], [r1c0, r1c1, r1c2], [r2c0, r2c1, r2c2]].
  final List<List<double>> gradingMatrix;

  /// Tone curve control points as (input, output) pairs, both in 0–1.
  /// Sorted ascending by input. Use [evaluateToneCurve] to sample.
  final List<(double, double)> toneCurvePoints;

  /// Global saturation multiplier (< 1 = pull back phone oversaturation).
  final double saturationMultiplier;

  final bool vignetteEnabled;

  /// Vignette blend strength (0–1).
  final double vignetteStrength;

  /// Vignette radial falloff start as fraction of image half-diagonal (0–1).
  final double vignetteRadius;

  /// Vignette softness — transition width as fraction of image half-diagonal.
  final double vignetteFeather;

  /// Unsharp mask blur radius in pixels.
  final double sharpeningRadius;

  /// Unsharp mask blend amount (0–1).
  final double sharpeningAmount;

  /// Unsharp mask edge threshold — gradients below this are not sharpened.
  final double sharpeningThreshold;

  // ─── Derived helpers ──────────────────────────────────────────────────────

  /// Returns the 3×3 grading matrix as a flat 9-element row-major list,
  /// ready for GPU uniform or matrix-multiply code.
  List<double> get gradingMatrixFlat => [
        for (final row in gradingMatrix)
          for (final v in row) v,
      ];

  /// Samples the tone curve at [input] (0.0–1.0) by linear interpolation
  /// between the two nearest control points.
  double evaluateToneCurve(double input) {
    final x = input.clamp(0.0, 1.0);

    // Below first point → clamp to first output.
    if (x <= toneCurvePoints.first.$1) return toneCurvePoints.first.$2;
    // Above last point → clamp to last output.
    if (x >= toneCurvePoints.last.$1)  return toneCurvePoints.last.$2;

    for (int i = 0; i < toneCurvePoints.length - 1; i++) {
      final (x0, y0) = toneCurvePoints[i];
      final (x1, y1) = toneCurvePoints[i + 1];
      if (x >= x0 && x <= x1) {
        final t = (x - x0) / (x1 - x0);
        return y0 + t * (y1 - y0);
      }
    }

    return toneCurvePoints.last.$2;
  }

  // ─── Loading ──────────────────────────────────────────────────────────────

  /// Loads and parses `assets/baseline/lumen_look.json` from the asset bundle.
  static Future<BaselineProfile> load() async {
    final raw  = await rootBundle.loadString('assets/baseline/lumen_look.json');
    final json = jsonDecode(raw) as Map<String, dynamic>;
    return BaselineProfile.fromJson(json);
  }

  factory BaselineProfile.fromJson(Map<String, dynamic> json) {
    // Grading matrix
    final matrixRows = (json['grading_matrix']['rows'] as List)
        .map((row) =>
            (row as List).map((v) => (v as num).toDouble()).toList(growable: false))
        .toList(growable: false);

    // Tone curve control points
    final points = (json['tone_curve']['control_points'] as List)
        .map((p) {
          final m = p as Map<String, dynamic>;
          return ((m['input'] as num).toDouble(), (m['output'] as num).toDouble());
        })
        .toList(growable: false);

    // Saturation
    final saturation = (json['saturation']['multiplier'] as num).toDouble();

    // Vignette
    final vig = json['vignette'] as Map<String, dynamic>;

    // Sharpening
    final sharp = json['sharpening'] as Map<String, dynamic>;

    return BaselineProfile(
      name:        json['name']        as String,
      version:     json['version']     as String,
      description: json['description'] as String,
      gradingMatrix:         matrixRows,
      toneCurvePoints:       points,
      saturationMultiplier:  saturation,
      vignetteEnabled:       vig['enabled']  as bool,
      vignetteStrength:      (vig['strength'] as num).toDouble(),
      vignetteRadius:        (vig['radius']   as num).toDouble(),
      vignetteFeather:       (vig['feather']  as num).toDouble(),
      sharpeningRadius:      (sharp['radius']    as num).toDouble(),
      sharpeningAmount:      (sharp['amount']    as num).toDouble(),
      sharpeningThreshold:   (sharp['threshold'] as num).toDouble(),
    );
  }
}
