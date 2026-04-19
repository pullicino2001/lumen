import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../core/models/bloom_settings.dart';
import '../../../core/models/edit_state.dart';
import '../../../core/providers/edit_state_provider.dart';

class BloomPanel extends ConsumerWidget {
  const BloomPanel({super.key, required this.editState});
  final EditState editState;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final s       = editState.bloom;
    final enabled = editState.bloomEnabled;

    void update(BloomSettings v) =>
        ref.read(editStateProvider.notifier).updateBloom(v);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Text('Bloom & Halation',
                style: Theme.of(context).textTheme.titleSmall),
            const Spacer(),
            Switch(
              value: enabled,
              onChanged: (_) =>
                  ref.read(editStateProvider.notifier).toggleBloom(),
            ),
          ],
        ),
        if (enabled) ...[
          _row(context, 'Bloom',     s.bloomIntensity,        0, 100,
              (v) => update(s.copyWith(bloomIntensity:  v))),
          _row(context, 'Radius',    s.bloomRadius * 100,     0, 100,
              (v) => update(s.copyWith(bloomRadius:     v / 100))),
          _row(context, 'Threshold', s.bloomThreshold * 100,  0, 100,
              (v) => update(s.copyWith(bloomThreshold:  v / 100))),
          const Padding(
            padding: EdgeInsets.symmetric(vertical: 6),
            child: Divider(height: 1),
          ),
          _row(context, 'Halation',  s.halationIntensity,     0, 100,
              (v) => update(s.copyWith(halationIntensity: v))),
          _row(context, 'Warmth',    s.halationWarmth * 100,  0, 100,
              (v) => update(s.copyWith(halationWarmth:  v / 100))),
          _row(context, 'Spread',    s.halationSpread * 100,  0, 100,
              (v) => update(s.copyWith(halationSpread:  v / 100))),
        ],
      ],
    );
  }

  Widget _row(
    BuildContext context,
    String label,
    double value,
    double min,
    double max,
    ValueChanged<double> onChanged,
  ) {
    return Row(
      children: [
        SizedBox(
          width: 90,
          child: Text(label, style: Theme.of(context).textTheme.bodySmall),
        ),
        Expanded(
          child: Slider(
            value: value.clamp(min, max),
            min: min,
            max: max,
            onChanged: onChanged,
          ),
        ),
        SizedBox(
          width: 42,
          child: Text(
            value.toStringAsFixed(0),
            textAlign: TextAlign.right,
            style: Theme.of(context).textTheme.bodySmall,
          ),
        ),
      ],
    );
  }
}
