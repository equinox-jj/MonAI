import 'package:fpdart/fpdart.dart';
import 'package:monai/core/data/base_repository.dart';
import 'package:monai/core/error/failure.dart';
import 'package:monai/core/services/receipt_scanner_service.dart';
import 'package:monai/features/receipt/domain/repository/receipt_repository.dart';

class ReceiptRepositoryImpl extends ReceiptRepository with BaseRepository {
  ReceiptRepositoryImpl({required this._scanner});

  final ReceiptScannerService _scanner;

  @override
  Future<Either<Failure, String?>> readText(String imagePath) =>
      safeCall(() => _scanner.readText(imagePath));
}
