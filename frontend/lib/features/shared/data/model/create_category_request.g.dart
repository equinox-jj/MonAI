// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'create_category_request.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_CreateCategoryRequest _$CreateCategoryRequestFromJson(
  Map<String, dynamic> json,
) => _CreateCategoryRequest(
  name: json['name'] as String,
  type: json['type'] as String,
  icon: json['icon'] as String?,
  color: json['color'] as String?,
);

Map<String, dynamic> _$CreateCategoryRequestToJson(
  _CreateCategoryRequest instance,
) => <String, dynamic>{
  'name': instance.name,
  'type': instance.type,
  'icon': ?instance.icon,
  'color': ?instance.color,
};
