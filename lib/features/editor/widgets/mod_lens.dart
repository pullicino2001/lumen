import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../core/data/lens_profiles.dart';
import '../../../core/models/lens_profile.dart';
import '../../../core/providers/edit_state_provider.dart';
import '../../../shared/theme/lumen_theme.dart';
import 'chromatic_slider.dart';

class ModLens extends ConsumerWidget {
  const ModLens({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final activeProfile = ref.watch(
      editStateProvider.select((s) => s?.lensProfile),
    );

    void setProfile(LensProfile? p) =>
        ref.read(editStateProvider.notifier).setLensProfile(p);

    final profiles = [null, ...kLensProfiles];

    return SingleChildScrollView(
      padding: const EdgeInsets.fromLTRB(24, 8, 24, 8),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _VignettePicker(
            profile: activeProfile,
            onOffsetChanged: (x, y) {
              if (activeProfile != null) {
                ref.read(editStateProvider.notifier).setLensProfile(
                      activeProfile.copyWith(
                          vignetteOffsetX: x, vignetteOffsetY: y),
                    );
              }
            },
          ),
          const SizedBox(height: 14),
          SizedBox(
            height: 44,
            child: ListView.separated(
              scrollDirection: Axis.horizontal,
              itemCount: profiles.length,
              separatorBuilder: (context, index) => const SizedBox(width: 6),
              itemBuilder: (context, i) {
                final p = profiles[i];
                final on = (p?.id == activeProfile?.id) &&
                    (p == null) == (activeProfile == null);
                final label = p?.name ?? 'None';
                return GestureDetector(
                  onTap: () => setProfile(p),
                  child: AnimatedContainer(
                    duration: const Duration(milliseconds: 150),
                    padding: const EdgeInsets.symmetric(
                        horizontal: 12, vertical: 6),
                    decoration: BoxDecoration(
                      color: on ? kAmberSoft : Colors.transparent,
                      border: Border.all(
                        color: on ? kAmber : kHair,
                        width: 0.5,
                      ),
                      borderRadius: BorderRadius.circular(3),
                    ),
                    child: Text(
                      label,
                      style: TextStyle(
                        fontFamily: 'Georgia',
                        fontStyle: FontStyle.italic,
                        fontSize: 12,
                        color: on ? kAmber : kText,
                        letterSpacing: 0.2,
                      ),
                    ),
                  ),
                );
              },
            ),
          ),
          const SizedBox(height: 14),
          ChromaticSlider(
            label: 'Vignette',
            value: (activeProfile?.vignetteIntensity ?? 0) * 100,
            min: 0,
            max: 100,
            onChanged: (v) {
              if (activeProfile != null) {
                ref.read(editStateProvider.notifier).setLensProfile(
                      activeProfile.copyWith(vignetteIntensity: v / 100),
                    );
              }
            },
          ),
          const SizedBox(height: 14),
          ChromaticSlider(
            label: 'Chromatic Ab.',
            value: (activeProfile?.chromaticAberration ?? 0) * 100,
            min: 0,
            max: 100,
            onChanged: (v) {
              if (activeProfile != null) {
                ref.read(editStateProvider.notifier).setLensProfile(
                      activeProfile.copyWith(chromaticAberration: v / 100),
                    );
              }
            },
          ),
        ],
      ),
    );
  }
}

// ─────────────────────────────────────────────────────────────────────────────
// INTERACTIVE VIGNETTE PICKER
// ─────────────────────────────────────────────────────────────────────────────

class _VignettePicker extends StatefulWidget {
  const _VignettePicker({
    required this.profile,
    required this.onOffsetChanged,
  });

  final LensProfile? profile;

  /// Called with (x, y) in 0–1 range as the user drags.
  /// Called once more on drag end with the final position.
  final void Function(double x, double y) onOffsetChanged;

  @override
  State<_VignettePicker> createState() => _VignettePickerState();
}

class _VignettePickerState extends State<_VignettePicker> {
  late Offset _center;

  static const double _kH = 130.0;

  @override
  void initState() {
    super.initState();
    _center = _centerFromProfile(widget.profile);
  }

  @override
  void didUpdateWidget(_VignettePicker old) {
    super.didUpdateWidget(old);
    // Sync if an external change (e.g. undo) updates the profile offsets.
    final nx = widget.profile?.vignetteOffsetX ?? 0.5;
    final ny = widget.profile?.vignetteOffsetY ?? 0.5;
    final ox = old.profile?.vignetteOffsetX ?? 0.5;
    final oy = old.profile?.vignetteOffsetY ?? 0.5;
    if ((nx - ox).abs() > 0.001 || (ny - oy).abs() > 0.001) {
      _center = Offset(nx, ny);
    }
  }

  static Offset _centerFromProfile(LensProfile? p) =>
      Offset(p?.vignetteOffsetX ?? 0.5, p?.vignetteOffsetY ?? 0.5);

  void _onPanUpdate(DragUpdateDetails d) {
    final box = context.findRenderObject() as RenderBox;
    final size = box.size;
    setState(() {
      _center = Offset(
        (_center.dx + d.delta.dx / size.width).clamp(0.05, 0.95),
        (_center.dy + d.delta.dy / size.height).clamp(0.05, 0.95),
      );
    });
    widget.onOffsetChanged(_center.dx, _center.dy);
  }

  void _onDoubleTap() {
    HapticFeedback.lightImpact();
    setState(() => _center = const Offset(0.5, 0.5));
    widget.onOffsetChanged(0.5, 0.5);
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onPanUpdate: widget.profile != null ? _onPanUpdate : null,
      onDoubleTap: widget.profile != null ? _onDoubleTap : null,
      child: ClipRRect(
        borderRadius: BorderRadius.circular(4),
        child: Container(
          height: _kH,
          decoration: BoxDecoration(
            border: Border.all(color: kHair, width: 0.5),
          ),
          child: CustomPaint(
            painter: _VignetteDiagramPainter(
              profile: widget.profile,
              center: _center,
            ),
            size: const Size(double.infinity, _kH),
          ),
        ),
      ),
    );
  }
}

// ─────────────────────────────────────────────────────────────────────────────

class _VignetteDiagramPainter extends CustomPainter {
  const _VignetteDiagramPainter({
    required this.profile,
    required this.center,
  });

  final LensProfile? profile;
  final Offset center;

  @override
  void paint(Canvas canvas, Size size) {
    final w = size.width, h = size.height;
    final vig = profile?.vignetteIntensity ?? 0;
    final ca = (profile?.chromaticAberration ?? 0).clamp(0.0, 1.0);
    final cx = center.dx * w;
    final cy = center.dy * h;

    // Background
    canvas.drawRect(
      Rect.fromLTWH(0, 0, w, h),
      Paint()..color = const Color(0xFF2A1A0C),
    );

    // Grid
    final gridPaint = Paint()..color = kHair..strokeWidth = 0.5;
    for (int i = 0; i <= 8; i++) {
      canvas.drawLine(Offset(w * i / 8, 0), Offset(w * i / 8, h), gridPaint);
    }
    for (int i = 0; i <= 5; i++) {
      canvas.drawLine(Offset(0, h * i / 5), Offset(w, h * i / 5), gridPaint);
    }

    // CA fringing at corners
    if (ca > 0.001) {
      final caStrength = ca * 0.7;
      final corners = [
        [Offset(0, 0), Offset(w * 0.15, h * 0.25)],
        [Offset(w, 0), Offset(w * 0.85, h * 0.25)],
        [Offset(0, h), Offset(w * 0.15, h * 0.75)],
        [Offset(w, h), Offset(w * 0.85, h * 0.75)],
      ];
      for (final c in corners) {
        canvas.drawLine(c[0], c[1],
            Paint()
              ..color = kRed.withValues(alpha: caStrength)
              ..strokeWidth = 1);
        canvas.drawLine(
          c[0].translate(2, 0),
          c[1].translate(2, 0),
          Paint()
            ..color = kTeal.withValues(alpha: caStrength)
            ..strokeWidth = 1,
        );
      }
    }

    // Vignette gradient — centred on the draggable point
    if (vig > 0) {
      final vigGrad = RadialGradient(
        center: Alignment(center.dx * 2 - 1, center.dy * 2 - 1),
        radius: 1.1,
        colors: [Colors.transparent, Colors.black.withValues(alpha: vig)],
        stops: const [0.4, 1.0],
      ).createShader(Rect.fromLTWH(0, 0, w, h));
      canvas.drawRect(
          Rect.fromLTWH(0, 0, w, h), Paint()..shader = vigGrad);
    }

    // Draggable crosshair at vignette center
    final crossPaint = Paint()
      ..color = kAmber
      ..strokeWidth = 0.5;
    canvas.drawCircle(Offset(cx, cy), 4,
        Paint()..color = kAmber);
    canvas.drawCircle(
        Offset(cx, cy),
        16,
        Paint()
          ..color = kAmber.withValues(alpha: 0.45)
          ..style = PaintingStyle.stroke
          ..strokeWidth = 0.5);
    canvas.drawLine(Offset(cx - 14, cy), Offset(cx + 14, cy), crossPaint);
    canvas.drawLine(Offset(cx, cy - 14), Offset(cx, cy + 14), crossPaint);

    // Labels
    final isCenter =
        (center.dx - 0.5).abs() < 0.01 && (center.dy - 0.5).abs() < 0.01;
    _text(
        canvas,
        '${profile?.name ?? "None"} · ${profile?.apertureLabel ?? "—"}',
        monoStyle(size: 9, color: kAmber, letterSpacing: 2),
        Offset(8, h - 12));
    _text(
        canvas,
        isCenter
            ? 'VIG ${(vig * 100).round()}  DRAG TO OFFSET'
            : 'VIG ${(vig * 100).round()}  ·  ${(center.dx * 100).round()} ${(center.dy * 100).round()}',
        monoStyle(size: 9, letterSpacing: 2),
        Offset(w - 8, h - 12),
        align: TextAlign.right);
  }

  void _text(Canvas canvas, String text, TextStyle style, Offset pos,
      {TextAlign align = TextAlign.left}) {
    final painter = TextPainter(
      text: TextSpan(text: text, style: style),
      textDirection: TextDirection.ltr,
      textAlign: align,
    )..layout();
    final dx = align == TextAlign.right ? pos.dx - painter.width : pos.dx;
    painter.paint(canvas, Offset(dx, pos.dy - painter.height));
  }

  @override
  bool shouldRepaint(_VignetteDiagramPainter old) =>
      old.center != center ||
      old.profile?.id != profile?.id ||
      old.profile?.vignetteIntensity != profile?.vignetteIntensity ||
      old.profile?.chromaticAberration != profile?.chromaticAberration;
}
