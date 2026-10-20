// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'parse_receipt_response.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_ParseReceiptResponse _$ParseReceiptResponseFromJson(
  Map<String, dynamic> json,
) => _ParseReceiptResponse(
  success: json['success'] as bool?,
  message: json['message'] as String?,
  data: json['data'] == null
      ? null
      : ParseReceiptData.fromJson(json['data'] as Map<String, dynamic>),
);

Map<String, dynamic> _$ParseReceiptResponseToJson(
  _ParseReceiptResponse instance,
) => <String, dynamic>{
  'success': instance.success,
  'message': instance.message,
  'data': instance.data,
};

_ParseReceiptData _$ParseReceiptDataFromJson(Map<String, dynamic> json) =>
    _ParseReceiptData(
      draft: json['draft'] == null
          ? null
          : ReceiptDraftData.fromJson(json['draft'] as Map<String, dynamic>),
    );

Map<String, dynamic> _$ParseReceiptDataToJson(_ParseReceiptData instance) =>
    <String, dynamic>{'draft': instance.draft};

_ReceiptDraftData _$ReceiptDraftDataFromJson(Map<String, dynamic> json) =>
    _ReceiptDraftData(
      type: json['type'] as String?,
      amount: (json['amount'] as num?)?.toInt(),
      walletId: json['wallet_id'] as String?,
      categoryId: json['category_id'] as String?,
      date: json['date'] as String?,
      note: json['note'] as String?,
      merchant: json['merchant'] as String?,
      confidence: json['confidence'] == null
          ? null
          : DraftConfidenceData.fromJson(
              json['confidence'] as Map<String, dynamic>,
            ),
      items: (json['items'] as List<dynamic>?)
          ?.map((e) => ReceiptItemData.fromJson(e as Map<String, dynamic>))
          .toList(),
    );

Map<String, dynamic> _$ReceiptDraftDataToJson(_ReceiptDraftData instance) =>
    <String, dynamic>{
      'type': instance.type,
      'amount': instance.amount,
      'wallet_id': instance.walletId,
      'category_id': instance.categoryId,
      'date': instance.date,
      'note': instance.note,
      'merchant': instance.merchant,
      'confidence': instance.confidence,
      'items': instance.items,
    };

_DraftConfidenceData _$DraftConfidenceDataFromJson(Map<String, dynamic> json) =>
    _DraftConfidenceData(
      type: (json['type'] as num?)?.toDouble(),
      amount: (json['amount'] as num?)?.toDouble(),
      wallet: (json['wallet'] as num?)?.toDouble(),
      category: (json['category'] as num?)?.toDouble(),
      date: (json['date'] as num?)?.toDouble(),
    );

Map<String, dynamic> _$DraftConfidenceDataToJson(
  _DraftConfidenceData instance,
) => <String, dynamic>{
  'type': instance.type,
  'amount': instance.amount,
  'wallet': instance.wallet,
  'category': instance.category,
  'date': instance.date,
};

_ReceiptItemData _$ReceiptItemDataFromJson(Map<String, dynamic> json) =>
    _ReceiptItemData(
      name: json['name'] as String?,
      quantity: (json['quantity'] as num?)?.toDouble(),
      amount: (json['amount'] as num?)?.toInt(),
    );

Map<String, dynamic> _$ReceiptItemDataToJson(_ReceiptItemData instance) =>
    <String, dynamic>{
      'name': instance.name,
      'quantity': instance.quantity,
      'amount': instance.amount,
    };
