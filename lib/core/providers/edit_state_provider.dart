import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../models/edit_state.dart';
import '../models/basic_editor_settings.dart';
import '../models/bloom_settings.dart';
import '../models/film_stock.dart';
import '../models/grain_settings.dart';
import '../models/import_profile.dart';
import '../models/lens_profile.dart';

/// Notifier that manages the full [EditState] for the active edit session.
///
/// Null means no photo is currently loaded.
class EditStateNotifier extends Notifier<EditState?> {
  @override
  EditState? build() => null;

  /// Loads a new photo into the editor, replacing any existing session.
  void load(String originalPath, String workingPath, String proxyPath) {
    state = EditState(
      originalFilePath: originalPath,
      workingFilePath: workingPath,
      proxyFilePath: proxyPath,
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

  /// Sets the active film stock. Pass null to clear.
  void setStock(FilmStock? stock) {
    state = state?.copyWith(filmStock: stock);
  }

  /// Sets the active lens profile. Pass null to clear.
  void setLensProfile(LensProfile? profile) {
    state = state?.copyWith(lensProfile: profile);
  }

  /// Updates grain settings.
  void updateGrain(GrainSettings settings) {
    state = state?.copyWith(grain: settings);
  }

  /// Updates bloom/halation settings.
  void updateBloom(BloomSettings settings) {
    state = state?.copyWith(bloom: settings);
  }

  /// Toggles the stock layer on/off.
  void toggleStock() {
    state = state?.copyWith(stockEnabled: !(state?.stockEnabled ?? true));
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

  /// Toggles the LUMEN Look on/off.
  void toggleLumenLook() {
    if (state == null) return;
    final next = state!.importProfile == ImportProfile.lumen
        ? ImportProfile.standard
        : ImportProfile.lumen;
    state = state!.copyWith(importProfile: next);
  }

  /// Records the path to the LUMEN-processed proxy.
  /// Guards against stale callbacks from a previous session.
  void setLumenProxyPath(String sourceProxyPath, String lumenPath) {
    if (state?.proxyFilePath == sourceProxyPath) {
      state = state!.copyWith(lumenProxyPath: lumenPath);
    }
  }
}

final editStateProvider =
    NotifierProvider<EditStateNotifier, EditState?>(() => EditStateNotifier());
