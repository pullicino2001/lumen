import 'dart:math';
import 'dart:ui' as ui;
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'rendered_preview_provider.dart';

typedef HistogramData = ({List<double> r, List<double> g, List<double> b});

/// Computes a 64-bucket RGB histogram from the fully-rendered preview image.
/// Samples every 4th pixel in both axes for performance.
final histogramProvider = FutureProvider<HistogramData?>((ref) async {
  final rendered = await ref.watch(renderedPreviewProvider.future);
  if (rendered == null) return null;

  final byteData = await rendered.toByteData(format: ui.ImageByteFormat.rawRgba);
  if (byteData == null) return null;

  const buckets = 64;
  final r = List<int>.filled(buckets, 0);
  final g = List<int>.filled(buckets, 0);
  final b = List<int>.filled(buckets, 0);

  final bytes = byteData.buffer.asUint8List();
  final stride = rendered.width * 4;

  for (int y = 0; y < rendered.height; y += 4) {
    for (int x = 0; x < rendered.width; x += 4) {
      final i = y * stride + x * 4;
      r[bytes[i] * buckets ~/ 256]++;
      g[bytes[i + 1] * buckets ~/ 256]++;
      b[bytes[i + 2] * buckets ~/ 256]++;
    }
  }

  final peak = [...r, ...g, ...b].reduce(max).toDouble();
  if (peak == 0) return null;

  return (
    r: r.map((v) => v / peak).toList(),
    g: g.map((v) => v / peak).toList(),
    b: b.map((v) => v / peak).toList(),
  );
});
