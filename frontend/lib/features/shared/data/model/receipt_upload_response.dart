import 'package:freezed_annotation/freezed_annotation.dart';

part 'receipt_upload_response.freezed.dart';
part 'receipt_upload_response.g.dart';

@freezed
abstract class ReceiptUploadResponse with _$ReceiptUploadResponse {
  const factory ReceiptUploadResponse({
    @JsonKey(name: 'success') bool? success,
    @JsonKey(name: 'message') String? message,
    @JsonKey(name: 'data') ReceiptUploadData? data,
  }) = _ReceiptUploadResponse;

  factory ReceiptUploadResponse.fromJson(Map<String, dynamic> json) =>
      _$ReceiptUploadResponseFromJson(json);
}

@freezed
abstract class ReceiptUploadData with _$ReceiptUploadData {
  const factory ReceiptUploadData({
    @JsonKey(name: 'receipt_key') String? receiptKey,
  }) = _ReceiptUploadData;

  factory ReceiptUploadData.fromJson(Map<String, dynamic> json) =>
      _$ReceiptUploadDataFromJson(json);
}
