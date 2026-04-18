import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../core/models/basic_editor_settings.dart';
import '../../../core/models/edit_state.dart';
import '../../../core/providers/edit_state_provider.dart';
import '../../../core/constants.dart';

/// Displays sliders for all basic editor parameters.
class BasicEditorPanel extends ConsumerWidget {
  const BasicEditorPanel({super.key, required this.editState});

  final EditState editState;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final s = editState.basicEditor;

    void update(BasicEditorSettings updated) =>
        ref.read(editStateProvider.notifier).updateBasicEditor(updated);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Text(
              'Basic',
              style: Theme.of(context).textTheme.titleSmall,
            ),
            const Spacer(),
            Switch(
              value: editState.basicEditorEnabled,
              onChanged: (_) =>
                  ref.read(editStateProvider.notifier).toggleBasicEditor(),
            ),
          ],
        ),
        if (editState.basicEditorEnabled) ...[
          _Slider(
            label: 'Exposure',
            value: s.exposure,
            min: kExposureMin,
            max: kExposureMax,
            onChanged: (v) => update(s.copyWith(exposure: v)),
          ),
          _Slider(
            label: 'Contrast',
            value: s.contrast,
            min: kAdjustmentMin,
            max: kAdjustmentMax,
            onChanged: (v) => update(s.copyWith(contrast: v)),
          ),
          _Slider(
            label: 'Highlights',
            value: s.highlights,
            min: kAdjustmentMin,
            max: kAdjustmentMax,
            onChanged: (v) => update(s.copyWith(highlights: v)),
          ),
          _Slider(
            label: 'Shadows',
            value: s.shadows,
            min: kAdjustmentMin,
            max: kAdjustmentMax,
            onChanged: (v) => update(s.copyWith(shadows: v)),
          ),
          _Slider(
            label: 'Whites',
            value: s.whites,
            min: kAdjustmentMin,
            max: kAdjustmentMax,
            onChanged: (v) => update(s.copyWith(whites: v)),
          ),
          _Slider(
            label: 'Blacks',
            value: s.blacks,
            min: kAdjustmentMin,
            max: kAdjustmentMax,
            onChanged: (v) => update(s.copyWith(blacks: v)),
          ),
          _Slider(
            label: 'Temperature',
            value: s.temperature,
            min: kTemperatureMin,
            max: kTemperatureMax,
            onChanged: (v) => update(s.copyWith(temperature: v)),
          ),
          _Slider(
            label: 'Tint',
            value: s.tint,
            min: kTintMin,
            max: kTintMax,
            onChanged: (v) => update(s.copyWith(tint: v)),
          ),
          _Slider(
            label: 'Clarity',
            value: s.clarity,
            min: kAdjustmentMin,
            max: kAdjustmentMax,
            onChanged: (v) => update(s.copyWith(clarity: v)),
          ),
          _Slider(
            label: 'Saturation',
            value: s.saturation,
            min: kAdjustmentMin,
            max: kAdjustmentMax,
            onChanged: (v) => update(s.copyWith(saturation: v)),
          ),
          _Slider(
            label: 'Vibrance',
            value: s.vibrance,
            min: kAdjustmentMin,
            max: kAdjustmentMax,
            onChanged: (v) => update(s.copyWith(vibrance: v)),
          ),
        ],
      ],
    );
  }
}

/// A labelled slider row with a numeric readout.
class _Slider extends StatelessWidget {
  const _Slider({
    required this.label,
    required this.value,
    required this.min,
    required this.max,
    required this.onChanged,
  });

  final String label;
  final double value;
  final double min;
  final double max;
  final ValueChanged<double> onChanged;

  @override
  Widget build(BuildContext context) {
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
            value.toStringAsFixed(1),
            textAlign: TextAlign.right,
            style: Theme.of(context).textTheme.bodySmall?.copyWith(
                  fontFeatures: const [FontFeature.tabularFigures()],
                ),
          ),
        ),
      ],
    );
  }
}
