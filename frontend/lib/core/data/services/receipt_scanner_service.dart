import 'package:flutter/services.dart';
import 'package:monai/core/base/error/exceptions.dart';

/// On-device receipt OCR, so the photo itself never goes to the AI.
abstract class ReceiptScannerService {
  /// Null when the image has no text. Throws an [UnknownException] whose `code`
  /// is the native error code: `unreadable_image`, `recognition_failed` or
  /// `invalid_argument`.
  Future<String?> readText(String imagePath);
}

/// Backed by the native `ReceiptScannerPlugin`: ML Kit on Android, Apple
/// Vision on iOS.
class ReceiptScannerServiceImpl implements ReceiptScannerService {
  ReceiptScannerServiceImpl({
    this._channel = const MethodChannel(kChannelName),
  });

  /// Must match the channel name the native plugins register.
  static const kChannelName = 'com.djtech.monai/receipt_scanner';

  final MethodChannel _channel;

  @override
  Future<String?> readText(String imagePath) async {
    try {
      return await _channel.invokeMethod<String>('readText', {
        'path': imagePath,
      });
    } on PlatformException catch (e) {
      throw UnknownException(
        message: e.message ?? 'Reading receipt text failed',
        code: e.code,
      );
    } on MissingPluginException catch (e) {
      throw UnknownException(
        message: e.message ?? 'Receipt scanner is not available',
      );
    }
  }
}
