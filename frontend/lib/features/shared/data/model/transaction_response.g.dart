// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'transaction_response.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_TransactionResponse _$TransactionResponseFromJson(Map<String, dynamic> json) =>
    _TransactionResponse(
      success: json['success'] as bool?,
      message: json['message'] as String?,
      data: json['data'] == null
          ? null
          : TransactionData.fromJson(json['data'] as Map<String, dynamic>),
    );

Map<String, dynamic> _$TransactionResponseToJson(
  _TransactionResponse instance,
) => <String, dynamic>{
  'success': instance.success,
  'message': instance.message,
  'data': instance.data,
};

_TransactionData _$TransactionDataFromJson(Map<String, dynamic> json) =>
    _TransactionData(
      id: json['id'] as String?,
      type: json['type'] as String?,
      amount: (json['amount'] as num?)?.toInt(),
      walletId: json['wallet_id'] as String?,
      toWalletId: json['to_wallet_id'] as String?,
      categoryId: json['category_id'] as String?,
      date: json['date'] as String?,
      note: json['note'] as String?,
      merchant: json['merchant'] as String?,
      receiptUrl: json['receipt_url'] as String?,
      source: json['source'] as String?,
      createdAt: json['created_at'] == null
          ? null
          : DateTime.parse(json['created_at'] as String),
      updatedAt: json['updated_at'] == null
          ? null
          : DateTime.parse(json['updated_at'] as String),
    );

Map<String, dynamic> _$TransactionDataToJson(_TransactionData instance) =>
    <String, dynamic>{
      'id': instance.id,
      'type': instance.type,
      'amount': instance.amount,
      'wallet_id': instance.walletId,
      'to_wallet_id': instance.toWalletId,
      'category_id': instance.categoryId,
      'date': instance.date,
      'note': instance.note,
      'merchant': instance.merchant,
      'receipt_url': instance.receiptUrl,
      'source': instance.source,
      'created_at': instance.createdAt?.toIso8601String(),
      'updated_at': instance.updatedAt?.toIso8601String(),
    };
