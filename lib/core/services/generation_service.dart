import '../models/edit_state.dart';

/// STUBBED — active in v4.
///
/// Translates [EditState] into an AI generation prompt and dispatches an
/// img2img call via the active model in [AiModelConfigService].
/// Returns a file path to the generated image.
class GenerationService {
  const GenerationService();

  /// Submits a generation request for [state].
  ///
  /// Throws [UnimplementedError] until v4.
  Future<String> generate(EditState state) async {
    throw UnimplementedError('GenerationService is not active until v4.');
  }
}
