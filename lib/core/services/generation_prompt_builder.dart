import '../models/edit_state.dart';

/// Translates a full [EditState] into a plain-text prompt string suitable
/// for submission to the active AI generation model.
///
/// Assembly order follows PROMPT_GUIDE.md rules:
/// 1. Camera — establishes the sensor/rendering base
/// 2. Film stock — establishes colour and tonal character
/// 3. Lens — adds optical rendering on top
/// 4. Fine-tuning layers (grain, bloom, basic editor)
class GenerationPromptBuilder {
  const GenerationPromptBuilder();

  /// Builds a prompt from [state] by concatenating each enabled layer's fragment.
  ///
  /// Empty fragments are excluded. Returns an empty string if no layers are
  /// enabled or all fragments are empty.
  String build(EditState state) {
    final parts = <String>[
      // Camera establishes the sensor/rendering base.
      if (state.cameraProfile != null && state.cameraEnabled)
        state.cameraProfile!.toPromptFragment(),

      // Film stock establishes colour and tonal character.
      if (state.filmStock != null && state.stockEnabled)
        state.filmStock!.toPromptFragment(),

      // Lens adds optical character on top.
      if (state.lensProfile != null && state.lensEnabled)
        state.lensProfile!.toPromptFragment(),

      // Fine-tuning layers.
      if (state.grainEnabled) state.grain.toPromptFragment(),
      if (state.bloomEnabled) state.bloom.toPromptFragment(),
      if (state.basicEditorEnabled) state.basicEditor.toPromptFragment(),
    ].where((s) => s.isNotEmpty).toList();

    return parts.join(', ');
  }
}
