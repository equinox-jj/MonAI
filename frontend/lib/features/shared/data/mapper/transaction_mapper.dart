import 'package:monai/core/database/monai_database.dart';
import 'package:monai/core/model/transaction_type.dart';
import 'package:monai/features/shared/data/mapper/api_values.dart';
import 'package:monai/features/shared/data/model/transaction_request.dart';
import 'package:monai/features/shared/data/model/transaction_response.dart';
import 'package:monai/features/shared/domain/entity/transaction.dart';
import 'package:monai/features/shared/domain/entity/transaction_input.dart';

extension TransactionDataMapper on TransactionData {
  TransactionRow toRow() => TransactionRow(
    id: requireField(id),
    type: parseTransactionType(type),
    amount: requireField(amount),
    walletId: requireField(walletId),
    toWalletId: toWalletId,
    categoryId: categoryId,
    date: parseApiDate(date),
    note: note,
    merchant: merchant,
    receiptUrl: receiptUrl,
    source: parseTransactionSource(source),
    createdAt: requireField(createdAt),
    updatedAt: requireField(updatedAt),
  );
}

extension TransactionRowMapper on TransactionRow {
  Transaction toEntity() => Transaction(
    id: id,
    type: type,
    amount: amount,
    walletId: walletId,
    toWalletId: toWalletId,
    categoryId: categoryId,
    date: date,
    note: note,
    merchant: merchant,
    receiptUrl: receiptUrl,
    source: source,
    createdAt: createdAt,
    updatedAt: updatedAt,
  );
}

extension TransactionInputMapper on TransactionInput {
  /// `POST /transactions`.
  TransactionRequest toCreateRequest() =>
      _request(source: source.apiValue, receiptKey: receiptKey);

  /// `PATCH /transactions/{id}`: the whole form, keeping the source and the
  /// receipt.
  TransactionRequest toUpdateRequest() => _request();

  TransactionRequest _request({String? source, String? receiptKey}) =>
      TransactionRequest(
        type: type.apiValue,
        amount: amount,
        walletId: walletId ?? '',
        toWalletId: type == TransactionType.transfer ? toWalletId : null,
        categoryId: type == TransactionType.transfer ? null : categoryId,
        date: formatApiDate(date),
        note: note,
        merchant: merchant,
        source: source,
        receiptKey: receiptKey,
      );
}
