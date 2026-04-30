import 'dart:io';
import 'dart:ui' as ui;
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../models/import_profile.dart';
import 'edit_state_provider.dart';

/// Decodes the raw proxy JPEG into a [ui.Image].
/// Always the unprocessed source — used by the before/after toggle.
final previewImageProvider = FutureProvider<ui.Image?>((ref) async {
  final path = ref.watch(
    editStateProvider.select((s) => s?.proxyFilePath),
  );
  if (path == null) return null;
  final bytes = await File(path).readAsBytes();
  final codec = await ui.instantiateImageCodec(bytes);
  final frame = await codec.getNextFrame();
  return frame.image;
});

/// The image that feeds the shader — either the LUMEN-processed proxy or the
/// raw proxy, depending on the active [ImportProfile].
final shaderSourceProvider = FutureProvider<ui.Image?>((ref) async {
  final profile   = ref.watch(editStateProvider.select((s) => s?.importProfile));
  final lumenPath = ref.watch(editStateProvider.select((s) => s?.lumenProxyPath));
  final rawPath   = ref.watch(editStateProvider.select((s) => s?.proxyFilePath));
  if (rawPath == null) return null;
  final path = (profile == ImportProfile.lumen && lumenPath != null)
      ? lumenPath
      : rawPath;
  final bytes = await File(path).readAsBytes();
  final codec = await ui.instantiateImageCodec(bytes);
  final frame = await codec.getNextFrame();
  return frame.image;
});
