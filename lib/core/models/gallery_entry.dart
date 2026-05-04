/// A single saved version of an edit session.
class EditSnapshot {
  final String id;
  final DateTime savedAt;
  final Map<String, dynamic> editStateJson;
  final String? exportedPath;

  const EditSnapshot({
    required this.id,
    required this.savedAt,
    required this.editStateJson,
    this.exportedPath,
  });

  factory EditSnapshot.fromJson(Map<String, dynamic> j) => EditSnapshot(
        id: j['id'] as String,
        savedAt: DateTime.parse(j['savedAt'] as String),
        editStateJson: Map<String, dynamic>.from(j['editState'] as Map),
        exportedPath: j['exportedPath'] as String?,
      );

  Map<String, dynamic> toJson() => {
        'id': id,
        'savedAt': savedAt.toIso8601String(),
        'editState': editStateJson,
        if (exportedPath != null) 'exportedPath': exportedPath,
      };
}

/// One photo in the Lumen Gallery, with its permanent source copy and edit history.
class GalleryEntry {
  final String id;

  /// Permanent working-format PNG in app documents storage.
  final String sourcePath;

  /// Permanent JPEG thumbnail in app documents storage.
  final String thumbPath;

  /// The most-recently-saved edit state (full EditState JSON).
  final Map<String, dynamic> currentEditStateJson;

  final DateTime importedAt;

  /// Ordered oldest-first list of saved edit snapshots.
  final List<EditSnapshot> history;

  const GalleryEntry({
    required this.id,
    required this.sourcePath,
    required this.thumbPath,
    required this.currentEditStateJson,
    required this.importedAt,
    this.history = const [],
  });

  GalleryEntry copyWith({
    Map<String, dynamic>? currentEditStateJson,
    List<EditSnapshot>? history,
  }) =>
      GalleryEntry(
        id: id,
        sourcePath: sourcePath,
        thumbPath: thumbPath,
        currentEditStateJson:
            currentEditStateJson ?? this.currentEditStateJson,
        importedAt: importedAt,
        history: history ?? this.history,
      );

  factory GalleryEntry.fromJson(Map<String, dynamic> j) => GalleryEntry(
        id: j['id'] as String,
        sourcePath: j['sourcePath'] as String,
        thumbPath: j['thumbPath'] as String,
        currentEditStateJson:
            Map<String, dynamic>.from(j['currentEditState'] as Map),
        importedAt: DateTime.parse(j['importedAt'] as String),
        history: (j['history'] as List<dynamic>)
            .map((e) => EditSnapshot.fromJson(
                Map<String, dynamic>.from(e as Map)))
            .toList(),
      );

  Map<String, dynamic> toJson() => {
        'id': id,
        'sourcePath': sourcePath,
        'thumbPath': thumbPath,
        'currentEditState': currentEditStateJson,
        'importedAt': importedAt.toIso8601String(),
        'history': history.map((e) => e.toJson()).toList(),
      };
}
