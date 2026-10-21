import 'dart:typed_data';

import 'package:flutter_image_compress/flutter_image_compress.dart';
import 'package:monai/core/base/error/exceptions.dart';

/// Shrinks photos before they are uploaded.
abstract class ImageCompressorService {
  /// The image file at [path] as a JPEG under the upload limit, turned
  /// upright, without EXIF data (location, camera).
  ///
  /// Throws an [UnknownException] with `code` `unreadable_image` when the
  /// file can't be decoded, or `photo_too_large` when it stays over the
  /// limit.
  Future<Uint8List> compressForUpload(String path);

  /// The square image file at [path] as a 512×512 WebP profile photo under
  /// the avatar limit, without EXIF data (location, camera).
  ///
  /// Throws an [UnknownException] with `code` `unreadable_image` when the
  /// file can't be decoded, or `photo_too_large` when it stays over the
  /// limit.
  Future<Uint8List> compressAvatar(String path);

  /// The image file at [path] as a payment provider logo: a WebP at most
  /// 256 px a side, under the logo limit, without EXIF data.
  ///
  /// Throws an [UnknownException] with `code` `unreadable_image` when the
  /// file can't be decoded, or `photo_too_large` when it stays over the
  /// limit.
  Future<Uint8List> compressLogo(String path);
}

/// Compresses [path] to a JPEG at [quality] (0 to 100), scaled down so its
/// shorter side is at most [minSide]; null when the image can't be read.
typedef CompressImage = Future<Uint8List?> Function(
  String path, {
  required int quality,
  required int minSide,
});

/// Compresses [path] to a WebP at [quality] (0 to 100), scaled down to
/// [side] pixels; null when the image can't be read.
typedef CompressAvatar = Future<Uint8List?> Function(
  String path, {
  required int quality,
  required int side,
});

/// [ImageCompressorService] backed by `flutter_image_compress`.
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

  /// The shorter side, in pixels, the photo is scaled down to.
  static const minSide = 1600;

  /// The upload limit of `PUT /me/avatar`.
  static const avatarMaxBytes = 2 * 1024 * 1024;

  /// A profile photo's side, in pixels.
  static const avatarSide = 512;

  /// The WebP quality of a profile photo.
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
