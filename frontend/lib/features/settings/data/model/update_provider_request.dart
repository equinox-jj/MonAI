import 'package:freezed_annotation/freezed_annotation.dart';

part 'update_provider_request.freezed.dart';
part 'update_provider_request.g.dart';

/// `PATCH /admin/payment-providers/{id}`; null fields are left out, so they
/// don't change.
@freezed
abstract class UpdateProviderRequest with _$UpdateProviderRequest {
  const factory UpdateProviderRequest({
    @JsonKey(name: 'name', includeIfNull: false) String? name,
    @JsonKey(name: 'type', includeIfNull: false) String? type,
    @JsonKey(name: 'aliases', includeIfNull: false) List<String>? aliases,
    @JsonKey(name: 'sort_order', includeIfNull: false) int? sortOrder,
  }) = _UpdateProviderRequest;

  factory UpdateProviderRequest.fromJson(Map<String, dynamic> json) =>
      _$UpdateProviderRequestFromJson(json);
}
