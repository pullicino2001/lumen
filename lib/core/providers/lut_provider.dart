import 'dart:ui' as ui;
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../services/lut_service.dart';
import 'edit_state_provider.dart';

/// Provides the 2D LUT texture for the current film look.
/// Only reloads when the active look's asset path changes — not on slider updates.
final lutImageProvider = FutureProvider<(ui.Image, double)>((ref) async {
  final path = ref.watch(
    editStateProvider.select((s) {
      if (s == null || !s.filmLookEnabled || s.filmLook == null) return null;
      return s.filmLook!.lutAssetPath;
    }),
  );

  if (path == null) {
    return (await LutService.placeholder(), 1.0);
  }

  final image = await LutService.loadFromAsset(path);
  return (image, 17.0);
});
