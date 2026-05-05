import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:gal/gal.dart';
import '../../../core/data/simulation_presets.dart';
import '../../../core/data/film_stocks.dart';
import '../../../core/models/simulation_state.dart';
import '../../../core/providers/simulation_provider.dart';
import '../../../shared/theme/lumen_theme.dart';

class ModSimulation extends ConsumerWidget {
  const ModSimulation({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final sim = ref.watch(simulationProvider);

    return SingleChildScrollView(
      child: Column(
        children: [
          // Camera picker
          _SectionLabel(label: 'CAMERA'),
          _GearStrip(
            items: kSimulationCameras.map((c) => c.shortName).toList(),
            selectedIndex: sim.cameraIndex,
            onSelect: (i) {
              HapticFeedback.selectionClick();
              ref.read(simulationProvider.notifier).selectCamera(i);
            },
          ),

          const SizedBox(height: 8),

          // Lens picker
          _SectionLabel(label: 'LENS'),
          _GearStrip(
            items: kSimulationLenses.map((l) => l.name).toList(),
            selectedIndex: sim.lensIndex,
            onSelect: (i) {
              HapticFeedback.selectionClick();
              ref.read(simulationProvider.notifier).selectLens(i);
            },
          ),

          const SizedBox(height: 8),

          // Film stock picker (first item = "NONE")
          _SectionLabel(label: 'FILM'),
          _GearStrip(
            items: ['NONE', ...kFilmStocks.map((s) => s.name)],
            selectedIndex: sim.stockIndex + 1, // -1 (none) → 0
            onSelect: (i) {
              HapticFeedback.selectionClick();
              ref.read(simulationProvider.notifier).selectStock(i - 1);
            },
          ),

          const SizedBox(height: 14),

          // Result / simulate area
          Padding(
            padding: const EdgeInsets.fromLTRB(20, 0, 20, 0),
            child: sim.status == SimulationStatus.success &&
                    sim.resultPath != null
                ? _ResultView(resultPath: sim.resultPath!)
                : _SimulateArea(sim: sim),
          ),
        ],
      ),
    );
  }
}

// ─────────────────────────────────────────────────────────────────────────────

class _SectionLabel extends StatelessWidget {
  const _SectionLabel({required this.label});
  final String label;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(20, 4, 20, 4),
      child: Align(
        alignment: Alignment.centerLeft,
        child: Text(label,
            style: monoStyle(size: 8, letterSpacing: 2.5, color: kMute)),
      ),
    );
  }
}

// ─────────────────────────────────────────────────────────────────────────────
// GEAR STRIP — compact horizontal pill scroll
// ─────────────────────────────────────────────────────────────────────────────

class _GearStrip extends StatelessWidget {
  const _GearStrip({
    required this.items,
    required this.selectedIndex,
    required this.onSelect,
  });

  final List<String> items;
  final int selectedIndex;
  final ValueChanged<int> onSelect;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 40,
      child: ListView.separated(
        scrollDirection: Axis.horizontal,
        padding: const EdgeInsets.symmetric(horizontal: 20),
        itemCount: items.length,
        separatorBuilder: (context, index) => const SizedBox(width: 8),
        itemBuilder: (context, i) {
          final active = i == selectedIndex;
          return GestureDetector(
            onTap: () => onSelect(i),
            child: AnimatedContainer(
              duration: const Duration(milliseconds: 150),
              padding:
                  const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
              decoration: BoxDecoration(
                color: active
                    ? kAmber.withValues(alpha: 0.10)
                    : Colors.transparent,
                borderRadius: BorderRadius.circular(8),
                border: Border.all(
                  color: active
                      ? kAmber.withValues(alpha: 0.55)
                      : kAmber.withValues(alpha: 0.14),
                  width: 0.5,
                ),
              ),
              child: Text(
                items[i],
                style: monoStyle(
                  size: 10,
                  color: active ? kAmber : kMute,
                  letterSpacing: 1.2,
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}

// ─────────────────────────────────────────────────────────────────────────────
// SIMULATE AREA
// ─────────────────────────────────────────────────────────────────────────────

class _SimulateArea extends ConsumerWidget {
  const _SimulateArea({required this.sim});
  final SimulationState sim;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final isLoading = sim.status == SimulationStatus.loading;
    final hasError = sim.status == SimulationStatus.error;

    return Column(
      children: [
        if (hasError) ...[
          Container(
            width: double.infinity,
            padding: const EdgeInsets.all(10),
            decoration: BoxDecoration(
              color: Colors.red.withValues(alpha: 0.08),
              borderRadius: BorderRadius.circular(6),
              border: Border.all(
                  color: Colors.red.withValues(alpha: 0.30), width: 0.5),
            ),
            child: Text(
              sim.errorMessage ?? 'Unknown error',
              style: monoStyle(
                  size: 8,
                  color: Colors.red.shade300,
                  letterSpacing: 0.5),
              maxLines: 3,
              overflow: TextOverflow.ellipsis,
            ),
          ),
          const SizedBox(height: 10),
        ],

        GestureDetector(
          onTap: isLoading
              ? null
              : () {
                  HapticFeedback.mediumImpact();
                  ref.read(simulationProvider.notifier).simulate();
                },
          child: AnimatedContainer(
            duration: const Duration(milliseconds: 150),
            width: double.infinity,
            padding: const EdgeInsets.symmetric(vertical: 14),
            decoration: BoxDecoration(
              color: isLoading
                  ? kAmber.withValues(alpha: 0.35)
                  : kAmber,
              borderRadius: BorderRadius.circular(8),
            ),
            child: Center(
              child: isLoading
                  ? Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        const SizedBox(
                          width: 14,
                          height: 14,
                          child: CircularProgressIndicator(
                            strokeWidth: 2,
                            color: Color(0xFF1A0F06),
                          ),
                        ),
                        const SizedBox(width: 10),
                        Text(
                          'SIMULATING...',
                          style: monoStyle(
                            size: 10,
                            color: const Color(0xFF1A0F06),
                            letterSpacing: 2.5,
                          ),
                        ),
                      ],
                    )
                  : Text(
                      'SIMULATE',
                      style: monoStyle(
                        size: 11,
                        color: const Color(0xFF1A0F06),
                        letterSpacing: 3,
                      ),
                    ),
            ),
          ),
        ),

        const SizedBox(height: 8),
      ],
    );
  }
}

// ─────────────────────────────────────────────────────────────────────────────
// RESULT VIEW
// ─────────────────────────────────────────────────────────────────────────────

class _ResultView extends ConsumerWidget {
  const _ResultView({required this.resultPath});
  final String resultPath;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Column(
      children: [
        SizedBox(
          height: 220,
          child: ClipRRect(
            borderRadius: BorderRadius.circular(8),
            child: Stack(
              fit: StackFit.expand,
              children: [
                Image.file(File(resultPath), fit: BoxFit.cover),
                Positioned(
                  top: 8,
                  left: 8,
                  child: Container(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 8, vertical: 4),
                    decoration: BoxDecoration(
                      color: kAmber.withValues(alpha: 0.88),
                      borderRadius: BorderRadius.circular(4),
                    ),
                    child: Text(
                      'SIMULATED',
                      style: monoStyle(
                          size: 7,
                          color: const Color(0xFF1A0F06),
                          letterSpacing: 2),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
        const SizedBox(height: 8),
        Row(
          children: [
            Expanded(
              child: GestureDetector(
                onTap: () {
                  HapticFeedback.lightImpact();
                  ref.read(simulationProvider.notifier).dismiss();
                },
                child: Container(
                  padding: const EdgeInsets.symmetric(vertical: 11),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(8),
                    border: Border.all(
                        color: kAmber.withValues(alpha: 0.25), width: 0.5),
                  ),
                  child: Center(
                    child: Text('DISCARD',
                        style:
                            monoStyle(size: 9, color: kMute, letterSpacing: 2)),
                  ),
                ),
              ),
            ),
            const SizedBox(width: 8),
            Expanded(
              flex: 2,
              child: GestureDetector(
                onTap: () => _saveToDevice(context),
                child: Container(
                  padding: const EdgeInsets.symmetric(vertical: 11),
                  decoration: BoxDecoration(
                    color: kAmber,
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Center(
                    child: Text(
                      'SAVE TO LUMEN',
                      style: monoStyle(
                        size: 9,
                        color: const Color(0xFF1A0F06),
                        letterSpacing: 2,
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
        const SizedBox(height: 8),
      ],
    );
  }

  Future<void> _saveToDevice(BuildContext context) async {
    try {
      HapticFeedback.mediumImpact();
      await Gal.putImage(resultPath, album: 'LUMEN');
      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Simulation saved to LUMEN album')),
        );
      }
    } catch (e) {
      if (context.mounted) {
        ScaffoldMessenger.of(context)
            .showSnackBar(SnackBar(content: Text('Save failed: $e')));
      }
    }
  }
}
