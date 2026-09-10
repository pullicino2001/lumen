import 'dart:convert';
import 'dart:io';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:http/http.dart' as http;
import 'package:http/testing.dart';
import 'package:lumen/core/services/ai_model_config_service.dart';
import 'package:lumen/core/services/atlas_cloud_service.dart';

AiModelConfigService _config({
  String provider = 'atlas',
  String endpoint = 'https://example.test/api/v1/model/generateImage',
  String modelId = 'vendor/model-x',
  String apiKeyEnv = 'ATLAS_API_KEY',
  Map<String, dynamic> parameters = const {},
}) =>
    AiModelConfigService.fromJson({
      'generation': {
        'provider': provider,
        'model_id': modelId,
        'endpoint': endpoint,
        'api_key_env': apiKeyEnv,
        'parameters': parameters,
      },
    });

void main() {
  group('AtlasCloudService.derivePollBase', () {
    test('keeps the /api/v1 prefix and swaps the last segment', () {
      expect(
        AtlasCloudService.derivePollBase(
            'https://api.atlascloud.ai/api/v1/model/generateImage'),
        'https://api.atlascloud.ai/api/v1/model/prediction',
      );
    });

    test('preserves scheme, host and port', () {
      expect(
        AtlasCloudService.derivePollBase(
            'http://localhost:8080/v2/model/generateImage'),
        'http://localhost:8080/v2/model/prediction',
      );
    });

    test('falls back to /model/prediction for a bare host', () {
      expect(
        AtlasCloudService.derivePollBase('https://host.test'),
        'https://host.test/model/prediction',
      );
    });
  });

  group('AtlasCloudService config handling', () {
    test('uses built-in defaults when no config is supplied', () {
      final svc = AtlasCloudService();
      expect(svc.submitUrl,
          'https://api.atlascloud.ai/api/v1/model/generateImage');
      expect(svc.pollUrl('abc'),
          'https://api.atlascloud.ai/api/v1/model/prediction/abc');
      expect(svc.modelId, 'black-forest-labs/flux-kontext-dev');
      expect(svc.apiKeyEnv, 'ATLAS_API_KEY');
    });

    test('uses the config when the provider is atlas', () {
      final svc = AtlasCloudService(
          modelConfig: _config(apiKeyEnv: 'MY_KEY'));
      expect(svc.submitUrl, 'https://example.test/api/v1/model/generateImage');
      expect(svc.pollUrl('id1'),
          'https://example.test/api/v1/model/prediction/id1');
      expect(svc.modelId, 'vendor/model-x');
      expect(svc.apiKeyEnv, 'MY_KEY');
    });

    test('ignores a config that targets another provider', () {
      final svc = AtlasCloudService(
        modelConfig: _config(
          provider: 'replicate',
          endpoint: 'https://api.replicate.com/v1/predictions',
          modelId: 'black-forest-labs/flux-1.1-pro',
          apiKeyEnv: 'LUMEN_GENERATION_API_KEY',
        ),
      );
      expect(svc.submitUrl,
          'https://api.atlascloud.ai/api/v1/model/generateImage');
      expect(svc.modelId, 'black-forest-labs/flux-kontext-dev');
      expect(svc.apiKeyEnv, 'ATLAS_API_KEY');
    });
  });

  group('AtlasCloudService.simulateWithUrlFallback', () {
    late Directory tmp;
    late File image;

    setUp(() async {
      tmp = await Directory.systemTemp.createTemp('lumen_atlas_test');
      image = File('${tmp.path}/proxy.jpg');
      await image.writeAsBytes([1, 2, 3, 4]);
      dotenv.testLoad(fileInput: 'ATLAS_API_KEY=test-key\n');
    });

    tearDown(() async {
      await tmp.delete(recursive: true);
    });

    AtlasCloudService build(MockClient client,
            {AiModelConfigService? config}) =>
        AtlasCloudService(
          modelConfig: config,
          client: client,
          tempDirectory: () async => tmp,
          pollInterval: const Duration(milliseconds: 5),
        );

    test('throws when the API key is missing', () async {
      dotenv.testLoad(fileInput: 'OTHER=1\n');
      final svc = build(MockClient((_) async => http.Response('', 500)));
      expect(
        () => svc.simulateWithUrlFallback(imagePath: image.path, prompt: 'p'),
        throwsA(isA<AtlasCloudException>()),
      );
    });

    test('submits, polls until completed, downloads and saves with the '
        'content-type extension', () async {
      var polls = 0;
      Map<String, dynamic>? submitted;
      final client = MockClient((req) async {
        final url = req.url.toString();
        if (req.method == 'POST' &&
            url == 'https://example.test/api/v1/model/generateImage') {
          expect(req.headers['Authorization'], 'Bearer test-key');
          submitted = jsonDecode(req.body) as Map<String, dynamic>;
          return http.Response(jsonEncode({'data': {'id': 'job-1'}}), 200);
        }
        if (req.method == 'GET' &&
            url == 'https://example.test/api/v1/model/prediction/job-1') {
          polls++;
          if (polls < 3) {
            return http.Response(jsonEncode({'status': 'processing'}), 200);
          }
          return http.Response(
            jsonEncode({
              'status': 'completed',
              'outputs': ['https://cdn.test/result'],
            }),
            200,
          );
        }
        if (req.method == 'GET' && url == 'https://cdn.test/result') {
          return http.Response.bytes([9, 8, 7], 200,
              headers: {'content-type': 'image/png'});
        }
        return http.Response('unexpected $url', 404);
      });

      final svc = build(
        client,
        config: _config(parameters: {
          'guidance_scale': 7.5,
          'strength': 0.1, // must not override the per-request strength
          'model': 'evil/override', // must not override the model
        }),
      );

      final path = await svc.simulateWithUrlFallback(
        imagePath: image.path,
        prompt: 'film look',
        strength: 0.8,
      );

      expect(polls, 3);
      expect(path, endsWith('.png'));
      expect(await File(path).readAsBytes(), [9, 8, 7]);

      expect(submitted, isNotNull);
      expect(submitted!['model'], 'vendor/model-x');
      expect(submitted!['prompt'], 'film look');
      expect(submitted!['strength'], 0.8);
      expect(submitted!['guidance_scale'], 7.5);
      expect(submitted!['image'], startsWith('data:image/jpeg;base64,'));
    });

    test('surfaces a failed job as AtlasCloudException', () async {
      final client = MockClient((req) async {
        if (req.method == 'POST') {
          return http.Response(jsonEncode({'id': 'job-2'}), 201);
        }
        return http.Response(
            jsonEncode({'status': 'failed', 'error': 'NSFW'}), 200);
      });
      final svc = build(client);
      expect(
        () => svc.simulateWithUrlFallback(imagePath: image.path, prompt: 'p'),
        throwsA(predicate((e) =>
            e is AtlasCloudException && e.message.contains('NSFW'))),
      );
    });

    test('honours cancellation between polls', () async {
      var polls = 0;
      final client = MockClient((req) async {
        if (req.method == 'POST') {
          return http.Response(jsonEncode({'id': 'job-3'}), 200);
        }
        polls++;
        return http.Response(jsonEncode({'status': 'processing'}), 200);
      });
      final svc = build(client);
      var cancelled = false;
      final future = svc.simulateWithUrlFallback(
        imagePath: image.path,
        prompt: 'p',
        isCancelled: () => cancelled,
      );
      await Future<void>.delayed(const Duration(milliseconds: 20));
      cancelled = true;
      await expectLater(future, throwsA(isA<AtlasCloudCancelledException>()));
      expect(polls, greaterThan(0));
    });

    test('wraps network errors in AtlasCloudException', () async {
      final client = MockClient((_) async => throw http.ClientException('boom'));
      final svc = build(client);
      expect(
        () => svc.simulateWithUrlFallback(imagePath: image.path, prompt: 'p'),
        throwsA(predicate((e) =>
            e is AtlasCloudException && e.message.contains('boom'))),
      );
    });
  });
}
