import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:monai/core/model/transaction_source.dart';
import 'package:monai/core/model/transaction_type.dart';

part 'transaction.freezed.dart';

/// [amount] is always positive; [type] gives the direction.
@freezed
abstract class Transaction with _$Transaction {
  const factory Transaction({
    required String id,
    required TransactionType type,
    required int amount,
    required String walletId,

    /// Local midnight.
    required DateTime date,
    required TransactionSource source,
    required DateTime createdAt,
    required DateTime updatedAt,

    /// Transfers only.
    String? toWalletId,

    /// Expenses and incomes only.
    String? categoryId,
    String? note,
    String? merchant,

    /// Presigned and short-lived.
    String? receiptUrl,
  }) = _Transaction;
}
