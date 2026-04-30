import 'dart:io';
import 'dart:isolate';
import 'dart:math' as math;
import 'dart:typed_data';
import 'package:image/image.dart' as img;
import '../models/baseline_profile.dart';

class LumenLookService {
  static Future<void> applyToProxy(
    String inputPath,
    String outputPath,
    BaselineProfile profile,
  ) =>
      Isolate.run(() => _processLumenLook(_paramsFrom(
            inputPath: inputPath,
            outputPath: outputPath,
            isProxy: true,
            profile: profile,
          )));

  static Future<void> applyToFullRes(
    String inputPath,
    String outputPath,
    BaselineProfile profile,
  ) =>
      Isolate.run(() => _processLumenLook(_paramsFrom(
            inputPath: inputPath,
            outputPath: outputPath,
            isProxy: false,
            profile: profile,
          )));
}

// ─── Params ──────────────────────────────────────────────────────────────────

class _LumenLookParams {
  const _LumenLookParams({
    required this.inputPath,
    required this.outputPath,
    required this.isProxy,
    required this.gradingMatrix,
    required this.toneCurveX,
    required this.toneCurveY,
    required this.saturationMultiplier,
    required this.vignetteEnabled,
    required this.vignetteStrength,
    required this.vignetteRadius,
    required this.vignetteFeather,
    required this.sharpenRadius,
    required this.sharpenAmount,
    required this.sharpenThreshold,
  });

  final String inputPath;
  final String outputPath;
  final bool isProxy;
  final List<double> gradingMatrix;
  final List<double> toneCurveX;
  final List<double> toneCurveY;
  final double saturationMultiplier;
  final bool vignetteEnabled;
  final double vignetteStrength;
  final double vignetteRadius;
  final double vignetteFeather;
  final int sharpenRadius;
  final double sharpenAmount;
  final double sharpenThreshold;
}

_LumenLookParams _paramsFrom({
  required String inputPath,
  required String outputPath,
  required bool isProxy,
  required BaselineProfile profile,
}) =>
    _LumenLookParams(
      inputPath: inputPath,
      outputPath: outputPath,
      isProxy: isProxy,
      gradingMatrix: profile.gradingMatrixFlat,
      toneCurveX: profile.toneCurvePoints.map((p) => p.$1).toList(),
      toneCurveY: profile.toneCurvePoints.map((p) => p.$2).toList(),
      saturationMultiplier: profile.saturationMultiplier,
      vignetteEnabled: profile.vignetteEnabled,
      vignetteStrength: profile.vignetteStrength,
      vignetteRadius: profile.vignetteRadius,
      vignetteFeather: profile.vignetteFeather,
      sharpenRadius: profile.sharpeningRadius.round(),
      sharpenAmount: profile.sharpeningAmount,
      sharpenThreshold: profile.sharpeningThreshold,
    );

// ─── Isolate entry point ──────────────────────────────────────────────────────

Future<void> _processLumenLook(_LumenLookParams p) async {
  final bytes = await File(p.inputPath).readAsBytes();
  final image = img.decodeImage(bytes)!;

  _applyGradingMatrix(image, p.gradingMatrix);
  _applyToneCurve(image, p.toneCurveX, p.toneCurveY);
  _applySaturation(image, p.saturationMultiplier);
  if (p.vignetteEnabled) {
    _applyVignette(image, p.vignetteStrength, p.vignetteRadius, p.vignetteFeather);
  }
  final sharpened = _applySharpen(image, p.sharpenRadius, p.sharpenAmount, p.sharpenThreshold);

  final Uint8List output = p.isProxy
      ? img.encodeJpg(sharpened, quality: 85)
      : img.encodePng(sharpened, level: 0);

  await File(p.outputPath).writeAsBytes(output, flush: true);
}

// ─── Per-pixel operations ─────────────────────────────────────────────────────

void _applyGradingMatrix(img.Image image, List<double> m) {
  for (final pixel in image) {
    final r = pixel.r.toDouble() / 255.0;
    final g = pixel.g.toDouble() / 255.0;
    final b = pixel.b.toDouble() / 255.0;

    final rl = math.pow(r.clamp(0.0, 1.0), 2.2).toDouble();
    final gl = math.pow(g.clamp(0.0, 1.0), 2.2).toDouble();
    final bl = math.pow(b.clamp(0.0, 1.0), 2.2).toDouble();

    final nr = (m[0] * rl + m[1] * gl + m[2] * bl).clamp(0.0, 1.0);
    final ng = (m[3] * rl + m[4] * gl + m[5] * bl).clamp(0.0, 1.0);
    final nb = (m[6] * rl + m[7] * gl + m[8] * bl).clamp(0.0, 1.0);

    pixel.r = math.pow(nr, 1.0 / 2.2) * 255.0;
    pixel.g = math.pow(ng, 1.0 / 2.2) * 255.0;
    pixel.b = math.pow(nb, 1.0 / 2.2) * 255.0;
  }
}

void _applyToneCurve(img.Image image, List<double> xs, List<double> ys) {
  final lut = List<int>.generate(256, (i) {
    final y = _lerpCurve(i / 255.0, xs, ys);
    return (y * 255.0).round().clamp(0, 255);
  });

  for (final pixel in image) {
    pixel.r = lut[pixel.r.toInt().clamp(0, 255)].toDouble();
    pixel.g = lut[pixel.g.toInt().clamp(0, 255)].toDouble();
    pixel.b = lut[pixel.b.toInt().clamp(0, 255)].toDouble();
  }
}

double _lerpCurve(double x, List<double> xs, List<double> ys) {
  if (x <= xs.first) return ys.first;
  if (x >= xs.last) return ys.last;
  for (int i = 0; i < xs.length - 1; i++) {
    if (x >= xs[i] && x <= xs[i + 1]) {
      final t = (x - xs[i]) / (xs[i + 1] - xs[i]);
      return ys[i] + t * (ys[i + 1] - ys[i]);
    }
  }
  return ys.last;
}

void _applySaturation(img.Image image, double multiplier) {
  for (final pixel in image) {
    final r = pixel.r.toDouble() / 255.0;
    final g = pixel.g.toDouble() / 255.0;
    final b = pixel.b.toDouble() / 255.0;

    final hsl = _rgbToHsl(r, g, b);
    final s = (hsl[1] * multiplier).clamp(0.0, 1.0);
    final rgb = _hslToRgb(hsl[0], s, hsl[2]);

    pixel.r = (rgb[0] * 255.0).clamp(0.0, 255.0);
    pixel.g = (rgb[1] * 255.0).clamp(0.0, 255.0);
    pixel.b = (rgb[2] * 255.0).clamp(0.0, 255.0);
  }
}

List<double> _rgbToHsl(double r, double g, double b) {
  final mx = math.max(r, math.max(g, b));
  final mn = math.min(r, math.min(g, b));
  final l = (mx + mn) / 2.0;

  if (mx == mn) return [0.0, 0.0, l];

  final d = mx - mn;
  final s = l > 0.5 ? d / (2.0 - mx - mn) : d / (mx + mn);

  double h;
  if (mx == r) {
    h = (g - b) / d + (g < b ? 6.0 : 0.0);
  } else if (mx == g) {
    h = (b - r) / d + 2.0;
  } else {
    h = (r - g) / d + 4.0;
  }

  return [h / 6.0, s, l];
}

List<double> _hslToRgb(double h, double s, double l) {
  if (s == 0.0) return [l, l, l];

  final q = l < 0.5 ? l * (1.0 + s) : l + s - l * s;
  final p = 2.0 * l - q;

  return [
    _hue2rgb(p, q, h + 1.0 / 3.0),
    _hue2rgb(p, q, h),
    _hue2rgb(p, q, h - 1.0 / 3.0),
  ];
}

double _hue2rgb(double p, double q, double t) {
  var tt = t;
  if (tt < 0) tt += 1.0;
  if (tt > 1) tt -= 1.0;
  if (tt < 1.0 / 6.0) return p + (q - p) * 6.0 * tt;
  if (tt < 1.0 / 2.0) return q;
  if (tt < 2.0 / 3.0) return p + (q - p) * (2.0 / 3.0 - tt) * 6.0;
  return p;
}

void _applyVignette(
  img.Image image,
  double strength,
  double radius,
  double feather,
) {
  final cx = image.width / 2.0;
  final cy = image.height / 2.0;
  final halfDiag = math.sqrt(cx * cx + cy * cy);

  for (final pixel in image) {
    final dx = pixel.x - cx;
    final dy = pixel.y - cy;
    final dist = math.sqrt(dx * dx + dy * dy) / halfDiag;

    final double falloff;
    if (dist <= radius) {
      falloff = 0.0;
    } else if (dist >= radius + feather) {
      falloff = 1.0;
    } else {
      falloff = (dist - radius) / feather;
    }

    final factor = 1.0 - strength * falloff;
    pixel.r = (pixel.r.toDouble() * factor).clamp(0.0, 255.0);
    pixel.g = (pixel.g.toDouble() * factor).clamp(0.0, 255.0);
    pixel.b = (pixel.b.toDouble() * factor).clamp(0.0, 255.0);
  }
}

img.Image _applySharpen(
  img.Image image,
  int radius,
  double amount,
  double threshold,
) {
  final blurred = img.gaussianBlur(image, radius: radius);

  for (final pixel in image) {
    final bp = blurred.getPixel(pixel.x, pixel.y);

    final dr = pixel.r.toDouble() - bp.r.toDouble();
    final dg = pixel.g.toDouble() - bp.g.toDouble();
    final db = pixel.b.toDouble() - bp.b.toDouble();

    final mag = math.sqrt(dr * dr + dg * dg + db * db) / 255.0;
    if (mag > threshold) {
      pixel.r = (pixel.r.toDouble() + amount * dr).clamp(0.0, 255.0);
      pixel.g = (pixel.g.toDouble() + amount * dg).clamp(0.0, 255.0);
      pixel.b = (pixel.b.toDouble() + amount * db).clamp(0.0, 255.0);
    }
  }

  return image;
}
