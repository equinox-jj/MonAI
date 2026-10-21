import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:monai/features/shared/data/model/draft_confidence_data.dart';

part 'parse_transaction_response.freezed.dart';
part 'parse_transaction_response.g.dart';

@freezed
abstract class ParseTransactionResponse with _$ParseTransactionResponse {
  const factory ParseTransactionResponse({
    @JsonKey(name: 'success') bool? success,
    @JsonKey(name: 'message') String? message,
    @JsonKey(name: 'data') ParseTransactionData? data,
  }) = _ParseTransactionResponse;

  factory ParseTransactionResponse.fromJson(Map<String, dynamic> json) =>
      _$ParseTransactionResponseFromJson(json);
}

@freezed
abstract class ParseTransactionData with _$ParseTransactionData {
  const factory ParseTransactionData({
    @JsonKey(name: 'drafts') List<TransactionDraftData>? drafts,
  }) = _ParseTransactionData;

  factory ParseTransactionData.fromJson(Map<String, dynamic> json) =>
      _$ParseTransactionDataFromJson(json);
}

/// The server's validated draft; an unknown or invalid value is null.
@freezed
abstract class TransactionDraftData with _$TransactionDraftData {
  const factory TransactionDraftData({
    @JsonKey(name: 'type') String? type,
    @JsonKey(name: 'amount') int? amount,
    @JsonKey(name: 'wallet_id') String? walletId,
    @JsonKey(name: 'to_wallet_id') String? toWalletId,
    @JsonKey(name: 'category_id') String? categoryId,

    /// `yyyy-MM-dd`.
    @JsonKey(name: 'date') String? date,
    @JsonKey(name: 'note') String? note,
    @JsonKey(name: 'merchant') String? merchant,
    @JsonKey(name: 'confidence') DraftConfidenceData? confidence,
  }) = _TransactionDraftData;

  factory TransactionDraftData.fromJson(Map<String, dynamic> json) =>
      _$TransactionDraftDataFromJson(json);
}
