import 'package:freezed_annotation/freezed_annotation.dart';

part 'create_wallet_request.freezed.dart';
part 'create_wallet_request.g.dart';

/// `POST /wallets`. Omitted fields take the server's defaults.
@freezed
abstract class CreateWalletRequest with _$CreateWalletRequest {
  const factory CreateWalletRequest({
    @JsonKey(name: 'name', includeIfNull: false) String? name,
    @JsonKey(name: 'provider_id', includeIfNull: false) String? providerId,
    @JsonKey(name: 'type', includeIfNull: false) String? type,
    @JsonKey(name: 'initial_balance') required int initialBalance,
    @JsonKey(name: 'color', includeIfNull: false) String? color,
    @JsonKey(name: 'is_default') required bool isDefault,
  }) = _CreateWalletRequest;

  factory CreateWalletRequest.fromJson(Map<String, dynamic> json) =>
      _$CreateWalletRequestFromJson(json);
}
