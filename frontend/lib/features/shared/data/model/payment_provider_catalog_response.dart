import 'package:freezed_annotation/freezed_annotation.dart';

part 'payment_provider_catalog_response.freezed.dart';
part 'payment_provider_catalog_response.g.dart';

/// `GET /payment-providers`.
@freezed
abstract class PaymentProviderCatalogResponse
    with _$PaymentProviderCatalogResponse {
  const factory PaymentProviderCatalogResponse({
    @JsonKey(name: 'success') bool? success,
    @JsonKey(name: 'message') String? message,
    @JsonKey(name: 'data') PaymentProviderCatalogData? data,
  }) = _PaymentProviderCatalogResponse;

  factory PaymentProviderCatalogResponse.fromJson(Map<String, dynamic> json) =>
      _$PaymentProviderCatalogResponseFromJson(json);
}

@freezed
abstract class PaymentProviderCatalogData with _$PaymentProviderCatalogData {
  const factory PaymentProviderCatalogData({
    @JsonKey(name: 'version') int? version,
    @JsonKey(name: 'providers') List<PaymentProviderData>? providers,
  }) = _PaymentProviderCatalogData;

  factory PaymentProviderCatalogData.fromJson(Map<String, dynamic> json) =>
      _$PaymentProviderCatalogDataFromJson(json);
}

@freezed
abstract class PaymentProviderData with _$PaymentProviderData {
  const factory PaymentProviderData({
    @JsonKey(name: 'id') String? id,
    @JsonKey(name: 'slug') String? slug,
    @JsonKey(name: 'name') String? name,
    @JsonKey(name: 'type') String? type,
    @JsonKey(name: 'logo_url') String? logoUrl,
    @JsonKey(name: 'aliases') List<String>? aliases,
    @JsonKey(name: 'sort_order') int? sortOrder,
  }) = _PaymentProviderData;

  factory PaymentProviderData.fromJson(Map<String, dynamic> json) =>
      _$PaymentProviderDataFromJson(json);
}
