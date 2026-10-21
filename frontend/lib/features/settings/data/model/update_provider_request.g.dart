// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'update_provider_request.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_UpdateProviderRequest _$UpdateProviderRequestFromJson(
  Map<String, dynamic> json,
) => _UpdateProviderRequest(
  name: json['name'] as String?,
  type: json['type'] as String?,
  aliases: (json['aliases'] as List<dynamic>?)
      ?.map((e) => e as String)
      .toList(),
  sortOrder: (json['sort_order'] as num?)?.toInt(),
);

Map<String, dynamic> _$UpdateProviderRequestToJson(
  _UpdateProviderRequest instance,
) => <String, dynamic>{
  'name': ?instance.name,
  'type': ?instance.type,
  'aliases': ?instance.aliases,
  'sort_order': ?instance.sortOrder,
};
