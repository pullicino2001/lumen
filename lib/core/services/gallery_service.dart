import 'dart:convert';
import 'dart:io';
import 'package:path/path.dart' as p;
import 'package:path_provider/path_provider.dart';
import '../models/edit_state.dart';
import '../models/gallery_entry.dart';

class GalleryService {
  static const _indexFile = 'index.json';

  Future<Directory> _galleryDir() async {
    final docs = await getApplicationDocumentsDirectory();
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
    if (!file.existsSync()) return [];
    try {
      final raw = jsonDecode(file.readAsStringSync()) as List;
      return raw
          .map((e) => GalleryEntry.fromJson(
              Map<String, dynamic>.from(e as Map)))
          .toList();
    } catch (_) {
      return [];
    }
  }

  Future<void> _persist(List<GalleryEntry> entries) async {
    final file = await _indexFile_();
    file.writeAsStringSync(
        jsonEncode(entries.map((e) => e.toJson()).toList()));
  }

  /// Copies source/thumb to permanent storage and returns a new [GalleryEntry].
  Future<GalleryEntry> createEntry(EditState state) async {
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
      currentEditStateJson: permanentState.toJson(),
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
      editStateJson: patched.toJson(),
      exportedPath: exportedPath,
    );

    final updated = entry.copyWith(
      currentEditStateJson: patched.toJson(),
      history: [...entry.history, snapshot],
    );

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
