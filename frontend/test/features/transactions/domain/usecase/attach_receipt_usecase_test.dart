import 'dart:typed_data';

import 'package:flutter_test/flutter_test.dart';
import 'package:fpdart/fpdart.dart';
import 'package:mocktail/mocktail.dart';
import 'package:monai/core/base/error/failure.dart';
import 'package:monai/features/shared/domain/repository/transaction_repository.dart';
import 'package:monai/features/transactions/domain/usecase/attach_receipt_usecase.dart';

import '../../../../helpers/entity_fixtures.dart';

class _MockRepository extends Mock implements TransactionRepository {}

void main() {
  late _MockRepository repository;
  late AttachReceiptUseCase useCase;
  final bytes = Uint8List(3);
  final params = AttachReceiptParams(
    transactionId: 't1',
    bytes: bytes,
    filename: 'r.webp',
  );

  setUp(() {
    repository = _MockRepository();
    useCase = AttachReceiptUseCase(repository);
  });

  test('uploads the photo, then attaches its key', () async {
    // Arrange
    final updated = transaction();
    when(() => repository.uploadReceipt(bytes, filename: 'r.webp'))
        .thenAnswer((_) async => const Right('receipts/k'));
    when(() => repository.attachReceipt('t1', 'receipts/k'))
        .thenAnswer((_) async => Right(updated));

    // Act
    final result = await useCase(params);

    // Assert
    expect(result.getRight().toNullable(), updated);
  });

  test('a failed upload attaches nothing', () async {
    // Arrange
    when(() => repository.uploadReceipt(bytes, filename: 'r.webp'))
        .thenAnswer((_) async => const Left(Failure.tooManyRequests()));

    // Act
    final result = await useCase(params);

    // Assert
    expect(result.getLeft().toNullable(), isA<TooManyRequestsFailure>());
    verifyNever(() => repository.attachReceipt(any(), any()));
  });
}
