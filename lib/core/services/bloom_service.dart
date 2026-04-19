import 'dart:ui' as ui;
import '../models/bloom_settings.dart';

typedef BloomPrograms = ({
  ui.FragmentProgram extract,
  ui.FragmentProgram blur,
  ui.FragmentProgram composite,
});

/// Orchestrates the multi-pass bloom + halation pipeline.
///
/// All passes run at 1/4 resolution for performance; the final composite
/// upsamples back to source resolution via bilinear filtering.
class BloomService {
  Future<ui.Image> apply({
    required ui.Image source,
    required BloomSettings settings,
    required BloomPrograms programs,
    List<double>? stockHalationTint,
  }) async {
    final w = source.width;
    final h = source.height;
    final bw = (w / 4).ceil().clamp(1, 1024);
    final bh = (h / 4).ceil().clamp(1, 1024);

    final bloomSigma    = (settings.bloomRadius    * bw * 0.04).clamp(0.5, 8.0);
    final halationSigma = (settings.halationSpread * bh * 0.06).clamp(0.5, 8.0);

    // Bloom: extract bright highlights as white glow
    final bloomSrc = await _extract(
      programs.extract, source, bw, bh,
      threshold: settings.bloomThreshold,
      softness: 0.08,
      tint: (1.0, 1.0, 1.0),
    );
    final bloomH      = await _blur(programs.blur, bloomSrc, (1.0, 0.0), bloomSigma);
    final bloomFinal  = await _blur(programs.blur, bloomH,   (0.0, 1.0), bloomSigma);

    // Halation: wider, softer threshold, per-stock or warmth-based tint
    final w01  = settings.halationWarmth; // 0–1
    final (double hr, double hg, double hb) = stockHalationTint != null
        ? (stockHalationTint[0], stockHalationTint[1], stockHalationTint[2])
        : (1.0, 0.35 + w01 * 0.25, w01 < 0.5 ? 0.05 : 0.0);
    final halSrc = await _extract(
      programs.extract, source, bw, bh,
      threshold: (settings.bloomThreshold - 0.15).clamp(0.0, 1.0),
      softness: 0.18,
      tint: (hr, hg, hb),
    );
    final halH     = await _blur(programs.blur, halSrc, (1.0, 0.0), halationSigma);
    final halFinal = await _blur(programs.blur, halH,   (0.0, 1.0), halationSigma);

    return _composite(
      programs.composite,
      original: source,
      bloom: bloomFinal,
      halation: halFinal,
      bloomIntensity: settings.bloomIntensity / 100.0,
      halationIntensity: settings.halationIntensity / 100.0,
    );
  }

  Future<ui.Image> _extract(
    ui.FragmentProgram program,
    ui.Image source,
    int outW,
    int outH, {
    required double threshold,
    required double softness,
    required (double, double, double) tint,
  }) async {
    final shader = program.fragmentShader();
    shader.setFloat(0, outW.toDouble());
    shader.setFloat(1, outH.toDouble());
    shader.setFloat(2, threshold);
    shader.setFloat(3, softness);
    shader.setFloat(4, tint.$1);
    shader.setFloat(5, tint.$2);
    shader.setFloat(6, tint.$3);
    shader.setImageSampler(0, source);
    return _render(shader, outW, outH);
  }

  Future<ui.Image> _blur(
    ui.FragmentProgram program,
    ui.Image source,
    (double, double) direction,
    double sigma,
  ) async {
    final w = source.width;
    final h = source.height;
    final shader = program.fragmentShader();
    shader.setFloat(0, w.toDouble());
    shader.setFloat(1, h.toDouble());
    shader.setFloat(2, direction.$1);
    shader.setFloat(3, direction.$2);
    shader.setFloat(4, sigma);
    shader.setImageSampler(0, source);
    return _render(shader, w, h);
  }

  Future<ui.Image> _composite(
    ui.FragmentProgram program, {
    required ui.Image original,
    required ui.Image bloom,
    required ui.Image halation,
    required double bloomIntensity,
    required double halationIntensity,
  }) async {
    final w = original.width;
    final h = original.height;
    final shader = program.fragmentShader();
    shader.setFloat(0, w.toDouble());
    shader.setFloat(1, h.toDouble());
    shader.setFloat(2, bloomIntensity);
    shader.setFloat(3, halationIntensity);
    shader.setImageSampler(0, original);
    shader.setImageSampler(1, bloom);
    shader.setImageSampler(2, halation);
    return _render(shader, w, h);
  }

  Future<ui.Image> _render(ui.FragmentShader shader, int w, int h) {
    final recorder = ui.PictureRecorder();
    ui.Canvas(recorder, ui.Rect.fromLTWH(0, 0, w.toDouble(), h.toDouble()))
        .drawRect(
          ui.Rect.fromLTWH(0, 0, w.toDouble(), h.toDouble()),
          ui.Paint()..shader = shader,
        );
    return recorder.endRecording().toImage(w, h);
  }
}
