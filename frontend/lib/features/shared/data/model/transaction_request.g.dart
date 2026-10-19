// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'transaction_request.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_TransactionRequest _$TransactionRequestFromJson(Map<String, dynamic> json) =>
    _TransactionRequest(
      type: json['type'] as String,
      amount: (json['amount'] as num).toInt(),
      walletId: json['wallet_id'] as String,
      toWalletId: json['to_wallet_id'] as String?,
      categoryId: json['category_id'] as String?,
      date: json['date'] as String,
      note: json['note'] as String?,
      merchant: json['merchant'] as String?,
      source: json['source'] as String?,
      receiptKey: json['receipt_key'] as String?,
    );

Map<String, dynamic> _$TransactionRequestToJson(_TransactionRequest instance) =>
    <String, dynamic>{
      'type': instance.type,
      'amount': instance.amount,
      'wallet_id': instance.walletId,
      'to_wallet_id': instance.toWalletId,
      'category_id': instance.categoryId,
      'date': instance.date,
      'note': instance.note,
      'merchant': instance.merchant,
      'source': ?instance.source,
      'receipt_key': ?instance.receiptKey,
    };
