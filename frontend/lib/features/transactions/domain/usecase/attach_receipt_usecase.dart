import 'dart:typed_data';

import 'package:fpdart/fpdart.dart';
import 'package:monai/core/base/error/failure.dart';
import 'package:monai/core/base/usecase.dart';
import 'package:monai/features/shared/domain/entity/transaction.dart';
import 'package:monai/features/shared/domain/repository/transaction_repository.dart';

class AttachReceiptUseCase
    implements UseCase<Transaction, AttachReceiptParams> {
  AttachReceiptUseCase(this._repository);

  final TransactionRepository _repository;

  @override
  Future<Either<Failure, Transaction>> call(AttachReceiptParams params) async {
    final upload = await _repository.uploadReceipt(
      params.bytes,
      filename: params.filename,
    );
    return switch (upload) {
      Left(value: final failure) => Left(failure),
      Right(value: final receiptKey) => _repository.attachReceipt(
        params.transactionId,
        receiptKey,
      ),
    };
  }
}

class AttachReceiptParams {
  const AttachReceiptParams({
    required this.transactionId,
    required this.bytes,
    required this.filename,
  });

  final String transactionId;
  final Uint8List bytes;
  final String filename;
}
