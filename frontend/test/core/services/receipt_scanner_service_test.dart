import 'package:flutter/services.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:monai/core/error/exceptions.dart';
import 'package:monai/core/services/receipt_scanner_service.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  const channel = MethodChannel(ReceiptScannerServiceImpl.kChannelName);
  final messenger =
      TestDefaultBinaryMessengerBinding.instance.defaultBinaryMessenger;
  final service = ReceiptScannerServiceImpl();

  void mockNative(Future<Object?>? Function(MethodCall call)? handler) =>
      messenger.setMockMethodCallHandler(channel, handler);

  tearDown(() => messenger.setMockMethodCallHandler(channel, null));

  test('sends the image path to readText and returns the text', () async {
    // Arrange
    MethodCall? received;
    mockNative((call) async {
      received = call;
      return 'TOTAL 25.000';
    });

    // Act
    final text = await service.readText('/tmp/receipt.jpg');

    // Assert
    expect(received?.method, 'readText');
    expect(received?.arguments, {'path': '/tmp/receipt.jpg'});
    expect(text, 'TOTAL 25.000');
  });

  test('returns null when the native side finds no text', () async {
    // Arrange
    mockNative((_) async => null);

    // Act
    final text = await service.readText('/tmp/receipt.jpg');

    // Assert
    expect(text, isNull);
  });

  test('throws UnknownException carrying the native error code', () async {
    // Arrange
    mockNative(
      (_) async => throw PlatformException(
        code: 'unreadable_image',
        message: 'Could not open',
      ),
    );

    // Act
    final call = service.readText('/tmp/missing.jpg');

    // Assert
    await expectLater(
      call,
      throwsA(
        isA<UnknownException>()
            .having((e) => e.code, 'code', 'unreadable_image')
            .having((e) => e.message, 'message', 'Could not open'),
      ),
    );
  });

  test('throws UnknownException when no native plugin is registered', () async {
    // Arrange
    mockNative(null);

    // Act
    final call = service.readText('/tmp/receipt.jpg');

    // Assert
    await expectLater(call, throwsA(isA<UnknownException>()));
  });
}
