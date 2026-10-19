// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'receipt_upload_response.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_ReceiptUploadResponse _$ReceiptUploadResponseFromJson(
  Map<String, dynamic> json,
) => _ReceiptUploadResponse(
  success: json['success'] as bool?,
  message: json['message'] as String?,
  data: json['data'] == null
      ? null
      : ReceiptUploadData.fromJson(json['data'] as Map<String, dynamic>),
);

Map<String, dynamic> _$ReceiptUploadResponseToJson(
  _ReceiptUploadResponse instance,
) => <String, dynamic>{
  'success': instance.success,
  'message': instance.message,
  'data': instance.data,
};

_ReceiptUploadData _$ReceiptUploadDataFromJson(Map<String, dynamic> json) =>
    _ReceiptUploadData(receiptKey: json['receipt_key'] as String?);

Map<String, dynamic> _$ReceiptUploadDataToJson(_ReceiptUploadData instance) =>
    <String, dynamic>{'receipt_key': instance.receiptKey};
