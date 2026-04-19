import 'dart:ui' as ui;
import '../models/edit_state.dart';
import '../models/basic_editor_settings.dart';
import '../models/grain_settings.dart';
import 'bloom_service.dart';

/// Renders the full effect stack to a [ui.Image] using the GPU shader.
///
/// Used for both preview (via ShaderPreview widget) and export.
class EffectEngine {
  EffectEngine();

  Future<ui.Image> apply({
    required EditState state,
    required ui.Image sourceImage,
    required ui.FragmentProgram program,
    BloomPrograms? bloomPrograms,
  }) async {
    final w = sourceImage.width.toDouble();
    final h = sourceImage.height.toDouble();

    final recorder = ui.PictureRecorder();
    final canvas = ui.Canvas(recorder, ui.Rect.fromLTWH(0, 0, w, h));

    final shader = program.fragmentShader();
    _bindUniforms(shader, state, ui.Size(w, h), sourceImage);
    canvas.drawRect(
      ui.Rect.fromLTWH(0, 0, w, h),
      ui.Paint()..shader = shader,
    );

    final processed =
        await recorder.endRecording().toImage(sourceImage.width, sourceImage.height);

    final bloomActive = bloomPrograms != null &&
        state.bloomEnabled &&
        (state.bloom.bloomIntensity > 0 || state.bloom.halationIntensity > 0);
    if (!bloomActive) return processed;

    final halationTint = (state.stockEnabled && state.filmStock != null)
        ? state.filmStock!.halationTint
        : null;

    return BloomService().apply(
      source:           processed,
      settings:         state.bloom,
      programs:         bloomPrograms,
      stockHalationTint: halationTint,
    );
  }

  void _bindUniforms(
    ui.FragmentShader shader,
    EditState state,
    ui.Size size,
    ui.Image sourceImage,
  ) {
    final be = state.basicEditorEnabled
        ? state.basicEditor
        : const BasicEditorSettings();
    final gr   = state.grainEnabled ? state.grain : const GrainSettings();
    final lens = state.lensEnabled  ? state.lensProfile : null;
    final stock = state.stockEnabled ? state.filmStock : null;

    // Geometry
    shader.setFloat(0, size.width);
    shader.setFloat(1, size.height);
    shader.setFloat(2, 0.0); // no letterbox offset for export/offscreen
    shader.setFloat(3, 0.0);
    // Basic editor
    shader.setFloat(4,  be.exposure);
    shader.setFloat(5,  be.contrast);
    shader.setFloat(6,  be.highlights);
    shader.setFloat(7,  be.shadows);
    shader.setFloat(8,  be.whites);
    shader.setFloat(9,  be.blacks);
    shader.setFloat(10, be.temperature);
    shader.setFloat(11, be.tint);
    shader.setFloat(12, be.saturation);
    shader.setFloat(13, be.vibrance);
    // Film stock
    shader.setFloat(14, stock != null ? 1.0 : 0.0);
    shader.setFloat(15, stock != null ? stock.intensity / 100.0 : 0.0);
    // Colour matrix (identity when no stock)
    final cm = stock?.colourMatrix ?? [1,0,0, 0,1,0, 0,0,1];
    shader.setFloat(16, cm[0]); shader.setFloat(17, cm[1]); shader.setFloat(18, cm[2]);
    shader.setFloat(19, cm[3]); shader.setFloat(20, cm[4]); shader.setFloat(21, cm[5]);
    shader.setFloat(22, cm[6]); shader.setFloat(23, cm[7]); shader.setFloat(24, cm[8]);
    // Tone curves
    _setCurve(shader, 25, stock?.redCurve   ?? [0.0, 1.0, 0.8, 2.0]);
    _setCurve(shader, 29, stock?.greenCurve ?? [0.0, 1.0, 0.8, 2.0]);
    _setCurve(shader, 33, stock?.blueCurve  ?? [0.0, 1.0, 0.8, 2.0]);
    // Hue shifts
    shader.setFloat(37, stock?.shadowHueDeg          ?? 0.0);
    shader.setFloat(38, stock?.shadowHueStrength      ?? 0.0);
    shader.setFloat(39, stock?.highlightHueDeg        ?? 0.0);
    shader.setFloat(40, stock?.highlightHueStrength   ?? 0.0);
    // Grain
    shader.setFloat(41, gr.intensity / 100.0);
    shader.setFloat(42, _grainSizeVal(gr.size));
    shader.setFloat(43, gr.type == GrainType.luminance ? 0.0 : 1.0);
    // Lens
    shader.setFloat(44, lens?.vignetteIntensity  ?? 0.0);
    shader.setFloat(45, lens?.vignetteShape       ?? 0.0);
    shader.setFloat(46, lens?.chromaticAberration ?? 0.0);
    shader.setFloat(47, lens?.distortion          ?? 0.0);
    // Sampler
    shader.setImageSampler(0, sourceImage);
  }

  void _setCurve(ui.FragmentShader shader, int start, List<double> c) {
    shader.setFloat(start,     c[0]);
    shader.setFloat(start + 1, c[1]);
    shader.setFloat(start + 2, c[2]);
    shader.setFloat(start + 3, c[3]);
  }

  double _grainSizeVal(GrainSize size) => switch (size) {
    GrainSize.fine   => 1.0,
    GrainSize.medium => 2.0,
    GrainSize.coarse => 4.0,
  };
}
