import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:monai/core/model/transaction_type.dart';
import 'package:monai/features/shared/domain/entity/quick_add_draft.dart';

part 'transaction_form_mode.freezed.dart';

@freezed
sealed class TransactionFormMode with _$TransactionFormMode {
  const factory TransactionFormMode.add({
    @Default(TransactionType.expense) TransactionType type,
    String? walletId,
  }) = AddTransactionMode;
  const factory TransactionFormMode.prefill(QuickAddDraft draft) =
      PrefillTransactionMode;
  const factory TransactionFormMode.edit(String id) = EditTransactionMode;
}

@freezed
sealed class TransactionFormOutcome with _$TransactionFormOutcome {
  const factory TransactionFormOutcome.closed() = ClosedFormOutcome;
  const factory TransactionFormOutcome.saved(String id) = SavedFormOutcome;
  const factory TransactionFormOutcome.deleted(String id) = DeletedFormOutcome;
  const factory TransactionFormOutcome.scanReceipt() = ScanReceiptFormOutcome;
}
