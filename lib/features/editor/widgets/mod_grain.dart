import 'dart:ui' as ui;
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../core/models/grain_settings.dart';
import '../../../core/providers/edit_state_provider.dart';
import '../../../core/providers/rendered_preview_provider.dart';
import '../../../shared/theme/lumen_theme.dart';
import 'chromatic_slider.dart';

class ModGrain extends ConsumerWidget {
  const ModGrain({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final editState = ref.watch(editStateProvider);
    if (editState == null) return const SizedBox.shrink();

    final s = editState.grain;

    void update(GrainSettings g) =>
        ref.read(editStateProvider.notifier).updateGrain(g);

    return SingleChildScrollView(
      padding: const EdgeInsets.fromLTRB(24, 8, 24, 8),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _GrainField(intensity: s.intensity),
          const SizedBox(height: 14),
          ChromaticSlider(
            label: 'Intensity',
            value: s.intensity,
            min: 0,
            max: 100,
            onChanged: (v) => update(s.copyWith(intensity: v)),
          ),
          const SizedBox(height: 16),
          _ChipRow<GrainSize>(
            label: 'Size',
            values: GrainSize.values,
            selected: s.size,
            labelFor: (v) => switch (v) {
              GrainSize.fine   => 'Fine',
              GrainSize.medium => 'Medium',
              GrainSize.coarse => 'Coarse',
            },
            onSelect: (v) => update(s.copyWith(size: v)),
          ),
          const SizedBox(height: 10),
          _ChipRow<GrainType>(
            label: 'Type',
            values: GrainType.values,
            selected: s.type,
            labelFor: (v) => switch (v) {
              GrainType.luminance => 'Luma',
              GrainType.colour    => 'Colour',
            },
            onSelect: (v) => update(s.copyWith(type: v)),
          ),
        ],
      ),
    );
  }
}

class _GrainField extends ConsumerStatefulWidget {
  const _GrainField({required this.intensity});
  final double intensity;

  @override
  ConsumerState<_GrainField> createState() => _GrainFieldState();
}

class _GrainFieldState extends ConsumerState<_GrainField> {
  ui.Image? _image;
  // Normalized center of the crop window (0..1 in each axis).
  Offset _anchor = const Offset(0.5, 0.5);
  static const double _zoom = 4.0;
  static const double _containerH = 90.0;

  @override
  void initState() {
    super.initState();
    // Seed from whatever is already resolved so we never start blank.
    ref.read(renderedPreviewProvider).whenData((img) {
      if (img != null && mounted) setState(() => _image = img);
    });
  }

  @override
  Widget build(BuildContext context) {
    ref.listen(renderedPreviewProvider, (_, next) {
      next.whenData((img) {
        if (img != null && mounted) setState(() => _image = img);
      });
    });

    return LayoutBuilder(builder: (context, constraints) {
      final containerW = constraints.maxWidth;

      return GestureDetector(
        onPanUpdate: (d) {
          final img = _image;
          if (img == null) return;

          final imgW = img.width.toDouble();
          final imgH = img.height.toDouble();
          final crop = _cropRect(imgW, imgH, containerW, _containerH, _anchor);

          // Map widget-pixel drag to image-fraction shift.
          final dAnchorX = -d.delta.dx * (crop.width  / imgW) / containerW;
          final dAnchorY = -d.delta.dy * (crop.height / imgH) / _containerH;

          final halfCropFracX = (crop.width  / 2) / imgW;
          final halfCropFracY = (crop.height / 2) / imgH;

          setState(() {
            _anchor = Offset(
              (_anchor.dx + dAnchorX).clamp(halfCropFracX, 1.0 - halfCropFracX),
              (_anchor.dy + dAnchorY).clamp(halfCropFracY, 1.0 - halfCropFracY),
            );
          });
        },
        onDoubleTap: () => setState(() => _anchor = const Offset(0.5, 0.5)),
        child: Container(
          height: _containerH,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(4),
            border: Border.all(color: kHair, width: 0.5),
            color: const Color(0xFF111111),
          ),
          clipBehavior: Clip.antiAlias,
          child: Stack(
            children: [
              if (_image != null)
                Positioned.fill(
                  child: CustomPaint(
                    painter: _ZoomedImagePainter(
                      image: _image!,
                      anchor: _anchor,
                      zoom: _zoom,
                    ),
                  ),
                )
              else
                Positioned.fill(
                  child: DecoratedBox(
                    decoration: const BoxDecoration(
                      gradient: RadialGradient(
                        center: Alignment.center,
                        radius: 1,
                        colors: [Color(0xFF2A1D0E), Color(0xFF050403)],
                      ),
                    ),
                  ),
                ),
              Positioned(
                bottom: 6,
                left: 10,
                child: Text(
                  _image != null ? 'DRAG  ·  ${_zoom.toInt()}× ZOOM' : 'LOADING',
                  style: monoStyle(size: 7, letterSpacing: 1.5, color: kMute),
                ),
              ),
            ],
          ),
        ),
      );
    });
  }

  // Computes the aspect-correct source crop in image pixels.
  static Rect _cropRect(
      double imgW, double imgH, double wW, double wH, Offset anchor) {
    final widgetAspect = wW / wH;
    final imgAspect = imgW / imgH;
    double cropW, cropH;
    if (widgetAspect > imgAspect) {
      cropW = imgW / _zoom;
      cropH = cropW / widgetAspect;
    } else {
      cropH = imgH / _zoom;
      cropW = cropH * widgetAspect;
    }
    final l = (anchor.dx * imgW - cropW / 2).clamp(0.0, imgW - cropW);
    final t = (anchor.dy * imgH - cropH / 2).clamp(0.0, imgH - cropH);
    return Rect.fromLTWH(l, t, cropW, cropH);
  }
}

class _ZoomedImagePainter extends CustomPainter {
  const _ZoomedImagePainter({
    required this.image,
    required this.anchor,
    required this.zoom,
  });

  final ui.Image image;
  final Offset anchor;
  final double zoom;

  @override
  void paint(Canvas canvas, Size size) {
    final imgW = image.width.toDouble();
    final imgH = image.height.toDouble();
    final src = _GrainFieldState._cropRect(imgW, imgH, size.width, size.height, anchor);
    final dst = Offset.zero & size;
    canvas.drawImageRect(image, src, dst, Paint()..filterQuality = FilterQuality.medium);
  }

  @override
  bool shouldRepaint(_ZoomedImagePainter old) =>
      old.image != image || old.anchor != anchor || old.zoom != zoom;
}

class _ChipRow<T> extends StatelessWidget {
  const _ChipRow({
    required this.label,
    required this.values,
    required this.selected,
    required this.labelFor,
    required this.onSelect,
  });

  final String label;
  final List<T> values;
  final T selected;
  final String Function(T) labelFor;
  final void Function(T) onSelect;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        SizedBox(
          width: 52,
          child: Text(label.toUpperCase(),
              style: monoStyle(size: 9, letterSpacing: 2)),
        ),
        const SizedBox(width: 10),
        Expanded(
          child: Row(
            children: values.map((v) {
              final on = v == selected;
              return Expanded(
                child: GestureDetector(
                  onTap: () => onSelect(v),
                  child: AnimatedContainer(
                    duration: const Duration(milliseconds: 150),
                    margin: const EdgeInsets.symmetric(horizontal: 3),
                    padding: const EdgeInsets.symmetric(vertical: 7),
                    alignment: Alignment.center,
                    decoration: BoxDecoration(
                      color: on ? kAmber : Colors.transparent,
                      border: Border.all(
                        color: on ? kAmber : kHair,
                        width: 0.5,
                      ),
                      borderRadius: BorderRadius.circular(3),
                    ),
                    child: Text(
                      labelFor(v),
                      style: sansStyle(
                        size: 10,
                        color: on ? const Color(0xFF1A0F06) : kText,
                      ),
                    ),
                  ),
                ),
              );
            }).toList(),
          ),
        ),
      ],
    );
  }
}
