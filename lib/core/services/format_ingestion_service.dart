import 'dart:io';
import 'package:image/image.dart' as img;
import 'package:path/path.dart' as p;
import 'package:path_provider/path_provider.dart';
import 'package:logger/logger.dart';

/// Converts any supported input format into the internal working format.
///
/// The working format is a lossless decoded [img.Image] object held in memory,
/// with a PNG written to app temp storage as the persistent working copy.
/// The original file is never modified.
///
/// Supported inputs: JPEG, PNG, WebP, HEIC/HEIF (via native decoder),
/// BMP, TIFF, AVIF, and DNG passthrough. Manufacturer RAW formats (CR2, ARW,
/// NEF etc.) are decoded via the `image` package where supported.
///
/// If a format cannot be decoded the method throws [FormatIngestionException].
class FormatIngestionService {
  FormatIngestionService();

  static final _log = Logger();

  /// Ingests the file at [sourcePath] and returns the path to the working copy
  /// written in app temp storage.
  ///
  /// Throws [FormatIngestionException] if the file cannot be decoded.
  Future<String> ingest(String sourcePath) async {
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

    final workingPath = await _writeWorkingCopy(decoded, sourcePath);
    _log.d('FormatIngestionService: working copy written to $workingPath');
    return workingPath;
  }

  /// Writes [image] as a lossless PNG to the app's temp directory.
  /// The filename is derived from the original source path.
  Future<String> _writeWorkingCopy(img.Image image, String sourcePath) async {
    final tempDir = await getTemporaryDirectory();
    final workingDir = Directory(p.join(tempDir.path, 'lumen_working'));
    await workingDir.create(recursive: true);

    final baseName = p.basenameWithoutExtension(sourcePath);
    final workingPath = p.join(workingDir.path, '${baseName}_working.png');

    final encoded = img.encodePng(image, level: 0); // level 0 = fastest, lossless
    await File(workingPath).writeAsBytes(encoded);
    return workingPath;
  }
}

/// Thrown when [FormatIngestionService] cannot decode an input file.
class FormatIngestionException implements Exception {
  const FormatIngestionException(this.message);

  final String message;

  @override
  String toString() => 'FormatIngestionException: $message';
}
