import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:monai/core/model/transaction_type.dart';
import 'package:monai/features/shared/domain/entity/quick_add_draft.dart';

part 'transaction_form_mode.freezed.dart';

/// Whether the form adds a transaction, checks a quick-add draft before
/// adding it, or edits one.
@freezed
sealed class TransactionFormMode with _$TransactionFormMode {
  /// A new transaction of [type], out of [walletId] (else the default
  /// wallet).
  const factory TransactionFormMode.add({
    @Default(TransactionType.expense) TransactionType type,
    String? walletId,
  }) = AddTransactionMode;

  /// A new transaction filled from a quick-add [draft]; its unsure fields
  /// are marked for the user to check.
  const factory TransactionFormMode.prefill(QuickAddDraft draft) =
      PrefillTransactionMode;

  /// The transaction with [id].
  const factory TransactionFormMode.edit(String id) = EditTransactionMode;
}

/// How the form closed.
@freezed
sealed class TransactionFormOutcome with _$TransactionFormOutcome {
  /// Without saving.
  const factory TransactionFormOutcome.closed() = ClosedFormOutcome;

  /// Saved as transaction [id].
  const factory TransactionFormOutcome.saved(String id) = SavedFormOutcome;

  /// The edited transaction was deleted.
  const factory TransactionFormOutcome.deleted(String id) = DeletedFormOutcome;

  /// Without saving, to scan a receipt instead.
  const factory TransactionFormOutcome.scanReceipt() = ScanReceiptFormOutcome;
}
