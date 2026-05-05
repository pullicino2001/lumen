import 'dart:convert';
import 'dart:io';
import 'dart:typed_data';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:http/http.dart' as http;
import 'package:path_provider/path_provider.dart';
import 'package:path/path.dart' as p;

/// Calls the Atlas Cloud Flux Kontext Dev image-to-image endpoint.
///
/// TODO: Verify the exact endpoint path and request/response schema against
///       the Atlas Cloud docs at atlascloud.ai — adjust [_kEndpoint] and
///       [_parseResultBytes] if their convention differs from the pattern below.
class AtlasCloudService {
  static const String _kEndpoint =
      'https://api.atlascloud.ai/v1/image-to-image';

  String? get _apiKey => dotenv.env['ATLAS_API_KEY'];

  /// Sends [imagePath] (JPEG/PNG) with [prompt] to Atlas Cloud and returns the
  /// local path of the result image saved in the app's temp directory.
  ///
  /// Throws [AtlasCloudException] on API errors or missing API key.
  Future<String> simulate({
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
    final ext = p.extension(imagePath).replaceFirst('.', '');
    final mimeType = ext == 'png' ? 'image/png' : 'image/jpeg';

    final body = jsonEncode({
      'model': 'flux-kontext-dev',
      'prompt': prompt,
      'input_image': 'data:$mimeType;base64,$base64Image',
      'strength': strength,
      'guidance_scale': 3.5,
      'num_inference_steps': 28,
      'output_format': 'jpeg',
    });

    final response = await http.post(
      Uri.parse(_kEndpoint),
      headers: {
        'Authorization': 'Bearer $key',
        'Content-Type': 'application/json',
      },
      body: body,
    );

    if (response.statusCode != 200 && response.statusCode != 201) {
      throw AtlasCloudException(
          'Atlas Cloud returned ${response.statusCode}: ${response.body}');
    }

    final resultBytes = _parseResultBytes(response);
    return _saveResult(resultBytes);
  }

  /// Parses the response body to raw image bytes.
  ///
  /// Handles two common patterns:
  ///   1. JSON with `images[0].url` → downloads the image
  ///   2. JSON with `output` as a base64 data URI
  ///   3. Raw binary response body
  Uint8List _parseResultBytes(http.Response response) {
    final contentType = response.headers['content-type'] ?? '';

    if (contentType.contains('application/json')) {
      final json = jsonDecode(response.body) as Map<String, dynamic>;

      // Pattern 1 — { "images": [{"url": "...", ...}] }
      if (json['images'] is List) {
        final images = json['images'] as List;
        if (images.isNotEmpty) {
          final first = images.first as Map<String, dynamic>;
          final url = first['url'] as String?;
          if (url != null) {
            // Synchronous download not ideal but keeps the method simple —
            // the caller already awaits in an async context.
            throw _UrlResultException(url);
          }
          final b64 = first['content'] as String? ?? first['data'] as String?;
          if (b64 != null) return base64Decode(_stripDataUri(b64));
        }
      }

      // Pattern 2 — { "output": "data:image/jpeg;base64,..." }
      final output = json['output'] as String?;
      if (output != null) return base64Decode(_stripDataUri(output));

      throw AtlasCloudException(
          'Unexpected JSON response from Atlas Cloud: ${response.body}');
    }

    // Pattern 3 — raw binary
    return response.bodyBytes;
  }

  String _stripDataUri(String s) {
    final comma = s.indexOf(',');
    return comma >= 0 ? s.substring(comma + 1) : s;
  }

  Future<String> _saveResult(Uint8List bytes) async {
    final tmp = await getTemporaryDirectory();
    final name =
        'sim_${DateTime.now().millisecondsSinceEpoch}.jpg';
    final file = File(p.join(tmp.path, name));
    await file.writeAsBytes(bytes);
    return file.path;
  }

  /// Overload that handles URL-based results by downloading the image first.
  Future<String> simulateWithUrlFallback({
    required String imagePath,
    required String prompt,
    double strength = 0.75,
  }) async {
    try {
      return await simulate(
          imagePath: imagePath, prompt: prompt, strength: strength);
    } on _UrlResultException catch (e) {
      final response = await http.get(Uri.parse(e.url));
      if (response.statusCode != 200) {
        throw AtlasCloudException(
            'Failed to download result image from ${e.url}');
      }
      return _saveResult(response.bodyBytes);
    }
  }
}

class AtlasCloudException implements Exception {
  const AtlasCloudException(this.message);
  final String message;

  @override
  String toString() => 'AtlasCloudException: $message';
}

class _UrlResultException implements Exception {
  const _UrlResultException(this.url);
  final String url;
}
