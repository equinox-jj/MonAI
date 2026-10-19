import 'package:freezed_annotation/freezed_annotation.dart';

part 'update_wallet_request.freezed.dart';
part 'update_wallet_request.g.dart';

/// `PATCH /wallets/{id}`. Only the fields that are set are sent.
@freezed
abstract class UpdateWalletRequest with _$UpdateWalletRequest {
  const factory UpdateWalletRequest({
    @JsonKey(name: 'name', includeIfNull: false) String? name,
    @JsonKey(name: 'type', includeIfNull: false) String? type,
    @JsonKey(name: 'initial_balance', includeIfNull: false) int? initialBalance,
    @JsonKey(name: 'color', includeIfNull: false) String? color,
    @JsonKey(name: 'is_default', includeIfNull: false) bool? isDefault,
    @JsonKey(name: 'is_archived', includeIfNull: false) bool? isArchived,
  }) = _UpdateWalletRequest;

  factory UpdateWalletRequest.fromJson(Map<String, dynamic> json) =>
      _$UpdateWalletRequestFromJson(json);
}
