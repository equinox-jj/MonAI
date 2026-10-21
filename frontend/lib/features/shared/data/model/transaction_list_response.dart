import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:monai/features/shared/data/model/transaction_response.dart';

part 'transaction_list_response.freezed.dart';
part 'transaction_list_response.g.dart';

@freezed
abstract class TransactionListResponse with _$TransactionListResponse {
  const factory TransactionListResponse({
    @JsonKey(name: 'success') bool? success,
    @JsonKey(name: 'message') String? message,
    @JsonKey(name: 'data') List<TransactionData>? data,
    @JsonKey(name: 'meta') TransactionListMeta? meta,
  }) = _TransactionListResponse;

  factory TransactionListResponse.fromJson(Map<String, dynamic> json) =>
      _$TransactionListResponseFromJson(json);
}

@freezed
abstract class TransactionListMeta with _$TransactionListMeta {
  const factory TransactionListMeta({
    @JsonKey(name: 'next_cursor') String? nextCursor,
    @JsonKey(name: 'has_more') bool? hasMore,
    @JsonKey(name: 'limit') int? limit,
  }) = _TransactionListMeta;

  factory TransactionListMeta.fromJson(Map<String, dynamic> json) =>
      _$TransactionListMetaFromJson(json);
}
