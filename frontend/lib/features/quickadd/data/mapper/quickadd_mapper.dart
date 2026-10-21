import 'package:monai/core/model/transaction_type.dart';
import 'package:monai/features/quickadd/data/model/parse_transaction_response.dart';
import 'package:monai/features/quickadd/domain/entity/ai_draft.dart';
import 'package:monai/features/shared/data/mapper/api_values.dart';
import 'package:monai/features/shared/data/model/draft_confidence_data.dart';
import 'package:monai/features/shared/domain/entity/draft_confidence.dart';

// A draft is a suggestion: a value the app can't use is dropped rather than
// failing the whole draft.

extension TransactionDraftDataMapper on TransactionDraftData {
  AiDraft toEntity() => AiDraft(
    type: _type(type),
    amount: amount != null && amount! > 0 ? amount : null,
    walletId: walletId,
    toWalletId: toWalletId,
    categoryId: categoryId,
    date: _date(date),
    note: _text(note),
    merchant: _text(merchant),
    confidence: confidence?.toEntity() ?? const DraftConfidence(),
  );
}

TransactionType? _type(String? value) =>
    TransactionType.values.where((t) => t.apiValue == value).firstOrNull;

DateTime? _date(String? value) {
  if (value == null || !RegExp(r'^\d{4}-\d{2}-\d{2}$').hasMatch(value)) {
    return null;
  }
  return DateTime.tryParse(value);
}

String? _text(String? value) {
  final trimmed = value?.trim();
  return trimmed == null || trimmed.isEmpty ? null : trimmed;
}
