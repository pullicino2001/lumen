import 'dart:convert';
import 'dart:io';
import 'package:logger/logger.dart';
import 'package:path/path.dart' as p;
import 'package:path_provider/path_provider.dart';
import '../models/edit_state.dart';
import '../models/gallery_entry.dart';

/// Persists gallery entries as a single JSON index plus one directory of
/// image files per entry under the app documents directory.
///
/// Every mutating operation is a read-modify-write of the index. They are
/// serialised through [_serialized] so an auto-save racing an export snapshot
/// (or a second import) can never drop the other's update, and the index is
/// written atomically (temp file + rename) so a crash mid-write never leaves
/// a truncated file behind.
class GalleryService {
  GalleryService({Future<Directory> Function()? documentsDirectory})
      : _documentsDirectory =
            documentsDirectory ?? getApplicationDocumentsDirectory;

  static const _indexFile = 'index.json';
  static final _log = Logger();

  final Future<Directory> Function() _documentsDirectory;

  /// Tail of the mutation queue. Each mutation chains onto the previous one.
  Future<void> _queue = Future<void>.value();

  /// Runs [op] after every previously queued mutation has finished.
  Future<T> _serialized<T>(Future<T> Function() op) {
    final result = _queue.then((_) => op());
    // Keep the chain alive even if op throws; the error still reaches `result`.
    _queue = result.then<void>((_) {}, onError: (Object _) {});
    return result;
  }

  /// Converts [state] to a JSON map made only of plain JSON values.
  ///
  /// The generated toJson() is configured with explicit_to_json, but a
  /// round-trip through the encoder guarantees the in-memory map handed to
  /// GalleryEntry is exactly what would be read back from disk — nested
  /// model objects in the map made EditState.fromJson throw on a type cast
  /// when a freshly imported entry was reopened before an app restart.
  static Map<String, dynamic> _plainJson(EditState state) =>
      jsonDecode(jsonEncode(state.toJson())) as Map<String, dynamic>;

  Future<Directory> _galleryDir() async {
    final docs = await _documentsDirectory();
    final dir = Directory(p.join(docs.path, 'lumen_gallery'));
    await dir.create(recursive: true);
    return dir;
  }

  Future<File> _indexFile_() async {
    final dir = await _galleryDir();
    return File(p.join(dir.path, _indexFile));
  }

  Future<List<GalleryEntry>> loadAll() async {
    final file = await _indexFile_();
    if (!await file.exists()) return [];
    try {
      final raw = jsonDecode(await file.readAsString()) as List;
      return raw
          .map((e) => GalleryEntry.fromJson(
              Map<String, dynamic>.from(e as Map)))
          .toList();
    } catch (e, st) {
      _log.e('Failed to load gallery index — index may be corrupt', error: e, stackTrace: st);
      // Rename the corrupt file so it can be inspected and we start fresh.
      try { await file.rename('${file.path}.corrupt'); } catch (_) {}
      return [];
    }
  }

  /// Writes the index atomically: serialise to a temp file, flush, rename.
  Future<void> _persist(List<GalleryEntry> entries) async {
    final file = await _indexFile_();
    final tmp = File('${file.path}.tmp');
    await tmp.writeAsString(
      jsonEncode(entries.map((e) => e.toJson()).toList()),
      flush: true,
    );
    await tmp.rename(file.path);
  }

  /// Copies source/thumb to permanent storage and returns a new [GalleryEntry].
  Future<GalleryEntry> createEntry(EditState state) =>
      _serialized(() => _createEntry(state));

  Future<GalleryEntry> _createEntry(EditState state) async {
    final dir = await _galleryDir();
    final id = DateTime.now().millisecondsSinceEpoch.toString();
    final entryDir = Directory(p.join(dir.path, id));
    await entryDir.create(recursive: true);

    final sourcePath = p.join(entryDir.path, 'source.png');
    await File(state.workingFilePath).copy(sourcePath);

    final thumbPath = p.join(entryDir.path, 'thumb.jpg');
    await File(state.proxyFilePath).copy(thumbPath);

    // Patch paths so stored JSON always points to permanent gallery files.
    final permanentState = state.copyWith(
      originalFilePath: sourcePath,
      workingFilePath: sourcePath,
      proxyFilePath: thumbPath,
      lumenProxyPath: null,
    );

    final entry = GalleryEntry(
      id: id,
      sourcePath: sourcePath,
      thumbPath: thumbPath,
      currentEditStateJson: _plainJson(permanentState),
      importedAt: DateTime.now(),
    );

    final all = await loadAll();
    all.insert(0, entry);
    await _persist(all);
    return entry;
  }

  /// Saves a snapshot of [state] to the entry's history and updates its current state.
  Future<GalleryEntry> addSnapshot(
    String entryId,
    EditState state, {
    String? exportedPath,
  }) =>
      _serialized(() => _addSnapshot(entryId, state, exportedPath: exportedPath));

  Future<GalleryEntry> _addSnapshot(
    String entryId,
    EditState state, {
    String? exportedPath,
  }) async {
    final all = await loadAll();
    final idx = all.indexWhere((e) => e.id == entryId);
    if (idx < 0) throw StateError('Gallery entry $entryId not found');

    final entry = all[idx];
    final patched = state.copyWith(
      originalFilePath: entry.sourcePath,
      workingFilePath: entry.sourcePath,
      proxyFilePath: entry.thumbPath,
      lumenProxyPath: null,
    );

    final snapshot = EditSnapshot(
      id: '${DateTime.now().millisecondsSinceEpoch}',
      savedAt: DateTime.now(),
      editStateJson: _plainJson(patched),
      exportedPath: exportedPath,
    );

    final updated = entry.copyWith(
      currentEditStateJson: _plainJson(patched),
      history: [...entry.history, snapshot],
    );

    all[idx] = updated;
    await _persist(all);
    return updated;
  }

  /// Updates only the current edit state of an entry — no history snapshot created.
  /// Called automatically as the user edits so changes are always persisted.
  Future<GalleryEntry> updateCurrentState(
    String entryId,
    EditState state,
  ) =>
      _serialized(() => _updateCurrentState(entryId, state));

  Future<GalleryEntry> _updateCurrentState(
    String entryId,
    EditState state,
  ) async {
    final all = await loadAll();
    final idx = all.indexWhere((e) => e.id == entryId);
    if (idx < 0) throw StateError('Gallery entry $entryId not found');

    final entry = all[idx];
    final patched = state.copyWith(
      originalFilePath: entry.sourcePath,
      workingFilePath: entry.sourcePath,
      proxyFilePath: entry.thumbPath,
      lumenProxyPath: null,
    );

    final updated = entry.copyWith(currentEditStateJson: patched.toJson());
    all[idx] = updated;
    await _persist(all);
    return updated;
  }

  /// Reconstructs an [EditState] from a gallery entry, optionally restoring a
  /// specific historical [snapshot]. Paths are always patched to permanent storage.
  EditState buildEditState(GalleryEntry entry, [EditSnapshot? snapshot]) {
    final json = Map<String, dynamic>.from(
        snapshot?.editStateJson ?? entry.currentEditStateJson);
    json['originalFilePath'] = entry.sourcePath;
    json['workingFilePath'] = entry.sourcePath;
    json['proxyFilePath'] = entry.thumbPath;
    json['lumenProxyPath'] = null;
    return EditState.fromJson(json);
  }
}
