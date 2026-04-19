import 'dart:ui' as ui;
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../core/providers/rendered_preview_provider.dart';

/// Displays the fully-rendered GPU preview (basic editor + LUT + grain + lens + bloom).
///
/// Uses a cached last-good image so the display never blanks between renders —
/// the previous frame stays visible while the next one is computing.
class ShaderPreview extends ConsumerStatefulWidget {
  const ShaderPreview({super.key});

  @override
  ConsumerState<ShaderPreview> createState() => _ShaderPreviewState();
}

class _ShaderPreviewState extends ConsumerState<ShaderPreview> {
  ui.Image? _cached;

  @override
  Widget build(BuildContext context) {
    ref.listen(renderedPreviewProvider, (prev, next) {
      next.whenData((img) {
        if (img != null && mounted) setState(() => _cached = img);
      });
    });

    if (_cached == null) {
      return const Center(child: CircularProgressIndicator());
    }
    return RawImage(image: _cached, fit: BoxFit.contain);
  }
}
