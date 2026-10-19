import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:monai/core/model/transaction_source.dart';
import 'package:monai/core/model/transaction_type.dart';

part 'transaction.freezed.dart';

/// Money in, out, or between two of the user's wallets. [amount] is rupiah
/// and always positive; [type] gives the direction.
@freezed
abstract class Transaction with _$Transaction {
  const factory Transaction({
    required String id,
    required TransactionType type,
    required int amount,
    required String walletId,

    /// Local midnight of the transaction's day.
    required DateTime date,
    required TransactionSource source,
    required DateTime createdAt,
    required DateTime updatedAt,

    /// The destination wallet; transfers only.
    String? toWalletId,

    /// Expenses and incomes only.
    String? categoryId,
    String? note,
    String? merchant,

    /// Presigned and short-lived.
    String? receiptUrl,
  }) = _Transaction;
}
