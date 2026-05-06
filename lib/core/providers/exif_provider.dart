import 'dart:io';
import 'package:flutter/foundation.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:image/image.dart' as img;
import 'edit_state_provider.dart';

class ImageExifData {
  const ImageExifData({
    this.focalLength,
    this.fNumber,
    this.shutterSpeed,
    this.iso,
  });
  final int? focalLength;
  final double? fNumber;
  final String? shutterSpeed;
  final int? iso;

  bool get isEmpty =>
      focalLength == null && fNumber == null && shutterSpeed == null && iso == null;
}

ImageExifData _parseExif(Uint8List bytes) {
  final decoded = img.decodeImage(bytes);
  if (decoded == null) return const ImageExifData();

  final exifSub = decoded.exif.exifIfd;

  // Prefer 35mm equivalent focal length
  int? focalLength = exifSub['FocalLengthIn35mmFilm']?.toInt();
  if (focalLength == null || focalLength == 0) {
    focalLength = exifSub['FocalLength']?.toDouble().round();
  }

  final fNum = exifSub['FNumber']?.toDouble();

  String? shutter;
  final shutterVal = exifSub['ExposureTime']?.toDouble();
  if (shutterVal != null && shutterVal > 0) {
    if (shutterVal >= 1) {
      shutter = '${shutterVal.toStringAsFixed(shutterVal < 10 ? 1 : 0)}s';
    } else {
      shutter = '1/${(1 / shutterVal).round()}';
    }
  }

  final iso = exifSub['ISOSpeed']?.toInt();

  return ImageExifData(
    focalLength: (focalLength != null && focalLength > 0) ? focalLength : null,
    fNumber: (fNum != null && fNum > 0) ? fNum : null,
    shutterSpeed: shutter,
    iso: (iso != null && iso > 0) ? iso : null,
  );
}

/// Reads EXIF metadata from the original source file in a background isolate.
final exifDataProvider = FutureProvider<ImageExifData?>((ref) async {
  final path = ref.watch(editStateProvider.select((s) => s?.originalFilePath));
  if (path == null) return null;
  final bytes = await File(path).readAsBytes();
  return compute(_parseExif, bytes);
});
