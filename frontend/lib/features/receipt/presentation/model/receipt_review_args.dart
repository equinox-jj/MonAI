import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:monai/features/receipt/domain/entity/receipt_draft.dart';
import 'package:monai/features/receipt/presentation/model/receipt_ai_failure.dart';

part 'receipt_review_args.freezed.dart';

/// What the scanner hands the review: the photo and what was read from it.
@freezed
abstract class ReceiptReviewArgs with _$ReceiptReviewArgs {
  const factory ReceiptReviewArgs({
    /// The photo as taken or picked, saved with the transaction.
    required String photoPath,

    /// The text read on the phone, sent to the AI again on "Try again".
    required String ocrText,
    required ReceiptDraft draft,

    /// Why the AI gave no draft, so [draft] is empty for the user to fill
    /// in; null when it read the receipt.
    ReceiptAiFailure? aiFailure,
  }) = _ReceiptReviewArgs;
}
