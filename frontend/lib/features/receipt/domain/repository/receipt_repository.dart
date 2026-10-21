import 'dart:typed_data';

import 'package:fpdart/fpdart.dart';
import 'package:monai/core/base/error/failure.dart';
import 'package:monai/features/receipt/domain/entity/receipt_draft.dart';

abstract class ReceiptRepository {
  /// The raw text read on the phone from the image at [imagePath], or null
  /// when the photo has none.
  Future<Either<Failure, String?>> readText(String imagePath);

  /// The photo at [imagePath] as a JPEG small enough to upload, without
  /// EXIF data.
  Future<Either<Failure, Uint8List>> compressPhoto(String imagePath);

  /// Asks the AI for a draft from a receipt's [ocrText] (1 to 5000
  /// characters). [today] is the user's date in [timezone], an IANA name.
  /// Nothing is saved.
  Future<Either<Failure, ReceiptDraft>> parse(
    String ocrText, {
    required DateTime today,
    required String timezone,
  });
}
