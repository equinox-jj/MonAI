// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'category_response.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_CategoryResponse _$CategoryResponseFromJson(Map<String, dynamic> json) =>
    _CategoryResponse(
      success: json['success'] as bool?,
      message: json['message'] as String?,
      data: json['data'] == null
          ? null
          : CategoryData.fromJson(json['data'] as Map<String, dynamic>),
    );

Map<String, dynamic> _$CategoryResponseToJson(_CategoryResponse instance) =>
    <String, dynamic>{
      'success': instance.success,
      'message': instance.message,
      'data': instance.data,
    };
