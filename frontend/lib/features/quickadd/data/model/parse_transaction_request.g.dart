// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'parse_transaction_request.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_ParseTransactionRequest _$ParseTransactionRequestFromJson(
  Map<String, dynamic> json,
) => _ParseTransactionRequest(
  text: json['text'] as String,
  today: json['today'] as String,
  timezone: json['timezone'] as String,
);

Map<String, dynamic> _$ParseTransactionRequestToJson(
  _ParseTransactionRequest instance,
) => <String, dynamic>{
  'text': instance.text,
  'today': instance.today,
  'timezone': instance.timezone,
};
