import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:file_picker/file_picker.dart';
import '../../../core/providers/edit_state_provider.dart';
import '../../../core/providers/shader_provider.dart';
import '../../../core/providers/preview_image_provider.dart';
import '../../../core/providers/bloom_shader_provider.dart';
import '../../../core/services/format_ingestion_service.dart';
import '../../../core/services/effect_engine.dart';
import '../../../core/services/export_service.dart';
import '../widgets/basic_editor_panel.dart';
import '../widgets/bloom_panel.dart';
import '../widgets/stock_strip.dart';
import '../widgets/grain_panel.dart';
import '../widgets/lens_profile_strip.dart';
import '../widgets/generate_button.dart';
import '../widgets/shader_preview.dart';

/// Main editor screen — entry point for every edit session.
class EditorScreen extends ConsumerStatefulWidget {
  const EditorScreen({super.key});

  @override
  ConsumerState<EditorScreen> createState() => _EditorScreenState();
}

class _EditorScreenState extends ConsumerState<EditorScreen> {
  bool _importing = false;
  bool _exporting = false;

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

      final workingPath = await FormatIngestionService().ingest(sourcePath);
      ref.read(editStateProvider.notifier).load(sourcePath, workingPath);
    } on FormatIngestionException catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context)
            .showSnackBar(SnackBar(content: Text(e.message)));
      }
    } finally {
      if (mounted) setState(() => _importing = false);
    }
  }

  Future<void> _exportPhoto() async {
    final state = ref.read(editStateProvider);
    if (state == null) return;
    setState(() => _exporting = true);
    try {
      final program       = await ref.read(basicEditorProgramProvider.future);
      final sourceImage   = await ref.read(previewImageProvider.future);
      final bloomPrograms = await ref.read(bloomProgramsProvider.future);
      if (sourceImage == null) return;

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
    final editState = ref.watch(editStateProvider);
    final hasPhoto  = editState != null;

    return Scaffold(
      appBar: AppBar(
        title: const Text('LUMEN'),
        actions: [
          if (hasPhoto)
            _exporting
                ? const Padding(
                    padding: EdgeInsets.all(16),
                    child: SizedBox(
                      width: 20,
                      height: 20,
                      child: CircularProgressIndicator(strokeWidth: 2),
                    ),
                  )
                : IconButton(
                    icon: const Icon(Icons.save_alt),
                    tooltip: 'Export',
                    onPressed: _exportPhoto,
                  ),
        ],
      ),
      body: Column(
        children: [
          Expanded(
            flex: 3,
            child: hasPhoto
                ? const ShaderPreview()
                : _ImportPrompt(onTap: _importing ? null : _importPhoto),
          ),
          if (hasPhoto) ...[
            const Divider(height: 1),
            Expanded(
              flex: 2,
              child: SingleChildScrollView(
                padding: const EdgeInsets.all(16),
                child: Column(
                  children: [
                    const StockStrip(),
                    const Divider(height: 24),
                    BasicEditorPanel(editState: editState),
                    const Divider(height: 24),
                    GrainPanel(editState: editState),
                    const Divider(height: 24),
                    BloomPanel(editState: editState),
                    const Divider(height: 24),
                    const LensProfileStrip(),
                    const SizedBox(height: 16),
                    const GenerateButton(),
                  ],
                ),
              ),
            ),
          ],
        ],
      ),
      floatingActionButton: hasPhoto
          ? null
          : FloatingActionButton.extended(
              onPressed: _importing ? null : _importPhoto,
              icon: _importing
                  ? const SizedBox(
                      width: 20,
                      height: 20,
                      child: CircularProgressIndicator(strokeWidth: 2),
                    )
                  : const Icon(Icons.add_photo_alternate_outlined),
              label: const Text('Import Photo'),
            ),
    );
  }
}

class _ImportPrompt extends StatelessWidget {
  const _ImportPrompt({this.onTap});
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              Icons.add_photo_alternate_outlined,
              size: 64,
              color: Theme.of(context).colorScheme.onSurface.withValues(alpha: 0.3),
            ),
            const SizedBox(height: 16),
            Text(
              'Import a photo to begin',
              style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                    color: Theme.of(context)
                        .colorScheme
                        .onSurface
                        .withValues(alpha: 0.5),
                  ),
            ),
          ],
        ),
      ),
    );
  }
}
