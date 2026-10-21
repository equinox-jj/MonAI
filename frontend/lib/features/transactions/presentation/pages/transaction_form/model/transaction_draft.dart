import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:monai/core/model/transaction_type.dart';

part 'transaction_draft.freezed.dart';

@freezed
abstract class TransactionDraft with _$TransactionDraft {
  const factory TransactionDraft({
    required TransactionType type,
    required DateTime date,
    @Default(0) int amount,
    String? walletId,
    String? toWalletId,
    String? categoryId,
  }) = _TransactionDraft;
}
