import 'package:freezed_annotation/freezed_annotation.dart';

part 'attach_receipt_request.freezed.dart';
part 'attach_receipt_request.g.dart';

@freezed
abstract class AttachReceiptRequest with _$AttachReceiptRequest {
  const factory AttachReceiptRequest({
    @JsonKey(name: 'receipt_key') required String receiptKey,
  }) = _AttachReceiptRequest;

  factory AttachReceiptRequest.fromJson(Map<String, dynamic> json) =>
      _$AttachReceiptRequestFromJson(json);
}
