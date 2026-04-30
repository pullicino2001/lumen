import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../core/data/film_stocks.dart';
import '../../../core/models/film_stock.dart';
import '../../../core/models/import_profile.dart';
import '../../../core/providers/edit_state_provider.dart';
import '../../../shared/theme/lumen_theme.dart';
import 'chromatic_slider.dart';

class ModLook extends ConsumerWidget {
  const ModLook({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final activeStock = ref.watch(
      editStateProvider.select((s) => s?.filmStock),
    );

    final stocks = [null, ...kFilmStocks];
    final selIndex = activeStock == null
        ? 0
        : stocks.indexWhere((s) => s?.id == activeStock.id);

    void selectStock(int i) {
      final stock = stocks[i];
      ref.read(editStateProvider.notifier).setStock(stock);
    }

    return Column(
      children: [
        const _LumenLookToggle(),
        _FilmstripPicker(
          stocks: stocks,
          selectedIndex: selIndex,
          onSelect: selectStock,
        ),
        const SizedBox(height: 14),
        Expanded(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 24),
            child: Column(
              children: [
                _FilmstockCard(stock: activeStock, frameIndex: selIndex),
                const SizedBox(height: 14),
                ChromaticSlider(
                  label: 'Intensity',
                  value: activeStock?.intensity ?? 0,
                  min: 0,
                  max: 100,
                  displayValue: activeStock != null
                      ? activeStock.intensity.toStringAsFixed(0)
                      : '—',
                  onChanged: activeStock == null
                      ? (_) {}
                      : (v) {
                          ref
                              .read(editStateProvider.notifier)
                              .setStock(activeStock.copyWith(intensity: v));
                        },
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }
}

class _LumenLookToggle extends ConsumerWidget {
  const _LumenLookToggle();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final isLumen = ref.watch(
      editStateProvider.select((s) => s?.importProfile == ImportProfile.lumen),
    );

    return GestureDetector(
      onTap: () => ref.read(editStateProvider.notifier).toggleLumenLook(),
      child: Padding(
        padding: const EdgeInsets.fromLTRB(16, 10, 16, 8),
        child: Row(
          children: [
            AnimatedContainer(
              duration: const Duration(milliseconds: 200),
              width: 36,
              height: 20,
              decoration: BoxDecoration(
                color: isLumen ? kAmberSoft : Colors.transparent,
                borderRadius: BorderRadius.circular(10),
                border: Border.all(
                  color: isLumen ? kAmber : kMute,
                  width: 1,
                ),
                boxShadow: isLumen
                    ? [BoxShadow(color: kAmber.withValues(alpha: 0.35), blurRadius: 8)]
                    : null,
              ),
              child: AnimatedAlign(
                duration: const Duration(milliseconds: 200),
                alignment: isLumen ? Alignment.centerRight : Alignment.centerLeft,
                child: Padding(
                  padding: const EdgeInsets.all(2),
                  child: Container(
                    width: 14,
                    height: 14,
                    decoration: BoxDecoration(
                      color: isLumen ? kAmber : kMute,
                      shape: BoxShape.circle,
                    ),
                  ),
                ),
              ),
            ),
            const SizedBox(width: 12),
            Text(
              'LUMEN LOOK',
              style: monoStyle(
                size: 10,
                color: isLumen ? kAmber : kMute,
                letterSpacing: 2.5,
              ),
            ),
            const Spacer(),
            Text(
              isLumen ? 'ON' : 'OFF',
              style: monoStyle(
                size: 9,
                color: isLumen ? kAmber : kMute,
                letterSpacing: 1.5,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _FilmstripPicker extends StatelessWidget {
  const _FilmstripPicker({
    required this.stocks,
    required this.selectedIndex,
    required this.onSelect,
  });

  final List<FilmStock?> stocks;
  final int selectedIndex;
  final ValueChanged<int> onSelect;

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.black,
      child: Stack(
        children: [
          Column(
            children: [
              _SprocketRow(),
              SizedBox(
                height: 80,
                child: ListView.separated(
                  scrollDirection: Axis.horizontal,
                  padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                  itemCount: stocks.length,
                  separatorBuilder: (_, x) => const SizedBox(width: 4),
                  itemBuilder: (context, i) {
                    final stock = stocks[i];
                    final active = i == selectedIndex;
                    return _FilmFrame(
                      stock: stock,
                      index: i,
                      active: active,
                      onTap: () => onSelect(i),
                    );
                  },
                ),
              ),
              _SprocketRow(),
            ],
          ),
          Positioned.fill(
            child: IgnorePointer(
              child: DecoratedBox(
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    colors: [Colors.black, Colors.transparent, Colors.transparent, Colors.black],
                    stops: const [0, 0.12, 0.88, 1],
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _SprocketRow extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 8,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: List.generate(22, (i) => Container(
          width: 10,
          height: 6,
          decoration: BoxDecoration(
            color: const Color(0xFF1A1611),
            borderRadius: BorderRadius.circular(1),
          ),
        )),
      ),
    );
  }
}

class _FilmFrame extends StatelessWidget {
  const _FilmFrame({
    required this.stock,
    required this.index,
    required this.active,
    required this.onTap,
  });

  final FilmStock? stock;
  final int index;
  final bool active;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final gradient = stock == null
        ? const LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [Color(0xFF2A2A2A), Color(0xFF080808)],
          )
        : LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: _colorsForStock(stock!.id),
          );

    return GestureDetector(
      onTap: onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 150),
        width: 52,
        decoration: BoxDecoration(
          border: Border.all(
            color: active ? kAmber : Colors.white.withValues(alpha: 0.08),
            width: active ? 1.5 : 0.5,
          ),
          borderRadius: BorderRadius.circular(1),
          boxShadow: active ? [BoxShadow(color: kAmber.withValues(alpha: 0.55), blurRadius: 16)] : null,
        ),
        child: Stack(
          children: [
            Positioned.fill(
              child: DecoratedBox(
                decoration: BoxDecoration(gradient: gradient),
              ),
            ),
            if (active) ...[
              Positioned.fill(
                child: DecoratedBox(
                  decoration: BoxDecoration(
                    gradient: gradient,
                    backgroundBlendMode: BlendMode.screen,
                  ),
                ),
              ),
            ],
            Positioned(
              top: 3,
              left: 4,
              child: Text(
                index.toString().padLeft(2, '0'),
                style: monoStyle(
                  size: 6,
                  color: active ? kAmber : Colors.white.withValues(alpha: 0.4),
                  letterSpacing: 0.5,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  List<Color> _colorsForStock(String id) => switch (id) {
        'portra_400'     => [const Color(0xFFE0A26F), const Color(0xFF4E1E10)],
        'gold_200'       => [const Color(0xFFD98B3C), const Color(0xFF2A1008)],
        'cinestill_800t' => [const Color(0xFF7AA6C4), const Color(0xFF1A2A3A)],
        'superia_400'    => [const Color(0xFF80A870), const Color(0xFF1A2A1A)],
        'trix_400'       => [const Color(0xFFD0D0D0), const Color(0xFF101010)],
        _                => [const Color(0xFF888888), const Color(0xFF181818)],
      };
}

class _FilmstockCard extends StatelessWidget {
  const _FilmstockCard({required this.stock, required this.frameIndex});

  final FilmStock? stock;
  final int frameIndex;

  @override
  Widget build(BuildContext context) {
    final name = stock?.name ?? 'None';
    final code = _codeForStock(stock?.id);
    final iso = _isoForStock(stock?.id);
    final desc = stock?.description ?? 'Camera-original tones, no processing.';
    final barColors = _barForStock(stock?.id);

    return Container(
      decoration: BoxDecoration(
        color: const Color(0xFF0D0A07),
        border: Border.all(color: kAmber, width: 1),
        borderRadius: BorderRadius.circular(4),
        boxShadow: [BoxShadow(color: kAmber.withValues(alpha: 0.25), blurRadius: 28)],
      ),
      padding: const EdgeInsets.fromLTRB(16, 14, 16, 12),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text('LUMEN · $code',
                        style: monoStyle(size: 8, color: kAmber, letterSpacing: 2.5)),
                    const SizedBox(height: 6),
                    Text(name,
                        style: displayStyle(size: 32, letterSpacing: -0.3, color: kText)),
                  ],
                ),
              ),
              Column(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  Text('ISO · DIN',
                      style: monoStyle(size: 7, letterSpacing: 1.5)),
                  const SizedBox(height: 4),
                  Text(iso,
                      style: monoStyle(size: 20, color: kText, letterSpacing: 1)),
                ],
              ),
            ],
          ),
          const SizedBox(height: 10),
          Text(desc,
              style: sansStyle(size: 11, color: kMute),
              maxLines: 2,
              overflow: TextOverflow.ellipsis),
          const SizedBox(height: 12),
          ClipRRect(
            borderRadius: BorderRadius.circular(1),
            child: SizedBox(
              height: 12,
              child: Row(
                children: barColors
                    .map((c) => Expanded(child: ColoredBox(color: c)))
                    .toList(),
              ),
            ),
          ),
          const SizedBox(height: 8),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text('Frame ${frameIndex.toString().padLeft(2, '0')} · Selected',
                  style: monoStyle(size: 8, letterSpacing: 2)),
              Text('γ 2.2', style: monoStyle(size: 8, letterSpacing: 2)),
            ],
          ),
        ],
      ),
    );
  }

  String _codeForStock(String? id) => switch (id) {
        'portra_400'     => 'PT-160',
        'gold_200'       => 'GD-200',
        'cinestill_800t' => 'CS-800',
        'superia_400'    => 'SP-400',
        'trix_400'       => 'TX-400',
        _                => 'ST-000',
      };

  String _isoForStock(String? id) => switch (id) {
        'portra_400'     => '160',
        'gold_200'       => '200',
        'cinestill_800t' => '800',
        'superia_400'    => '400',
        'trix_400'       => '400',
        _                => '—',
      };

  List<Color> _barForStock(String? id) => switch (id) {
        'portra_400'     => [const Color(0xFFF2C8A6), const Color(0xFFD98D63), const Color(0xFF8A3D20), const Color(0xFF2A130A)],
        'gold_200'       => [const Color(0xFFFFD080), const Color(0xFFD98B3C), const Color(0xFF7A3A10), const Color(0xFF1A0804)],
        'cinestill_800t' => [const Color(0xFFD8E5EC), const Color(0xFF8FAEC4), const Color(0xFF42607A), const Color(0xFF12243A)],
        'superia_400'    => [const Color(0xFFC8E0B8), const Color(0xFF7AAA68), const Color(0xFF3A5A28), const Color(0xFF0A1A08)],
        'trix_400'       => [const Color(0xFFD0D0D0), const Color(0xFF7A7A7A), const Color(0xFF2A2A2A), const Color(0xFF060606)],
        _                => [const Color(0xFF8A6A48), const Color(0xFF5A4028), const Color(0xFF2A1A10), const Color(0xFF0A0604)],
      };
}
