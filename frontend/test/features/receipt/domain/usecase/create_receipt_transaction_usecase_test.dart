import 'dart:typed_data';

import 'package:flutter_test/flutter_test.dart';
import 'package:fpdart/fpdart.dart';
import 'package:mocktail/mocktail.dart';
import 'package:monai/core/error/failure.dart';
import 'package:monai/core/model/transaction_source.dart';
import 'package:monai/core/model/transaction_type.dart';
import 'package:monai/features/receipt/domain/repository/receipt_repository.dart';
import 'package:monai/features/receipt/domain/usecase/create_receipt_transaction_usecase.dart';
import 'package:monai/features/shared/domain/entity/transaction.dart';
import 'package:monai/features/shared/domain/entity/transaction_input.dart';
import 'package:monai/features/shared/domain/usecase/create_transaction_usecase.dart';
import 'package:monai/features/shared/domain/usecase/upload_receipt_usecase.dart';
import 'package:monai/features/shared/domain/validation/transaction_input_validator.dart';

import '../../../../helpers/entity_fixtures.dart';

class _MockRepository extends Mock implements ReceiptRepository {}

class _MockUpload extends Mock implements UploadReceiptUseCase {}

class _MockCreate extends Mock implements CreateTransactionUseCase {}

void main() {
  late _MockRepository repository;
  late _MockUpload upload;
  late _MockCreate create;
  late CreateReceiptTransactionUseCase useCase;

  final photo = Uint8List(10);
  final input = TransactionInput(
    type: TransactionType.expense,
    amount: 187500,
    date: DateTime(2026, 10, 9),
    walletId: 'w1',
    categoryId: 'c1',
    merchant: 'Toko Sumber Rejeki',
  );
  final params = CreateReceiptTransactionParams(
    input: input,
    photoPath: '/tmp/receipt.jpg',
  );

  setUpAll(() {
    registerFallbackValue(
      UploadReceiptParams(bytes: Uint8List(0), filename: ''),
    );
    registerFallbackValue(input);
  });

  setUp(() {
    repository = _MockRepository();
    upload = _MockUpload();
    create = _MockCreate();
    useCase = CreateReceiptTransactionUseCase(
      repository: repository,
      upload: upload,
      create: create,
      now: () => DateTime(2026, 10, 10, 9),
    );
    when(() => repository.compressPhoto(any()))
        .thenAnswer((_) async => Right(photo));
    when(() => upload(any())).thenAnswer((_) async => const Right('key-1'));
    when(() => create(any()))
        .thenAnswer((_) async => Right(transaction(id: 't9')));
  });

  test(
    'uploads the compressed photo and creates the transaction with it',
    () async {
      // Arrange
      // (compress, upload and create succeed)

      // Act
      final result = await useCase(params);

      // Assert
      expect(result.map((t) => t.id), const Right<Failure, String>('t9'));
      verify(() => repository.compressPhoto('/tmp/receipt.jpg')).called(1);
      final sent =
          verify(() => upload(captureAny())).captured.single
              as UploadReceiptParams;
      expect(sent.bytes, photo);
      expect(sent.filename, endsWith('.jpg'));
      verify(
        () => create(
          input.copyWith(
            receiptKey: 'key-1',
            source: TransactionSource.receipt,
          ),
        ),
      ).called(1);
    },
  );

  test('invalid input fails before anything is uploaded', () async {
    // Arrange
    final invalid = CreateReceiptTransactionParams(
      input: input.copyWith(amount: 0, categoryId: null),
      photoPath: '/tmp/receipt.jpg',
    );

    // Act
    final result = await useCase(invalid);

    // Assert
    expect(
      result.getLeft().toNullable(),
      isA<ValidationFailure>().having(
        (f) => f.fieldErrors.map((e) => e.field),
        'fields',
        containsAll([
          TransactionInputValidator.amountField,
          TransactionInputValidator.categoryField,
        ]),
      ),
    );
    verifyNever(() => repository.compressPhoto(any()));
    verifyNever(() => upload(any()));
    verifyNever(() => create(any()));
  });

  test('a photo that cannot be compressed creates nothing', () async {
    // Arrange
    when(() => repository.compressPhoto(any())).thenAnswer(
      (_) async => const Left(Failure.unknown(code: 'photo_too_large')),
    );

    // Act
    final result = await useCase(params);

    // Assert
    expect(
      result,
      const Left<Failure, Transaction>(
        Failure.unknown(code: 'photo_too_large'),
      ),
    );
    verifyNever(() => upload(any()));
    verifyNever(() => create(any()));
  });

  test('a failed upload creates nothing', () async {
    // Arrange
    when(() => upload(any()))
        .thenAnswer((_) async => const Left(Failure.network()));

    // Act
    final result = await useCase(params);

    // Assert
    expect(result, const Left<Failure, Transaction>(Failure.network()));
    verifyNever(() => create(any()));
  });

  test("passes the server's validation failure through", () async {
    // Arrange
    when(() => create(any()))
        .thenAnswer((_) async => const Left(Failure.validation([])));

    // Act
    final result = await useCase(params);

    // Assert
    expect(result, const Left<Failure, Transaction>(Failure.validation([])));
  });
}
