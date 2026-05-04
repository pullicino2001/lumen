import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../models/edit_state.dart';
import '../models/gallery_entry.dart';
import '../services/gallery_service.dart';

final galleryServiceProvider = Provider((_) => GalleryService());

class GalleryNotifier extends StateNotifier<List<GalleryEntry>> {
  GalleryNotifier(this._service) : super([]) {
    _load();
  }

  final GalleryService _service;

  Future<void> _load() async {
    state = await _service.loadAll();
  }

  Future<GalleryEntry> addEntry(EditState editState) async {
    final entry = await _service.createEntry(editState);
    state = [entry, ...state.where((e) => e.id != entry.id)];
    return entry;
  }

  Future<GalleryEntry> addSnapshot(
    String entryId,
    EditState editState, {
    String? exportedPath,
  }) async {
    final updated = await _service.addSnapshot(
      entryId,
      editState,
      exportedPath: exportedPath,
    );
    state = state.map((e) => e.id == entryId ? updated : e).toList();
    return updated;
  }
}

final galleryProvider =
    StateNotifierProvider<GalleryNotifier, List<GalleryEntry>>(
  (ref) => GalleryNotifier(ref.read(galleryServiceProvider)),
);
