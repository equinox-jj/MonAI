import 'package:freezed_annotation/freezed_annotation.dart';

part 'budget_response.freezed.dart';
part 'budget_response.g.dart';

@freezed
abstract class BudgetResponse with _$BudgetResponse {
  const factory BudgetResponse({
    @JsonKey(name: 'success') bool? success,
    @JsonKey(name: 'message') String? message,
    @JsonKey(name: 'data') BudgetData? data,
  }) = _BudgetResponse;

  factory BudgetResponse.fromJson(Map<String, dynamic> json) =>
      _$BudgetResponseFromJson(json);
}

@freezed
abstract class BudgetData with _$BudgetData {
  const factory BudgetData({
    @JsonKey(name: 'month') String? month,
    @JsonKey(name: 'limit_amount') int? limitAmount,
    @JsonKey(name: 'spent') int? spent,
    @JsonKey(name: 'remaining') int? remaining,
    @JsonKey(name: 'progress_percent') double? progressPercent,
    @JsonKey(name: 'status') String? status,
  }) = _BudgetData;

  factory BudgetData.fromJson(Map<String, dynamic> json) =>
      _$BudgetDataFromJson(json);
}
