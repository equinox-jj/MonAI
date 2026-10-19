// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'payment_provider_catalog_response.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_PaymentProviderCatalogResponse _$PaymentProviderCatalogResponseFromJson(
  Map<String, dynamic> json,
) => _PaymentProviderCatalogResponse(
  success: json['success'] as bool?,
  message: json['message'] as String?,
  data: json['data'] == null
      ? null
      : PaymentProviderCatalogData.fromJson(
          json['data'] as Map<String, dynamic>,
        ),
);

Map<String, dynamic> _$PaymentProviderCatalogResponseToJson(
  _PaymentProviderCatalogResponse instance,
) => <String, dynamic>{
  'success': instance.success,
  'message': instance.message,
  'data': instance.data,
};

_PaymentProviderCatalogData _$PaymentProviderCatalogDataFromJson(
  Map<String, dynamic> json,
) => _PaymentProviderCatalogData(
  version: (json['version'] as num?)?.toInt(),
  providers: (json['providers'] as List<dynamic>?)
      ?.map((e) => PaymentProviderData.fromJson(e as Map<String, dynamic>))
      .toList(),
);

Map<String, dynamic> _$PaymentProviderCatalogDataToJson(
  _PaymentProviderCatalogData instance,
) => <String, dynamic>{
  'version': instance.version,
  'providers': instance.providers,
};

_PaymentProviderData _$PaymentProviderDataFromJson(Map<String, dynamic> json) =>
    _PaymentProviderData(
      id: json['id'] as String?,
      slug: json['slug'] as String?,
      name: json['name'] as String?,
      type: json['type'] as String?,
      logoUrl: json['logo_url'] as String?,
      aliases: (json['aliases'] as List<dynamic>?)
          ?.map((e) => e as String)
          .toList(),
      sortOrder: (json['sort_order'] as num?)?.toInt(),
    );

Map<String, dynamic> _$PaymentProviderDataToJson(
  _PaymentProviderData instance,
) => <String, dynamic>{
  'id': instance.id,
  'slug': instance.slug,
  'name': instance.name,
  'type': instance.type,
  'logo_url': instance.logoUrl,
  'aliases': instance.aliases,
  'sort_order': instance.sortOrder,
};
