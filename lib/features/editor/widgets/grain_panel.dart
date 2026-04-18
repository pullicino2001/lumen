import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../core/models/edit_state.dart';
import '../../../core/models/grain_settings.dart';
import '../../../core/providers/edit_state_provider.dart';

class GrainPanel extends ConsumerWidget {
  const GrainPanel({super.key, required this.editState});
  final EditState editState;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final s = editState.grain;
    final enabled = editState.grainEnabled;

    void update(GrainSettings updated) =>
        ref.read(editStateProvider.notifier).updateGrain(updated);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Text('Grain', style: Theme.of(context).textTheme.titleSmall),
            const Spacer(),
            Switch(
              value: enabled,
              onChanged: (_) =>
                  ref.read(editStateProvider.notifier).toggleGrain(),
            ),
          ],
        ),
        if (enabled) ...[
          Row(
            children: [
              SizedBox(
                width: 90,
                child: Text('Intensity',
                    style: Theme.of(context).textTheme.bodySmall),
              ),
              Expanded(
                child: Slider(
                  value: s.intensity.clamp(0.0, 100.0),
                  min: 0,
                  max: 100,
                  onChanged: (v) => update(s.copyWith(intensity: v)),
                ),
              ),
              SizedBox(
                width: 42,
                child: Text(
                  s.intensity.toStringAsFixed(0),
                  textAlign: TextAlign.right,
                  style: Theme.of(context).textTheme.bodySmall,
                ),
              ),
            ],
          ),
          _ChipRow<GrainSize>(
            label: 'Size',
            values: GrainSize.values,
            selected: s.size,
            labelFor: (v) => switch (v) {
              GrainSize.fine   => 'Fine',
              GrainSize.medium => 'Medium',
              GrainSize.coarse => 'Coarse',
            },
            onSelected: (v) => update(s.copyWith(size: v)),
          ),
          _ChipRow<GrainType>(
            label: 'Type',
            values: GrainType.values,
            selected: s.type,
            labelFor: (v) => switch (v) {
              GrainType.luminance => 'Luma',
              GrainType.colour    => 'Colour',
            },
            onSelected: (v) => update(s.copyWith(type: v)),
          ),
        ],
      ],
    );
  }
}

class _ChipRow<T> extends StatelessWidget {
  const _ChipRow({
    required this.label,
    required this.values,
    required this.selected,
    required this.labelFor,
    required this.onSelected,
  });

  final String label;
  final List<T> values;
  final T selected;
  final String Function(T) labelFor;
  final void Function(T) onSelected;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        children: [
          SizedBox(
            width: 90,
            child: Text(label, style: Theme.of(context).textTheme.bodySmall),
          ),
          Wrap(
            spacing: 6,
            children: values.map((v) {
              final isSelected = v == selected;
              return ChoiceChip(
                label: Text(labelFor(v)),
                selected: isSelected,
                onSelected: (_) => onSelected(v),
                labelStyle: Theme.of(context).textTheme.labelSmall,
                padding: const EdgeInsets.symmetric(horizontal: 4),
                visualDensity: VisualDensity.compact,
              );
            }).toList(),
          ),
        ],
      ),
    );
  }
}
