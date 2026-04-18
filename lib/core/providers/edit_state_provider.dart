import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../models/edit_state.dart';
import '../models/basic_editor_settings.dart';
import '../models/film_look.dart';
import '../models/grain_settings.dart';
import '../models/lens_profile.dart';

/// Notifier that manages the full [EditState] for the active edit session.
///
/// Null means no photo is currently loaded.
class EditStateNotifier extends Notifier<EditState?> {
  @override
  EditState? build() => null;

  /// Loads a new photo into the editor, replacing any existing session.
  void load(String originalPath, String workingPath) {
    state = EditState(
      originalFilePath: originalPath,
      workingFilePath: workingPath,
    );
  }

  /// Clears the current edit session.
  void clear() => state = null;

  /// Updates the basic editor settings.
  void updateBasicEditor(BasicEditorSettings settings) {
    state = state?.copyWith(basicEditor: settings);
  }

  /// Toggles the basic editor layer on/off.
  void toggleBasicEditor() {
    state = state?.copyWith(basicEditorEnabled: !(state?.basicEditorEnabled ?? true));
  }

  /// Sets the active film look. Pass null to clear.
  void setFilmLook(FilmLook? look) {
    state = state?.copyWith(filmLook: look);
  }

  /// Sets the active lens profile. Pass null to clear.
  void setLensProfile(LensProfile? profile) {
    state = state?.copyWith(lensProfile: profile);
  }

  /// Updates grain settings.
  void updateGrain(GrainSettings settings) {
    state = state?.copyWith(grain: settings);
  }

  /// Toggles the film look layer on/off.
  void toggleFilmLook() {
    state = state?.copyWith(filmLookEnabled: !(state?.filmLookEnabled ?? true));
  }

  /// Toggles the grain layer on/off.
  void toggleGrain() {
    state = state?.copyWith(grainEnabled: !(state?.grainEnabled ?? true));
  }

  /// Toggles the bloom/halation layer on/off.
  void toggleBloom() {
    state = state?.copyWith(bloomEnabled: !(state?.bloomEnabled ?? true));
  }

  /// Toggles the lens profile layer on/off.
  void toggleLens() {
    state = state?.copyWith(lensEnabled: !(state?.lensEnabled ?? true));
  }
}

final editStateProvider =
    NotifierProvider<EditStateNotifier, EditState?>(() => EditStateNotifier());
