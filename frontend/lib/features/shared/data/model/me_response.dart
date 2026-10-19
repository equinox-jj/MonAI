import 'package:freezed_annotation/freezed_annotation.dart';

part 'me_response.freezed.dart';
part 'me_response.g.dart';

/// `GET /me`.
@freezed
abstract class MeResponse with _$MeResponse {
  const factory MeResponse({
    @JsonKey(name: 'success') bool? success,
    @JsonKey(name: 'message') String? message,
    @JsonKey(name: 'data') MeData? data,
  }) = _MeResponse;

  factory MeResponse.fromJson(Map<String, dynamic> json) =>
      _$MeResponseFromJson(json);
}

@freezed
abstract class MeData with _$MeData {
  const factory MeData({
    @JsonKey(name: 'id') String? id,
    @JsonKey(name: 'name') String? name,
    @JsonKey(name: 'email') String? email,
    @JsonKey(name: 'avatar_url') String? avatarUrl,
    @JsonKey(name: 'timezone') String? timezone,
    @JsonKey(name: 'role') MeRole? role,
    @JsonKey(name: 'permissions') List<String>? permissions,
    @JsonKey(name: 'created_at') DateTime? createdAt,
  }) = _MeData;

  factory MeData.fromJson(Map<String, dynamic> json) => _$MeDataFromJson(json);
}

@freezed
abstract class MeRole with _$MeRole {
  const factory MeRole({
    @JsonKey(name: 'slug') String? slug,
    @JsonKey(name: 'name') String? name,
  }) = _MeRole;

  factory MeRole.fromJson(Map<String, dynamic> json) => _$MeRoleFromJson(json);
}
