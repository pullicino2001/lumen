import 'dart:io';
import 'package:image/image.dart' as img;
import 'package:logger/logger.dart';
import '../models/edit_state.dart';

/// Orchestrates the full simulation pipeline.
///
/// Pipeline order (each layer is independent and can be toggled):
///   BasicEditor → LensProfile → FilmLook → Grain → Bloom/Halation
///
/// In v1 all layers apply CPU-side via the `image` package.
/// GLSL shader passes replace these one-by-one as shaders are written.
///
/// This class is camera-agnostic — the live camera module (v2+) will call
/// the same apply() method on each captured frame.
class EffectEngine {
  EffectEngine();

  static final _log = Logger();

  /// Applies the full effect stack from [state] to the working image file.
  ///
  /// Returns the processed [img.Image]. Does not write to disk — the caller
  /// (export or preview) decides what to do with the result.
  Future<img.Image> apply(EditState state) async {
    final bytes = await File(state.workingFilePath).readAsBytes();
    var image = img.decodeImage(bytes);
    if (image == null) {
      throw StateError('EffectEngine: could not decode working file.');
    }

    if (state.basicEditorEnabled) {
      image = _applyBasicEditor(image, state);
    }

    // Lens, film look, grain, bloom layers — GLSL shaders in v1b+.
    // Left as identity passes for now; each will be replaced by a shader call.
    _log.d('EffectEngine: lens/film/grain/bloom — shader passes pending.');

    return image;
  }

  /// CPU-side basic editor — replaced by GLSL shader in the next pass.
  img.Image _applyBasicEditor(img.Image image, EditState state) {
    final s = state.basicEditor;

    // Exposure: scale all channels by 2^EV
    if (s.exposure != 0.0) {
      final factor = _evToFactor(s.exposure);
      image = img.adjustColor(image, brightness: factor);
    }

    // Saturation
    if (s.saturation != 0.0) {
      image = img.adjustColor(image, saturation: 1.0 + (s.saturation / 100.0));
    }

    // Contrast
    if (s.contrast != 0.0) {
      image = img.adjustColor(image, contrast: 1.0 + (s.contrast / 100.0));
    }

    return image;
  }

  double _evToFactor(double ev) => ev >= 0
      ? 1.0 + (ev / 5.0)
      : 1.0 + (ev / 5.0); // simplified for CPU pass
}
