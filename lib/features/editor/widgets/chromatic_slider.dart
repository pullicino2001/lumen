import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../../../shared/theme/lumen_theme.dart';

class ChromaticSlider extends StatefulWidget {
  const ChromaticSlider({
    super.key,
    required this.value,
    required this.min,
    required this.max,
    required this.onChanged,
    this.bipolar = false,
    this.label,
    this.displayValue,
    this.defaultValue,
  });

  final double value;
  final double min;
  final double max;
  final ValueChanged<double> onChanged;
  final bool bipolar;
  final String? label;
  final String? displayValue;
  // The value double-tap resets to; defaults to min.
  final double? defaultValue;

  @override
  State<ChromaticSlider> createState() => _ChromaticSliderState();
}

class _ChromaticSliderState extends State<ChromaticSlider> {
  double? _cachedWidth;

  @override
  Widget build(BuildContext context) {
    final pct = ((widget.value - widget.min) / (widget.max - widget.min)).clamp(0.0, 1.0);
    final resetVal = widget.defaultValue ?? widget.min;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        if (widget.label != null)
          Padding(
            padding: const EdgeInsets.only(bottom: 8),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(widget.label!.toUpperCase(),
                    style: monoStyle(size: 9, letterSpacing: 2)),
                Text(
                  widget.displayValue ?? widget.value.toStringAsFixed(0),
                  style: monoStyle(size: 9, color: kAmber, letterSpacing: 1.5),
                ),
              ],
            ),
          ),
        GestureDetector(
          behavior: HitTestBehavior.opaque,
          onHorizontalDragStart: (_) {
            final box = context.findRenderObject() as RenderBox?;
            _cachedWidth = box?.size.width;
          },
          onHorizontalDragUpdate: (d) {
            final w = _cachedWidth;
            if (w == null || w == 0) return;
            final frac = (d.localPosition.dx / w).clamp(0.0, 1.0);
            widget.onChanged(widget.min + frac * (widget.max - widget.min));
          },
          onTapDown: (d) {
            final box = context.findRenderObject() as RenderBox?;
            if (box == null) return;
            final frac = (d.localPosition.dx / box.size.width).clamp(0.0, 1.0);
            widget.onChanged(widget.min + frac * (widget.max - widget.min));
          },
          onDoubleTap: () {
            HapticFeedback.mediumImpact();
            widget.onChanged(resetVal);
          },
          child: SizedBox(
            height: 24,
            child: CustomPaint(
              painter: _ChromaticSliderPainter(pct: pct, bipolar: widget.bipolar),
              size: const Size(double.infinity, 24),
            ),
          ),
        ),
      ],
    );
  }
}

class _ChromaticSliderPainter extends CustomPainter {
  const _ChromaticSliderPainter({required this.pct, required this.bipolar});
  final double pct;
  final bool bipolar;

  @override
  void paint(Canvas canvas, Size size) {
    final trackY = size.height / 2;

    canvas.drawLine(
      Offset(0, trackY),
      Offset(size.width, trackY),
      Paint()
        ..color = kHair
        ..strokeWidth = 1
        ..style = PaintingStyle.stroke,
    );

    final fillPaint = Paint()
      ..color = kText
      ..strokeWidth = 1
      ..style = PaintingStyle.stroke;

    if (bipolar) {
      final midX = size.width * 0.5;
      final thumbX = size.width * pct;
      canvas.drawLine(Offset(midX, trackY), Offset(thumbX, trackY), fillPaint);
    } else {
      canvas.drawLine(
          Offset(0, trackY), Offset(size.width * pct, trackY), fillPaint);
    }

    final thumbX = size.width * pct;
    canvas.drawRect(
      Rect.fromLTWH(thumbX - 2, 0, 2, size.height),
      Paint()..color = kRed..blendMode = BlendMode.screen,
    );
    canvas.drawRect(
      Rect.fromLTWH(thumbX + 2, 0, 2, size.height),
      Paint()..color = kTeal..blendMode = BlendMode.screen,
    );
    canvas.drawRect(
      Rect.fromLTWH(thumbX - 0.5, 0, 1.5, size.height),
      Paint()..color = kText,
    );
  }

  @override
  bool shouldRepaint(_ChromaticSliderPainter old) => old.pct != pct;
}
