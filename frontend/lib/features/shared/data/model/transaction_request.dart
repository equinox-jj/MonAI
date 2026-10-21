import 'package:freezed_annotation/freezed_annotation.dart';

part 'transaction_request.freezed.dart';
part 'transaction_request.g.dart';

/// On a patch, a null `to_wallet_id`, `category_id`, `note` or `merchant` is
/// sent and clears the field. `source` and `receipt_key` are left out when
/// null, so a patch keeps them.
@freezed
abstract class TransactionRequest with _$TransactionRequest {
  const factory TransactionRequest({
    @JsonKey(name: 'type') required String type,
    @JsonKey(name: 'amount') required int amount,
    @JsonKey(name: 'wallet_id') required String walletId,
    @JsonKey(name: 'to_wallet_id') String? toWalletId,
    @JsonKey(name: 'category_id') String? categoryId,
    @JsonKey(name: 'date') required String date,
    @JsonKey(name: 'note') String? note,
    @JsonKey(name: 'merchant') String? merchant,
    @JsonKey(name: 'source', includeIfNull: false) String? source,
    @JsonKey(name: 'receipt_key', includeIfNull: false) String? receiptKey,
  }) = _TransactionRequest;

  factory TransactionRequest.fromJson(Map<String, dynamic> json) =>
      _$TransactionRequestFromJson(json);
}
