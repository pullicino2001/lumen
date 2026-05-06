import 'package:flutter_test/flutter_test.dart';
import 'package:lumen/core/data/camera_profiles.dart';
import 'package:lumen/core/data/film_stocks.dart';
import 'package:lumen/core/data/lens_profiles.dart';
import 'package:lumen/core/models/edit_state.dart';
import 'package:lumen/core/services/generation_prompt_builder.dart';

void main() {
  group('GenerationPromptBuilder', () {
    const builder = GenerationPromptBuilder();

    test('assembles camera + film stock + lens in correct order', () {
      // Leica M11 + Summilux 50 f/1.4 + Portra 400 — the definitive combination
      final m11 = kCameraProfiles.firstWhere((c) => c.id == 'leica_m11');
      final portra400 = kFilmStocks.firstWhere((s) => s.id == 'portra_400');
      final summilux50 =
          kLensProfiles.firstWhere((l) => l.id == 'summilux_50_wide');

      final state = EditState(
        originalFilePath: '/test/image.dng',
        workingFilePath: '/test/working.dng',
        proxyFilePath: '/test/proxy.jpg',
        cameraProfile: m11,
        filmStock: portra400,
        lensProfile: summilux50,
        cameraEnabled: true,
        stockEnabled: true,
        lensEnabled: true,
        grainEnabled: false,
        bloomEnabled: false,
        basicEditorEnabled: false,
      );

      final prompt = builder.build(state);

      // Must be non-empty
      expect(prompt, isNotEmpty);

      // Must contain key phrases from all three fragments
      expect(prompt, contains('Leica M11'));
      expect(prompt, contains('Summilux'));
      expect(prompt, contains('Portra 400'));

      // Camera fragment must appear before film stock fragment
      final cameraPos = prompt.indexOf('Leica M11');
      final stockPos = prompt.indexOf('Portra 400');
      final lensPos = prompt.indexOf('Summilux');
      expect(cameraPos, lessThan(stockPos),
          reason: 'Camera fragment must come before film stock fragment');
      expect(stockPos, lessThan(lensPos),
          reason: 'Film stock fragment must come before lens fragment');

      // Print the assembled prompt for review
      // ignore: avoid_print
      print('\n── Assembled Generation Prompt ──────────────────────────────');
      // ignore: avoid_print
      print(prompt);
      // ignore: avoid_print
      print('─────────────────────────────────────────────────────────────\n');
    });

    test('excludes disabled layers', () {
      final m11 = kCameraProfiles.firstWhere((c) => c.id == 'leica_m11');
      final portra400 = kFilmStocks.firstWhere((s) => s.id == 'portra_400');

      final state = EditState(
        originalFilePath: '/test/image.dng',
        workingFilePath: '/test/working.dng',
        proxyFilePath: '/test/proxy.jpg',
        cameraProfile: m11,
        filmStock: portra400,
        cameraEnabled: false,
        stockEnabled: true,
        lensEnabled: false,
        grainEnabled: false,
        bloomEnabled: false,
        basicEditorEnabled: false,
      );

      final prompt = builder.build(state);

      expect(prompt, isNotEmpty);
      expect(prompt, isNot(contains('Leica M11')));
      expect(prompt, contains('Portra 400'));
    });

    test('returns empty string when all layers are disabled', () {
      final state = EditState(
        originalFilePath: '/test/image.dng',
        workingFilePath: '/test/working.dng',
        proxyFilePath: '/test/proxy.jpg',
        cameraEnabled: false,
        stockEnabled: false,
        lensEnabled: false,
        grainEnabled: false,
        bloomEnabled: false,
        basicEditorEnabled: false,
      );

      expect(builder.build(state), isEmpty);
    });

    test('all kFilmStocks have non-empty promptFragments', () {
      for (final stock in kFilmStocks) {
        expect(stock.promptFragment, isNotEmpty,
            reason: 'Film stock ${stock.id} has empty promptFragment');
        expect(stock.toPromptFragment(), equals(stock.promptFragment),
            reason:
                'toPromptFragment() must return promptFragment for ${stock.id}');
      }
    });

    test('all kLensProfiles have non-empty promptFragments', () {
      for (final lens in kLensProfiles) {
        expect(lens.promptFragment, isNotEmpty,
            reason: 'Lens profile ${lens.id} has empty promptFragment');
        expect(lens.toPromptFragment(), equals(lens.promptFragment),
            reason:
                'toPromptFragment() must return promptFragment for ${lens.id}');
      }
    });

    test('all kCameraProfiles have non-empty promptFragments', () {
      for (final camera in kCameraProfiles) {
        expect(camera.promptFragment, isNotEmpty,
            reason: 'Camera profile ${camera.id} has empty promptFragment');
        expect(camera.toPromptFragment(), equals(camera.promptFragment),
            reason:
                'toPromptFragment() must return promptFragment for ${camera.id}');
      }
    });
  });
}
