// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'me_response.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_MeResponse _$MeResponseFromJson(Map<String, dynamic> json) => _MeResponse(
  success: json['success'] as bool?,
  message: json['message'] as String?,
  data: json['data'] == null
      ? null
      : MeData.fromJson(json['data'] as Map<String, dynamic>),
);

Map<String, dynamic> _$MeResponseToJson(_MeResponse instance) =>
    <String, dynamic>{
      'success': instance.success,
      'message': instance.message,
      'data': instance.data,
    };

_MeData _$MeDataFromJson(Map<String, dynamic> json) => _MeData(
  id: json['id'] as String?,
  name: json['name'] as String?,
  email: json['email'] as String?,
  avatarUrl: json['avatar_url'] as String?,
  timezone: json['timezone'] as String?,
  role: json['role'] == null
      ? null
      : MeRole.fromJson(json['role'] as Map<String, dynamic>),
  permissions: (json['permissions'] as List<dynamic>?)
      ?.map((e) => e as String)
      .toList(),
  createdAt: json['created_at'] == null
      ? null
      : DateTime.parse(json['created_at'] as String),
);

Map<String, dynamic> _$MeDataToJson(_MeData instance) => <String, dynamic>{
  'id': instance.id,
  'name': instance.name,
  'email': instance.email,
  'avatar_url': instance.avatarUrl,
  'timezone': instance.timezone,
  'role': instance.role,
  'permissions': instance.permissions,
  'created_at': instance.createdAt?.toIso8601String(),
};

_MeRole _$MeRoleFromJson(Map<String, dynamic> json) =>
    _MeRole(slug: json['slug'] as String?, name: json['name'] as String?);

Map<String, dynamic> _$MeRoleToJson(_MeRole instance) => <String, dynamic>{
  'slug': instance.slug,
  'name': instance.name,
};
