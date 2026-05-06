import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../models/edit_state.dart';
import 'atlas_cloud_service.dart';
import 'generation_prompt_builder.dart';

/// Translates an [EditState] into an AI generation prompt and dispatches an
/// img2img call via [AtlasCloudService].
/// Returns a file path to the generated image.
class GenerationService {
  GenerationService({
    AtlasCloudService? atlasService,
    GenerationPromptBuilder? promptBuilder,
  })  : _atlas = atlasService ?? AtlasCloudService(),
        _builder = promptBuilder ?? const GenerationPromptBuilder();

  final AtlasCloudService _atlas;
  final GenerationPromptBuilder _builder;

  Future<String> generate(EditState state, {double strength = 0.75}) async {
    final prompt = _builder.build(state);
    return _atlas.simulateWithUrlFallback(
      imagePath: state.proxyFilePath,
      prompt: prompt,
      strength: strength,
    );
  }
}

final atlasCloudServiceProvider = Provider<AtlasCloudService>(
  (_) => AtlasCloudService(),
);

final generationServiceProvider = Provider<GenerationService>((ref) {
  return GenerationService(atlasService: ref.watch(atlasCloudServiceProvider));
});
