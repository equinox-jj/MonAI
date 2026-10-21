import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:monai/core/model/transaction_type.dart';
import 'package:monai/features/shared/domain/entity/draft_confidence.dart';

export 'package:monai/features/shared/domain/entity/draft_confidence.dart';

part 'receipt_draft.freezed.dart';

/// Every field may be missing; the user checks and completes it before
/// anything is saved.
@freezed
abstract class ReceiptDraft with _$ReceiptDraft {
  const factory ReceiptDraft({
    TransactionType? type,
    int? amount,
    String? walletId,
    String? categoryId,

    /// Local midnight.
    DateTime? date,
    String? note,
    String? merchant,
    @Default(DraftConfidence()) DraftConfidence confidence,
    @Default([]) List<ReceiptItem> items,
  }) = _ReceiptDraft;

  /// Nothing read: the AI failed, so the user fills the fields in.
  static const empty = ReceiptDraft();
}

@freezed
abstract class ReceiptItem with _$ReceiptItem {
  const factory ReceiptItem({
    required String name,
    double? quantity,
    int? amount,
  }) = _ReceiptItem;
}
