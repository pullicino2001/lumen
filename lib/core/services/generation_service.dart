import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../models/edit_state.dart';
import 'ai_model_config_service.dart';
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

  Future<String> generate(
    EditState state, {
    double strength = 0.75,
    bool Function()? isCancelled,
  }) async {
    final prompt = _builder.build(state);
    return _atlas.simulateWithUrlFallback(
      imagePath: state.proxyFilePath,
      prompt: prompt,
      strength: strength,
      isCancelled: isCancelled,
    );
  }
}

final aiModelConfigServiceProvider = FutureProvider<AiModelConfigService>((ref) {
  return AiModelConfigService.create();
});

final atlasCloudServiceProvider = FutureProvider<AtlasCloudService>((ref) async {
  final config = await ref.watch(aiModelConfigServiceProvider.future);
  return AtlasCloudService(modelConfig: config);
});

final generationServiceProvider = FutureProvider<GenerationService>((ref) async {
  final atlas = await ref.watch(atlasCloudServiceProvider.future);
  return GenerationService(atlasService: atlas);
});
