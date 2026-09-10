import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'dart:typed_data';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:http/http.dart' as http;
import 'package:logger/logger.dart';
import 'package:path_provider/path_provider.dart';
import 'package:path/path.dart' as p;
import 'ai_model_config_service.dart';

/// Calls the Atlas Cloud image generation API (async submit → poll pattern).
///
/// Submit: POST {base}/model/generateImage → prediction ID
/// Poll:   GET  {base}/model/prediction/{id} every 2s until completed/failed
///
/// Model ID, endpoint, and parameters are read from [AiModelConfigService]
/// when the configured provider is `atlas`; otherwise the hardcoded Atlas
/// defaults are used. A config for another provider (e.g. Replicate) is
/// ignored with a warning rather than being sent to the wrong API.
class AtlasCloudService {
  AtlasCloudService({
    AiModelConfigService? modelConfig,
    http.Client? client,
    Future<Directory> Function()? tempDirectory,
    Duration pollInterval = _kDefaultPollInterval,
  })  : _modelConfig = modelConfig,
        _client = client ?? http.Client(),
        _tempDirectory = tempDirectory ?? getTemporaryDirectory,
        _pollInterval = pollInterval;

  /// Provider name expected in `ai_model_config.json` for this service.
  static const String kProvider = 'atlas';

  static const String _kDefaultBase = 'https://api.atlascloud.ai/api/v1';
  static const String _kDefaultSubmitPath = '/model/generateImage';
  static const String _kDefaultPollSegment = 'prediction';
  static const String _kDefaultModel = 'black-forest-labs/flux-kontext-dev';
  static const String _kDefaultApiKeyEnv = 'ATLAS_API_KEY';

  static const Duration _kDefaultPollInterval = Duration(seconds: 2);
  static const Duration _kJobTimeout = Duration(minutes: 2);
  static const Duration _kRequestTimeout = Duration(seconds: 30);
  static const Duration _kDownloadTimeout = Duration(seconds: 60);

  static final _log = Logger();

  final AiModelConfigService? _modelConfig;
  final http.Client _client;
  final Future<Directory> Function() _tempDirectory;
  final Duration _pollInterval;
  bool _warnedProviderMismatch = false;

  /// The generation slot config, but only if it targets this provider.
  AiModelSlotConfig? get _cfg {
    final cfg = _modelConfig?.generation;
    if (cfg == null) return null;
    if (cfg.provider.toLowerCase() != kProvider) {
      if (!_warnedProviderMismatch) {
        _warnedProviderMismatch = true;
        _log.w('AtlasCloudService: ai_model_config.json generation provider '
            'is "${cfg.provider}", expected "$kProvider" — using built-in '
            'Atlas defaults instead.');
      }
      return null;
    }
    return cfg;
  }

  /// Name of the environment variable (in .env) holding the API key.
  String get apiKeyEnv {
    final env = _cfg?.apiKeyEnv;
    return (env != null && env.isNotEmpty) ? env : _kDefaultApiKeyEnv;
  }

  /// Reads the API key from the loaded .env. Returns null when dotenv was
  /// never initialised (e.g. in unit tests) instead of throwing.
  String? get _apiKey => dotenv.isInitialized ? dotenv.env[apiKeyEnv] : null;

  Map<String, String> get _headers => {
        'Authorization': 'Bearer ${_apiKey ?? ''}',
        'Content-Type': 'application/json',
      };

  /// Full URL the img2img job is POSTed to.
  String get submitUrl {
    final endpoint = _cfg?.endpoint;
    if (endpoint != null && endpoint.isNotEmpty) return endpoint;
    return '$_kDefaultBase$_kDefaultSubmitPath';
  }

  /// Full URL polled for the status of [predictionId].
  String pollUrl(String predictionId) =>
      '${derivePollBase(submitUrl)}/$predictionId';

  /// Derives the poll base URL from the submit URL by replacing the last
  /// path segment (`generateImage`) with `prediction`, preserving scheme,
  /// host, port and any API-version prefix such as `/api/v1`.
  static String derivePollBase(String submitUrl) {
    final uri = Uri.parse(submitUrl);
    final segments =
        uri.pathSegments.where((s) => s.isNotEmpty).toList(growable: true);
    if (segments.isEmpty) {
      segments.addAll(['model', _kDefaultPollSegment]);
    } else {
      segments[segments.length - 1] = _kDefaultPollSegment;
    }
    return uri.replace(pathSegments: segments, query: null).toString();
  }

  /// Model identifier sent with each job.
  String get modelId {
    final id = _cfg?.modelId;
    return (id != null && id.isNotEmpty) ? id : _kDefaultModel;
  }

  Map<String, dynamic> get _defaultParameters {
    final params = _cfg?.parameters;
    if (params != null && params.isNotEmpty) return params;
    return const {
      'guidance_scale': 3.5,
      'num_inference_steps': 28,
      'output_format': 'jpeg',
    };
  }

  /// Submits an img2img job and polls until the result is ready.
  ///
  /// Pass an [isCancelled] callback to support cooperative cancellation —
  /// the poll loop checks it before each poll and stops if it returns true.
  ///
  /// Returns the local file path of the downloaded result image.
  Future<String> simulateWithUrlFallback({
    required String imagePath,
    required String prompt,
    double strength = 0.75,
    bool Function()? isCancelled,
  }) async {
    final key = _apiKey;
    if (key == null || key.isEmpty || key == 'your_atlas_cloud_api_key_here') {
      throw AtlasCloudException(
          '$apiKeyEnv is not set in .env — add your Atlas Cloud API key.');
    }

    final imageBytes = await File(imagePath).readAsBytes();
    final base64Image = base64Encode(imageBytes);
    final ext = p.extension(imagePath).replaceFirst('.', '').toLowerCase();
    final mimeType = ext == 'png' ? 'image/png' : 'image/jpeg';

    // Step 1: submit. Config parameters are spread first so they can never
    // override the per-request fields (model, image, prompt, strength).
    final submitBody = <String, dynamic>{
      ..._defaultParameters,
      'model': modelId,
      'image': 'data:$mimeType;base64,$base64Image',
      'prompt': prompt,
      'strength': strength,
    };

    final submitResponse = await _guard(
      () => _client.post(
        Uri.parse(submitUrl),
        headers: _headers,
        body: jsonEncode(submitBody),
      ),
      _kRequestTimeout,
      'submit',
    );

    if (submitResponse.statusCode != 200 && submitResponse.statusCode != 201) {
      throw AtlasCloudException(
          'Atlas Cloud submit failed ${submitResponse.statusCode}: ${submitResponse.body}');
    }

    final submitJson = _decodeObject(submitResponse.body, 'submit');
    final predictionId = _extractPredictionId(submitJson);

    // Step 2: poll with cancellation support
    final deadline = DateTime.now().add(_kJobTimeout);
    while (DateTime.now().isBefore(deadline)) {
      if (isCancelled != null && isCancelled()) {
        throw const AtlasCloudCancelledException();
      }

      await Future<void>.delayed(_pollInterval);

      if (isCancelled != null && isCancelled()) {
        throw const AtlasCloudCancelledException();
      }

      final pollResponse = await _guard(
        () => _client.get(Uri.parse(pollUrl(predictionId)), headers: _headers),
        _kRequestTimeout,
        'poll',
      );

      if (pollResponse.statusCode != 200) {
        throw AtlasCloudException(
            'Atlas Cloud poll failed ${pollResponse.statusCode}: ${pollResponse.body}');
      }

      final pollJson = _decodeObject(pollResponse.body, 'poll');
      final status = (pollJson['status'] as String? ?? '').toLowerCase();

      if (status == 'completed' || status == 'succeeded') {
        final url = _extractOutputUrl(pollJson);
        return _downloadAndSave(url);
      }

      if (status == 'failed' || status == 'error' || status == 'canceled') {
        final error = pollJson['error'] ?? pollJson['message'] ?? 'unknown error';
        throw AtlasCloudException('Atlas Cloud generation failed: $error');
      }
      // Any other status (queued/processing/starting) → keep polling
    }

    throw AtlasCloudException(
        'Atlas Cloud timed out after ${_kJobTimeout.inMinutes} minutes');
  }

  /// Runs [request] with a [timeout], translating network-level failures
  /// into [AtlasCloudException] so callers see a single error type.
  Future<http.Response> _guard(
    Future<http.Response> Function() request,
    Duration timeout,
    String stage,
  ) async {
    try {
      return await request().timeout(timeout);
    } on TimeoutException {
      throw AtlasCloudException(
          'Atlas Cloud $stage request timed out after ${timeout.inSeconds}s');
    } on http.ClientException catch (e) {
      throw AtlasCloudException('Atlas Cloud $stage request failed: ${e.message}');
    } on SocketException catch (e) {
      throw AtlasCloudException(
          'Atlas Cloud $stage request failed: ${e.message} — check your connection');
    }
  }

  Map<String, dynamic> _decodeObject(String body, String stage) {
    try {
      final decoded = jsonDecode(body);
      if (decoded is Map<String, dynamic>) return decoded;
    } on FormatException {
      // fall through
    }
    throw AtlasCloudException(
        'Atlas Cloud $stage response was not a JSON object: $body');
  }

  String _extractPredictionId(Map<String, dynamic> json) {
    final data = json['data'];
    if (data is Map<String, dynamic>) {
      final id = data['id'];
      if (id is String && id.isNotEmpty) return id;
    }
    final id = json['id'];
    if (id is String && id.isNotEmpty) return id;
    throw AtlasCloudException(
        'Could not find prediction ID in response: $json');
  }

  String _extractOutputUrl(Map<String, dynamic> json) {
    // Atlas responses may nest the payload under "data".
    final data = json['data'];
    if (data is Map<String, dynamic>) {
      final nested = _tryExtractOutputUrl(data);
      if (nested != null) return nested;
    }
    final url = _tryExtractOutputUrl(json);
    if (url != null) return url;
    throw AtlasCloudException(
        'Could not find output URL in completed response: $json');
  }

  String? _tryExtractOutputUrl(Map<String, dynamic> json) {
    final outputs = json['outputs'];
    if (outputs is List && outputs.isNotEmpty) {
      final first = outputs.first;
      if (first is String && first.isNotEmpty) return first;
    }
    final output = json['output'];
    if (output is String && output.isNotEmpty) return output;
    if (output is List && output.isNotEmpty) {
      final first = output.first;
      if (first is String && first.isNotEmpty) return first;
    }
    final urls = json['urls'];
    if (urls is Map<String, dynamic>) {
      final url = urls['output'];
      if (url is String && url.isNotEmpty) return url;
    }
    return null;
  }

  Future<String> _downloadAndSave(String url) async {
    final response = await _guard(
      () => _client.get(Uri.parse(url)),
      _kDownloadTimeout,
      'download',
    );
    if (response.statusCode != 200) {
      throw AtlasCloudException(
          'Failed to download result image from $url (${response.statusCode})');
    }
    final ext = _extensionFor(response.headers['content-type'], url);
    return _saveBytes(response.bodyBytes, ext);
  }

  /// Picks a file extension from the Content-Type header, falling back to the
  /// URL's own extension, then to jpg.
  static String _extensionFor(String? contentType, String url) {
    final ct = (contentType ?? '').toLowerCase();
    if (ct.contains('image/png')) return 'png';
    if (ct.contains('image/webp')) return 'webp';
    if (ct.contains('image/jpeg') || ct.contains('image/jpg')) return 'jpg';
    final urlExt = p.extension(Uri.parse(url).path).replaceFirst('.', '').toLowerCase();
    if (urlExt == 'png' || urlExt == 'webp' || urlExt == 'jpg' || urlExt == 'jpeg') {
      return urlExt == 'jpeg' ? 'jpg' : urlExt;
    }
    return 'jpg';
  }

  Future<String> _saveBytes(Uint8List bytes, String ext) async {
    final tmp = await _tempDirectory();
    final name = 'sim_${DateTime.now().millisecondsSinceEpoch}.$ext';
    final file = File(p.join(tmp.path, name));
    await file.writeAsBytes(bytes, flush: true);
    return file.path;
  }
}

class AtlasCloudException implements Exception {
  const AtlasCloudException(this.message);
  final String message;

  @override
  String toString() => 'AtlasCloudException: $message';
}

/// Thrown when a generation job is cancelled via the [isCancelled] callback.
class AtlasCloudCancelledException implements Exception {
  const AtlasCloudCancelledException();

  @override
  String toString() => 'AtlasCloudCancelledException: job was cancelled';
}
