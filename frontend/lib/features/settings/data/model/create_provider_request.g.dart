// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'create_provider_request.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_CreateProviderRequest _$CreateProviderRequestFromJson(
  Map<String, dynamic> json,
) => _CreateProviderRequest(
  name: json['name'] as String,
  type: json['type'] as String,
  aliases: (json['aliases'] as List<dynamic>).map((e) => e as String).toList(),
  sortOrder: (json['sort_order'] as num).toInt(),
);

Map<String, dynamic> _$CreateProviderRequestToJson(
  _CreateProviderRequest instance,
) => <String, dynamic>{
  'name': instance.name,
  'type': instance.type,
  'aliases': instance.aliases,
  'sort_order': instance.sortOrder,
};
