import 'package:fpdart/fpdart.dart';
import 'package:monai/core/base/error/failure.dart';
import 'package:monai/core/base/usecase.dart';
import 'package:monai/features/receipt/domain/repository/receipt_repository.dart';

class ReadReceiptTextUseCase implements UseCase<String?, String> {
  ReadReceiptTextUseCase(this._repository);

  final ReceiptRepository _repository;

  @override
  Future<Either<Failure, String?>> call(String imagePath) async {
    final result = await _repository.readText(imagePath);
    return result.map((text) {
      final trimmed = text?.trim();
      return trimmed == null || trimmed.isEmpty ? null : trimmed;
    });
  }
}
