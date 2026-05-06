import 'dart:async';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../models/edit_state.dart';
import '../models/basic_editor_settings.dart';
import '../models/bloom_settings.dart';
import '../models/film_stock.dart';
import '../models/grain_settings.dart';
import '../models/import_profile.dart';
import '../models/lens_profile.dart';
import 'gallery_provider.dart';

/// Tracks whether undo/redo is available. Updated by [EditStateNotifier].
final undoAvailabilityProvider =
    StateProvider<({bool canUndo, bool canRedo})>(
  (ref) => (canUndo: false, canRedo: false),
);

/// Manages the full [EditState] for the active edit session.
///
/// - All edits are auto-saved to the current gallery entry (debounced 600 ms).
/// - Slider-type edits (updateBasicEditor, updateGrain, updateBloom) batch into
///   a single undo step per gesture; discrete operations push immediately.
class EditStateNotifier extends Notifier<EditState?> {
  final List<EditState> _undoStack = [];
  final List<EditState> _redoStack = [];

  /// State captured at the start of a continuous edit gesture (slider drag).
  EditState? _pendingUndoState;

  String? _entryId;
  Timer? _saveTimer;
  Timer? _undoDebounceTimer;

  @override
  EditState? build() => null;

  // ── Entry tracking ────────────────────────────────────────────────────────

  void setEntryId(String? id) => _entryId = id;

  // ── Undo / Redo ───────────────────────────────────────────────────────────

  bool get canUndo => _undoStack.isNotEmpty;
  bool get canRedo => _redoStack.isNotEmpty;

  void undo() {
    if (_undoStack.isEmpty) return;
    _undoDebounceTimer?.cancel();
    _pendingUndoState = null;
    _redoStack.add(state!);
    state = _undoStack.removeLast();
    _updateUndoAvailability();
    _scheduleAutoSave();
  }

  void redo() {
    if (_redoStack.isEmpty) return;
    _undoStack.add(state!);
    state = _redoStack.removeLast();
    _updateUndoAvailability();
    _scheduleAutoSave();
  }

  void _updateUndoAvailability() {
    ref.read(undoAvailabilityProvider.notifier).state = (
      canUndo: _undoStack.isNotEmpty,
      canRedo: _redoStack.isNotEmpty,
    );
  }

  /// For continuous edits (sliders): captures the pre-gesture state once and
  /// commits it to the undo stack after 600 ms of inactivity.
  void _beginContinuousEdit() {
    _pendingUndoState ??= state;
    _undoDebounceTimer?.cancel();
    _undoDebounceTimer = Timer(const Duration(milliseconds: 600), () {
      if (_pendingUndoState != null) {
        _undoStack.add(_pendingUndoState!);
        if (_undoStack.length > 50) _undoStack.removeAt(0);
        _redoStack.clear();
        _pendingUndoState = null;
        _updateUndoAvailability();
      }
    });
  }

  /// For discrete operations (toggles, stock/lens changes): pushes immediately.
  void _pushUndoImmediate() {
    _undoDebounceTimer?.cancel();
    _pendingUndoState = null;
    if (state != null) {
      _undoStack.add(state!);
      if (_undoStack.length > 50) _undoStack.removeAt(0);
      _redoStack.clear();
      _updateUndoAvailability();
    }
  }

  void _resetUndoState() {
    _undoStack.clear();
    _redoStack.clear();
    _pendingUndoState = null;
    _undoDebounceTimer?.cancel();
    _saveTimer?.cancel();
    _updateUndoAvailability();
  }

  // ── Auto-save ─────────────────────────────────────────────────────────────

  void _scheduleAutoSave() {
    _saveTimer?.cancel();
    _saveTimer = Timer(const Duration(milliseconds: 600), () async {
      final s = state;
      final id = _entryId;
      if (s == null || id == null) return;
      try {
        final updated =
            await ref.read(galleryServiceProvider).updateCurrentState(id, s);
        ref.read(galleryProvider.notifier).updateEntry(updated);
      } catch (_) {}
    });
  }

  // ── Session lifecycle ─────────────────────────────────────────────────────

  void load(String originalPath, String workingPath, String proxyPath) {
    _resetUndoState();
    _entryId = null;
    state = EditState(
      originalFilePath: originalPath,
      workingFilePath: workingPath,
      proxyFilePath: proxyPath,
    );
  }

  void restore(EditState editState) {
    _resetUndoState();
    state = editState;
  }

  void clear() {
    _resetUndoState();
    _entryId = null;
    state = null;
  }

  // ── Edit operations ───────────────────────────────────────────────────────

  void updateBasicEditor(BasicEditorSettings settings) {
    _beginContinuousEdit();
    state = state?.copyWith(basicEditor: settings);
    _scheduleAutoSave();
  }

  void toggleBasicEditor() {
    _pushUndoImmediate();
    state = state?.copyWith(basicEditorEnabled: !(state?.basicEditorEnabled ?? true));
    _scheduleAutoSave();
  }

  void setStock(FilmStock? stock) {
    _pushUndoImmediate();
    state = state?.copyWith(filmStock: stock);
    _scheduleAutoSave();
  }

  void setLensProfile(LensProfile? profile) {
    _pushUndoImmediate();
    state = state?.copyWith(lensProfile: profile);
    _scheduleAutoSave();
  }

  void updateGrain(GrainSettings settings) {
    _beginContinuousEdit();
    state = state?.copyWith(grain: settings);
    _scheduleAutoSave();
  }

  void updateBloom(BloomSettings settings) {
    _beginContinuousEdit();
    state = state?.copyWith(bloom: settings);
    _scheduleAutoSave();
  }

  void toggleStock() {
    _pushUndoImmediate();
    state = state?.copyWith(stockEnabled: !(state?.stockEnabled ?? true));
    _scheduleAutoSave();
  }

  void toggleGrain() {
    _pushUndoImmediate();
    state = state?.copyWith(grainEnabled: !(state?.grainEnabled ?? true));
    _scheduleAutoSave();
  }

  void toggleBloom() {
    _pushUndoImmediate();
    state = state?.copyWith(bloomEnabled: !(state?.bloomEnabled ?? true));
    _scheduleAutoSave();
  }

  void toggleLens() {
    _pushUndoImmediate();
    state = state?.copyWith(lensEnabled: !(state?.lensEnabled ?? true));
    _scheduleAutoSave();
  }

  void toggleLumenLook() {
    if (state == null) return;
    _pushUndoImmediate();
    final next = state!.importProfile == ImportProfile.lumen
        ? ImportProfile.standard
        : ImportProfile.lumen;
    state = state!.copyWith(importProfile: next);
    _scheduleAutoSave();
  }

  /// Records the path to the LUMEN-processed proxy.
  /// Guards against stale callbacks from a previous session.
  void setLumenProxyPath(String sourceProxyPath, String lumenPath) {
    if (state?.proxyFilePath == sourceProxyPath) {
      state = state!.copyWith(lumenProxyPath: lumenPath);
    }
  }

  /// Loads an AI-generated result into the editor as the new working file.
  /// The original file path is preserved; the result becomes the new working
  /// and proxy path so all subsequent edits layer on top of the generation.
  void loadGeneratedResult(String resultPath) {
    if (state == null) return;
    _pushUndoImmediate();
    state = state!.copyWith(
      workingFilePath: resultPath,
      proxyFilePath: resultPath,
    );
    _scheduleAutoSave();
  }
}

final editStateProvider =
    NotifierProvider<EditStateNotifier, EditState?>(() => EditStateNotifier());
