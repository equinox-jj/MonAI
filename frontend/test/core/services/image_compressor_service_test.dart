import 'dart:typed_data';

import 'package:flutter_test/flutter_test.dart';
import 'package:monai/core/error/exceptions.dart';
import 'package:monai/core/services/image_compressor_service.dart';

void main() {
  final calls = <int>[];

  setUp(calls.clear);

  /// A compressor whose output at each quality is [sizes] bytes long.
  ImageCompressorServiceImpl service(Map<int, int?> sizes) =>
      ImageCompressorServiceImpl(
        compress: (path, {required quality, required minSide}) async {
          calls.add(quality);
          final size = sizes[quality];
          return size == null ? null : Uint8List(size);
        },
      );

  test('gives the photo as a JPEG at the first quality', () async {
    // Arrange
    final compressor = service({ImageCompressorServiceImpl.quality: 1000});

    // Act
    final bytes = await compressor.compressForUpload('/tmp/receipt.jpg');

    // Assert
    expect(bytes.length, 1000);
    expect(calls, [ImageCompressorServiceImpl.quality]);
  });

  test('tries a lower quality when the photo is over the limit', () async {
    // Arrange
    final compressor = service({
      ImageCompressorServiceImpl.quality:
          ImageCompressorServiceImpl.maxBytes + 1,
      ImageCompressorServiceImpl.fallbackQuality: 2000,
    });

    // Act
    final bytes = await compressor.compressForUpload('/tmp/receipt.jpg');

    // Assert
    expect(bytes.length, 2000);
    expect(calls, [
      ImageCompressorServiceImpl.quality,
      ImageCompressorServiceImpl.fallbackQuality,
    ]);
  });

  test('throws photo_too_large when even the lower quality is', () async {
    // Arrange
    final compressor = service({
      ImageCompressorServiceImpl.quality:
          ImageCompressorServiceImpl.maxBytes + 1,
      ImageCompressorServiceImpl.fallbackQuality:
          ImageCompressorServiceImpl.maxBytes + 1,
    });

    // Act
    final result = compressor.compressForUpload('/tmp/receipt.jpg');

    // Assert
    await expectLater(
      result,
      throwsA(
        isA<UnknownException>().having(
          (e) => e.code,
          'code',
          'photo_too_large',
        ),
      ),
    );
  });

  test('throws unreadable_image when the photo can\'t be read', () async {
    // Arrange
    final compressor = service({ImageCompressorServiceImpl.quality: null});

    // Act
    final result = compressor.compressForUpload('/tmp/receipt.jpg');

    // Assert
    await expectLater(
      result,
      throwsA(
        isA<UnknownException>().having(
          (e) => e.code,
          'code',
          'unreadable_image',
        ),
      ),
    );
  });
}
