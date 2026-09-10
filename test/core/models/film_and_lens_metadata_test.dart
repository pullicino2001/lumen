import 'package:flutter_test/flutter_test.dart';
import 'package:lumen/core/data/film_stocks.dart';
import 'package:lumen/core/data/lens_profiles.dart';
import 'package:lumen/core/models/film_stock.dart';
import 'package:lumen/core/models/lens_profile.dart';

void main() {
  group('FilmStock metadata', () {
    test('every bundled stock has a plausible ISO and a unique code', () {
      final codes = <String>{};
      for (final s in kFilmStocks) {
        expect(s.iso, inInclusiveRange(25, 3200), reason: s.id);
        expect(s.displayCode, isNotEmpty, reason: s.id);
        expect(codes.add(s.displayCode), isTrue,
            reason: 'duplicate code ${s.displayCode}');
      }
    });

    test('Portra 400 is ISO 400 (was shown as 160)', () {
      final portra = kFilmStocks.firstWhere((s) => s.id == 'portra_400');
      expect(portra.iso, 400);
      expect(portra.displayCode, 'PT-400');
    });

    test('displayCode derives from id and iso when code is empty', () {
      const s = FilmStock(id: 'kodachrome_64', name: 'K', description: '', iso: 64);
      expect(s.displayCode, 'KO-64');
    });
  });

  group('LensProfile.apertureLabel', () {
    test('parses the aperture out of the display name', () {
      const l = LensProfile(id: 'x', name: 'Noctilux 50 f/0.95', description: '');
      expect(l.apertureLabel, 'f/0.95');
    });

    test('falls back to known apertures for legacy character profiles', () {
      const l = LensProfile(id: 'classic_50', name: 'Classic 50', description: '');
      expect(l.apertureLabel, 'f/1.8');
    });

    test('every bundled lens resolves to a real aperture', () {
      for (final l in kLensProfiles) {
        expect(l.apertureLabel, isNot('f/—'), reason: l.id);
      }
    });
  });
}
