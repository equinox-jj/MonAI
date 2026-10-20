// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'draft_confidence_data.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

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
