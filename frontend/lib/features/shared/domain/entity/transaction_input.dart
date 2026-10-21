import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:monai/core/model/transaction_source.dart';
import 'package:monai/core/model/transaction_type.dart';

part 'transaction_input.freezed.dart';

/// Clean it up with `normalized` before validating and sending it.
@freezed
abstract class TransactionInput with _$TransactionInput {
  const factory TransactionInput({
    required TransactionType type,
    required int amount,
    required DateTime date,
    String? walletId,
    String? toWalletId,
    String? categoryId,
    String? note,
    String? merchant,
    @Default(TransactionSource.manual) TransactionSource source,

    /// From an uploaded receipt photo; creates only.
    String? receiptKey,
  }) = _TransactionInput;
}
