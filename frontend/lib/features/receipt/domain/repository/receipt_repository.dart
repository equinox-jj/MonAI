import 'package:fpdart/fpdart.dart';
import 'package:monai/core/error/failure.dart';

abstract class ReceiptRepository {
  /// The raw text read on the phone from the image at [imagePath], or null
  /// when the photo has none.
  Future<Either<Failure, String?>> readText(String imagePath);
}
