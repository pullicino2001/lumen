import 'dart:io';
import 'dart:ui' as ui;
import 'package:image/image.dart' as img;
import 'package:path/path.dart' as p;
import 'package:path_provider/path_provider.dart';
import 'package:logger/logger.dart';
import '../models/edit_state.dart';

/// Encodes a GPU-rendered [ui.Image] to JPEG and saves it to the LUMEN folder.
class ExportService {
  ExportService();

  static final _log = Logger();

  Future<String> export(ui.Image processedImage, EditState state) async {
    final byteData = await processedImage.toByteData(
      format: ui.ImageByteFormat.rawRgba,
    );
    final buffer = byteData!.buffer;

    final imgImage = img.Image.fromBytes(
      width: processedImage.width,
      height: processedImage.height,
      bytes: buffer,
      numChannels: 4,
      order: img.ChannelOrder.rgba,
    );

    final encoded = img.encodeJpg(imgImage, quality: 97);

    final picturesDir = await getExternalStorageDirectory();
    final outputDir = Directory(
      p.join(
        picturesDir?.path ?? (await getApplicationDocumentsDirectory()).path,
        'LUMEN',
      ),
    );
    await outputDir.create(recursive: true);

    final baseName = p.basenameWithoutExtension(state.originalFilePath);
    final timestamp = DateTime.now().millisecondsSinceEpoch;
    final outputPath = p.join(outputDir.path, '${baseName}_lumen_$timestamp.jpg');

    await File(outputPath).writeAsBytes(encoded);
    _log.d('ExportService: saved $outputPath');
    return outputPath;
  }
}
