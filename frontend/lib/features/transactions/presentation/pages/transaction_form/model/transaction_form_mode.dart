import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:monai/core/model/transaction_type.dart';

part 'transaction_form_mode.freezed.dart';

/// Whether the form adds a transaction or edits one.
@freezed
sealed class TransactionFormMode with _$TransactionFormMode {
  /// A new transaction of [type], out of [walletId] (else the default
  /// wallet).
  const factory TransactionFormMode.add({
    @Default(TransactionType.expense) TransactionType type,
    String? walletId,
  }) = AddTransactionMode;

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
