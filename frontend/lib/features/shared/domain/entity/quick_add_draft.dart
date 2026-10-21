import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:monai/core/model/transaction_type.dart';
import 'package:monai/features/shared/domain/entity/draft_confidence.dart';

part 'quick_add_draft.freezed.dart';

/// Nothing is saved until the user confirms it; a field that couldn't be read
/// is null with confidence 0.
@freezed
abstract class QuickAddDraft with _$QuickAddDraft {
  const factory QuickAddDraft({
    required TransactionType type,

    /// Local midnight.
    required DateTime date,
    int? amount,
    String? walletId,

    /// Transfers only.
    String? toWalletId,

    /// Expense and income only.
    String? categoryId,
    String? note,
    String? merchant,
    @Default(DraftConfidence()) DraftConfidence confidence,
  }) = _QuickAddDraft;
}

extension QuickAddDraftX on QuickAddDraft {
  bool get isAmountUnsure => confidence.amount < DraftConfidence.sure;

  bool get isWalletUnsure => confidence.wallet < DraftConfidence.sure;

  bool get isCategoryUnsure =>
      type != TransactionType.transfer &&
      confidence.category < DraftConfidence.sure;

  bool get isDateUnsure => confidence.date < DraftConfidence.sure;
}
