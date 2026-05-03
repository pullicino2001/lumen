import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../../../core/services/export_service.dart';
import '../../../shared/theme/lumen_theme.dart';

class ExportSheet extends StatefulWidget {
  const ExportSheet({super.key, required this.onExport});

  /// Called when the user confirms. Sheet is responsible for popping itself.
  final Future<void> Function(ExportFormat format, int jpegQuality) onExport;

  @override
  State<ExportSheet> createState() => _ExportSheetState();
}

class _ExportSheetState extends State<ExportSheet> {
  ExportFormat _format = ExportFormat.jpeg;
  double _quality = 95;
  bool _exporting = false;

  Future<void> _confirm() async {
    setState(() => _exporting = true);
    HapticFeedback.mediumImpact();
    try {
      await widget.onExport(_format, _quality.round());
    } finally {
      if (mounted) setState(() => _exporting = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    final botPad = MediaQuery.paddingOf(context).bottom;
    return Container(
      decoration: BoxDecoration(
        color: kSheet,
        borderRadius: const BorderRadius.vertical(top: Radius.circular(22)),
        border: Border(
          top: BorderSide(color: kAmber.withValues(alpha: 0.16), width: 0.5),
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.6),
            blurRadius: 48,
            offset: const Offset(0, -24),
          ),
        ],
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          // Handle
          Padding(
            padding: const EdgeInsets.fromLTRB(0, 10, 0, 0),
            child: Center(
              child: Container(
                width: 36, height: 4,
                decoration: BoxDecoration(
                  color: kAmber.withValues(alpha: 0.3),
                  borderRadius: BorderRadius.circular(2),
                ),
              ),
            ),
          ),

          // Header
          Padding(
            padding: const EdgeInsets.fromLTRB(22, 18, 22, 0),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text('Action', style: monoStyle(size: 9, letterSpacing: 2.5)),
                    const SizedBox(height: 2),
                    const Text(
                      'Export',
                      style: TextStyle(
                        fontFamily: 'Georgia',
                        fontStyle: FontStyle.italic,
                        fontSize: 26,
                        color: kText,
                        letterSpacing: 0.2,
                      ),
                    ),
                  ],
                ),
                const Spacer(),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    Text('Format', style: monoStyle(size: 9, letterSpacing: 2.5)),
                    const SizedBox(height: 2),
                    Text(
                      _format.label,
                      style: const TextStyle(
                        fontFamily: 'Georgia',
                        fontStyle: FontStyle.italic,
                        fontSize: 22,
                        color: kAmber,
                        letterSpacing: 0,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),

          const SizedBox(height: 24),

          // Format selector
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 22),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('FORMAT', style: monoStyle(size: 8, letterSpacing: 2.5)),
                const SizedBox(height: 10),
                Row(
                  children: ExportFormat.values.map((f) {
                    final active = f == _format;
                    return Expanded(
                      child: Padding(
                        padding: EdgeInsets.only(
                          right: f != ExportFormat.values.last ? 8 : 0,
                        ),
                        child: GestureDetector(
                          onTap: () {
                            HapticFeedback.selectionClick();
                            setState(() => _format = f);
                          },
                          child: AnimatedContainer(
                            duration: const Duration(milliseconds: 150),
                            padding: const EdgeInsets.symmetric(vertical: 10),
                            decoration: BoxDecoration(
                              color: active
                                  ? kAmber.withValues(alpha: 0.08)
                                  : Colors.transparent,
                              borderRadius: BorderRadius.circular(6),
                              border: Border.all(
                                color: active
                                    ? kAmber.withValues(alpha: 0.55)
                                    : kAmber.withValues(alpha: 0.14),
                                width: 0.5,
                              ),
                            ),
                            child: Center(
                              child: Text(
                                f.label,
                                style: monoStyle(
                                  size: 10,
                                  color: active ? kAmber : kMute,
                                  letterSpacing: 1.5,
                                ),
                              ),
                            ),
                          ),
                        ),
                      ),
                    );
                  }).toList(),
                ),
              ],
            ),
          ),

          // Quality section — animated, only visible for JPEG
          AnimatedSize(
            duration: const Duration(milliseconds: 200),
            curve: Curves.easeInOut,
            child: _format == ExportFormat.jpeg
                ? Padding(
                    padding: const EdgeInsets.fromLTRB(22, 24, 22, 0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text('QUALITY',
                                style: monoStyle(size: 8, letterSpacing: 2.5)),
                            Text(
                              _quality.round().toString(),
                              style: monoStyle(
                                  size: 10, color: kAmber, letterSpacing: 1),
                            ),
                          ],
                        ),
                        const SizedBox(height: 6),
                        SliderTheme(
                          data: SliderThemeData(
                            trackHeight: 2,
                            activeTrackColor: kAmber,
                            inactiveTrackColor: kAmber.withValues(alpha: 0.15),
                            thumbColor: kAmber,
                            thumbShape: const RoundSliderThumbShape(
                                enabledThumbRadius: 6),
                            overlayShape: SliderComponentShape.noOverlay,
                          ),
                          child: Slider(
                            value: _quality,
                            min: 50,
                            max: 100,
                            onChanged: (v) => setState(() => _quality = v),
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 4),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text('50',
                                  style: monoStyle(size: 8, letterSpacing: 1)),
                              Text('100',
                                  style: monoStyle(size: 8, letterSpacing: 1)),
                            ],
                          ),
                        ),
                      ],
                    ),
                  )
                : const SizedBox.shrink(),
          ),

          const SizedBox(height: 28),

          // Save button
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 22),
            child: GestureDetector(
              onTap: _exporting ? null : _confirm,
              child: AnimatedContainer(
                duration: const Duration(milliseconds: 150),
                padding: const EdgeInsets.symmetric(vertical: 16),
                decoration: BoxDecoration(
                  color: _exporting
                      ? kAmber.withValues(alpha: 0.4)
                      : kAmber,
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Center(
                  child: _exporting
                      ? const SizedBox(
                          width: 18, height: 18,
                          child: CircularProgressIndicator(
                            strokeWidth: 2,
                            color: Color(0xFF1A0F06),
                          ),
                        )
                      : Text(
                          'SAVE TO LUMEN',
                          style: monoStyle(
                            size: 11,
                            color: const Color(0xFF1A0F06),
                            letterSpacing: 3,
                          ),
                        ),
                ),
              ),
            ),
          ),

          SizedBox(height: botPad + 20),
        ],
      ),
    );
  }
}
