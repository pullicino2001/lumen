import 'dart:ui' as ui;
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../core/models/basic_editor_settings.dart';
import '../../../core/models/edit_state.dart';
import '../../../core/providers/shader_provider.dart';
import '../../../core/providers/preview_image_provider.dart';

/// Live GPU preview — repaints on every slider change via [BasicEditorSettings].
class ShaderPreview extends ConsumerWidget {
  const ShaderPreview({super.key, required this.editState});

  final EditState editState;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final programAsync = ref.watch(basicEditorProgramProvider);
    final imageAsync = ref.watch(previewImageProvider);

    return programAsync.when(
      loading: () => const Center(child: CircularProgressIndicator()),
      error: (e, st) => const Center(child: Icon(Icons.broken_image_outlined)),
      data: (program) => imageAsync.when(
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (e, st) => const Center(child: Icon(Icons.broken_image_outlined)),
        data: (image) {
          if (image == null) return const SizedBox.shrink();
          final settings = editState.basicEditorEnabled
              ? editState.basicEditor
              : const BasicEditorSettings();
          return CustomPaint(
            painter: _BasicEditorPainter(
              shader: program.fragmentShader(),
              image: image,
              settings: settings,
            ),
            child: const SizedBox.expand(),
          );
        },
      ),
    );
  }
}

class _BasicEditorPainter extends CustomPainter {
  _BasicEditorPainter({
    required this.shader,
    required this.image,
    required this.settings,
  });

  final ui.FragmentShader shader;
  final ui.Image image;
  final BasicEditorSettings settings;

  @override
  void paint(Canvas canvas, Size size) {
    // Letterbox: preserve image aspect ratio within the available area.
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

    shader.setFloat(0, drawRect.width);
    shader.setFloat(1, drawRect.height);
    shader.setFloat(2, drawRect.left);
    shader.setFloat(3, drawRect.top);
    shader.setFloat(4, settings.exposure);
    shader.setFloat(5, settings.contrast);
    shader.setFloat(6, settings.highlights);
    shader.setFloat(7, settings.shadows);
    shader.setFloat(8, settings.whites);
    shader.setFloat(9, settings.blacks);
    shader.setFloat(10, settings.temperature);
    shader.setFloat(11, settings.tint);
    shader.setFloat(12, settings.saturation);
    shader.setFloat(13, settings.vibrance);
    shader.setImageSampler(0, image);

    canvas.drawRect(drawRect, Paint()..shader = shader);
  }

  @override
  bool shouldRepaint(_BasicEditorPainter old) =>
      old.settings != settings || old.image != image;
}
