import 'dart:typed_data';

import 'package:fpdart/fpdart.dart';
import 'package:monai/core/error/failure.dart';
import 'package:monai/core/usecase/usecase.dart';
import 'package:monai/features/shared/domain/repository/transaction_repository.dart';

/// Uploads a receipt photo; gives the key to create or attach it with.
class UploadReceiptUseCase implements UseCase<String, UploadReceiptParams> {
  UploadReceiptUseCase(this._repository);

  final TransactionRepository _repository;

  @override
  Future<Either<Failure, String>> call(UploadReceiptParams params) =>
      _repository.uploadReceipt(params.bytes, filename: params.filename);
}

/// An encoded receipt photo (JPEG or WebP, at most 5 MB).
class UploadReceiptParams {
  const UploadReceiptParams({required this.bytes, required this.filename});

  final Uint8List bytes;
  final String filename;
}
