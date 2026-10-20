import 'package:freezed_annotation/freezed_annotation.dart';

part 'set_budget_request.freezed.dart';
part 'set_budget_request.g.dart';

/// `PUT /budgets/{month}`.
@freezed
abstract class SetBudgetRequest with _$SetBudgetRequest {
  const factory SetBudgetRequest({
    @JsonKey(name: 'limit_amount') required int limitAmount,
  }) = _SetBudgetRequest;

  factory SetBudgetRequest.fromJson(Map<String, dynamic> json) =>
      _$SetBudgetRequestFromJson(json);
}
