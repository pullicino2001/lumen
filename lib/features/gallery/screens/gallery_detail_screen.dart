import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../core/models/gallery_entry.dart';
import '../../../core/providers/gallery_provider.dart';
import '../../../shared/theme/lumen_theme.dart';

class GalleryDetailScreen extends ConsumerWidget {
  const GalleryDetailScreen({
    super.key,
    required this.entry,
    required this.onEdit,
  });

  final GalleryEntry entry;
  final void Function(GalleryEntry entry) onEdit;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    // Watch for live updates to this entry (e.g. new snapshots added).
    final liveEntry = ref.watch(
      galleryProvider.select(
        (list) => list.firstWhere((e) => e.id == entry.id,
            orElse: () => entry),
      ),
    );

    final topPad = MediaQuery.paddingOf(context).top;
    final botPad = MediaQuery.paddingOf(context).bottom;
    final thumbExists = File(liveEntry.thumbPath).existsSync();

    return Scaffold(
      backgroundColor: kBg,
      body: Column(
        children: [
          SizedBox(height: topPad),

          // Back + Edit bar
          Padding(
            padding: const EdgeInsets.fromLTRB(14, 10, 14, 0),
            child: Row(
              children: [
                _NavBtn(
                  onTap: () => Navigator.of(context).pop(),
                  child: const Icon(Icons.chevron_left,
                      size: 20, color: kText),
                ),
                const Spacer(),
                GestureDetector(
                  onTap: () {
                    HapticFeedback.mediumImpact();
                    Navigator.of(context).pop();
                    onEdit(liveEntry);
                  },
                  child: Container(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 18, vertical: 10),
                    decoration: BoxDecoration(
                      color: kAmber,
                      borderRadius: BorderRadius.circular(8),
                      boxShadow: [
                        BoxShadow(
                            color: kAmber.withValues(alpha: 0.4),
                            blurRadius: 18)
                      ],
                    ),
                    child: Text(
                      'EDIT',
                      style: monoStyle(
                          size: 10,
                          color: const Color(0xFF1A0F06),
                          letterSpacing: 2.5),
                    ),
                  ),
                ),
              ],
            ),
          ),

          const SizedBox(height: 16),

          // Thumbnail
          Expanded(
            flex: 3,
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 14),
              child: ClipRRect(
                borderRadius: BorderRadius.circular(12),
                child: thumbExists
                    ? Image.file(File(liveEntry.thumbPath),
                        fit: BoxFit.cover, width: double.infinity)
                    : const ColoredBox(color: kSheet),
              ),
            ),
          ),

          const SizedBox(height: 20),

          // History section
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 18),
            child: Row(
              children: [
                Text('HISTORY',
                    style: monoStyle(size: 8, letterSpacing: 2.5)),
                const SizedBox(width: 8),
                Text(
                  liveEntry.history.isEmpty
                      ? 'No versions yet'
                      : '${liveEntry.history.length} version${liveEntry.history.length == 1 ? '' : 's'}',
                  style: monoStyle(size: 8, color: kMute, letterSpacing: 1),
                ),
              ],
            ),
          ),

          const SizedBox(height: 10),

          if (liveEntry.history.isEmpty)
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 18),
              child: Text(
                'Export a photo to save a version here.',
                style: monoStyle(size: 8, color: kMute, letterSpacing: 0.5),
              ),
            )
          else
            SizedBox(
              height: 88,
              child: ListView.builder(
                scrollDirection: Axis.horizontal,
                padding: const EdgeInsets.symmetric(horizontal: 14),
                // Show newest first
                itemCount: liveEntry.history.length,
                itemBuilder: (context, i) {
                  final snap = liveEntry.history[
                      liveEntry.history.length - 1 - i];
                  return _HistoryCard(
                    label: 'v${liveEntry.history.length - i}',
                    date: snap.savedAt,
                    onTap: () {
                      HapticFeedback.selectionClick();
                      final restoredEntry = GalleryEntry(
                        id: liveEntry.id,
                        sourcePath: liveEntry.sourcePath,
                        thumbPath: liveEntry.thumbPath,
                        currentEditStateJson: snap.editStateJson,
                        importedAt: liveEntry.importedAt,
                        history: liveEntry.history,
                      );
                      // Build an EditState from this snapshot, then hand back
                      // the entry (onEdit will restore it in the editor).
                      Navigator.of(context).pop();
                      onEdit(restoredEntry);
                    },
                  );
                },
              ),
            ),

          SizedBox(height: botPad + 24),
        ],
      ),
    );
  }
}

class _HistoryCard extends StatelessWidget {
  const _HistoryCard({
    required this.label,
    required this.date,
    required this.onTap,
  });

  final String label;
  final DateTime date;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: 76,
        margin: const EdgeInsets.only(right: 8),
        decoration: BoxDecoration(
          color: kSheet,
          borderRadius: BorderRadius.circular(8),
          border:
              Border.all(color: kAmber.withValues(alpha: 0.22), width: 0.5),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              label,
              style: const TextStyle(
                fontFamily: 'Georgia',
                fontStyle: FontStyle.italic,
                fontSize: 20,
                color: kAmber,
              ),
            ),
            const SizedBox(height: 4),
            Text(
              _fmt(date),
              style: monoStyle(size: 7, color: kMute, letterSpacing: 0.5),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }

  String _fmt(DateTime dt) {
    final diff = DateTime.now().difference(dt);
    if (diff.inDays == 0) return 'Today';
    if (diff.inDays == 1) return 'Yesterday';
    if (diff.inDays < 7) return '${diff.inDays}d ago';
    return '${dt.day}/${dt.month}';
  }
}

class _NavBtn extends StatelessWidget {
  const _NavBtn({required this.child, required this.onTap});
  final Widget child;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: 34,
        height: 34,
        decoration: BoxDecoration(
          color: kPanelBg,
          borderRadius: BorderRadius.circular(8),
          border: Border.all(
              color: kAmber.withValues(alpha: 0.16), width: 0.5),
        ),
        child: Center(child: child),
      ),
    );
  }
}
