import 'package:freezed_annotation/freezed_annotation.dart';

part 'admin_provider_response.freezed.dart';
part 'admin_provider_response.g.dart';

@freezed
abstract class AdminProviderResponse with _$AdminProviderResponse {
  const factory AdminProviderResponse({
    @JsonKey(name: 'success') bool? success,
    @JsonKey(name: 'message') String? message,
    @JsonKey(name: 'data') AdminProviderData? data,
  }) = _AdminProviderResponse;

  factory AdminProviderResponse.fromJson(Map<String, dynamic> json) =>
      _$AdminProviderResponseFromJson(json);
}

@freezed
abstract class AdminProviderData with _$AdminProviderData {
  const factory AdminProviderData({
    @JsonKey(name: 'id') String? id,
    @JsonKey(name: 'slug') String? slug,
    @JsonKey(name: 'name') String? name,
    @JsonKey(name: 'type') String? type,
    @JsonKey(name: 'logo_url') String? logoUrl,
    @JsonKey(name: 'aliases') List<String>? aliases,
    @JsonKey(name: 'sort_order') int? sortOrder,
    @JsonKey(name: 'is_active') bool? isActive,
    @JsonKey(name: 'is_system') bool? isSystem,
    @JsonKey(name: 'updated_at') DateTime? updatedAt,
  }) = _AdminProviderData;

  factory AdminProviderData.fromJson(Map<String, dynamic> json) =>
      _$AdminProviderDataFromJson(json);
}
