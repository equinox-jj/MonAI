import 'dart:typed_data';

import 'package:flutter_image_compress/flutter_image_compress.dart';
import 'package:monai/core/base/error/exceptions.dart';

typedef CompressImage = Future<Uint8List?> Function(
  String path, {
  required int quality,
  required int minSide,
});

typedef CompressAvatar = Future<Uint8List?> Function(
  String path, {
  required int quality,
  required int side,
});

abstract class ImageCompressorService {
  /// A JPEG under the upload limit, turned upright, without EXIF data. Throws an
  /// [UnknownException] coded `unreadable_image` or `photo_too_large`.
  Future<Uint8List> compressForUpload(String path);
  Future<Uint8List> compressAvatar(String path);
  Future<Uint8List> compressLogo(String path);
}

class ImageCompressorServiceImpl implements ImageCompressorService {
  /// [compress] and [compressAvatar] replace the platform compressor in
  /// tests.
  ImageCompressorServiceImpl({
    CompressImage? compress,
    CompressAvatar? compressAvatar,
  }) : _compress = compress ?? _flutterImageCompress,
       _compressAvatar = compressAvatar ?? _flutterAvatarCompress;

  /// The upload limit of `POST /transactions/receipt`.
  static const maxBytes = 5 * 1024 * 1024;

  /// The JPEG quality tried first; text stays sharp at this level.
  static const quality = 80;

  /// The quality tried once when the first is over [maxBytes].
  static const fallbackQuality = 55;
  static const minSide = 1600;

  /// The upload limit of `PUT /me/avatar`.
  static const avatarMaxBytes = 2 * 1024 * 1024;
  static const avatarSide = 512;
  static const avatarQuality = 85;

  /// The upload limit of `PUT /admin/payment-providers/{id}/logo`.
  static const logoMaxBytes = 512 * 1024;

  /// A logo's longest side, in pixels; logos show at most 48 dp, so this
  /// stays sharp on any screen.
  static const logoSide = 256;

  /// The WebP quality of a logo: the highest, since logos are small and
  /// flat.
  static const logoQuality = 100;

  final CompressImage _compress;
  final CompressAvatar _compressAvatar;

  static Future<Uint8List?> _flutterAvatarCompress(
    String path, {
    required int quality,
    required int side,
  }) => FlutterImageCompress.compressWithFile(
    path,
    minWidth: side,
    minHeight: side,
    quality: quality,
    format: CompressFormat.webp,
  );

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

  @override
  Future<Uint8List> compressAvatar(String path) => _webp(
    path,
    quality: avatarQuality,
    side: avatarSide,
    max: avatarMaxBytes,
  );

  @override
  Future<Uint8List> compressLogo(String path) =>
      _webp(path, quality: logoQuality, side: logoSide, max: logoMaxBytes);

  Future<Uint8List> _webp(
    String path, {
    required int quality,
    required int side,
    required int max,
  }) async {
    final bytes = await _compressAvatar(path, quality: quality, side: side);
    if (bytes == null) {
      throw const UnknownException(
        message: "The photo couldn't be read",
        code: 'unreadable_image',
      );
    }
    if (bytes.length > max) {
      throw const UnknownException(
        message: 'The photo is too large',
        code: 'photo_too_large',
      );
    }
    return bytes;
  }
}
