import 'dart:io';
import 'dart:ui' as ui;
import 'package:gal/gal.dart';
import 'package:image/image.dart' as img;
import 'package:path/path.dart' as p;
import 'package:path_provider/path_provider.dart';
import 'package:logger/logger.dart';
import '../models/edit_state.dart';

enum ExportFormat { jpeg, png, tiff }

extension ExportFormatExt on ExportFormat {
  String get extension => switch (this) {
    ExportFormat.jpeg => 'jpg',
    ExportFormat.png  => 'png',
    ExportFormat.tiff => 'tiff',
  };

  String get label => switch (this) {
    ExportFormat.jpeg => 'JPEG',
    ExportFormat.png  => 'PNG',
    ExportFormat.tiff => 'TIFF',
  };
}

/// Encodes a GPU-rendered [ui.Image] and saves it to the LUMEN folder.
class ExportService {
  ExportService();

  static final _log = Logger();

  Future<String> export(
    ui.Image processedImage,
    EditState state, {
    ExportFormat format = ExportFormat.jpeg,
    int jpegQuality = 95,
  }) async {
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

    final List<int> encoded = switch (format) {
      ExportFormat.jpeg => img.encodeJpg(imgImage, quality: jpegQuality),
      ExportFormat.png  => img.encodePng(imgImage, level: 0),
      ExportFormat.tiff => img.encodeTiff(imgImage),
    };

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
    final outputPath = p.join(
      outputDir.path,
      '${baseName}_lumen_$timestamp.${format.extension}',
    );

    await File(outputPath).writeAsBytes(encoded);
    _log.d('ExportService: saved $outputPath');

    // Also save to device gallery (visible in Photos / Gallery app).
    try {
      await Gal.putImage(outputPath, album: 'LUMEN');
    } catch (e) {
      _log.w('ExportService: gal save failed — $e');
    }

    return outputPath;
  }
}
