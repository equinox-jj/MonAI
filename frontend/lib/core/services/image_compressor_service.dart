import 'dart:typed_data';

import 'package:flutter_image_compress/flutter_image_compress.dart';
import 'package:monai/core/error/exceptions.dart';

/// Shrinks photos before they are uploaded.
abstract class ImageCompressorService {
  /// The image file at [path] as a JPEG under the upload limit, turned
  /// upright, without EXIF data (location, camera).
  ///
  /// Throws an [UnknownException] with `code` `unreadable_image` when the
  /// file can't be decoded, or `photo_too_large` when it stays over the
  /// limit.
  Future<Uint8List> compressForUpload(String path);
}

/// Compresses [path] to a JPEG at [quality] (0 to 100), scaled down so its
/// shorter side is at most [minSide]; null when the image can't be read.
typedef CompressImage = Future<Uint8List?> Function(
  String path, {
  required int quality,
  required int minSide,
});

/// [ImageCompressorService] backed by `flutter_image_compress`.
class ImageCompressorServiceImpl implements ImageCompressorService {
  /// [compress] replaces the platform compressor in tests.
  ImageCompressorServiceImpl({CompressImage? compress})
    : _compress = compress ?? _flutterImageCompress;

  /// The upload limit of `POST /transactions/receipt`.
  static const maxBytes = 5 * 1024 * 1024;

  /// The JPEG quality tried first; text stays sharp at this level.
  static const quality = 80;

  /// The quality tried once when the first is over [maxBytes].
  static const fallbackQuality = 55;

  /// The shorter side, in pixels, the photo is scaled down to.
  static const minSide = 1600;

  final CompressImage _compress;

  static Future<Uint8List?> _flutterImageCompress(
    String path, {
    required int quality,
    required int minSide,
  }) => FlutterImageCompress.compressWithFile(
    path,
    minWidth: minSide,
    minHeight: minSide,
    quality: quality,
  );

  @override
  Future<Uint8List> compressForUpload(String path) async {
    for (final q in const [quality, fallbackQuality]) {
      final bytes = await _compress(path, quality: q, minSide: minSide);
      if (bytes == null) {
        throw const UnknownException(
          message: "The photo couldn't be read",
          code: 'unreadable_image',
        );
      }
      if (bytes.length <= maxBytes) return bytes;
    }
    throw const UnknownException(
      message: 'The photo is too large',
      code: 'photo_too_large',
    );
  }
}
