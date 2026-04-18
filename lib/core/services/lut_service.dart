import 'dart:async';
import 'dart:ui' as ui;
import 'package:flutter/services.dart';

/// Parses .cube LUT files and encodes them as 2D [ui.Image] textures for the shader.
///
/// 2D layout: (size × size) wide × size tall.
/// Pixel at (b*size + r, g) holds the LUT output for input (r, g, b).
/// Manual trilinear interpolation is done in the shader.
class LutService {
  /// Loads a .cube file from the asset bundle and returns a 2D [ui.Image].
  static Future<ui.Image> loadFromAsset(String assetPath) async {
    final data = await rootBundle.load(assetPath);
    final text = String.fromCharCodes(data.buffer.asUint8List());
    return _parseCube(text);
  }

  /// A trivial 1×1 white image for use when LUT intensity is 0.
  static Future<ui.Image> placeholder() async {
    final pixels = Uint8List.fromList([255, 255, 255, 255]);
    return _decodePixels(pixels, 1, 1);
  }

  static Future<ui.Image> _parseCube(String text) async {
    int size = 0;
    final List<double> r = [], g = [], b = [];

    for (final raw in text.split('\n')) {
      final line = raw.trim();
      if (line.isEmpty || line.startsWith('#')) continue;
      if (line.startsWith('LUT_3D_SIZE')) {
        size = int.parse(line.split(RegExp(r'\s+')).last);
        continue;
      }
      if (line.startsWith('TITLE') ||
          line.startsWith('DOMAIN') ||
          line.startsWith('LUT_1D') ||
          line.startsWith('LUT_3D')) {
        continue;
      }

      final parts = line.split(RegExp(r'\s+'));
      if (parts.length >= 3) {
        final rv = double.tryParse(parts[0]);
        final gv = double.tryParse(parts[1]);
        final bv = double.tryParse(parts[2]);
        if (rv != null && gv != null && bv != null) {
          r.add(rv);
          g.add(gv);
          b.add(bv);
        }
      }
    }

    if (size == 0) size = 17;

    // Build RGBA pixel buffer: width = size*size, height = size
    final width = size * size;
    final height = size;
    final pixels = Uint8List(width * height * 4);

    // .cube order: R varies fastest, then G, then B
    int idx = 0;
    for (int bi = 0; bi < size; bi++) {
      for (int gi = 0; gi < size; gi++) {
        for (int ri = 0; ri < size; ri++) {
          if (idx < r.length) {
            final px = (gi * width + bi * size + ri) * 4;
            pixels[px    ] = (r[idx].clamp(0.0, 1.0) * 255).round();
            pixels[px + 1] = (g[idx].clamp(0.0, 1.0) * 255).round();
            pixels[px + 2] = (b[idx].clamp(0.0, 1.0) * 255).round();
            pixels[px + 3] = 255;
            idx++;
          }
        }
      }
    }

    return _decodePixels(pixels, width, height);
  }

  static Future<ui.Image> _decodePixels(Uint8List pixels, int w, int h) {
    final completer = Completer<ui.Image>();
    ui.decodeImageFromPixels(
      pixels, w, h, ui.PixelFormat.rgba8888, completer.complete,
    );
    return completer.future;
  }
}
