import 'package:freezed_annotation/freezed_annotation.dart';

part 'delete_account_request.freezed.dart';
part 'delete_account_request.g.dart';

@freezed
abstract class DeleteAccountRequest with _$DeleteAccountRequest {
  const factory DeleteAccountRequest({
    @JsonKey(name: 'password') required String password,
  }) = _DeleteAccountRequest;

  factory DeleteAccountRequest.fromJson(Map<String, dynamic> json) =>
      _$DeleteAccountRequestFromJson(json);
}
