import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:monai/features/shared/data/model/wallet_response.dart';

part 'wallet_list_response.freezed.dart';
part 'wallet_list_response.g.dart';

/// `GET /wallets`.
@freezed
abstract class WalletListResponse with _$WalletListResponse {
  const factory WalletListResponse({
    @JsonKey(name: 'success') bool? success,
    @JsonKey(name: 'message') String? message,
    @JsonKey(name: 'data') List<WalletData>? data,
    @JsonKey(name: 'meta') WalletListMeta? meta,
  }) = _WalletListResponse;

  factory WalletListResponse.fromJson(Map<String, dynamic> json) =>
      _$WalletListResponseFromJson(json);
}

@freezed
abstract class WalletListMeta with _$WalletListMeta {
  const factory WalletListMeta({
    @JsonKey(name: 'total_balance') int? totalBalance,
  }) = _WalletListMeta;

  factory WalletListMeta.fromJson(Map<String, dynamic> json) =>
      _$WalletListMetaFromJson(json);
}
