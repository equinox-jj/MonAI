// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'parse_receipt_request.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_ParseReceiptRequest _$ParseReceiptRequestFromJson(Map<String, dynamic> json) =>
    _ParseReceiptRequest(
      ocrText: json['ocr_text'] as String,
      today: json['today'] as String,
      timezone: json['timezone'] as String,
    );

Map<String, dynamic> _$ParseReceiptRequestToJson(
  _ParseReceiptRequest instance,
) => <String, dynamic>{
  'ocr_text': instance.ocrText,
  'today': instance.today,
  'timezone': instance.timezone,
};
