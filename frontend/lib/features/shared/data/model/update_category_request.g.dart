// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'update_category_request.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_UpdateCategoryRequest _$UpdateCategoryRequestFromJson(
  Map<String, dynamic> json,
) => _UpdateCategoryRequest(
  name: json['name'] as String?,
  icon: json['icon'] as String?,
  color: json['color'] as String?,
  isHidden: json['is_hidden'] as bool?,
);

Map<String, dynamic> _$UpdateCategoryRequestToJson(
  _UpdateCategoryRequest instance,
) => <String, dynamic>{
  'name': ?instance.name,
  'icon': ?instance.icon,
  'color': ?instance.color,
  'is_hidden': ?instance.isHidden,
};
