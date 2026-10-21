import 'package:freezed_annotation/freezed_annotation.dart';

part 'parse_receipt_request.freezed.dart';
part 'parse_receipt_request.g.dart';

@freezed
abstract class ParseReceiptRequest with _$ParseReceiptRequest {
  const factory ParseReceiptRequest({
    @JsonKey(name: 'ocr_text') required String ocrText,

    /// The user's date, `yyyy-MM-dd`.
    @JsonKey(name: 'today') required String today,

    /// IANA name, e.g. `Asia/Jakarta`.
    @JsonKey(name: 'timezone') required String timezone,
  }) = _ParseReceiptRequest;

  factory ParseReceiptRequest.fromJson(Map<String, dynamic> json) =>
      _$ParseReceiptRequestFromJson(json);
}
