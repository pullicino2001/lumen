import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'core/models/gallery_entry.dart';
import 'core/providers/edit_state_provider.dart';
import 'core/providers/gallery_provider.dart';
import 'features/editor/screens/editor_screen.dart';
import 'features/gallery/screens/gallery_screen.dart';
import 'shared/theme/app_theme.dart';
import 'shared/theme/lumen_theme.dart';

class LumenApp extends StatelessWidget {
  const LumenApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'LUMEN',
      debugShowCheckedModeBanner: false,
      theme: AppTheme.dark,
      home: const _HomeShell(),
    );
  }
}

// ─────────────────────────────────────────────────────────────────────────────
// HOME SHELL — Gallery | Editor bottom-nav
// ─────────────────────────────────────────────────────────────────────────────

class _HomeShell extends ConsumerStatefulWidget {
  const _HomeShell();

  @override
  ConsumerState<_HomeShell> createState() => _HomeShellState();
}

class _HomeShellState extends ConsumerState<_HomeShell> {
  int _tab = 0;
  String? _currentEntryId;

  void _onImportFromGallery() {
    // Clear current entry ID so EditorScreen knows this is a fresh import.
    setState(() {
      _currentEntryId = null;
      _tab = 1;
    });
  }

  void _onOpenEntry(GalleryEntry entry) {
    // Restore the entry's edit state then switch to editor.
    final service = ref.read(galleryServiceProvider);
    final editState = service.buildEditState(entry);
    ref.read(editStateProvider.notifier).restore(editState);
    setState(() {
      _currentEntryId = entry.id;
      _tab = 1;
    });
  }

  void _onEntryCreated(String entryId) {
    setState(() => _currentEntryId = entryId);
  }

  void _onBackToGallery() {
    setState(() => _tab = 0);
  }

  @override
  Widget build(BuildContext context) {
    final botPad = MediaQuery.paddingOf(context).bottom;

    return Scaffold(
      backgroundColor: kBg,
      body: IndexedStack(
        index: _tab,
        children: [
          GalleryScreen(
            onImport: _onImportFromGallery,
            onOpenEntry: _onOpenEntry,
          ),
          EditorScreen(
            currentEntryId: _currentEntryId,
            onEntryCreated: _onEntryCreated,
            onBackToGallery: _onBackToGallery,
          ),
        ],
      ),
      bottomNavigationBar: _BottomNav(
        tab: _tab,
        onTab: (i) {
          HapticFeedback.selectionClick();
          setState(() => _tab = i);
        },
        botPad: botPad,
      ),
    );
  }
}

class _BottomNav extends StatelessWidget {
  const _BottomNav({
    required this.tab,
    required this.onTab,
    required this.botPad,
  });

  final int tab;
  final ValueChanged<int> onTab;
  final double botPad;

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: kSheet,
        border: Border(
            top: BorderSide(color: kAmber.withValues(alpha: 0.12), width: 0.5)),
      ),
      child: SafeArea(
        top: false,
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 10),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              _NavItem(
                icon: Icons.photo_library_outlined,
                label: 'GALLERY',
                active: tab == 0,
                onTap: () => onTab(0),
              ),
              _NavItem(
                icon: Icons.tune_outlined,
                label: 'EDITOR',
                active: tab == 1,
                onTap: () => onTab(1),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _NavItem extends StatelessWidget {
  const _NavItem({
    required this.icon,
    required this.label,
    required this.active,
    required this.onTap,
  });

  final IconData icon;
  final String label;
  final bool active;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      behavior: HitTestBehavior.opaque,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 4),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              icon,
              size: 22,
              color: active ? kAmber : kMute,
            ),
            const SizedBox(height: 4),
            Text(
              label,
              style: monoStyle(
                size: 8,
                color: active ? kAmber : kMute,
                letterSpacing: 2,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
