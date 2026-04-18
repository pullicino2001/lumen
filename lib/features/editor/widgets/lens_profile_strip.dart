import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../core/data/lens_profiles.dart';
import '../../../core/providers/edit_state_provider.dart';

class LensProfileStrip extends ConsumerWidget {
  const LensProfileStrip({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final activeId = ref.watch(
      editStateProvider.select((s) => s?.lensProfile?.id),
    );
    final enabled = ref.watch(
      editStateProvider.select((s) => s?.lensEnabled ?? true),
    );

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Text('Lens', style: Theme.of(context).textTheme.titleSmall),
            const Spacer(),
            Switch(
              value: enabled,
              onChanged: (_) =>
                  ref.read(editStateProvider.notifier).toggleLens(),
            ),
          ],
        ),
        SizedBox(
          height: 72,
          child: ListView.separated(
            scrollDirection: Axis.horizontal,
            itemCount: kLensProfiles.length + 1,
            separatorBuilder: (ctx, idx) => const SizedBox(width: 8),
            itemBuilder: (context, index) {
              if (index == 0) {
                return _ProfileChip(
                  label: 'None',
                  selected: activeId == null,
                  color: Colors.grey,
                  onTap: () => ref
                      .read(editStateProvider.notifier)
                      .setLensProfile(null),
                );
              }
              final profile = kLensProfiles[index - 1];
              return _ProfileChip(
                label: profile.name,
                selected: activeId == profile.id,
                color: _accentFor(profile.id),
                onTap: () => ref
                    .read(editStateProvider.notifier)
                    .setLensProfile(profile),
              );
            },
          ),
        ),
      ],
    );
  }

  Color _accentFor(String id) => switch (id) {
        'classic_50'  => const Color(0xFFD4AF37),
        'portrait_85' => const Color(0xFFE8A87C),
        'wide_24'     => const Color(0xFF5A9AD4),
        'vintage_35'  => const Color(0xFFB87333),
        'anamorphic'  => const Color(0xFF8A5AD4),
        _             => const Color(0xFFAAAAAA),
      };
}

class _ProfileChip extends StatelessWidget {
  const _ProfileChip({
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
