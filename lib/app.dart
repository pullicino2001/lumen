import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'features/editor/screens/editor_screen.dart';
import 'shared/theme/app_theme.dart';

/// Root widget. Wraps the app in [ProviderScope] for Riverpod.
class LumenApp extends StatelessWidget {
  const LumenApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'LUMEN',
      debugShowCheckedModeBanner: false,
      theme: AppTheme.dark,
      home: const EditorScreen(),
    );
  }
}
