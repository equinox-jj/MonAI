// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'admin_provider_response.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_AdminProviderResponse _$AdminProviderResponseFromJson(
  Map<String, dynamic> json,
) => _AdminProviderResponse(
  success: json['success'] as bool?,
  message: json['message'] as String?,
  data: json['data'] == null
      ? null
      : AdminProviderData.fromJson(json['data'] as Map<String, dynamic>),
);

Map<String, dynamic> _$AdminProviderResponseToJson(
  _AdminProviderResponse instance,
) => <String, dynamic>{
  'success': instance.success,
  'message': instance.message,
  'data': instance.data,
};

_AdminProviderData _$AdminProviderDataFromJson(Map<String, dynamic> json) =>
    _AdminProviderData(
      id: json['id'] as String?,
      slug: json['slug'] as String?,
      name: json['name'] as String?,
      type: json['type'] as String?,
      logoUrl: json['logo_url'] as String?,
      aliases: (json['aliases'] as List<dynamic>?)
          ?.map((e) => e as String)
          .toList(),
      sortOrder: (json['sort_order'] as num?)?.toInt(),
      isActive: json['is_active'] as bool?,
      isSystem: json['is_system'] as bool?,
      updatedAt: json['updated_at'] == null
          ? null
          : DateTime.parse(json['updated_at'] as String),
    );

Map<String, dynamic> _$AdminProviderDataToJson(_AdminProviderData instance) =>
    <String, dynamic>{
      'id': instance.id,
      'slug': instance.slug,
      'name': instance.name,
      'type': instance.type,
      'logo_url': instance.logoUrl,
      'aliases': instance.aliases,
      'sort_order': instance.sortOrder,
      'is_active': instance.isActive,
      'is_system': instance.isSystem,
      'updated_at': instance.updatedAt?.toIso8601String(),
    };
