import '../models/edit_state.dart';

/// Translates a full [EditState] into a plain-text prompt string suitable
/// for submission to the active AI generation model.
///
/// All [toPromptFragment()] calls return empty strings in v1.
/// This class is fully implemented in v4.
class GenerationPromptBuilder {
  const GenerationPromptBuilder();

  /// Builds a prompt from [state] by concatenating each layer's fragment.
  String build(EditState state) {
    final parts = <String>[
      if (state.lensProfile != null && state.lensEnabled)
        state.lensProfile!.toPromptFragment(),
      if (state.filmLook != null && state.filmLookEnabled)
        state.filmLook!.toPromptFragment(),
      if (state.grainEnabled) state.grain.toPromptFragment(),
      if (state.bloomEnabled) state.bloom.toPromptFragment(),
      if (state.basicEditorEnabled) state.basicEditor.toPromptFragment(),
    ].where((s) => s.isNotEmpty).toList();

    return parts.join(', ');
  }
}
