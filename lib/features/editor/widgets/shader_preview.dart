import 'dart:ui' as ui;
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../core/providers/rendered_preview_provider.dart';
import '../../../shared/theme/lumen_theme.dart';

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
  void initState() {
    super.initState();
    // Seed from the current provider value so re-mounts (e.g. after long-press
    // BEFORE view) never show a blank frame while waiting for the next emission.
    ref.read(renderedPreviewProvider).whenData((img) {
      if (img != null) _cached = img;
    });
  }

  @override
  Widget build(BuildContext context) {
    final previewAsync = ref.watch(renderedPreviewProvider);

    ref.listen(renderedPreviewProvider, (prev, next) {
      next.whenData((img) {
        if (img != null && mounted) setState(() => _cached = img);
      });
    });

    if (_cached == null) {
      return const Center(child: CircularProgressIndicator());
    }

    return Stack(
      fit: StackFit.expand,
      children: [
        RawImage(image: _cached, fit: BoxFit.contain),
        if (previewAsync.isLoading)
          const Positioned(
            bottom: 12,
            right: 12,
            child: SizedBox(
              width: 14,
              height: 14,
              child: CircularProgressIndicator(
                strokeWidth: 1.5,
                color: kAmber,
              ),
            ),
          ),
      ],
    );
  }
}
