import 'dart:async';
import 'dart:io';
import 'dart:ui' as ui;
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:file_picker/file_picker.dart';
import '../../../core/models/baseline_profile.dart';
import '../../../core/models/import_profile.dart';
import '../../../core/providers/edit_state_provider.dart';
import '../../../core/providers/shader_provider.dart';
import '../../../core/providers/preview_image_provider.dart';
import '../../../core/providers/bloom_shader_provider.dart';
import '../../../core/services/format_ingestion_service.dart';
import '../../../core/services/lumen_look_service.dart';
import '../../../core/services/effect_engine.dart';
import '../../../core/services/export_service.dart';
import '../../../shared/theme/lumen_theme.dart';
import '../widgets/shader_preview.dart';
import '../widgets/mod_look.dart';
import '../widgets/mod_tone.dart';
import '../widgets/mod_grain.dart';
import '../widgets/mod_bloom.dart';
import '../widgets/mod_lens.dart';

enum _Module { look, tone, grain, bloom, lens }

extension _ModuleExt on _Module {
  String get label => switch (this) {
    _Module.look  => 'Look',
    _Module.tone  => 'Tone',
    _Module.grain => 'Grain',
    _Module.bloom => 'Bloom',
    _Module.lens  => 'Lens',
  };

  IconData get icon => switch (this) {
    _Module.look  => Icons.movie_filter_outlined,
    _Module.tone  => Icons.tune_outlined,
    _Module.grain => Icons.grain,
    _Module.bloom => Icons.flare_outlined,
    _Module.lens  => Icons.lens_outlined,
  };
}

class EditorScreen extends ConsumerStatefulWidget {
  const EditorScreen({super.key});

  @override
  ConsumerState<EditorScreen> createState() => _EditorScreenState();
}

class _EditorScreenState extends ConsumerState<EditorScreen> {
  bool _importing = false;
  bool _exporting = false;
  _Module _activeModule = _Module.look;

  @override
  void initState() {
    super.initState();
    SystemChrome.setSystemUIOverlayStyle(const SystemUiOverlayStyle(
      statusBarColor: Colors.transparent,
      statusBarBrightness: Brightness.dark,
      statusBarIconBrightness: Brightness.light,
    ));
  }

  Future<void> _importPhoto() async {
    setState(() => _importing = true);
    try {
      final result = await FilePicker.platform.pickFiles(
        type: FileType.image,
        allowMultiple: false,
      );
      if (result == null || result.files.isEmpty) return;
      final sourcePath = result.files.single.path;
      if (sourcePath == null) return;
      final ingestion = await FormatIngestionService().ingest(sourcePath);
      ref.read(editStateProvider.notifier).load(
            sourcePath, ingestion.workingPath, ingestion.proxyPath);
      unawaited(_generateLumenProxy(ingestion.proxyPath));
    } on FormatIngestionException catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context)
            .showSnackBar(SnackBar(content: Text(e.message)));
      }
    } finally {
      if (mounted) setState(() => _importing = false);
    }
  }

  Future<void> _generateLumenProxy(String proxyPath) async {
    try {
      final profile = await BaselineProfile.load();
      final dot = proxyPath.lastIndexOf('.');
      final outPath = '${proxyPath.substring(0, dot)}_lumen${proxyPath.substring(dot)}';
      await LumenLookService.applyToProxy(proxyPath, outPath, profile);
      if (mounted) {
        ref.read(editStateProvider.notifier).setLumenProxyPath(proxyPath, outPath);
      }
    } catch (_) {
      // Silent fallback — shader will use raw proxy instead.
    }
  }

  Future<void> _exportPhoto() async {
    final state = ref.read(editStateProvider);
    if (state == null) return;
    setState(() => _exporting = true);
    try {
      final program       = await ref.read(basicEditorProgramProvider.future);
      final bloomPrograms = await ref.read(bloomProgramsProvider.future);

      // When LUMEN Look is on, bake it into a copy of the full-res PNG first.
      String sourcePath = state.workingFilePath;
      if (state.importProfile == ImportProfile.lumen) {
        final profile = await BaselineProfile.load();
        final dot = sourcePath.lastIndexOf('.');
        final lumenPath = '${sourcePath.substring(0, dot)}_lumen${sourcePath.substring(dot)}';
        await LumenLookService.applyToFullRes(sourcePath, lumenPath, profile);
        sourcePath = lumenPath;
      }

      // Load full-res working copy for export — proxy is for preview only.
      final bytes = await File(sourcePath).readAsBytes();
      final codec = await ui.instantiateImageCodec(bytes);
      final frame = await codec.getNextFrame();
      final sourceImage = frame.image;
      final processed = await EffectEngine().apply(
        state:         state,
        sourceImage:   sourceImage,
        program:       program,
        bloomPrograms: bloomPrograms,
      );
      final outputPath = await ExportService().export(processed, state);
      if (mounted) {
        ScaffoldMessenger.of(context)
            .showSnackBar(SnackBar(content: Text('Saved: $outputPath')));
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context)
            .showSnackBar(SnackBar(content: Text('Export failed: $e')));
      }
    } finally {
      if (mounted) setState(() => _exporting = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    ref.listen(
      editStateProvider.select((s) => s?.importProfile),
      (_, next) {
        if (next == ImportProfile.lumen) {
          final state = ref.read(editStateProvider);
          if (state != null && state.lumenProxyPath == null) {
            unawaited(_generateLumenProxy(state.proxyFilePath));
          }
        }
      },
    );

    final hasPhoto = ref.watch(editStateProvider.select((s) => s != null));

    return Scaffold(
      backgroundColor: kBg,
      body: hasPhoto
          ? _HybridEditor(
              activeModule: _activeModule,
              onModuleChanged: (m) => setState(() => _activeModule = m),
              onExport: _exporting ? null : _exportPhoto,
              exporting: _exporting,
            )
          : _ImportScreen(
              importing: _importing,
              onImport: _importPhoto,
            ),
    );
  }
}

// ─────────────────────────────────────────────────────────────────────────────
// HYBRID EDITOR — main layout
// ─────────────────────────────────────────────────────────────────────────────

class _HybridEditor extends StatefulWidget {
  const _HybridEditor({
    required this.activeModule,
    required this.onModuleChanged,
    required this.onExport,
    required this.exporting,
  });

  final _Module activeModule;
  final ValueChanged<_Module> onModuleChanged;
  final VoidCallback? onExport;
  final bool exporting;

  @override
  State<_HybridEditor> createState() => _HybridEditorState();
}

class _HybridEditorState extends State<_HybridEditor> {
  double? _sheetH;

  // Fixed heights of the non-module chrome inside the sheet:
  //   handle 20 + header ~80 + tab dock ~72 = 172
  // Plus a minimum module content area (200) so the hero never collapses.
  static const double _kSheetChrome = 172.0;
  static const double _kMinModuleH  = 200.0;

  void _onHandleDrag(double dy) {
    final mq      = MediaQuery.of(context);
    final screenH = mq.size.height;
    final topPad  = mq.padding.top;
    final botPad  = mq.padding.bottom;

    // Min: chrome + module area + bottom safe area.
    final min = _kSheetChrome + _kMinModuleH + botPad;
    // Max: leave at least 160px of photo visible above the nav bar.
    final max = screenH - topPad - 160.0;

    setState(() {
      _sheetH = ((_sheetH ?? screenH * 0.50) - dy).clamp(min, max);
    });
  }

  @override
  Widget build(BuildContext context) {
    final mq      = MediaQuery.of(context);
    final screenH = mq.size.height;
    final topPad  = mq.padding.top;
    final botPad  = mq.padding.bottom;

    final min    = _kSheetChrome + _kMinModuleH + botPad;
    final max    = screenH - topPad - 160.0;
    final sheetH = (_sheetH ?? screenH * 0.50).clamp(min, max);

    return Stack(
      children: [
        // Photo — full bleed with interactive viewer and long-press original.
        Positioned(
          top: 0, left: 0, right: 0, bottom: sheetH - 32,
          child: ClipRect(
            child: Stack(
              fit: StackFit.expand,
              children: [
                const _PhotoArea(),
                // Fade gradient toward the sheet — outside InteractiveViewer.
                Positioned(
                  bottom: 0, left: 0, right: 0, height: 80,
                  child: const DecoratedBox(
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        begin: Alignment.topCenter,
                        end: Alignment.bottomCenter,
                        colors: [Colors.transparent, kBg],
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),

        // Top nav.
        Positioned(
          top: topPad + 12, left: 0, right: 0,
          child: _TopNav(exporting: widget.exporting, onExport: widget.onExport),
        ),

        // Floating micro-panels.
        Positioned(
          top: topPad + 66, left: 12,
          child: const _HistogramPanel(),
        ),
        Positioned(
          top: topPad + 66, right: 12,
          child: const _FilmLookPanel(),
        ),
        Positioned(
          top: topPad + 176, left: 12,
          child: const _ExifPanel(),
        ),
        Positioned(
          top: topPad + 176, right: 12,
          child: const _ComparePanel(),
        ),

        // Drag-up sheet.
        Positioned(
          left: 0, right: 0, bottom: 0, height: sheetH,
          child: _EditorSheet(
            activeModule: widget.activeModule,
            onModuleChanged: widget.onModuleChanged,
            onHandleDrag: _onHandleDrag,
          ),
        ),
      ],
    );
  }
}

// ─────────────────────────────────────────────────────────────────────────────
// PHOTO AREA — pinch-to-zoom + long-press original
// ─────────────────────────────────────────────────────────────────────────────

class _PhotoArea extends ConsumerStatefulWidget {
  const _PhotoArea();

  @override
  ConsumerState<_PhotoArea> createState() => _PhotoAreaState();
}

class _PhotoAreaState extends ConsumerState<_PhotoArea> {
  bool _showOriginal = false;
  final _txController = TransformationController();

  @override
  void dispose() {
    _txController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onLongPressStart: (_) {
        HapticFeedback.mediumImpact();
        setState(() => _showOriginal = true);
      },
      onLongPressEnd: (_) => setState(() => _showOriginal = false),
      child: InteractiveViewer(
        transformationController: _txController,
        minScale: 1.0,
        maxScale: 6.0,
        child: Stack(
          fit: StackFit.expand,
          children: [
            _showOriginal
                ? const _OriginalPreview()
                : const RepaintBoundary(child: ShaderPreview()),
            if (_showOriginal)
              Positioned(
                top: 12, left: 0, right: 0,
                child: Center(
                  child: Container(
                    padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 5),
                    decoration: BoxDecoration(
                      color: kPanelBg,
                      borderRadius: BorderRadius.circular(4),
                      border: Border.all(
                          color: kAmber.withValues(alpha: 0.4), width: 0.5),
                    ),
                    child: Text('BEFORE',
                        style: monoStyle(
                            size: 8, color: kAmber, letterSpacing: 2.5)),
                  ),
                ),
              ),
          ],
        ),
      ),
    );
  }
}

// Shows the unprocessed source image (from previewImageProvider) for BEFORE view.
class _OriginalPreview extends ConsumerWidget {
  const _OriginalPreview();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return ref.watch(previewImageProvider).when(
      data: (img) => img != null
          ? RawImage(image: img, fit: BoxFit.contain)
          : const SizedBox.shrink(),
      loading: () => const SizedBox.shrink(),
      error: (e, s) => const SizedBox.shrink(),
    );
  }
}

// ─────────────────────────────────────────────────────────────────────────────
// TOP NAV
// ─────────────────────────────────────────────────────────────────────────────

class _TopNav extends ConsumerWidget {
  const _TopNav({required this.exporting, required this.onExport});
  final bool exporting;
  final VoidCallback? onExport;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 14),
      child: Row(
        children: [
          _NavBtn(
            child: const Icon(Icons.chevron_left, size: 20, color: kText),
            onTap: () {},
          ),
          const Spacer(),
          Column(
            children: [
              const Text(
                'Lumen',
                style: TextStyle(
                  fontFamily: 'Georgia',
                  fontStyle: FontStyle.italic,
                  fontSize: 16,
                  color: kAmber,
                  letterSpacing: 1,
                ),
              ),
              const SizedBox(height: 2),
              Text('ROLL 03 · FRAME 07',
                  style: monoStyle(size: 8, letterSpacing: 2.5)),
            ],
          ),
          const Spacer(),
          _NavBtn(
            color: kAmber,
            shadow: true,
            onTap: onExport,
            child: exporting
                ? const SizedBox(
                    width: 16, height: 16,
                    child: CircularProgressIndicator(
                        strokeWidth: 2, color: Color(0xFF1A0F06)),
                  )
                : const Icon(Icons.file_upload_outlined,
                    size: 18, color: Color(0xFF1A0F06)),
          ),
        ],
      ),
    );
  }
}

class _NavBtn extends StatelessWidget {
  const _NavBtn(
      {required this.child, this.onTap, this.color, this.shadow = false});
  final Widget child;
  final VoidCallback? onTap;
  final Color? color;
  final bool shadow;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: 34, height: 34,
        decoration: BoxDecoration(
          color: color ?? kPanelBg,
          borderRadius: BorderRadius.circular(8),
          border: color == null
              ? Border.all(
                  color: kAmber.withValues(alpha: 0.16), width: 0.5)
              : null,
          boxShadow: shadow
              ? [BoxShadow(
                  color: kAmber.withValues(alpha: 0.45), blurRadius: 18)]
              : null,
        ),
        child: Center(child: child),
      ),
    );
  }
}

// ─────────────────────────────────────────────────────────────────────────────
// FLOATING MICRO-PANELS
// ─────────────────────────────────────────────────────────────────────────────

class _FloatingPanel extends StatelessWidget {
  const _FloatingPanel({
    required this.child,
    this.label,
    this.labelRight,
    this.width,
  });

  final Widget child;
  final String? label;
  final Widget? labelRight;
  final double? width;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: width,
      decoration: BoxDecoration(
        color: kPanelBg,
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: kAmber.withValues(alpha: 0.18), width: 0.5),
        boxShadow: [
          BoxShadow(
              color: Colors.black.withValues(alpha: 0.55),
              blurRadius: 32,
              offset: const Offset(0, 10)),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: [
          if (label != null)
            Container(
              padding:
                  const EdgeInsets.symmetric(horizontal: 10, vertical: 7),
              decoration: BoxDecoration(
                border: Border(bottom: BorderSide(color: kHair, width: 0.5)),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(label!.toUpperCase(),
                      style: monoStyle(size: 8, letterSpacing: 2)),
                  ?labelRight,
                ],
              ),
            ),
          child,
        ],
      ),
    );
  }
}

class _HistogramPanel extends StatelessWidget {
  const _HistogramPanel();

  @override
  Widget build(BuildContext context) {
    return _FloatingPanel(
      width: 118,
      label: 'Histogram',
      labelRight: Text('RGB',
          style: monoStyle(size: 8, color: kAmber, letterSpacing: 1)),
      child: Padding(
        padding: const EdgeInsets.all(8),
        child: SizedBox(
          height: 40,
          child: RepaintBoundary(
            child: CustomPaint(painter: _HistogramPainter()),
          ),
        ),
      ),
    );
  }
}

class _HistogramPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final pts  = [0.0, 5.0, 15.0, 25.0, 35.0, 45.0, 55.0, 65.0, 75.0, 85.0, 95.0, 100.0];
    final vals = [1.0, 0.78, 0.72, 0.44, 0.56, 0.22, 0.33, 0.11, 0.28, 0.61, 0.89, 1.0];

    final path = Path()..moveTo(0, size.height);
    for (int i = 0; i < pts.length; i++) {
      path.lineTo(size.width * pts[i] / 100, size.height * (1 - vals[i]));
    }
    path.lineTo(size.width, size.height);
    path.close();

    canvas.drawPath(
        path, Paint()..color = kAmber.withValues(alpha: 0.55));
  }

  @override
  bool shouldRepaint(_HistogramPainter _) => false;
}

// Watches only filmStock — rebuilds only when that specific field changes.
class _FilmLookPanel extends ConsumerWidget {
  const _FilmLookPanel();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final filmStock =
        ref.watch(editStateProvider.select((s) => s?.filmStock));
    final stockName = filmStock?.name ?? 'None';
    final intensity = filmStock?.intensity ?? 0.0;

    return _FloatingPanel(
      width: 128,
      label: 'Film Look',
      labelRight: Container(
        width: 6, height: 6,
        decoration:
            const BoxDecoration(color: kAmber, shape: BoxShape.circle),
      ),
      child: Padding(
        padding: const EdgeInsets.fromLTRB(10, 10, 10, 12),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              stockName,
              style: const TextStyle(
                fontFamily: 'Georgia',
                fontStyle: FontStyle.italic,
                fontSize: 18,
                color: kText,
                letterSpacing: 0.3,
              ),
            ),
            const SizedBox(height: 10),
            Container(
              height: 2,
              color: kHair,
              child: FractionallySizedBox(
                widthFactor: (intensity / 100).clamp(0, 1),
                alignment: Alignment.centerLeft,
                child: const ColoredBox(color: kAmber),
              ),
            ),
            const SizedBox(height: 4),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text('INTENSITY',
                    style: monoStyle(size: 8, letterSpacing: 1.2)),
                Text(intensity.toStringAsFixed(0),
                    style:
                        monoStyle(size: 8, color: kAmber, letterSpacing: 1.2)),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

class _ExifPanel extends StatelessWidget {
  const _ExifPanel();

  @override
  Widget build(BuildContext context) {
    return _FloatingPanel(
      width: 90,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 8),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('35mm',    style: monoStyle(size: 9, letterSpacing: 1)),
            Text('f/2.8',  style: monoStyle(size: 9, letterSpacing: 1)),
            Text('1/250',  style: monoStyle(size: 9, letterSpacing: 1)),
            Text('ISO 400',style: monoStyle(size: 9, letterSpacing: 1)),
          ],
        ),
      ),
    );
  }
}

class _ComparePanel extends StatelessWidget {
  const _ComparePanel();

  @override
  Widget build(BuildContext context) {
    return _FloatingPanel(
      width: 96,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 8),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text('BEFORE', style: monoStyle(size: 9, letterSpacing: 1.5)),
            Text('AFTER',
                style: monoStyle(
                    size: 9, color: kAmber, letterSpacing: 1.5)),
          ],
        ),
      ),
    );
  }
}

// ─────────────────────────────────────────────────────────────────────────────
// EDITOR SHEET
// ─────────────────────────────────────────────────────────────────────────────

class _EditorSheet extends ConsumerWidget {
  const _EditorSheet({
    required this.activeModule,
    required this.onModuleChanged,
    required this.onHandleDrag,
  });

  final _Module activeModule;
  final ValueChanged<_Module> onModuleChanged;
  final ValueChanged<double> onHandleDrag;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final editState = ref.watch(editStateProvider);
    final moduleName = activeModule.label;
    final moduleMeta = _metaFor(activeModule, editState);

    return Container(
      decoration: BoxDecoration(
        color: kSheet,
        borderRadius: const BorderRadius.vertical(top: Radius.circular(22)),
        border: Border(
            top: BorderSide(
                color: kAmber.withValues(alpha: 0.16), width: 0.5)),
        boxShadow: [
          BoxShadow(
              color: Colors.black.withValues(alpha: 0.6),
              blurRadius: 48,
              offset: const Offset(0, -24)),
        ],
      ),
      child: Column(
        children: [
          // Drag handle — vertical drag resizes the sheet.
          GestureDetector(
            behavior: HitTestBehavior.opaque,
            onVerticalDragUpdate: (d) => onHandleDrag(d.delta.dy),
            child: Padding(
              padding: const EdgeInsets.fromLTRB(0, 10, 0, 6),
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
          ),

          // Sheet header.
          Padding(
            padding: const EdgeInsets.fromLTRB(22, 14, 22, 0),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text('Module',
                        style: monoStyle(size: 9, letterSpacing: 2.5)),
                    const SizedBox(height: 2),
                    Text(
                      moduleName,
                      style: const TextStyle(
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
                    Text(moduleMeta.$1,
                        style: monoStyle(size: 9, letterSpacing: 2.5)),
                    const SizedBox(height: 2),
                    Text(
                      moduleMeta.$2,
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

          // Module hero area.
          Expanded(
            child: switch (activeModule) {
              _Module.look  => const ModLook(),
              _Module.tone  => const ModTone(),
              _Module.grain => const ModGrain(),
              _Module.bloom => const ModBloom(),
              _Module.lens  => const ModLens(),
            },
          ),

          // Module tab dock.
          Container(
            margin: const EdgeInsets.fromLTRB(18, 0, 18, 0),
            decoration: BoxDecoration(
              border: Border(top: BorderSide(color: kHair, width: 0.5)),
            ),
            padding: const EdgeInsets.symmetric(vertical: 10),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: _Module.values.map((m) {
                final active = m == activeModule;
                return GestureDetector(
                  onTap: () => onModuleChanged(m),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      AnimatedContainer(
                        duration: const Duration(milliseconds: 150),
                        padding: const EdgeInsets.all(4),
                        decoration: BoxDecoration(
                          color: active ? kAmberSoft : Colors.transparent,
                          borderRadius: BorderRadius.circular(4),
                        ),
                        child: Icon(m.icon,
                            size: 18,
                            color: active ? kAmber : kMute),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        m.label.toUpperCase(),
                        style: monoStyle(
                          size: 8,
                          color: active ? kAmber : kMute,
                          letterSpacing: 2,
                        ),
                      ),
                    ],
                  ),
                );
              }).toList(),
            ),
          ),
          SizedBox(height: MediaQuery.paddingOf(context).bottom + 4),
        ],
      ),
    );
  }

  (String, String) _metaFor(_Module m, dynamic state) => switch (m) {
    _Module.look  =>
        ('Film Look', state?.filmStock?.name?.split(' ').first ?? 'None'),
    _Module.tone  =>
        ('Highlights', state?.basicEditor?.highlights.toStringAsFixed(0) ?? '0'),
    _Module.grain =>
        ('Intensity', state?.grain?.intensity.toStringAsFixed(0) ?? '0'),
    _Module.bloom =>
        ('Bloom', state?.bloom?.bloomIntensity.toStringAsFixed(0) ?? '0'),
    _Module.lens  =>
        ('Profile', state?.lensProfile?.name?.split(' ').last ?? '—'),
  };
}

// ─────────────────────────────────────────────────────────────────────────────
// IMPORT SCREEN
// ─────────────────────────────────────────────────────────────────────────────

class _ImportScreen extends StatelessWidget {
  const _ImportScreen({required this.importing, required this.onImport});
  final bool importing;
  final VoidCallback onImport;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: kBg,
      body: Stack(
        children: [
          Positioned.fill(
            child: DecoratedBox(
              decoration: BoxDecoration(
                gradient: RadialGradient(
                  center: Alignment.center,
                  radius: 1.2,
                  colors: [
                    kAmber.withValues(alpha: 0.04),
                    Colors.transparent,
                  ],
                ),
              ),
            ),
          ),
          SafeArea(
            child: Center(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  const Text(
                    'Lumen',
                    style: TextStyle(
                      fontFamily: 'Georgia',
                      fontStyle: FontStyle.italic,
                      fontSize: 52,
                      color: kAmber,
                      letterSpacing: -1,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    'A DARKROOM FOR EVERY CAMERA',
                    style: monoStyle(size: 9, letterSpacing: 3),
                  ),
                  const SizedBox(height: 60),
                  GestureDetector(
                    onTap: importing ? null : onImport,
                    child: AnimatedContainer(
                      duration: const Duration(milliseconds: 150),
                      padding: const EdgeInsets.symmetric(
                          horizontal: 32, vertical: 16),
                      decoration: BoxDecoration(
                        border: Border.all(
                            color: kAmber.withValues(alpha: 0.6), width: 1),
                        borderRadius: BorderRadius.circular(4),
                        boxShadow: [
                          BoxShadow(
                              color: kAmber.withValues(alpha: 0.12),
                              blurRadius: 24),
                        ],
                      ),
                      child: importing
                          ? const SizedBox(
                              width: 20, height: 20,
                              child: CircularProgressIndicator(
                                  strokeWidth: 1.5, color: kAmber),
                            )
                          : Text(
                              'IMPORT PHOTO',
                              style: monoStyle(
                                  size: 11, color: kAmber, letterSpacing: 3),
                            ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
