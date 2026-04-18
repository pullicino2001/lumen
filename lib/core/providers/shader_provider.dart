import 'dart:ui' as ui;
import 'package:flutter_riverpod/flutter_riverpod.dart';

final basicEditorProgramProvider = FutureProvider<ui.FragmentProgram>((ref) {
  return ui.FragmentProgram.fromAsset('assets/shaders/basic_editor.frag');
});
