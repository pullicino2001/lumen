import 'dart:math' as math;
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../core/models/basic_editor_settings.dart';
import '../../../core/providers/edit_state_provider.dart';
import '../../../core/constants.dart';
import '../../../shared/theme/lumen_theme.dart';

enum _ToneParam {
  exposure, contrast, highlights, shadows, whites, blacks, temperature, tint, saturation,
}

extension _ToneParamExt on _ToneParam {
  String get label => switch (this) {
    _ToneParam.exposure    => 'EXP',
    _ToneParam.contrast    => 'CON',
    _ToneParam.highlights  => 'HIGH',
    _ToneParam.shadows     => 'SHAD',
    _ToneParam.whites      => 'WHT',
    _ToneParam.blacks      => 'BLK',
    _ToneParam.temperature => 'TEMP',
    _ToneParam.tint        => 'TINT',
    _ToneParam.saturation  => 'SAT',
  };

  double get minVal => switch (this) {
    _ToneParam.exposure    => kExposureMin,
    _ToneParam.temperature => kTemperatureMin,
    _ToneParam.tint        => kTintMin,
    _                      => kAdjustmentMin,
  };

  double get maxVal => switch (this) {
    _ToneParam.exposure    => kExposureMax,
    _ToneParam.temperature => kTemperatureMax,
    _ToneParam.tint        => kTintMax,
    _                      => kAdjustmentMax,
  };

  double get defaultVal => switch (this) {
    _ToneParam.temperature => kDefaultTemperature,
    _                      => 0.0,
  };

  double getValue(BasicEditorSettings s) => switch (this) {
    _ToneParam.exposure    => s.exposure,
    _ToneParam.contrast    => s.contrast,
    _ToneParam.highlights  => s.highlights,
    _ToneParam.shadows     => s.shadows,
    _ToneParam.whites      => s.whites,
    _ToneParam.blacks      => s.blacks,
    _ToneParam.temperature => s.temperature,
    _ToneParam.tint        => s.tint,
    _ToneParam.saturation  => s.saturation,
  };

  BasicEditorSettings setValue(BasicEditorSettings s, double v) => switch (this) {
    _ToneParam.exposure    => s.copyWith(exposure: v),
    _ToneParam.contrast    => s.copyWith(contrast: v),
    _ToneParam.highlights  => s.copyWith(highlights: v),
    _ToneParam.shadows     => s.copyWith(shadows: v),
    _ToneParam.whites      => s.copyWith(whites: v),
    _ToneParam.blacks      => s.copyWith(blacks: v),
    _ToneParam.temperature => s.copyWith(temperature: v),
    _ToneParam.tint        => s.copyWith(tint: v),
    _ToneParam.saturation  => s.copyWith(saturation: v),
  };
}

class ModTone extends ConsumerStatefulWidget {
  const ModTone({super.key});

  @override
  ConsumerState<ModTone> createState() => _ModToneState();
}

class _ModToneState extends ConsumerState<ModTone>
    with SingleTickerProviderStateMixin {
  _ToneParam _active = _ToneParam.highlights;
  double _verticalDragAccum = 0;
  late AnimationController _expandAnim;

  double get _precisionFactor =>
      1.0 / (1.0 + (_verticalDragAccum.clamp(0.0, 240.0) / 60.0));

  @override
  void initState() {
    super.initState();
    _expandAnim = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 180),
    )..addListener(() => setState(() {}));
  }

  @override
  void dispose() {
    _expandAnim.dispose();
    super.dispose();
  }

  void _onPanStart(DragStartDetails _) {
    _expandAnim.animateTo(1.0, curve: Curves.easeOut);
  }

  void _onPanUpdate(DragUpdateDetails d, double minVal, double maxVal) {
    bool needsRebuild = false;

    final upDelta = -d.delta.dy;
    if (upDelta != 0) {
      final next = (_verticalDragAccum + upDelta).clamp(0.0, 240.0);
      if (next != _verticalDragAccum) {
        _verticalDragAccum = next;
        needsRebuild = true;
      }
    }

    final dx = d.delta.dx;
    if (dx != 0) {
      final range = maxVal - minVal;
      // Expanded dial reduces sensitivity → finer control while dragging.
      final expandFactor = 1.0 - _expandAnim.value * 0.45;
      final valueDelta = dx / 160.0 * range * _precisionFactor * expandFactor;
      final s = ref.read(editStateProvider)?.basicEditor;
      if (s != null) {
        final cur = _active.getValue(s);
        final nv = (cur + valueDelta).clamp(minVal, maxVal);
        ref.read(editStateProvider.notifier).updateBasicEditor(_active.setValue(s, nv));
      }
    }

    if (needsRebuild) setState(() {});
  }

  void _onPanEnd(DragEndDetails _) {
    _expandAnim.animateTo(0.0, curve: Curves.easeIn);
    if (_verticalDragAccum != 0) setState(() => _verticalDragAccum = 0);
  }

  void _resetActive() {
    final s = ref.read(editStateProvider)?.basicEditor;
    if (s == null) return;
    HapticFeedback.mediumImpact();
    ref.read(editStateProvider.notifier)
        .updateBasicEditor(_active.setValue(s, _active.defaultVal));
  }

  @override
  Widget build(BuildContext context) {
    final settings = ref.watch(
      editStateProvider.select((st) => st?.basicEditor ?? const BasicEditorSettings()),
    );

    final val    = _active.getValue(settings);
    final minVal = _active.minVal;
    final maxVal = _active.maxVal;
    final pct    = ((val - minVal) / (maxVal - minVal)).clamp(0.0, 1.0);
    final zeroPct = ((0.0 - minVal) / (maxVal - minVal)).clamp(0.0, 1.0);

    final displayVal = _active == _ToneParam.temperature
        ? '${val.round()}K'
        : val.toStringAsFixed(val.abs() < 10 ? 1 : 0);

    return Column(
      children: [
        Expanded(
          child: GestureDetector(
            onPanStart: _onPanStart,
            onPanUpdate: (d) => _onPanUpdate(d, minVal, maxVal),
            onPanEnd: _onPanEnd,
            onDoubleTap: _resetActive,
            child: Center(
              child: RepaintBoundary(
                child: CustomPaint(
                  painter: _DialPainter(
                    pct: pct,
                    zeroPct: zeroPct,
                    paramLabel: _active.label,
                    displayValue: displayVal,
                    precisionFactor: _precisionFactor,
                    dragExpand: _expandAnim.value,
                  ),
                  size: const Size(240, 200),
                ),
              ),
            ),
          ),
        ),
        _ParamWheel(
          params: _ToneParam.values,
          active: _active,
          onSelect: (p) => setState(() {
            _active = p;
            _verticalDragAccum = 0;
          }),
        ),
        const SizedBox(height: 8),
      ],
    );
  }
}

class _DialPainter extends CustomPainter {
  const _DialPainter({
    required this.pct,
    required this.zeroPct,
    required this.paramLabel,
    required this.displayValue,
    this.precisionFactor = 1.0,
    this.dragExpand = 0.0,
  });

  final double pct;
  final double zeroPct;
  final String paramLabel;
  final String displayValue;
  final double precisionFactor;
  // 0.0 = idle, 1.0 = actively dragging — drives ring/tick/thumb expansion.
  final double dragExpand;

  static const double startDeg = -210;
  static const double endDeg   =   30;
  static const double span     = endDeg - startDeg;
  static const double dcx      = 120;
  static const double dcy      = 110;

  double get _dR =>
      92.0
      + (1.0 - precisionFactor.clamp(0.0, 1.0)) * 10.0
      + dragExpand * 16.0;

  @override
  void paint(Canvas canvas, Size size) {
    final dR = _dR;

    Offset toXY(double deg, {double? r}) {
      final rad = deg * math.pi / 180;
      final radius = r ?? dR;
      return Offset(dcx + radius * math.cos(rad), dcy + radius * math.sin(rad));
    }

    final angle    = startDeg + span * pct;
    final zeroAngle = startDeg + span * zeroPct;
    final pt       = toXY(angle);

    // Outer ring — glows brighter while dragging.
    canvas.drawCircle(
      const Offset(dcx, dcy),
      dR + 6,
      Paint()
        ..color = kText.withValues(alpha: 0.22 + dragExpand * 0.55)
        ..style = PaintingStyle.stroke
        ..strokeWidth = 0.5 + dragExpand * 0.8,
    );

    // Ticks: count stays fixed during drag-expand so gaps grow with the ring.
    // Vertical-precision mode (upward swipe) doubles the count for density.
    final tickCount = 49 + ((1.0 - precisionFactor.clamp(0.0, 1.0)) * 48).round();
    final majorPeriod = tickCount > 49 ? 16 : 12;
    for (int i = 0; i < tickCount; i++) {
      final tickDeg = startDeg + span * (i / (tickCount - 1));
      final isMajor = i % majorPeriod == 0;
      final frac = i / (tickCount - 1);
      final inArc = zeroPct <= pct
          ? frac >= zeroPct && frac <= pct
          : frac <= zeroPct && frac >= pct;
      // Ticks grow taller while dragging to emphasise the expanded ring.
      final majorLen = 11.0 + dragExpand * 5.0;
      final minorLen =  7.0 + dragExpand * 3.0;
      final r1 = dR - (isMajor ? majorLen : minorLen);
      canvas.drawLine(
        toXY(tickDeg, r: r1),
        toXY(tickDeg, r: dR - 2),
        Paint()
          ..color = inArc ? kAmber : kText.withValues(alpha: 0.28)
          ..strokeWidth = isMajor ? 1.2 : 0.7,
      );
    }

    // Zero marker.
    canvas.drawLine(
      toXY(zeroAngle, r: dR - 2),
      toXY(zeroAngle, r: dR + 8),
      Paint()..color = kText.withValues(alpha: 0.75)..strokeWidth = 1.2,
    );

    // Active arc.
    final arcRect = Rect.fromCircle(center: const Offset(dcx, dcy), radius: dR - 5);
    canvas.drawArc(
      arcRect,
      zeroAngle * math.pi / 180,
      (angle - zeroAngle) * math.pi / 180,
      false,
      Paint()
        ..color = kAmber
        ..style = PaintingStyle.stroke
        ..strokeWidth = 2.5
        ..strokeCap = StrokeCap.round,
    );

    // Chromatic pointer — expands while dragging.
    final thumbR  = 6.5 + dragExpand * 3.0;
    final chromaR = thumbR - 0.5;
    canvas.drawCircle(pt.translate(-1.5, 0), chromaR, Paint()..color = kRed.withValues(alpha: 0.55));
    canvas.drawCircle(pt.translate(1.5, 0),  chromaR, Paint()..color = kTeal.withValues(alpha: 0.55));
    canvas.drawCircle(pt, thumbR,       Paint()..color = kAmber);
    canvas.drawCircle(pt, thumbR * 2.0, Paint()..color = kAmber.withValues(alpha: 0.14));

    // Param label.
    _text(canvas, paramLabel,
        monoStyle(size: 8, color: kMute, letterSpacing: 3),
        const Offset(dcx, dcy - 14));

    // Value readout.
    final valuePainter = TextPainter(
      text: TextSpan(
        text: displayValue,
        style: const TextStyle(
          fontFamily: 'Georgia', fontStyle: FontStyle.italic,
          fontSize: 42, color: kText, letterSpacing: -1,
        ),
      ),
      textDirection: TextDirection.ltr,
    )..layout();
    valuePainter.paint(canvas, Offset(dcx - valuePainter.width / 2, dcy + 2));

    // Precision badge — shown when swipe-up is active.
    if (precisionFactor < 0.95) {
      final mult = (1.0 / precisionFactor).round();
      _text(canvas, '×$mult  FINE',
          monoStyle(size: 7, color: kAmber, letterSpacing: 1.5),
          Offset(dcx, dcy + 54));
    }
  }

  void _text(Canvas canvas, String text, TextStyle style, Offset center) {
    final painter = TextPainter(
      text: TextSpan(text: text, style: style),
      textDirection: TextDirection.ltr,
    )..layout();
    painter.paint(canvas, center.translate(-painter.width / 2, -painter.height / 2));
  }

  @override
  bool shouldRepaint(_DialPainter old) =>
      old.pct != pct ||
      old.paramLabel != paramLabel ||
      old.displayValue != displayValue ||
      old.precisionFactor != precisionFactor ||
      old.dragExpand != dragExpand;
}

class _ParamWheel extends StatelessWidget {
  const _ParamWheel({
    required this.params,
    required this.active,
    required this.onSelect,
  });

  final List<_ToneParam> params;
  final _ToneParam active;
  final ValueChanged<_ToneParam> onSelect;

  @override
  Widget build(BuildContext context) {
    final activeIdx = params.indexOf(active);
    return ShaderMask(
      shaderCallback: (bounds) => const LinearGradient(
        colors: [Colors.transparent, Colors.black, Colors.black, Colors.transparent],
        stops: [0, 0.18, 0.82, 1],
      ).createShader(bounds),
      blendMode: BlendMode.dstIn,
      child: SizedBox(
        height: 36,
        child: ListView.builder(
          scrollDirection: Axis.horizontal,
          padding: const EdgeInsets.symmetric(horizontal: 48),
          itemCount: params.length,
          itemBuilder: (context, i) {
            final p = params[i];
            final d = (i - activeIdx).abs();
            final isActive = p == active;
            return GestureDetector(
              onTap: () => onSelect(p),
              child: Container(
                padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                alignment: Alignment.center,
                decoration: BoxDecoration(
                  border: isActive
                      ? const Border(bottom: BorderSide(color: kAmber, width: 1))
                      : null,
                ),
                child: Text(
                  p.label,
                  style: monoStyle(
                    size: 11,
                    color: isActive
                        ? kAmber
                        : kMute.withValues(alpha: math.max(0.28, 1 - d * 0.22)),
                    letterSpacing: 1.6,
                  ),
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}
