import 'package:flutter/material.dart';
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
          ClipRRect(
            borderRadius: BorderRadius.circular(4),
            child: Container(
              height: 130,
              decoration: BoxDecoration(
                border: Border.all(color: kHair, width: 0.5),
              ),
              child: CustomPaint(
                painter: _OpticalDiagramPainter(profile: activeProfile),
                size: const Size(double.infinity, 130),
              ),
            ),
          ),
          const SizedBox(height: 14),
          SizedBox(
            height: 44,
            child: ListView.separated(
              scrollDirection: Axis.horizontal,
              itemCount: profiles.length,
              separatorBuilder: (_, x) => const SizedBox(width: 6),
              itemBuilder: (context, i) {
                final p = profiles[i];
                final on = (p?.id == activeProfile?.id) && (p == null) == (activeProfile == null);
                final label = p?.name ?? 'None';
                return GestureDetector(
                  onTap: () => setProfile(p),
                  child: AnimatedContainer(
                    duration: const Duration(milliseconds: 150),
                    padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
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

class _OpticalDiagramPainter extends CustomPainter {
  const _OpticalDiagramPainter({required this.profile});
  final LensProfile? profile;

  @override
  void paint(Canvas canvas, Size size) {
    final w = size.width, h = size.height;
    final vig = profile?.vignetteIntensity ?? 0;
    final ca  = (profile?.chromaticAberration ?? 0).clamp(0.0, 1.0);

    // warm field
    canvas.drawRect(
      Rect.fromLTWH(0, 0, w, h),
      Paint()..color = const Color(0xFF2A1A0C),
    );

    // grid
    final gridPaint = Paint()..color = kHair..strokeWidth = 0.5;
    for (int i = 0; i <= 8; i++) {
      final x = w * i / 8;
      canvas.drawLine(Offset(x, 0), Offset(x, h), gridPaint);
    }
    for (int i = 0; i <= 5; i++) {
      final y = h * i / 5;
      canvas.drawLine(Offset(0, y), Offset(w, y), gridPaint);
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
            Paint()..color = kRed.withValues(alpha: caStrength)..strokeWidth = 1);
        canvas.drawLine(
          c[0].translate(2, 0),
          c[1].translate(2, 0),
          Paint()..color = kTeal.withValues(alpha: caStrength)..strokeWidth = 1,
        );
      }
    }

    // vignette
    if (vig > 0) {
      final vigGrad = RadialGradient(
        colors: [Colors.transparent, Colors.black.withValues(alpha: vig)],
        stops: const [0.5, 1.0],
      ).createShader(Rect.fromLTWH(0, 0, w, h));
      canvas.drawRect(Rect.fromLTWH(0, 0, w, h), Paint()..shader = vigGrad);
    }

    // center crosshair
    final cx = w / 2, cy = h / 2;
    final crossPaint = Paint()..color = kAmber..strokeWidth = 0.5;
    canvas.drawCircle(Offset(cx, cy), 3, Paint()..color = kAmber);
    canvas.drawCircle(Offset(cx, cy), 14,
        Paint()..color = kAmber.withValues(alpha: 0.5)..style = PaintingStyle.stroke..strokeWidth = 0.5);
    canvas.drawLine(Offset(cx - 12, cy), Offset(cx + 12, cy), crossPaint);
    canvas.drawLine(Offset(cx, cy - 12), Offset(cx, cy + 12), crossPaint);

    // labels
    _text(canvas, '${profile?.name ?? "None"} · ${_focalLabel()}',
        monoStyle(size: 9, color: kAmber, letterSpacing: 2), Offset(8, h - 12));
    _text(canvas, 'VIG ${(vig * 100).round()} · CA ${(ca * 100).round()}',
        monoStyle(size: 9, letterSpacing: 2), Offset(w - 8, h - 12),
        align: TextAlign.right);
  }

  String _focalLabel() {
    if (profile == null) return '—';
    return switch (profile!.id) {
      'classic_50'  => 'f/1.8',
      'portrait_85' => 'f/1.4',
      'wide_24'     => 'f/2.8',
      'vintage_35'  => 'f/2.8',
      'anamorphic'  => 'f/2.0',
      _             => 'f/—',
    };
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
  bool shouldRepaint(_OpticalDiagramPainter old) => old.profile?.id != profile?.id;
}
