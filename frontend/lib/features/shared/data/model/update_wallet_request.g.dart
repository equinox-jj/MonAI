// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'update_wallet_request.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_UpdateWalletRequest _$UpdateWalletRequestFromJson(Map<String, dynamic> json) =>
    _UpdateWalletRequest(
      name: json['name'] as String?,
      type: json['type'] as String?,
      initialBalance: (json['initial_balance'] as num?)?.toInt(),
      color: json['color'] as String?,
      isDefault: json['is_default'] as bool?,
      isArchived: json['is_archived'] as bool?,
    );

Map<String, dynamic> _$UpdateWalletRequestToJson(
  _UpdateWalletRequest instance,
) => <String, dynamic>{
  'name': ?instance.name,
  'type': ?instance.type,
  'initial_balance': ?instance.initialBalance,
  'color': ?instance.color,
  'is_default': ?instance.isDefault,
  'is_archived': ?instance.isArchived,
};
