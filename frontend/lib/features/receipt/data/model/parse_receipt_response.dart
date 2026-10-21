import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:monai/features/shared/data/model/draft_confidence_data.dart';

export 'package:monai/features/shared/data/model/draft_confidence_data.dart';

part 'parse_receipt_response.freezed.dart';
part 'parse_receipt_response.g.dart';

@freezed
abstract class ParseReceiptResponse with _$ParseReceiptResponse {
  const factory ParseReceiptResponse({
    @JsonKey(name: 'success') bool? success,
    @JsonKey(name: 'message') String? message,
    @JsonKey(name: 'data') ParseReceiptData? data,
  }) = _ParseReceiptResponse;

  factory ParseReceiptResponse.fromJson(Map<String, dynamic> json) =>
      _$ParseReceiptResponseFromJson(json);
}

@freezed
abstract class ParseReceiptData with _$ParseReceiptData {
  const factory ParseReceiptData({
    @JsonKey(name: 'draft') ReceiptDraftData? draft,
  }) = _ParseReceiptData;

  factory ParseReceiptData.fromJson(Map<String, dynamic> json) =>
      _$ParseReceiptDataFromJson(json);
}

/// The server's validated draft; an unknown or invalid value is null.
@freezed
abstract class ReceiptDraftData with _$ReceiptDraftData {
  const factory ReceiptDraftData({
    @JsonKey(name: 'type') String? type,
    @JsonKey(name: 'amount') int? amount,
    @JsonKey(name: 'wallet_id') String? walletId,
    @JsonKey(name: 'category_id') String? categoryId,

    /// `yyyy-MM-dd`.
    @JsonKey(name: 'date') String? date,
    @JsonKey(name: 'note') String? note,
    @JsonKey(name: 'merchant') String? merchant,
    @JsonKey(name: 'confidence') DraftConfidenceData? confidence,
    @JsonKey(name: 'items') List<ReceiptItemData>? items,
  }) = _ReceiptDraftData;

  factory ReceiptDraftData.fromJson(Map<String, dynamic> json) =>
      _$ReceiptDraftDataFromJson(json);
}

@freezed
abstract class ReceiptItemData with _$ReceiptItemData {
  const factory ReceiptItemData({
    @JsonKey(name: 'name') String? name,
    @JsonKey(name: 'quantity') double? quantity,
    @JsonKey(name: 'amount') int? amount,
  }) = _ReceiptItemData;

  factory ReceiptItemData.fromJson(Map<String, dynamic> json) =>
      _$ReceiptItemDataFromJson(json);
}
