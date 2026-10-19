import 'package:flutter_test/flutter_test.dart';
import 'package:fpdart/fpdart.dart';
import 'package:mocktail/mocktail.dart';
import 'package:monai/core/error/exceptions.dart';
import 'package:monai/core/error/failure.dart';
import 'package:monai/core/services/receipt_scanner_service.dart';
import 'package:monai/features/receipt/data/repository/receipt_repository_impl.dart';

class _MockScanner extends Mock implements ReceiptScannerService {}

void main() {
  late _MockScanner scanner;
  late ReceiptRepositoryImpl repository;

  setUp(() {
    scanner = _MockScanner();
    repository = ReceiptRepositoryImpl(scanner: scanner);
  });

  test('returns Right with the text the scanner read', () async {
    // Arrange
    when(() => scanner.readText('/tmp/receipt.jpg'))
        .thenAnswer((_) async => 'TOTAL 25.000');

    // Act
    final result = await repository.readText('/tmp/receipt.jpg');

    // Assert
    expect(result, const Right<Failure, String?>('TOTAL 25.000'));
  });

  test(
    'returns Left(UnknownFailure) with the code when reading fails',
    () async {
      // Arrange
      when(() => scanner.readText(any())).thenThrow(
        const UnknownException(message: 'boom', code: 'recognition_failed'),
      );

      // Act
      final result = await repository.readText('/tmp/receipt.jpg');

      // Assert
      expect(
        result,
        const Left<Failure, String?>(
          Failure.unknown(message: 'boom', code: 'recognition_failed'),
        ),
      );
    },
  );
}
