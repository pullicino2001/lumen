import 'dart:ui' as ui;
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../core/models/basic_editor_settings.dart';
import '../../../core/models/edit_state.dart';
import '../../../core/models/grain_settings.dart';
import '../../../core/providers/shader_provider.dart';
import '../../../core/providers/preview_image_provider.dart';
import '../../../core/providers/lut_provider.dart';

/// Live GPU preview — repaints on every slider or setting change.
class ShaderPreview extends ConsumerWidget {
  const ShaderPreview({super.key, required this.editState});

  final EditState editState;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final programAsync = ref.watch(basicEditorProgramProvider);
    final imageAsync   = ref.watch(previewImageProvider);
    final lutAsync     = ref.watch(lutImageProvider);

    return programAsync.when(
      loading: () => const Center(child: CircularProgressIndicator()),
      error: (e, st) => const Center(child: Icon(Icons.broken_image_outlined)),
      data: (program) => imageAsync.when(
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (e, st) => const Center(child: Icon(Icons.broken_image_outlined)),
        data: (image) {
          if (image == null) return const SizedBox.shrink();
          return lutAsync.when(
            loading: () => const Center(child: CircularProgressIndicator()),
            error: (e, st) => const Center(child: Icon(Icons.broken_image_outlined)),
            data: (lutData) {
              final (lutImage, lutSize) = lutData;
              return CustomPaint(
                painter: _Painter(
                  shader:       program.fragmentShader(),
                  image:        image,
                  editState:    editState,
                  lutImage:     lutImage,
                  lutSize:      lutSize,
                ),
                child: const SizedBox.expand(),
              );
            },
          );
        },
      ),
    );
  }
}

class _Painter extends CustomPainter {
  _Painter({
    required this.shader,
    required this.image,
    required this.editState,
    required this.lutImage,
    required this.lutSize,
  });

  final ui.FragmentShader shader;
  final ui.Image image;
  final EditState editState;
  final ui.Image lutImage;
  final double lutSize;

  @override
  void paint(Canvas canvas, Size size) {
    final imgW = image.width.toDouble();
    final imgH = image.height.toDouble();
    final imgAspect = imgW / imgH;
    final canvasAspect = size.width / size.height;

    final Rect drawRect;
    if (imgAspect > canvasAspect) {
      final h = size.width / imgAspect;
      drawRect = Rect.fromLTWH(0, (size.height - h) / 2, size.width, h);
    } else {
      final w = size.height * imgAspect;
      drawRect = Rect.fromLTWH((size.width - w) / 2, 0, w, size.height);
    }

    final be = editState.basicEditorEnabled
        ? editState.basicEditor
        : const BasicEditorSettings();
    final gr = editState.grainEnabled ? editState.grain : const GrainSettings();
    final lens = editState.lensEnabled ? editState.lensProfile : null;
    final lutIntensity =
        (editState.filmLookEnabled && editState.filmLook != null)
            ? editState.filmLook!.intensity / 100.0
            : 0.0;

    // Geometry
    shader.setFloat(0,  drawRect.width);
    shader.setFloat(1,  drawRect.height);
    shader.setFloat(2,  drawRect.left);
    shader.setFloat(3,  drawRect.top);
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
    shader.setFloat(19, lens?.vignetteIntensity  ?? 0.0);
    shader.setFloat(20, lens?.vignetteShape       ?? 0.0);
    shader.setFloat(21, lens?.chromaticAberration ?? 0.0);
    shader.setFloat(22, lens?.distortion          ?? 0.0);
    // Samplers
    shader.setImageSampler(0, image);
    shader.setImageSampler(1, lutImage);

    canvas.drawRect(drawRect, Paint()..shader = shader);
  }

  double _grainSizeVal(GrainSize size) => switch (size) {
    GrainSize.fine   => 1.0,
    GrainSize.medium => 2.0,
    GrainSize.coarse => 4.0,
  };

  @override
  bool shouldRepaint(_Painter old) =>
      old.editState != editState ||
      old.image     != image     ||
      old.lutImage  != lutImage;
}
