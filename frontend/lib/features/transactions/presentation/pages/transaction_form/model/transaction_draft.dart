import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:monai/core/model/transaction_type.dart';

part 'transaction_draft.freezed.dart';

/// The form's choices, except the note, which lives in its text field.
@freezed
abstract class TransactionDraft with _$TransactionDraft {
  const factory TransactionDraft({
    required TransactionType type,

    /// Local midnight.
    required DateTime date,

    /// Rupiah typed on the keypad.
    @Default(0) int amount,
    String? walletId,

    /// Transfers only.
    String? toWalletId,

    /// Expenses and incomes only.
    String? categoryId,
  }) = _TransactionDraft;
}
