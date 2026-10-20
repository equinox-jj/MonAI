import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:monai/core/model/transaction_type.dart';
import 'package:monai/features/shared/domain/entity/draft_confidence.dart';

part 'ai_draft.freezed.dart';

/// A draft as the AI read a quick-add phrase. Every field may be missing;
/// quick add fills the gaps from the phone's own reading.
@freezed
abstract class AiDraft with _$AiDraft {
  const factory AiDraft({
    TransactionType? type,

    /// Rupiah.
    int? amount,
    String? walletId,
    String? toWalletId,
    String? categoryId,

    /// Local midnight.
    DateTime? date,
    String? note,
    String? merchant,
    @Default(DraftConfidence()) DraftConfidence confidence,
  }) = _AiDraft;
}
