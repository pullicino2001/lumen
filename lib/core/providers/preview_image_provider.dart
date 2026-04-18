import 'dart:io';
import 'dart:ui' as ui;
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'edit_state_provider.dart';

/// Decodes the current working file into a [ui.Image] for shader rendering.
/// Only reloads when [workingFilePath] changes — not on every slider update.
final previewImageProvider = FutureProvider<ui.Image?>((ref) async {
  final path = ref.watch(
    editStateProvider.select((s) => s?.workingFilePath),
  );
  if (path == null) return null;
  final bytes = await File(path).readAsBytes();
  final codec = await ui.instantiateImageCodec(bytes);
  final frame = await codec.getNextFrame();
  return frame.image;
});
