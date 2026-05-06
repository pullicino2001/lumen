import 'package:flutter_test/flutter_test.dart';
import 'package:lumen/core/data/camera_profiles.dart';
import 'package:lumen/core/data/film_stocks.dart';
import 'package:lumen/core/data/lens_profiles.dart';
import 'package:lumen/core/models/edit_state.dart';
import 'package:lumen/core/services/atlas_cloud_service.dart';
import 'package:lumen/core/services/generation_service.dart';

// Manual stub — avoids pulling in mocktail/mockito.
class _StubAtlasService extends AtlasCloudService {
  String? capturedPrompt;
  double? capturedStrength;
  String? capturedImagePath;

  final String _returnPath;

  _StubAtlasService({String returnPath = '/tmp/result.jpg'})
      : _returnPath = returnPath;

  @override
  Future<String> simulateWithUrlFallback({
    required String imagePath,
    required String prompt,
    double strength = 0.75,
  }) async {
    capturedImagePath = imagePath;
    capturedPrompt = prompt;
    capturedStrength = strength;
    return _returnPath;
  }
}

void main() {
  group('GenerationService', () {
    test('builds prompt from EditState and calls AtlasCloudService', () async {
      final stub = _StubAtlasService(returnPath: '/tmp/gen_result.jpg');
      final service = GenerationService(atlasService: stub);

      final m11 = kCameraProfiles.firstWhere((c) => c.id == 'leica_m11');
      final portra400 = kFilmStocks.firstWhere((s) => s.id == 'portra_400');
      final summilux50 =
          kLensProfiles.firstWhere((l) => l.id == 'summilux_50_wide');

      final state = EditState(
        originalFilePath: '/test/original.dng',
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

      final result = await service.generate(state, strength: 0.80);

      expect(result, equals('/tmp/gen_result.jpg'));
      expect(stub.capturedImagePath, equals('/test/proxy.jpg'));
      expect(stub.capturedStrength, equals(0.80));
      expect(stub.capturedPrompt, isNotEmpty);
      expect(stub.capturedPrompt, contains('Leica M11'));
      expect(stub.capturedPrompt, contains('Portra 400'));
      expect(stub.capturedPrompt, contains('Summilux'));

      // Camera must come before film stock, film stock before lens
      final prompt = stub.capturedPrompt!;
      expect(prompt.indexOf('Leica M11'), lessThan(prompt.indexOf('Portra 400')));
      expect(prompt.indexOf('Portra 400'), lessThan(prompt.indexOf('Summilux')));
    });

    test('passes proxy file path to atlas service', () async {
      final stub = _StubAtlasService();
      final service = GenerationService(atlasService: stub);

      final state = EditState(
        originalFilePath: '/photos/raw.dng',
        workingFilePath: '/photos/working.dng',
        proxyFilePath: '/photos/proxy_small.jpg',
        grainEnabled: false,
        bloomEnabled: false,
        basicEditorEnabled: false,
      );

      await service.generate(state);

      expect(stub.capturedImagePath, equals('/photos/proxy_small.jpg'));
    });

    test('uses default strength of 0.75 when not specified', () async {
      final stub = _StubAtlasService();
      final service = GenerationService(atlasService: stub);

      final state = EditState(
        originalFilePath: '/test/original.dng',
        workingFilePath: '/test/working.dng',
        proxyFilePath: '/test/proxy.jpg',
        grainEnabled: false,
        bloomEnabled: false,
        basicEditorEnabled: false,
      );

      await service.generate(state);

      expect(stub.capturedStrength, equals(0.75));
    });

    test('returns empty prompt when all layers disabled', () async {
      final stub = _StubAtlasService();
      final service = GenerationService(atlasService: stub);

      final state = EditState(
        originalFilePath: '/test/original.dng',
        workingFilePath: '/test/working.dng',
        proxyFilePath: '/test/proxy.jpg',
        cameraEnabled: false,
        stockEnabled: false,
        lensEnabled: false,
        grainEnabled: false,
        bloomEnabled: false,
        basicEditorEnabled: false,
      );

      await service.generate(state);

      expect(stub.capturedPrompt, isEmpty);
    });
  });
}
