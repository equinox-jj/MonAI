// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'admin_provider_list_response.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_AdminProviderListResponse _$AdminProviderListResponseFromJson(
  Map<String, dynamic> json,
) => _AdminProviderListResponse(
  success: json['success'] as bool?,
  message: json['message'] as String?,
  data: (json['data'] as List<dynamic>?)
      ?.map((e) => AdminProviderData.fromJson(e as Map<String, dynamic>))
      .toList(),
  meta: json['meta'] == null
      ? null
      : AdminProviderListMeta.fromJson(json['meta'] as Map<String, dynamic>),
);

Map<String, dynamic> _$AdminProviderListResponseToJson(
  _AdminProviderListResponse instance,
) => <String, dynamic>{
  'success': instance.success,
  'message': instance.message,
  'data': instance.data,
  'meta': instance.meta,
};

_AdminProviderListMeta _$AdminProviderListMetaFromJson(
  Map<String, dynamic> json,
) => _AdminProviderListMeta(
  page: (json['page'] as num?)?.toInt(),
  perPage: (json['per_page'] as num?)?.toInt(),
  total: (json['total'] as num?)?.toInt(),
  totalPages: (json['total_pages'] as num?)?.toInt(),
);

Map<String, dynamic> _$AdminProviderListMetaToJson(
  _AdminProviderListMeta instance,
) => <String, dynamic>{
  'page': instance.page,
  'per_page': instance.perPage,
  'total': instance.total,
  'total_pages': instance.totalPages,
};
