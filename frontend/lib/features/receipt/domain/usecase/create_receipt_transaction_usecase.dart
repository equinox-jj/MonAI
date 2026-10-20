import 'dart:typed_data';

import 'package:fpdart/fpdart.dart';
import 'package:monai/core/error/failure.dart';
import 'package:monai/core/model/transaction_source.dart';
import 'package:monai/core/usecase/usecase.dart';
import 'package:monai/features/receipt/domain/repository/receipt_repository.dart';
import 'package:monai/features/shared/domain/entity/transaction.dart';
import 'package:monai/features/shared/domain/entity/transaction_input.dart';
import 'package:monai/features/shared/domain/usecase/create_transaction_usecase.dart';
import 'package:monai/features/shared/domain/usecase/upload_receipt_usecase.dart';
import 'package:monai/features/shared/domain/validation/transaction_input_validator.dart';

/// Saves a scanned receipt: checks the input, uploads the compressed photo,
/// then creates the transaction with it. Invalid input fails as
/// [ValidationFailure] before anything is uploaded.
class CreateReceiptTransactionUseCase
    implements UseCase<Transaction, CreateReceiptTransactionParams> {
  /// [now] is the clock; tests pass a fixed one.
  CreateReceiptTransactionUseCase({
    required this._repository,
    required this._upload,
    required this._create,
    DateTime Function()? now,
  }) : _now = now ?? DateTime.now;

  static const _filename = 'receipt.jpg';

  final ReceiptRepository _repository;
  final UploadReceiptUseCase _upload;
  final CreateTransactionUseCase _create;
  final DateTime Function() _now;

  @override
  Future<Either<Failure, Transaction>> call(
    CreateReceiptTransactionParams params,
  ) async {
    final input = params.input.copyWith(source: TransactionSource.receipt);
    final errors = TransactionInputValidator.validate(
      input.normalized,
      today: _now(),
    );
    if (errors.isNotEmpty) return Left(Failure.validation(errors));

    final photo = await _repository.compressPhoto(params.photoPath);
    final Uint8List bytes;
    switch (photo) {
      case Left(value: final failure):
        return Left(failure);
      case Right(:final value):
        bytes = value;
    }
    final upload = await _upload(
      UploadReceiptParams(bytes: bytes, filename: _filename),
    );
    return switch (upload) {
      Left(value: final failure) => Left(failure),
      Right(value: final receiptKey) => _create(
        input.copyWith(receiptKey: receiptKey),
      ),
    };
  }
}

/// A scanned receipt's transaction and the photo to save with it.
class CreateReceiptTransactionParams {
  const CreateReceiptTransactionParams({
    required this.input,
    required this.photoPath,
  });

  final TransactionInput input;

  /// The photo as taken or picked; it is compressed before the upload.
  final String photoPath;
}
