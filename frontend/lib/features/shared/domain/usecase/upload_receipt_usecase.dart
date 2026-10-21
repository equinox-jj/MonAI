import 'dart:typed_data';

import 'package:fpdart/fpdart.dart';
import 'package:monai/core/base/error/failure.dart';
import 'package:monai/core/base/usecase.dart';
import 'package:monai/features/shared/domain/repository/transaction_repository.dart';

class UploadReceiptUseCase implements UseCase<String, UploadReceiptParams> {
  UploadReceiptUseCase(this._repository);

  final TransactionRepository _repository;

  @override
  Future<Either<Failure, String>> call(UploadReceiptParams params) =>
      _repository.uploadReceipt(params.bytes, filename: params.filename);
}

class UploadReceiptParams {
  const UploadReceiptParams({required this.bytes, required this.filename});

  final Uint8List bytes;
  final String filename;
}
