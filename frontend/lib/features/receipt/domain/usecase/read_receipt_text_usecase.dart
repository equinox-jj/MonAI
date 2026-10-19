import 'package:fpdart/fpdart.dart';
import 'package:monai/core/error/failure.dart';
import 'package:monai/core/usecase/usecase.dart';
import 'package:monai/features/receipt/domain/repository/receipt_repository.dart';

/// The text on the receipt photo at the given path, read on the phone and
/// trimmed; null when the photo has none.
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
