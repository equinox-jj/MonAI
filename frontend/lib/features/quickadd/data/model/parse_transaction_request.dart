import 'package:freezed_annotation/freezed_annotation.dart';

part 'parse_transaction_request.freezed.dart';
part 'parse_transaction_request.g.dart';

@freezed
abstract class ParseTransactionRequest with _$ParseTransactionRequest {
  const factory ParseTransactionRequest({
    /// 1 to 300 characters.
    @JsonKey(name: 'text') required String text,

    /// The user's date, `yyyy-MM-dd`.
    @JsonKey(name: 'today') required String today,

    /// IANA name, e.g. `Asia/Jakarta`.
    @JsonKey(name: 'timezone') required String timezone,
  }) = _ParseTransactionRequest;

  factory ParseTransactionRequest.fromJson(Map<String, dynamic> json) =>
      _$ParseTransactionRequestFromJson(json);
}
