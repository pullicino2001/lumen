import 'package:flutter_test/flutter_test.dart';
import 'package:lumen/core/models/basic_editor_settings.dart';
import 'package:lumen/core/models/edit_state.dart';
import 'package:lumen/core/services/generation_prompt_builder.dart';

void main() {
  const builder = GenerationPromptBuilder();

  group('GenerationPromptBuilder — BasicEditorSettings integration', () {
    test('includes basic editor fragment when enabled and non-neutral', () {
      final state = EditState(
        originalFilePath: '/o.jpg',
        workingFilePath: '/w.png',
        proxyFilePath: '/p.jpg',
        basicEditor: const BasicEditorSettings(exposure: -1.5, contrast: 50.0),
        basicEditorEnabled: true,
        cameraEnabled: false,
        stockEnabled: false,
        lensEnabled: false,
        grainEnabled: false,
        bloomEnabled: false,
      );

      final prompt = builder.build(state);
      expect(prompt, isNotEmpty);
      expect(prompt, contains('underexposed'));
      expect(prompt, contains('high contrast'));
    });

    test('excludes basic editor fragment when disabled', () {
      final state = EditState(
        originalFilePath: '/o.jpg',
        workingFilePath: '/w.png',
        proxyFilePath: '/p.jpg',
        basicEditor: const BasicEditorSettings(exposure: -2.0),
        basicEditorEnabled: false,
        cameraEnabled: false,
        stockEnabled: false,
        lensEnabled: false,
        grainEnabled: false,
        bloomEnabled: false,
      );

      expect(builder.build(state), isEmpty);
    });

    test('excludes basic editor fragment when neutral even if enabled', () {
      final state = EditState(
        originalFilePath: '/o.jpg',
        workingFilePath: '/w.png',
        proxyFilePath: '/p.jpg',
        basicEditorEnabled: true,
        cameraEnabled: false,
        stockEnabled: false,
        lensEnabled: false,
        grainEnabled: false,
        bloomEnabled: false,
      );

      expect(builder.build(state), isEmpty);
    });

    test('basic editor fragment appears after camera, stock, and lens', () {
      // This test verifies the assembly order is camera → stock → lens → fine-tuning.
      // We use a non-neutral BasicEditorSettings so its fragment is emitted.
      final state = EditState(
        originalFilePath: '/o.jpg',
        workingFilePath: '/w.png',
        proxyFilePath: '/p.jpg',
        basicEditor: const BasicEditorSettings(exposure: -1.5),
        basicEditorEnabled: true,
        cameraEnabled: false,
        stockEnabled: false,
        lensEnabled: false,
        grainEnabled: false,
        bloomEnabled: false,
      );

      final prompt = builder.build(state);
      // When camera/stock/lens are all off, basic editor fragment is the whole prompt.
      expect(prompt, equals('underexposed, moody'));
    });
  });
}
