// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'wallet_response.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_WalletResponse _$WalletResponseFromJson(Map<String, dynamic> json) =>
    _WalletResponse(
      success: json['success'] as bool?,
      message: json['message'] as String?,
      data: json['data'] == null
          ? null
          : WalletData.fromJson(json['data'] as Map<String, dynamic>),
    );

Map<String, dynamic> _$WalletResponseToJson(_WalletResponse instance) =>
    <String, dynamic>{
      'success': instance.success,
      'message': instance.message,
      'data': instance.data,
    };

_WalletData _$WalletDataFromJson(Map<String, dynamic> json) => _WalletData(
  id: json['id'] as String?,
  providerId: json['provider_id'] as String?,
  name: json['name'] as String?,
  type: json['type'] as String?,
  logoUrl: json['logo_url'] as String?,
  initialBalance: (json['initial_balance'] as num?)?.toInt(),
  currentBalance: (json['current_balance'] as num?)?.toInt(),
  icon: json['icon'] as String?,
  color: json['color'] as String?,
  isDefault: json['is_default'] as bool?,
  isArchived: json['is_archived'] as bool?,
  createdAt: json['created_at'] == null
      ? null
      : DateTime.parse(json['created_at'] as String),
  updatedAt: json['updated_at'] == null
      ? null
      : DateTime.parse(json['updated_at'] as String),
);

Map<String, dynamic> _$WalletDataToJson(_WalletData instance) =>
    <String, dynamic>{
      'id': instance.id,
      'provider_id': instance.providerId,
      'name': instance.name,
      'type': instance.type,
      'logo_url': instance.logoUrl,
      'initial_balance': instance.initialBalance,
      'current_balance': instance.currentBalance,
      'icon': instance.icon,
      'color': instance.color,
      'is_default': instance.isDefault,
      'is_archived': instance.isArchived,
      'created_at': instance.createdAt?.toIso8601String(),
      'updated_at': instance.updatedAt?.toIso8601String(),
    };
