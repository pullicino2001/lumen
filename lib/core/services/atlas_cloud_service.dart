import 'dart:convert';
import 'dart:io';
import 'dart:typed_data';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:http/http.dart' as http;
import 'package:path_provider/path_provider.dart';
import 'package:path/path.dart' as p;

/// Calls the Atlas Cloud image generation API (async submit → poll pattern).
///
/// Submit: POST /api/v1/model/generateImage → prediction ID
/// Poll:   GET  /api/v1/model/prediction/{id} every 2s until completed/failed
class AtlasCloudService {
  static const String _kBase = 'https://api.atlascloud.ai/api/v1';
  static const String _kSubmit = '$_kBase/model/generateImage';
  static const String _kPoll = '$_kBase/model/prediction';

  static const int _kPollIntervalMs = 2000;
  static const int _kTimeoutMs = 120000; // 2 minutes

  String? get _apiKey => dotenv.env['ATLAS_API_KEY'];

  Map<String, String> get _headers => {
        'Authorization': 'Bearer ${_apiKey ?? ''}',
        'Content-Type': 'application/json',
      };

  /// Submits an img2img job to Atlas Cloud and polls until the result is ready.
  /// Returns the local file path of the downloaded result image.
  Future<String> simulateWithUrlFallback({
    required String imagePath,
    required String prompt,
    double strength = 0.75,
  }) async {
    final key = _apiKey;
    if (key == null || key.isEmpty || key == 'your_atlas_cloud_api_key_here') {
      throw const AtlasCloudException(
          'ATLAS_API_KEY is not set in .env — add your Atlas Cloud API key.');
    }

    final imageBytes = await File(imagePath).readAsBytes();
    final base64Image = base64Encode(imageBytes);
    final ext = p.extension(imagePath).replaceFirst('.', '').toLowerCase();
    final mimeType = ext == 'png' ? 'image/png' : 'image/jpeg';

    // Step 1: submit
    final submitResponse = await http.post(
      Uri.parse(_kSubmit),
      headers: _headers,
      body: jsonEncode({
        'model': 'black-forest-labs/flux-kontext-dev',
        'image': 'data:$mimeType;base64,$base64Image',
        'prompt': prompt,
        'strength': strength,
        'guidance_scale': 3.5,
        'num_inference_steps': 28,
        'output_format': 'jpeg',
      }),
    );

    if (submitResponse.statusCode != 200 && submitResponse.statusCode != 201) {
      throw AtlasCloudException(
          'Atlas Cloud submit failed ${submitResponse.statusCode}: ${submitResponse.body}');
    }

    final submitJson = jsonDecode(submitResponse.body) as Map<String, dynamic>;
    final predictionId = _extractPredictionId(submitJson);

    // Step 2: poll
    final deadline = DateTime.now().add(const Duration(milliseconds: _kTimeoutMs));
    while (DateTime.now().isBefore(deadline)) {
      await Future.delayed(const Duration(milliseconds: _kPollIntervalMs));

      final pollResponse = await http.get(
        Uri.parse('$_kPoll/$predictionId'),
        headers: _headers,
      );

      if (pollResponse.statusCode != 200) {
        throw AtlasCloudException(
            'Atlas Cloud poll failed ${pollResponse.statusCode}: ${pollResponse.body}');
      }

      final pollJson = jsonDecode(pollResponse.body) as Map<String, dynamic>;
      final status = pollJson['status'] as String? ?? '';

      if (status == 'completed') {
        final url = _extractOutputUrl(pollJson);
        return _downloadAndSave(url);
      }

      if (status == 'failed') {
        final error = pollJson['error'] ?? pollJson['message'] ?? 'unknown error';
        throw AtlasCloudException('Atlas Cloud generation failed: $error');
      }
      // status == 'processing' → keep polling
    }

    throw const AtlasCloudException('Atlas Cloud timed out after 2 minutes');
  }

  String _extractPredictionId(Map<String, dynamic> json) {
    // { "data": { "id": "..." } }  or  { "id": "..." }
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
    // { "outputs": ["https://..."] }  or  { "urls": { "output": "..." } }
    final outputs = json['outputs'];
    if (outputs is List && outputs.isNotEmpty) {
      final first = outputs.first;
      if (first is String && first.isNotEmpty) return first;
    }
    final urls = json['urls'];
    if (urls is Map<String, dynamic>) {
      final url = urls['output'];
      if (url is String && url.isNotEmpty) return url;
    }
    throw AtlasCloudException(
        'Could not find output URL in completed response: $json');
  }

  Future<String> _downloadAndSave(String url) async {
    final response = await http.get(Uri.parse(url));
    if (response.statusCode != 200) {
      throw AtlasCloudException(
          'Failed to download result image from $url (${response.statusCode})');
    }
    return _saveBytes(response.bodyBytes);
  }

  Future<String> _saveBytes(Uint8List bytes) async {
    final tmp = await getTemporaryDirectory();
    final name = 'sim_${DateTime.now().millisecondsSinceEpoch}.jpg';
    final file = File(p.join(tmp.path, name));
    await file.writeAsBytes(bytes);
    return file.path;
  }
}

class AtlasCloudException implements Exception {
  const AtlasCloudException(this.message);
  final String message;

  @override
  String toString() => 'AtlasCloudException: $message';
}
