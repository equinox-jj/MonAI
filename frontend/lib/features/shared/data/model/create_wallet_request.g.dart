// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'create_wallet_request.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_CreateWalletRequest _$CreateWalletRequestFromJson(Map<String, dynamic> json) =>
    _CreateWalletRequest(
      name: json['name'] as String?,
      providerId: json['provider_id'] as String?,
      type: json['type'] as String?,
      initialBalance: (json['initial_balance'] as num).toInt(),
      color: json['color'] as String?,
      isDefault: json['is_default'] as bool,
    );

Map<String, dynamic> _$CreateWalletRequestToJson(
  _CreateWalletRequest instance,
) => <String, dynamic>{
  'name': ?instance.name,
  'provider_id': ?instance.providerId,
  'type': ?instance.type,
  'initial_balance': instance.initialBalance,
  'color': ?instance.color,
  'is_default': instance.isDefault,
};
