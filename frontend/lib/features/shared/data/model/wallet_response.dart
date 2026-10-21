import 'package:freezed_annotation/freezed_annotation.dart';

part 'wallet_response.freezed.dart';
part 'wallet_response.g.dart';

@freezed
abstract class WalletResponse with _$WalletResponse {
  const factory WalletResponse({
    @JsonKey(name: 'success') bool? success,
    @JsonKey(name: 'message') String? message,
    @JsonKey(name: 'data') WalletData? data,
  }) = _WalletResponse;

  factory WalletResponse.fromJson(Map<String, dynamic> json) =>
      _$WalletResponseFromJson(json);
}

@freezed
abstract class WalletData with _$WalletData {
  const factory WalletData({
    @JsonKey(name: 'id') String? id,
    @JsonKey(name: 'provider_id') String? providerId,
    @JsonKey(name: 'name') String? name,
    @JsonKey(name: 'type') String? type,
    @JsonKey(name: 'logo_url') String? logoUrl,
    @JsonKey(name: 'initial_balance') int? initialBalance,
    @JsonKey(name: 'current_balance') int? currentBalance,
    @JsonKey(name: 'icon') String? icon,
    @JsonKey(name: 'color') String? color,
    @JsonKey(name: 'is_default') bool? isDefault,
    @JsonKey(name: 'is_archived') bool? isArchived,
    @JsonKey(name: 'created_at') DateTime? createdAt,
    @JsonKey(name: 'updated_at') DateTime? updatedAt,
  }) = _WalletData;

  factory WalletData.fromJson(Map<String, dynamic> json) =>
      _$WalletDataFromJson(json);
}
