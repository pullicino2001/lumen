import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../core/models/gallery_entry.dart';
import '../../../core/providers/gallery_provider.dart';
import '../../../shared/theme/lumen_theme.dart';
import 'gallery_detail_screen.dart';

class GalleryScreen extends ConsumerWidget {
  const GalleryScreen({
    super.key,
    required this.onImport,
    required this.onOpenEntry,
  });

  final VoidCallback onImport;
  final void Function(GalleryEntry entry) onOpenEntry;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final entries = ref.watch(galleryProvider);
    final topPad = MediaQuery.paddingOf(context).top;

    return Scaffold(
      backgroundColor: kBg,
      body: Column(
        children: [
          SizedBox(height: topPad),
          _Header(onImport: onImport),
          Expanded(
            child: entries.isEmpty
                ? _EmptyState(onImport: onImport)
                : GridView.builder(
                    padding: const EdgeInsets.all(2),
                    gridDelegate:
                        const SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 3,
                      crossAxisSpacing: 2,
                      mainAxisSpacing: 2,
                    ),
                    itemCount: entries.length,
                    itemBuilder: (context, i) => _Tile(
                      entry: entries[i],
                      onTap: () => _openDetail(context, ref, entries[i]),
                    ),
                  ),
          ),
        ],
      ),
    );
  }

  void _openDetail(BuildContext context, WidgetRef ref, GalleryEntry entry) {
    Navigator.of(context).push(MaterialPageRoute<void>(
      builder: (_) => GalleryDetailScreen(
        entry: entry,
        onEdit: onOpenEntry,
      ),
    ));
  }
}

class _Header extends StatelessWidget {
  const _Header({required this.onImport});
  final VoidCallback onImport;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(18, 14, 14, 14),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.end,
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text('Lumen', style: monoStyle(size: 8, letterSpacing: 3)),
              const SizedBox(height: 2),
              const Text(
                'Gallery',
                style: TextStyle(
                  fontFamily: 'Georgia',
                  fontStyle: FontStyle.italic,
                  fontSize: 28,
                  color: kText,
                  letterSpacing: 0,
                ),
              ),
            ],
          ),
          const Spacer(),
          GestureDetector(
            onTap: () {
              HapticFeedback.selectionClick();
              onImport();
            },
            child: Container(
              width: 36,
              height: 36,
              decoration: BoxDecoration(
                color: kAmber,
                borderRadius: BorderRadius.circular(8),
                boxShadow: [
                  BoxShadow(
                      color: kAmber.withValues(alpha: 0.4), blurRadius: 18)
                ],
              ),
              child: const Center(
                child: Icon(Icons.add, size: 20, color: Color(0xFF1A0F06)),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _Tile extends StatelessWidget {
  const _Tile({required this.entry, required this.onTap});
  final GalleryEntry entry;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final thumbExists = File(entry.thumbPath).existsSync();
    return GestureDetector(
      onTap: onTap,
      child: Stack(
        fit: StackFit.expand,
        children: [
          thumbExists
              ? Image.file(File(entry.thumbPath), fit: BoxFit.cover)
              : const ColoredBox(color: kSheet),
          if (entry.history.isNotEmpty)
            Positioned(
              top: 5,
              right: 5,
              child: Container(
                padding:
                    const EdgeInsets.symmetric(horizontal: 5, vertical: 2),
                decoration: BoxDecoration(
                  color: Colors.black.withValues(alpha: 0.6),
                  borderRadius: BorderRadius.circular(3),
                ),
                child: Text(
                  '${entry.history.length}',
                  style: monoStyle(size: 7, color: kAmber, letterSpacing: 0),
                ),
              ),
            ),
        ],
      ),
    );
  }
}

class _EmptyState extends StatelessWidget {
  const _EmptyState({required this.onImport});
  final VoidCallback onImport;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text('No photos yet',
              style: monoStyle(size: 10, color: kMute, letterSpacing: 2)),
          const SizedBox(height: 24),
          GestureDetector(
            onTap: onImport,
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
              decoration: BoxDecoration(
                border: Border.all(color: kAmber.withValues(alpha: 0.6)),
                borderRadius: BorderRadius.circular(4),
              ),
              child: Text(
                'IMPORT PHOTO',
                style:
                    monoStyle(size: 10, color: kAmber, letterSpacing: 2.5),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
