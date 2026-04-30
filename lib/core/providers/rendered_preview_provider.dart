import 'dart:ui' as ui;
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'edit_state_provider.dart';
import 'preview_image_provider.dart';
import 'shader_provider.dart';
import 'bloom_shader_provider.dart';
import '../services/effect_engine.dart';
import '../services/bloom_service.dart';

/// Renders the full effect pipeline (basic editor → stock → grain → lens → bloom)
/// to a [ui.Image] every time [editStateProvider] changes.
///
/// The widget layer caches the last resolved image so the display never blanks
/// between renders — see ShaderPreview.
final renderedPreviewProvider = FutureProvider<ui.Image?>((ref) async {
  final state = ref.watch(editStateProvider);
  if (state == null) return null;

  final program = await ref.watch(basicEditorProgramProvider.future);
  final source  = await ref.watch(shaderSourceProvider.future);
  if (source == null) return null;

  final processed = await EffectEngine().apply(
    state:       state,
    sourceImage: source,
    program:     program,
  );

  final bloomActive = state.bloomEnabled &&
      (state.bloom.bloomIntensity > 0 || state.bloom.halationIntensity > 0);
  if (!bloomActive) return processed;

  final programs = await ref.watch(bloomProgramsProvider.future);
  final halationTint = (state.stockEnabled && state.filmStock != null)
      ? state.filmStock!.halationTint
      : null;

  return BloomService().apply(
    source:            processed,
    settings:          state.bloom,
    programs:          programs,
    stockHalationTint: halationTint,
  );
});
