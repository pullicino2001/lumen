import 'dart:ui' as ui;
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../services/bloom_service.dart';

final bloomProgramsProvider = FutureProvider<BloomPrograms>((ref) async {
  final extract   = await ui.FragmentProgram.fromAsset('assets/shaders/bloom_extract.frag');
  final blur      = await ui.FragmentProgram.fromAsset('assets/shaders/bloom_blur.frag');
  final composite = await ui.FragmentProgram.fromAsset('assets/shaders/bloom_composite.frag');
  return (extract: extract, blur: blur, composite: composite);
});
