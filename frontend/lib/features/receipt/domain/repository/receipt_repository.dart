import 'dart:typed_data';

import 'package:fpdart/fpdart.dart';
import 'package:monai/core/base/error/failure.dart';
import 'package:monai/features/receipt/domain/entity/receipt_draft.dart';

abstract class ReceiptRepository {
  Future<Either<Failure, String?>> readText(String imagePath);

  Future<Either<Failure, Uint8List>> compressPhoto(String imagePath);

  /// [ocrText] is 1 to 5000 characters; [today] is the user's date in
  /// [timezone], an IANA name. Nothing is saved.
  Future<Either<Failure, ReceiptDraft>> parse(
    String ocrText, {
    required DateTime today,
    required String timezone,
  });
}
