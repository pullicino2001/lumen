import 'dart:math' as math;
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../core/models/bloom_settings.dart';
import '../../../core/providers/edit_state_provider.dart';
import '../../../shared/theme/lumen_theme.dart';
import 'chromatic_slider.dart';

class ModBloom extends ConsumerWidget {
  const ModBloom({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final editState = ref.watch(editStateProvider);
    if (editState == null) return const SizedBox.shrink();

    final s = editState.bloom;

    void update(BloomSettings b) =>
        ref.read(editStateProvider.notifier).updateBloom(b);

    return SingleChildScrollView(
      padding: const EdgeInsets.fromLTRB(24, 8, 24, 8),
      child: Column(
        children: [
          RepaintBoundary(
            child: SizedBox(
              height: 160,
              child: CustomPaint(
                painter: _BloomPainter(
                  bloomIntensity: s.bloomIntensity,
                  bloomRadius: s.bloomRadius,
                  halationIntensity: s.halationIntensity,
                ),
                size: const Size(double.infinity, 160),
              ),
            ),
          ),
          const SizedBox(height: 14),
          Row(
            children: [
              Expanded(
                child: ChromaticSlider(
                  label: 'Bloom',
                  value: s.bloomIntensity,
                  min: 0,
                  max: 100,
                  onChanged: (v) => update(s.copyWith(bloomIntensity: v)),
                ),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: ChromaticSlider(
                  label: 'Radius',
                  value: s.bloomRadius * 100,
                  min: 0,
                  max: 100,
                  onChanged: (v) => update(s.copyWith(bloomRadius: v / 100)),
                ),
              ),
            ],
          ),
          const SizedBox(height: 14),
          Row(
            children: [
              Expanded(
                child: ChromaticSlider(
                  label: 'Halation',
                  value: s.halationIntensity,
                  min: 0,
                  max: 100,
                  onChanged: (v) => update(s.copyWith(halationIntensity: v)),
                ),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: ChromaticSlider(
                  label: 'Warmth',
                  value: s.halationWarmth * 100,
                  min: 0,
                  max: 100,
                  onChanged: (v) => update(s.copyWith(halationWarmth: v / 100)),
                ),
              ),
            ],
          ),
          const SizedBox(height: 14),
          ChromaticSlider(
            label: 'Threshold',
            value: s.bloomThreshold * 100,
            min: 0,
            max: 100,
            onChanged: (v) => update(s.copyWith(bloomThreshold: v / 100)),
          ),
        ],
      ),
    );
  }
}

class _BloomPainter extends CustomPainter {
  const _BloomPainter({
    required this.bloomIntensity,
    required this.bloomRadius,
    required this.halationIntensity,
  });

  final double bloomIntensity;
  final double bloomRadius;
  final double halationIntensity;

  @override
  void paint(Canvas canvas, Size size) {
    final cx = size.width / 2;
    final cy = size.height / 2;
    final ringR = 30 + bloomRadius * 60;

    // halation aura
    if (halationIntensity > 0) {
      final halo = RadialGradient(
        colors: [
          const Color(0xFFFF6C24).withValues(alpha: 0.6 * halationIntensity / 100),
          const Color(0xFFFF6C24).withValues(alpha: 0.12 * halationIntensity / 100),
          Colors.transparent,
        ],
        stops: const [0, 0.6, 1],
      ).createShader(Rect.fromCircle(center: Offset(cx, cy), radius: ringR + 36));
      canvas.drawCircle(Offset(cx, cy), ringR + 36, Paint()..shader = halo);
    }

    // bloom core
    if (bloomIntensity > 0) {
      final bloom = RadialGradient(
        colors: [
          Colors.white.withValues(alpha: bloomIntensity / 100),
          kAmber.withValues(alpha: 0.9 * bloomIntensity / 100),
          Colors.transparent,
        ],
        stops: const [0, 0.4, 1],
      ).createShader(Rect.fromCircle(center: Offset(cx, cy), radius: ringR));
      canvas.drawCircle(Offset(cx, cy), ringR, Paint()..shader = bloom);
    }

    // outer ring
    canvas.drawCircle(
      Offset(cx, cy),
      ringR,
      Paint()
        ..color = kAmber
        ..style = PaintingStyle.stroke
        ..strokeWidth = 1,
    );

    // threshold ticks
    for (int i = 0; i < 24; i++) {
      final a = (i * 360 / 24 - 90) * math.pi / 180;
      final x1 = cx + (ringR + 4) * math.cos(a);
      final y1 = cy + (ringR + 4) * math.sin(a);
      final x2 = cx + (ringR + 10) * math.cos(a);
      final y2 = cy + (ringR + 10) * math.sin(a);
      canvas.drawLine(
        Offset(x1, y1),
        Offset(x2, y2),
        Paint()..color = kHair..strokeWidth = 0.8,
      );
    }

    // drag handle (right of ring)
    final hx = cx + ringR;
    canvas.drawCircle(Offset(hx - 1.5, cy), 5, Paint()..color = kRed.withValues(alpha: 0.5));
    canvas.drawCircle(Offset(hx + 1.5, cy), 5, Paint()..color = kTeal.withValues(alpha: 0.5));
    canvas.drawCircle(
      Offset(hx, cy),
      6,
      Paint()..color = kAmber,
    );
    canvas.drawCircle(
      Offset(hx, cy),
      6,
      Paint()
        ..color = const Color(0xFF1A0F06)
        ..style = PaintingStyle.stroke
        ..strokeWidth = 1.5,
    );

    // center readout
    _drawText(
      canvas,
      'BLOOM · ${bloomIntensity.round()}',
      monoStyle(size: 9, color: kText, letterSpacing: 2),
      Offset(cx, cy - 6),
    );
    _drawText(
      canvas,
      'R ${(bloomRadius * 100).round()} · TH 64',
      monoStyle(size: 7, letterSpacing: 2),
      Offset(cx, cy + 10),
    );
  }

  void _drawText(Canvas canvas, String text, TextStyle style, Offset center) {
    final painter = TextPainter(
      text: TextSpan(text: text, style: style),
      textDirection: TextDirection.ltr,
    )..layout();
    painter.paint(canvas, center.translate(-painter.width / 2, -painter.height / 2));
  }

  @override
  bool shouldRepaint(_BloomPainter old) =>
      old.bloomIntensity != bloomIntensity ||
      old.bloomRadius != bloomRadius ||
      old.halationIntensity != halationIntensity;
}
