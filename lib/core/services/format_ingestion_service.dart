import 'dart:io';
import 'package:image/image.dart' as img;
import 'package:path/path.dart' as p;
import 'package:path_provider/path_provider.dart';
import 'package:logger/logger.dart';

/// Result of a successful ingestion — full-res working copy and downscaled proxy.
class IngestionResult {
  const IngestionResult({required this.workingPath, required this.proxyPath});
  final String workingPath;
  final String proxyPath;
}

/// Converts any supported input format into the internal working format.
///
/// Produces two outputs:
/// - A full-resolution lossless PNG (used only for final export).
/// - A JPEG proxy ≤ [_proxyLongEdge]px (used for all live preview rendering).
///
/// The original file is never modified.
class FormatIngestionService {
  FormatIngestionService();

  static final _log = Logger();
  static const _proxyLongEdge = 2048;

  /// Ingests the file at [sourcePath] and returns [IngestionResult] with both
  /// the full-res working path and the downscaled proxy path.
  ///
  /// Throws [FormatIngestionException] if the file cannot be decoded.
  Future<IngestionResult> ingest(String sourcePath) async {
    _log.d('FormatIngestionService: ingesting $sourcePath');

    final sourceFile = File(sourcePath);
    if (!sourceFile.existsSync()) {
      throw FormatIngestionException('File not found: $sourcePath');
    }

    final bytes = await sourceFile.readAsBytes();
    final decoded = img.decodeImage(bytes);

    if (decoded == null) {
      throw FormatIngestionException(
        'Could not decode image: ${p.basename(sourcePath)}. '
        'The format may not be supported.',
      );
    }

    final tempDir = await getTemporaryDirectory();
    final workingDir = Directory(p.join(tempDir.path, 'lumen_working'));
    await workingDir.create(recursive: true);

    final baseName = p.basenameWithoutExtension(sourcePath);

    final workingPath = await _writeWorkingCopy(decoded, workingDir, baseName);
    final proxyPath   = await _writeProxy(decoded, workingDir, baseName);

    _log.d('FormatIngestionService: working=$workingPath  proxy=$proxyPath');
    return IngestionResult(workingPath: workingPath, proxyPath: proxyPath);
  }

  Future<String> _writeWorkingCopy(
      img.Image image, Directory dir, String baseName) async {
    final path = p.join(dir.path, '${baseName}_working.png');
    final encoded = img.encodePng(image, level: 0);
    await File(path).writeAsBytes(encoded);
    return path;
  }

  Future<String> _writeProxy(
      img.Image image, Directory dir, String baseName) async {
    final long = image.width > image.height ? image.width : image.height;
    final proxy = long > _proxyLongEdge
        ? (image.width >= image.height
            ? img.copyResize(image,
                width: _proxyLongEdge, interpolation: img.Interpolation.linear)
            : img.copyResize(image,
                height: _proxyLongEdge, interpolation: img.Interpolation.linear))
        : image;

    final path = p.join(dir.path, '${baseName}_proxy.jpg');
    final encoded = img.encodeJpg(proxy, quality: 85);
    await File(path).writeAsBytes(encoded);
    return path;
  }
}

/// Thrown when [FormatIngestionService] cannot decode an input file.
class FormatIngestionException implements Exception {
  const FormatIngestionException(this.message);

  final String message;

  @override
  String toString() => 'FormatIngestionException: $message';
}
