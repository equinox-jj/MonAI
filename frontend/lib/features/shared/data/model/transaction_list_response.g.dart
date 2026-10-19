// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'transaction_list_response.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_TransactionListResponse _$TransactionListResponseFromJson(
  Map<String, dynamic> json,
) => _TransactionListResponse(
  success: json['success'] as bool?,
  message: json['message'] as String?,
  data: (json['data'] as List<dynamic>?)
      ?.map((e) => TransactionData.fromJson(e as Map<String, dynamic>))
      .toList(),
  meta: json['meta'] == null
      ? null
      : TransactionListMeta.fromJson(json['meta'] as Map<String, dynamic>),
);

Map<String, dynamic> _$TransactionListResponseToJson(
  _TransactionListResponse instance,
) => <String, dynamic>{
  'success': instance.success,
  'message': instance.message,
  'data': instance.data,
  'meta': instance.meta,
};

_TransactionListMeta _$TransactionListMetaFromJson(Map<String, dynamic> json) =>
    _TransactionListMeta(
      nextCursor: json['next_cursor'] as String?,
      hasMore: json['has_more'] as bool?,
      limit: (json['limit'] as num?)?.toInt(),
    );

Map<String, dynamic> _$TransactionListMetaToJson(
  _TransactionListMeta instance,
) => <String, dynamic>{
  'next_cursor': instance.nextCursor,
  'has_more': instance.hasMore,
  'limit': instance.limit,
};
