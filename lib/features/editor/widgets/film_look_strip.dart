import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../core/data/film_looks.dart';
import '../../../core/models/film_look.dart';
import '../../../core/providers/edit_state_provider.dart';

/// Horizontally scrollable film look selector strip.
class FilmLookStrip extends ConsumerWidget {
  const FilmLookStrip({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final activeLook = ref.watch(
      editStateProvider.select((s) => s?.filmLook),
    );
    final enabled = ref.watch(
      editStateProvider.select((s) => s?.filmLookEnabled ?? true),
    );

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Text('Film Look', style: Theme.of(context).textTheme.titleSmall),
            const Spacer(),
            Switch(
              value: enabled,
              onChanged: (_) =>
                  ref.read(editStateProvider.notifier).toggleFilmLook(),
            ),
          ],
        ),
        SizedBox(
          height: 72,
          child: ListView.separated(
            scrollDirection: Axis.horizontal,
            itemCount: kFilmLooks.length + 1, // +1 for "None"
            separatorBuilder: (ctx, idx) => const SizedBox(width: 8),
            itemBuilder: (context, index) {
              if (index == 0) {
                return _LookChip(
                  label: 'None',
                  selected: activeLook == null,
                  color: Colors.grey,
                  onTap: () =>
                      ref.read(editStateProvider.notifier).setFilmLook(null),
                );
              }
              final look = kFilmLooks[index - 1];
              return _LookChip(
                label: look.name,
                selected: activeLook?.id == look.id,
                color: _accentFor(look.id),
                onTap: () =>
                    ref.read(editStateProvider.notifier).setFilmLook(look),
              );
            },
          ),
        ),
        if (activeLook != null && enabled) ...[
          const SizedBox(height: 4),
          _IntensityRow(look: activeLook),
        ],
      ],
    );
  }

  Color _accentFor(String id) => switch (id) {
        'warm_fade' => const Color(0xFFD4A05A),
        'cool_mist' => const Color(0xFF5A9AD4),
        'noir'      => const Color(0xFF888888),
        _           => const Color(0xFFD4AF37),
      };
}

class _LookChip extends StatelessWidget {
  const _LookChip({
    required this.label,
    required this.selected,
    required this.color,
    required this.onTap,
  });

  final String label;
  final bool selected;
  final Color color;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 150),
        width: 64,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(8),
          border: Border.all(
            color: selected
                ? Theme.of(context).colorScheme.primary
                : Colors.transparent,
            width: 2,
          ),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              width: 36,
              height: 36,
              decoration: BoxDecoration(
                color: color.withValues(alpha: selected ? 1.0 : 0.5),
                shape: BoxShape.circle,
              ),
            ),
            const SizedBox(height: 4),
            Text(
              label,
              style: Theme.of(context).textTheme.labelSmall?.copyWith(
                    color: selected
                        ? Theme.of(context).colorScheme.primary
                        : null,
                  ),
              overflow: TextOverflow.ellipsis,
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }
}

class _IntensityRow extends ConsumerWidget {
  const _IntensityRow({required this.look});
  final FilmLook look;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Row(
      children: [
        SizedBox(
          width: 90,
          child: Text('Intensity', style: Theme.of(context).textTheme.bodySmall),
        ),
        Expanded(
          child: Slider(
            value: look.intensity.clamp(0.0, 100.0),
            min: 0,
            max: 100,
            onChanged: (v) {
              final updated = look.copyWith(intensity: v);
              ref.read(editStateProvider.notifier).setFilmLook(updated);
            },
          ),
        ),
        SizedBox(
          width: 42,
          child: Text(
            look.intensity.toStringAsFixed(0),
            textAlign: TextAlign.right,
            style: Theme.of(context).textTheme.bodySmall,
          ),
        ),
      ],
    );
  }
}
