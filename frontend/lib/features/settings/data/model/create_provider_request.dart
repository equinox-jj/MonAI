import 'package:freezed_annotation/freezed_annotation.dart';

part 'create_provider_request.freezed.dart';
part 'create_provider_request.g.dart';

/// `POST /admin/payment-providers`; the server makes the slug from the name.
@freezed
abstract class CreateProviderRequest with _$CreateProviderRequest {
  const factory CreateProviderRequest({
    @JsonKey(name: 'name') required String name,

    /// `CASH`, `BANK`, `E_WALLET` or `OTHER`.
    @JsonKey(name: 'type') required String type,
    @JsonKey(name: 'aliases') required List<String> aliases,
    @JsonKey(name: 'sort_order') required int sortOrder,
  }) = _CreateProviderRequest;

  factory CreateProviderRequest.fromJson(Map<String, dynamic> json) =>
      _$CreateProviderRequestFromJson(json);
}
