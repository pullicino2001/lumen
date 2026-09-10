import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:lumen/core/models/edit_state.dart';
import 'package:lumen/core/models/gallery_entry.dart';
import 'package:lumen/core/providers/edit_state_provider.dart';
import 'package:lumen/core/providers/gallery_provider.dart';
import 'package:lumen/core/services/gallery_service.dart';

// Stub GalleryService that never hits disk.
class _StubGalleryService extends GalleryService {
  @override
  Future<List<GalleryEntry>> loadAll() async => [];

  @override
  Future<GalleryEntry> updateCurrentState(String entryId, EditState state) async {
    return GalleryEntry(
      id: entryId,
      sourcePath: state.workingFilePath,
      thumbPath: state.proxyFilePath,
      currentEditStateJson: state.toJson(),
      importedAt: DateTime.now(),
    );
  }
}

ProviderContainer _makeContainer() {
  return ProviderContainer(
    overrides: [
      galleryServiceProvider.overrideWithValue(_StubGalleryService()),
    ],
  );
}

void main() {
  group('EditStateNotifier — undo/redo', () {
    test('canUndo is false before any edits', () {
      final c = _makeContainer();
      addTearDown(c.dispose);
      c.read(editStateProvider.notifier).load('/o.jpg', '/w.png', '/p.jpg');
      expect(c.read(undoAvailabilityProvider).canUndo, isFalse);
      expect(c.read(undoAvailabilityProvider).canRedo, isFalse);
    });

    test('discrete edit pushes to undo stack immediately', () {
      final c = _makeContainer();
      addTearDown(c.dispose);
      c.read(editStateProvider.notifier).load('/o.jpg', '/w.png', '/p.jpg');

      // toggleGrain is a discrete operation.
      c.read(editStateProvider.notifier).toggleGrain();

      expect(c.read(undoAvailabilityProvider).canUndo, isTrue);
      expect(c.read(undoAvailabilityProvider).canRedo, isFalse);
    });

    test('undo restores previous state', () {
      final c = _makeContainer();
      addTearDown(c.dispose);
      c.read(editStateProvider.notifier).load('/o.jpg', '/w.png', '/p.jpg');

      final before = c.read(editStateProvider)!.grainEnabled;
      c.read(editStateProvider.notifier).toggleGrain();
      final after = c.read(editStateProvider)!.grainEnabled;

      expect(after, isNot(equals(before)));

      c.read(editStateProvider.notifier).undo();
      expect(c.read(editStateProvider)!.grainEnabled, equals(before));
    });

    test('redo re-applies undone edit', () {
      final c = _makeContainer();
      addTearDown(c.dispose);
      c.read(editStateProvider.notifier).load('/o.jpg', '/w.png', '/p.jpg');

      c.read(editStateProvider.notifier).toggleGrain();
      final afterToggle = c.read(editStateProvider)!.grainEnabled;

      c.read(editStateProvider.notifier).undo();
      c.read(editStateProvider.notifier).redo();

      expect(c.read(editStateProvider)!.grainEnabled, equals(afterToggle));
    });

    test('new discrete edit clears redo stack', () {
      final c = _makeContainer();
      addTearDown(c.dispose);
      c.read(editStateProvider.notifier).load('/o.jpg', '/w.png', '/p.jpg');

      c.read(editStateProvider.notifier).toggleGrain();
      c.read(editStateProvider.notifier).undo();
      expect(c.read(undoAvailabilityProvider).canRedo, isTrue);

      // New discrete edit must clear redo.
      c.read(editStateProvider.notifier).toggleBloom();
      expect(c.read(undoAvailabilityProvider).canRedo, isFalse);
    });

    test('undo stack respects 50-entry limit', () {
      final c = _makeContainer();
      addTearDown(c.dispose);
      c.read(editStateProvider.notifier).load('/o.jpg', '/w.png', '/p.jpg');

      // Push 60 discrete edits.
      for (var i = 0; i < 60; i++) {
        c.read(editStateProvider.notifier).toggleGrain();
      }

      // Undo 50 times must succeed.
      for (var i = 0; i < 50; i++) {
        c.read(editStateProvider.notifier).undo();
      }
      // 51st undo must be a no-op.
      expect(c.read(undoAvailabilityProvider).canUndo, isFalse);
    });

    test('load() resets undo and redo stacks', () {
      final c = _makeContainer();
      addTearDown(c.dispose);
      c.read(editStateProvider.notifier).load('/o.jpg', '/w.png', '/p.jpg');
      c.read(editStateProvider.notifier).toggleGrain();

      // Load a new session — stacks must reset.
      c.read(editStateProvider.notifier).load('/other.jpg', '/w2.png', '/p2.jpg');
      expect(c.read(undoAvailabilityProvider).canUndo, isFalse);
      expect(c.read(undoAvailabilityProvider).canRedo, isFalse);
    });

    test('setEntryId updates currentEntryIdProvider', () {
      final c = _makeContainer();
      addTearDown(c.dispose);
      c.read(editStateProvider.notifier).load('/o.jpg', '/w.png', '/p.jpg');

      expect(c.read(currentEntryIdProvider), isNull);
      c.read(editStateProvider.notifier).setEntryId('entry_123');
      expect(c.read(currentEntryIdProvider), equals('entry_123'));
    });
  });
}
