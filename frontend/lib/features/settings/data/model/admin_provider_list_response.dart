import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:monai/features/settings/data/model/admin_provider_response.dart';

part 'admin_provider_list_response.freezed.dart';
part 'admin_provider_list_response.g.dart';

@freezed
abstract class AdminProviderListResponse with _$AdminProviderListResponse {
  const factory AdminProviderListResponse({
    @JsonKey(name: 'success') bool? success,
    @JsonKey(name: 'message') String? message,
    @JsonKey(name: 'data') List<AdminProviderData>? data,
    @JsonKey(name: 'meta') AdminProviderListMeta? meta,
  }) = _AdminProviderListResponse;

  factory AdminProviderListResponse.fromJson(Map<String, dynamic> json) =>
      _$AdminProviderListResponseFromJson(json);
}

@freezed
abstract class AdminProviderListMeta with _$AdminProviderListMeta {
  const factory AdminProviderListMeta({
    @JsonKey(name: 'page') int? page,
    @JsonKey(name: 'per_page') int? perPage,
    @JsonKey(name: 'total') int? total,
    @JsonKey(name: 'total_pages') int? totalPages,
  }) = _AdminProviderListMeta;

  factory AdminProviderListMeta.fromJson(Map<String, dynamic> json) =>
      _$AdminProviderListMetaFromJson(json);
}
