import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../core/data/film_stocks.dart';
import '../../../core/models/film_stock.dart';
import '../../../core/providers/edit_state_provider.dart';

/// Horizontally scrollable film stock selector strip.
class StockStrip extends ConsumerWidget {
  const StockStrip({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final activeStock = ref.watch(
      editStateProvider.select((s) => s?.filmStock),
    );
    final enabled = ref.watch(
      editStateProvider.select((s) => s?.stockEnabled ?? true),
    );

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Text('Stocks', style: Theme.of(context).textTheme.titleSmall),
            const Spacer(),
            Switch(
              value: enabled,
              onChanged: (_) =>
                  ref.read(editStateProvider.notifier).toggleStock(),
            ),
          ],
        ),
        SizedBox(
          height: 72,
          child: ListView.separated(
            scrollDirection: Axis.horizontal,
            itemCount: kFilmStocks.length + 1,
            separatorBuilder: (ctx, idx) => const SizedBox(width: 8),
            itemBuilder: (context, index) {
              if (index == 0) {
                return _StockChip(
                  label: 'None',
                  selected: activeStock == null,
                  color: Colors.grey,
                  onTap: () =>
                      ref.read(editStateProvider.notifier).setStock(null),
                );
              }
              final stock = kFilmStocks[index - 1];
              return _StockChip(
                label: stock.name,
                selected: activeStock?.id == stock.id,
                color: _accentFor(stock.id),
                onTap: () =>
                    ref.read(editStateProvider.notifier).setStock(stock),
              );
            },
          ),
        ),
        if (activeStock != null && enabled) ...[
          const SizedBox(height: 4),
          _IntensityRow(stock: activeStock),
        ],
      ],
    );
  }

  Color _accentFor(String id) => switch (id) {
        'portra_400'     => const Color(0xFFD4A05A),
        'gold_200'       => const Color(0xFFFFBB33),
        'cinestill_800t' => const Color(0xFFFF6633),
        'superia_400'    => const Color(0xFF66BB66),
        'trix_400'       => const Color(0xFF888888),
        _                => const Color(0xFFD4AF37),
      };
}

class _StockChip extends StatelessWidget {
  const _StockChip({
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
  const _IntensityRow({required this.stock});
  final FilmStock stock;

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
            value: stock.intensity.clamp(0.0, 100.0),
            min: 0,
            max: 100,
            onChanged: (v) {
              final updated = stock.copyWith(intensity: v);
              ref.read(editStateProvider.notifier).setStock(updated);
            },
          ),
        ),
        SizedBox(
          width: 42,
          child: Text(
            stock.intensity.toStringAsFixed(0),
            textAlign: TextAlign.right,
            style: Theme.of(context).textTheme.bodySmall,
          ),
        ),
      ],
    );
  }
}
