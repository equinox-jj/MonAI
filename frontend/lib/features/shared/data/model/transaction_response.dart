import 'package:freezed_annotation/freezed_annotation.dart';

part 'transaction_response.freezed.dart';
part 'transaction_response.g.dart';

@freezed
abstract class TransactionResponse with _$TransactionResponse {
  const factory TransactionResponse({
    @JsonKey(name: 'success') bool? success,
    @JsonKey(name: 'message') String? message,
    @JsonKey(name: 'data') TransactionData? data,
  }) = _TransactionResponse;

  factory TransactionResponse.fromJson(Map<String, dynamic> json) =>
      _$TransactionResponseFromJson(json);
}

@freezed
abstract class TransactionData with _$TransactionData {
  const factory TransactionData({
    @JsonKey(name: 'id') String? id,
    @JsonKey(name: 'type') String? type,
    @JsonKey(name: 'amount') int? amount,
    @JsonKey(name: 'wallet_id') String? walletId,
    @JsonKey(name: 'to_wallet_id') String? toWalletId,
    @JsonKey(name: 'category_id') String? categoryId,
    @JsonKey(name: 'date') String? date,
    @JsonKey(name: 'note') String? note,
    @JsonKey(name: 'merchant') String? merchant,
    @JsonKey(name: 'receipt_url') String? receiptUrl,
    @JsonKey(name: 'source') String? source,
    @JsonKey(name: 'created_at') DateTime? createdAt,
    @JsonKey(name: 'updated_at') DateTime? updatedAt,
  }) = _TransactionData;

  factory TransactionData.fromJson(Map<String, dynamic> json) =>
      _$TransactionDataFromJson(json);
}
