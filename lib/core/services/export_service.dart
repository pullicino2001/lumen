import 'dart:io';
import 'package:image/image.dart' as img;
import 'package:path/path.dart' as p;
import 'package:path_provider/path_provider.dart';
import 'package:logger/logger.dart';
import '../models/edit_state.dart';

/// Exports the final processed image to the device's pictures directory.
class ExportService {
  ExportService();

  static final _log = Logger();

  /// Exports [processedImage] derived from [state] as a full-resolution JPEG.
  ///
  /// Returns the path of the saved file.
  Future<String> export(img.Image processedImage, EditState state) async {
    final picturesDir = await getExternalStorageDirectory();
    final outputDir = Directory(
      p.join(picturesDir?.path ?? (await getApplicationDocumentsDirectory()).path, 'LUMEN'),
    );
    await outputDir.create(recursive: true);

    final baseName = p.basenameWithoutExtension(state.originalFilePath);
    final timestamp = DateTime.now().millisecondsSinceEpoch;
    final outputPath = p.join(outputDir.path, '${baseName}_lumen_$timestamp.jpg');

    final encoded = img.encodeJpg(processedImage, quality: 97);
    await File(outputPath).writeAsBytes(encoded);

    _log.d('ExportService: saved to $outputPath');
    return outputPath;
  }
}
