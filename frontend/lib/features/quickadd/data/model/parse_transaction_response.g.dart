// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'parse_transaction_response.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_ParseTransactionResponse _$ParseTransactionResponseFromJson(
  Map<String, dynamic> json,
) => _ParseTransactionResponse(
  success: json['success'] as bool?,
  message: json['message'] as String?,
  data: json['data'] == null
      ? null
      : ParseTransactionData.fromJson(json['data'] as Map<String, dynamic>),
);

Map<String, dynamic> _$ParseTransactionResponseToJson(
  _ParseTransactionResponse instance,
) => <String, dynamic>{
  'success': instance.success,
  'message': instance.message,
  'data': instance.data,
};

_ParseTransactionData _$ParseTransactionDataFromJson(
  Map<String, dynamic> json,
) => _ParseTransactionData(
  drafts: (json['drafts'] as List<dynamic>?)
      ?.map((e) => TransactionDraftData.fromJson(e as Map<String, dynamic>))
      .toList(),
);

Map<String, dynamic> _$ParseTransactionDataToJson(
  _ParseTransactionData instance,
) => <String, dynamic>{'drafts': instance.drafts};

_TransactionDraftData _$TransactionDraftDataFromJson(
  Map<String, dynamic> json,
) => _TransactionDraftData(
  type: json['type'] as String?,
  amount: (json['amount'] as num?)?.toInt(),
  walletId: json['wallet_id'] as String?,
  toWalletId: json['to_wallet_id'] as String?,
  categoryId: json['category_id'] as String?,
  date: json['date'] as String?,
  note: json['note'] as String?,
  merchant: json['merchant'] as String?,
  confidence: json['confidence'] == null
      ? null
      : DraftConfidenceData.fromJson(
          json['confidence'] as Map<String, dynamic>,
        ),
);

Map<String, dynamic> _$TransactionDraftDataToJson(
  _TransactionDraftData instance,
) => <String, dynamic>{
  'type': instance.type,
  'amount': instance.amount,
  'wallet_id': instance.walletId,
  'to_wallet_id': instance.toWalletId,
  'category_id': instance.categoryId,
  'date': instance.date,
  'note': instance.note,
  'merchant': instance.merchant,
  'confidence': instance.confidence,
};
