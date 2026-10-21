import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:monai/features/receipt/domain/entity/receipt_draft.dart';
import 'package:monai/features/receipt/presentation/model/receipt_ai_failure.dart';

part 'receipt_review_args.freezed.dart';

@freezed
abstract class ReceiptReviewArgs with _$ReceiptReviewArgs {
  const factory ReceiptReviewArgs({
    required String photoPath,
    required String ocrText,
    required ReceiptDraft draft,
    ReceiptAiFailure? aiFailure,
  }) = _ReceiptReviewArgs;
}
