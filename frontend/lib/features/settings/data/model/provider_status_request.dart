import 'package:freezed_annotation/freezed_annotation.dart';

part 'provider_status_request.freezed.dart';
part 'provider_status_request.g.dart';

@freezed
abstract class ProviderStatusRequest with _$ProviderStatusRequest {
  const factory ProviderStatusRequest({
    @JsonKey(name: 'is_active') required bool isActive,
  }) = _ProviderStatusRequest;

  factory ProviderStatusRequest.fromJson(Map<String, dynamic> json) =>
      _$ProviderStatusRequestFromJson(json);
}
