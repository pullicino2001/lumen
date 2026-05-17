import 'package:flutter_test/flutter_test.dart';
import 'package:lumen/core/constants.dart';
import 'package:lumen/core/models/basic_editor_settings.dart';

void main() {
  group('BasicEditorSettings.toPromptFragment()', () {
    test('returns empty string for neutral settings', () {
      expect(const BasicEditorSettings().toPromptFragment(), isEmpty);
    });

    test('isNeutral is true for default-constructed settings', () {
      expect(const BasicEditorSettings().isNeutral, isTrue);
    });

    test('heavy underexposure produces correct term', () {
      final s = const BasicEditorSettings(exposure: -2.5);
      expect(s.toPromptFragment(), contains('heavily underexposed'));
    });

    test('mild underexposure produces correct term', () {
      final s = const BasicEditorSettings(exposure: -1.0);
      expect(s.toPromptFragment(), contains('underexposed'));
      expect(s.toPromptFragment(), isNot(contains('heavily')));
    });

    test('high exposure produces correct term', () {
      final s = const BasicEditorSettings(exposure: 2.5);
      expect(s.toPromptFragment(), contains('heavily overexposed'));
    });

    test('high contrast produces correct term', () {
      final s = const BasicEditorSettings(contrast: 50.0);
      expect(s.toPromptFragment(), contains('high contrast'));
    });

    test('low contrast produces correct term', () {
      final s = const BasicEditorSettings(contrast: -50.0);
      expect(s.toPromptFragment(), contains('flat'));
    });

    test('cool temperature produces correct term', () {
      final s = const BasicEditorSettings(temperature: 2800);
      expect(s.toPromptFragment(), contains('cool tones'));
    });

    test('warm temperature produces correct term', () {
      final s = const BasicEditorSettings(temperature: 9000);
      expect(s.toPromptFragment(), contains('warm tones'));
    });

    test('neutral temperature produces no term', () {
      // Default is 5500K — well within the neutral range.
      final s = const BasicEditorSettings(temperature: kDefaultTemperature);
      expect(s.toPromptFragment(), isEmpty);
    });

    test('high saturation produces correct term', () {
      final s = const BasicEditorSettings(saturation: 60.0);
      expect(s.toPromptFragment(), contains('vivid colors'));
    });

    test('desaturation produces correct term', () {
      final s = const BasicEditorSettings(saturation: -60.0);
      expect(s.toPromptFragment(), contains('desaturated'));
    });

    test('multiple non-neutral params are all included', () {
      final s = const BasicEditorSettings(
        exposure: -1.5,
        contrast: 50.0,
        temperature: 2500,
      );
      final fragment = s.toPromptFragment();
      expect(fragment, contains('underexposed'));
      expect(fragment, contains('high contrast'));
      expect(fragment, contains('cool tones'));
    });

    test('results are comma-separated', () {
      final s = const BasicEditorSettings(exposure: -1.0, contrast: 50.0);
      final fragment = s.toPromptFragment();
      expect(fragment, contains(','));
    });
  });
}
