// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'wallet_list_response.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_WalletListResponse _$WalletListResponseFromJson(Map<String, dynamic> json) =>
    _WalletListResponse(
      success: json['success'] as bool?,
      message: json['message'] as String?,
      data: (json['data'] as List<dynamic>?)
          ?.map((e) => WalletData.fromJson(e as Map<String, dynamic>))
          .toList(),
      meta: json['meta'] == null
          ? null
          : WalletListMeta.fromJson(json['meta'] as Map<String, dynamic>),
    );

Map<String, dynamic> _$WalletListResponseToJson(_WalletListResponse instance) =>
    <String, dynamic>{
      'success': instance.success,
      'message': instance.message,
      'data': instance.data,
      'meta': instance.meta,
    };

_WalletListMeta _$WalletListMetaFromJson(Map<String, dynamic> json) =>
    _WalletListMeta(totalBalance: (json['total_balance'] as num?)?.toInt());

Map<String, dynamic> _$WalletListMetaToJson(_WalletListMeta instance) =>
    <String, dynamic>{'total_balance': instance.totalBalance};
