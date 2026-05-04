import 'dart:math' as math;
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../core/models/basic_editor_settings.dart';
import '../../../core/providers/edit_state_provider.dart';
import '../../../core/constants.dart';
import '../../../shared/theme/lumen_theme.dart';

// Shared between gesture handler and painter.
const double _kDialStartDeg = -210;
const double _kDialSpan     =  240;

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

class _ModToneState extends ConsumerState<ModTone> {
  _ToneParam _active      = _ToneParam.highlights;
  final      _areaKey     = GlobalKey();
  double?    _lastHapticPct;   // tracks which tick last fired a click

  // Fire a selection click each time the thumb crosses a tick mark (1 per graduation).
  // Fire a medium impact when the value hits a hard limit.
  void _maybeHaptic(double pct, bool hitLimit) {
    if (hitLimit) {
      if (_lastHapticPct != pct) {
        HapticFeedback.mediumImpact();
        _lastHapticPct = pct;
      }
      return;
    }
    const ticks = 48.0; // matches 49 drawn ticks (48 gaps)
    final tickNow  = (pct * ticks).floor();
    final tickLast = ((_lastHapticPct ?? -1.0) * ticks).floor();
    if (tickNow != tickLast) {
      HapticFeedback.selectionClick();
      _lastHapticPct = pct;
    }
  }

  void _onPanStart(DragStartDetails _) {
    final s = ref.read(editStateProvider)?.basicEditor;
    if (s == null) return;
    final cur = _active.getValue(s);
    _lastHapticPct = ((cur - _active.minVal) / (_active.maxVal - _active.minVal)).clamp(0.0, 1.0);
  }

  void _onPanUpdate(DragUpdateDetails d) {
    final box = _areaKey.currentContext?.findRenderObject() as RenderBox?;
    if (box == null) return;

    final s = ref.read(editStateProvider)?.basicEditor;
    if (s == null) return;

    final minVal = _active.minVal;
    final maxVal = _active.maxVal;
    final range  = maxVal - minVal;
    final cur    = _active.getValue(s);
    final pct    = ((cur - minVal) / range).clamp(0.0, 1.0);

    // Compute the tangent direction at the current thumb position.
    // This gives consistent sensitivity everywhere on the arc — no speed-up at the top.
    final thumbRad  = (_kDialStartDeg + _kDialSpan * pct) * math.pi / 180;
    final tangentX  = -math.sin(thumbRad);
    final tangentY  =  math.cos(thumbRad);

    // Project the raw drag delta onto the tangent (pixels along the arc).
    final dR         = math.min(box.size.width * 0.44, box.size.height * 0.44);
    final tangential = d.delta.dx * tangentX + d.delta.dy * tangentY;

    // arc-pixels → angle delta → value delta
    final angleDeltaDeg = tangential * 180 / (dR * math.pi);
    final valueDelta    = (angleDeltaDeg / _kDialSpan) * range;

    final nv     = (cur + valueDelta).clamp(minVal, maxVal);
    final newPct = ((nv - minVal) / range).clamp(0.0, 1.0);
    _maybeHaptic(newPct, nv == minVal || nv == maxVal);

    ref.read(editStateProvider.notifier).updateBasicEditor(_active.setValue(s, nv));
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

    final val     = _active.getValue(settings);
    final minVal  = _active.minVal;
    final maxVal  = _active.maxVal;
    final pct     = ((val - minVal) / (maxVal - minVal)).clamp(0.0, 1.0);
    final zeroPct = ((0.0  - minVal) / (maxVal - minVal)).clamp(0.0, 1.0);

    final displayVal = _active == _ToneParam.temperature
        ? '${val.round()}K'
        : val.toStringAsFixed(val.abs() < 10 ? 1 : 0);

    return Column(
      children: [
        Expanded(
          child: GestureDetector(
            key: _areaKey,
            onPanStart: _onPanStart,
            onPanUpdate: _onPanUpdate,
            onDoubleTap: _resetActive,
            child: RepaintBoundary(
              child: CustomPaint(
                painter: _DialPainter(
                  pct: pct,
                  zeroPct: zeroPct,
                  paramLabel: _active.label,
                  displayValue: displayVal,
                ),
                child: const SizedBox.expand(),
              ),
            ),
          ),
        ),
        _ParamWheel(
          params: _ToneParam.values,
          active: _active,
          onSelect: (p) => setState(() {
            _active = p;
            _lastHapticPct = null;
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
  });

  final double pct;
  final double zeroPct;
  final String paramLabel;
  final String displayValue;

  @override
  void paint(Canvas canvas, Size size) {
    final dcx = size.width  / 2;
    final dcy = size.height * 0.55;
    final dR  = math.min(size.width * 0.44, size.height * 0.44);

    Offset toXY(double deg, {double? r}) {
      final rad = deg * math.pi / 180;
      final radius = r ?? dR;
      return Offset(dcx + radius * math.cos(rad), dcy + radius * math.sin(rad));
    }

    final angle     = _kDialStartDeg + _kDialSpan * pct;
    final zeroAngle = _kDialStartDeg + _kDialSpan * zeroPct;
    final pt        = toXY(angle);

    // Outer ring.
    canvas.drawCircle(
      Offset(dcx, dcy),
      dR + 6,
      Paint()
        ..color = kText.withValues(alpha: 0.22)
        ..style = PaintingStyle.stroke
        ..strokeWidth = 0.5,
    );

    const tickCount   = 49;
    const majorPeriod = 12;
    for (int i = 0; i < tickCount; i++) {
      final tickDeg = _kDialStartDeg + _kDialSpan * (i / (tickCount - 1));
      final isMajor = i % majorPeriod == 0;
      final frac    = i / (tickCount - 1);
      final inArc   = zeroPct <= pct
          ? frac >= zeroPct && frac <= pct
          : frac <= zeroPct && frac >= pct;
      final majorLen = dR * 0.12;
      final minorLen = dR * 0.076;
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
    final arcRect = Rect.fromCircle(center: Offset(dcx, dcy), radius: dR - 5);
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

    // Chromatic pointer.
    const thumbR  = 6.5;
    const chromaR = thumbR - 0.5;
    canvas.drawCircle(pt.translate(-1.5, 0), chromaR, Paint()..color = kRed.withValues(alpha: 0.55));
    canvas.drawCircle(pt.translate(1.5, 0),  chromaR, Paint()..color = kTeal.withValues(alpha: 0.55));
    canvas.drawCircle(pt, thumbR,       Paint()..color = kAmber);
    canvas.drawCircle(pt, thumbR * 2.0, Paint()..color = kAmber.withValues(alpha: 0.14));

    // Param label.
    _text(canvas, paramLabel,
        monoStyle(size: 8, color: kMute, letterSpacing: 3),
        Offset(dcx, dcy - 14));

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
      old.displayValue != displayValue;
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
