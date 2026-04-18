import 'dart:ui' as ui;
import '../models/edit_state.dart';
import '../models/basic_editor_settings.dart';
import '../models/grain_settings.dart';

/// Renders the full effect stack to a [ui.Image] using the GPU shader.
///
/// Used for both preview (via ShaderPreview widget) and export.
/// Camera-agnostic — v2 live camera module will call apply() per frame.
class EffectEngine {
  EffectEngine();

  Future<ui.Image> apply({
    required EditState state,
    required ui.Image sourceImage,
    required ui.FragmentProgram program,
    required ui.Image lutImage,
    required double lutSize,
  }) async {
    final w = sourceImage.width.toDouble();
    final h = sourceImage.height.toDouble();

    final recorder = ui.PictureRecorder();
    final canvas = ui.Canvas(recorder, ui.Rect.fromLTWH(0, 0, w, h));

    final shader = program.fragmentShader();
    _bindUniforms(shader, state, ui.Size(w, h), lutSize, lutImage, sourceImage);
    canvas.drawRect(
      ui.Rect.fromLTWH(0, 0, w, h),
      ui.Paint()..shader = shader,
    );

    final picture = recorder.endRecording();
    return picture.toImage(sourceImage.width, sourceImage.height);
  }

  void _bindUniforms(
    ui.FragmentShader shader,
    EditState state,
    ui.Size size,
    double lutSize,
    ui.Image lutImage,
    ui.Image sourceImage,
  ) {
    final be = state.basicEditorEnabled
        ? state.basicEditor
        : const BasicEditorSettings();
    final gr = state.grainEnabled ? state.grain : const GrainSettings();
    final lens = state.lensEnabled ? state.lensProfile : null;
    final lutIntensity =
        (state.filmLookEnabled && state.filmLook != null)
            ? state.filmLook!.intensity / 100.0
            : 0.0;

    // Geometry
    shader.setFloat(0,  size.width);
    shader.setFloat(1,  size.height);
    shader.setFloat(2,  0.0); // no letterbox offset for export
    shader.setFloat(3,  0.0);
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
    // LUT
    shader.setFloat(14, lutSize);
    shader.setFloat(15, lutIntensity);
    // Grain
    shader.setFloat(16, gr.intensity / 100.0);
    shader.setFloat(17, _grainSizeVal(gr.size));
    shader.setFloat(18, gr.type == GrainType.luminance ? 0.0 : 1.0);
    // Lens
    shader.setFloat(19, lens?.vignetteIntensity   ?? 0.0);
    shader.setFloat(20, lens?.vignetteShape        ?? 0.0);
    shader.setFloat(21, lens?.chromaticAberration  ?? 0.0);
    shader.setFloat(22, lens?.distortion           ?? 0.0);
    // Samplers
    shader.setImageSampler(0, sourceImage);
    shader.setImageSampler(1, lutImage);
  }

  double _grainSizeVal(GrainSize size) => switch (size) {
    GrainSize.fine   => 1.0,
    GrainSize.medium => 2.0,
    GrainSize.coarse => 4.0,
  };
}
