import 'package:monai/core/model/transaction_type.dart';
import 'package:monai/features/receipt/data/model/parse_receipt_response.dart';
import 'package:monai/features/receipt/domain/entity/receipt_draft.dart';
import 'package:monai/features/shared/data/mapper/api_values.dart';

// A draft is a suggestion: a value the app can't use is dropped rather than
// failing the whole draft.

extension ReceiptDraftDataMapper on ReceiptDraftData {
  ReceiptDraft toEntity() => ReceiptDraft(
    type: _receiptType(type),
    amount: amount,
    walletId: walletId,
    categoryId: categoryId,
    date: _date(date),
    note: note,
    merchant: merchant,
    confidence: confidence?.toEntity() ?? const DraftConfidence(),
    items: [
      for (final item in items ?? const <ReceiptItemData>[])
        if (item.name case final name? when name.trim().isNotEmpty)
          ReceiptItem(name: name, quantity: item.quantity, amount: item.amount),
    ],
  );
}

/// Expense or income; a receipt is never a transfer.
TransactionType? _receiptType(String? value) {
  if (value == null) return null;
  for (final type in [TransactionType.expense, TransactionType.income]) {
    if (type.apiValue == value) return type;
  }
  return null;
}

/// `yyyy-MM-dd` at local midnight, or null when it isn't one.
DateTime? _date(String? value) {
  if (value == null || !RegExp(r'^\d{4}-\d{2}-\d{2}$').hasMatch(value)) {
    return null;
  }
  return DateTime.tryParse(value);
}
