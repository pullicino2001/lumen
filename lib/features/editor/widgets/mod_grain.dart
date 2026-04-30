import 'dart:math' as math;
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../core/models/grain_settings.dart';
import '../../../core/providers/edit_state_provider.dart';
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

class _GrainField extends StatelessWidget {
  const _GrainField({required this.intensity});
  final double intensity;

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 90,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(4),
        border: Border.all(color: kHair, width: 0.5),
        color: const Color(0xFF111111),
      ),
      clipBehavior: Clip.antiAlias,
      child: Stack(
        children: [
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
          Positioned.fill(
            child: Opacity(
              opacity: (intensity / 100).clamp(0.05, 1.0),
              child: CustomPaint(painter: _GrainPainter()),
            ),
          ),
          Positioned(
            top: 8,
            right: 8,
            child: Container(
              width: 56,
              height: 56,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                border: Border.all(color: kAmber, width: 1),
                boxShadow: [BoxShadow(color: kAmber.withValues(alpha: 0.4), blurRadius: 16)],
              ),
              clipBehavior: Clip.antiAlias,
              child: Stack(
                children: [
                  Positioned.fill(
                    child: DecoratedBox(
                      decoration: const BoxDecoration(
                        gradient: RadialGradient(
                          colors: [Color(0xFF3A2A18), Color(0xFF0A0605)],
                        ),
                      ),
                    ),
                  ),
                  Positioned.fill(
                    child: Opacity(
                      opacity: (intensity / 100 * 1.8).clamp(0.05, 1.0),
                      child: CustomPaint(painter: _GrainPainter(scale: 0.4)),
                    ),
                  ),
                ],
              ),
            ),
          ),
          Positioned(
            bottom: 6,
            left: 10,
            child: Text('100% ZOOM', style: monoStyle(size: 8, letterSpacing: 2)),
          ),
        ],
      ),
    );
  }
}

class _GrainPainter extends CustomPainter {
  const _GrainPainter({this.scale = 1.0});
  final double scale;

  @override
  void paint(Canvas canvas, Size size) {
    final rng = math.Random(42);
    final paint = Paint()..color = kText;
    final count = (size.width * size.height * 0.08 * scale).round();
    for (int i = 0; i < count; i++) {
      final x = rng.nextDouble() * size.width;
      final y = rng.nextDouble() * size.height;
      final r = rng.nextDouble() * 0.8 * scale + 0.2;
      paint.color = kText.withValues(alpha: rng.nextDouble() * 0.6 + 0.2);
      canvas.drawCircle(Offset(x, y), r, paint);
    }
  }

  @override
  bool shouldRepaint(_GrainPainter old) => false;
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
