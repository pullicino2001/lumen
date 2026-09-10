import 'dart:io';
import 'package:flutter_test/flutter_test.dart';
import 'package:lumen/core/models/basic_editor_settings.dart';
import 'package:lumen/core/models/edit_state.dart';
import 'package:lumen/core/services/gallery_service.dart';

void main() {
  late Directory docs;
  late GalleryService service;
  late EditState state;

  setUp(() async {
    docs = await Directory.systemTemp.createTemp('lumen_gallery_test');
    service = GalleryService(documentsDirectory: () async => docs);
    final working = File('${docs.path}/working.png')..writeAsBytesSync([1]);
    final proxy = File('${docs.path}/proxy.jpg')..writeAsBytesSync([2]);
    state = EditState(
      originalFilePath: '${docs.path}/orig.jpg',
      workingFilePath: working.path,
      proxyFilePath: proxy.path,
    );
  });

  tearDown(() async => docs.delete(recursive: true));

  test('createEntry copies files and patches paths to permanent storage', () async {
    final entry = await service.createEntry(state);
    expect(File(entry.sourcePath).existsSync(), isTrue);
    expect(File(entry.thumbPath).existsSync(), isTrue);
    expect(entry.currentEditStateJson['workingFilePath'], entry.sourcePath);
    expect(entry.currentEditStateJson['proxyFilePath'], entry.thumbPath);
    expect(entry.currentEditStateJson['lumenProxyPath'], isNull);

    final all = await service.loadAll();
    expect(all.map((e) => e.id), [entry.id]);
  });

  test('concurrent snapshots and auto-saves never lose an update', () async {
    final entry = await service.createEntry(state);

    // Fire many overlapping mutations without awaiting between them.
    final futures = <Future<void>>[];
    for (var i = 0; i < 10; i++) {
      futures.add(service.addSnapshot(entry.id, state, exportedPath: '/e$i'));
      futures.add(service.updateCurrentState(
        entry.id,
        state.copyWith(basicEditor: BasicEditorSettings(exposure: i.toDouble())),
      ));
    }
    await Future.wait(futures);

    final reloaded = (await service.loadAll()).single;
    expect(reloaded.history.length, 10);
    expect(reloaded.history.map((s) => s.exportedPath).toSet().length, 10);
    // Last write wins for the current state.
    expect(reloaded.currentEditStateJson['basicEditor']['exposure'], 9.0);
  });

  test('index is written atomically (no temp file left behind)', () async {
    await service.createEntry(state);
    final dir = Directory('${docs.path}/lumen_gallery');
    final names = dir.listSync().map((f) => f.uri.pathSegments.last).toList();
    expect(names, contains('index.json'));
    expect(names.where((n) => n.endsWith('.tmp')), isEmpty);
  });

  test('a corrupt index is quarantined and loadAll returns empty', () async {
    await service.createEntry(state);
    final index = File('${docs.path}/lumen_gallery/index.json');
    await index.writeAsString('{not json');
    expect(await service.loadAll(), isEmpty);
    expect(File('${index.path}.corrupt').existsSync(), isTrue);
  });
}
