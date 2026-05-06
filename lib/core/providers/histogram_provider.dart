import 'dart:io';
import 'dart:math';
import 'package:flutter/foundation.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:image/image.dart' as img;
import 'edit_state_provider.dart';

typedef HistogramData = ({List<double> r, List<double> g, List<double> b});

HistogramData? _computeFromBytes(Uint8List bytes) {
  final image = img.decodeImage(bytes);
  if (image == null) return null;

  const buckets = 64;
  final r = List<int>.filled(buckets, 0);
  final g = List<int>.filled(buckets, 0);
  final b = List<int>.filled(buckets, 0);

  for (int y = 0; y < image.height; y += 4) {
    for (int x = 0; x < image.width; x += 4) {
      final p = image.getPixel(x, y);
      r[(p.rNormalized * buckets).floor().clamp(0, buckets - 1)]++;
      g[(p.gNormalized * buckets).floor().clamp(0, buckets - 1)]++;
      b[(p.bNormalized * buckets).floor().clamp(0, buckets - 1)]++;
    }
  }

  final peak = [...r, ...g, ...b].reduce(max).toDouble();
  if (peak == 0) return null;

  return (
    r: r.map((v) => v / peak).toList(),
    g: g.map((v) => v / peak).toList(),
    b: b.map((v) => v / peak).toList(),
  );
}

/// Computes a 64-bucket RGB histogram from the proxy image in a background isolate.
/// Only recomputes when a new image is loaded.
final histogramProvider = FutureProvider<HistogramData?>((ref) async {
  final path = ref.watch(editStateProvider.select((s) => s?.proxyFilePath));
  if (path == null) return null;
  final bytes = await File(path).readAsBytes();
  return compute(_computeFromBytes, bytes);
});
