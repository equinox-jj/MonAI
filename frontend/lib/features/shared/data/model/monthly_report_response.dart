import 'package:freezed_annotation/freezed_annotation.dart';

part 'monthly_report_response.freezed.dart';
part 'monthly_report_response.g.dart';

/// `GET /reports/monthly`.
@freezed
abstract class MonthlyReportResponse with _$MonthlyReportResponse {
  const factory MonthlyReportResponse({
    @JsonKey(name: 'success') bool? success,
    @JsonKey(name: 'message') String? message,
    @JsonKey(name: 'data') MonthlyReportData? data,
  }) = _MonthlyReportResponse;

  factory MonthlyReportResponse.fromJson(Map<String, dynamic> json) =>
      _$MonthlyReportResponseFromJson(json);
}

@freezed
abstract class MonthlyReportData with _$MonthlyReportData {
  const factory MonthlyReportData({
    @JsonKey(name: 'month') String? month,
    @JsonKey(name: 'income_total') int? incomeTotal,
    @JsonKey(name: 'expense_total') int? expenseTotal,
    @JsonKey(name: 'net') int? net,
    @JsonKey(name: 'previous') PreviousMonthData? previous,
    @JsonKey(name: 'expense_change_percent') double? expenseChangePercent,
    @JsonKey(name: 'categories') List<CategoryBreakdownData>? categories,
  }) = _MonthlyReportData;

  factory MonthlyReportData.fromJson(Map<String, dynamic> json) =>
      _$MonthlyReportDataFromJson(json);
}

@freezed
abstract class PreviousMonthData with _$PreviousMonthData {
  const factory PreviousMonthData({
    @JsonKey(name: 'month') String? month,
    @JsonKey(name: 'income_total') int? incomeTotal,
    @JsonKey(name: 'expense_total') int? expenseTotal,
  }) = _PreviousMonthData;

  factory PreviousMonthData.fromJson(Map<String, dynamic> json) =>
      _$PreviousMonthDataFromJson(json);
}

@freezed
abstract class CategoryBreakdownData with _$CategoryBreakdownData {
  const factory CategoryBreakdownData({
    @JsonKey(name: 'category_id') String? categoryId,
    @JsonKey(name: 'name') String? name,
    @JsonKey(name: 'icon') String? icon,
    @JsonKey(name: 'color') String? color,
    @JsonKey(name: 'amount') int? amount,
    @JsonKey(name: 'share_percent') double? sharePercent,
    @JsonKey(name: 'previous_amount') int? previousAmount,
    @JsonKey(name: 'change_percent') double? changePercent,
  }) = _CategoryBreakdownData;

  factory CategoryBreakdownData.fromJson(Map<String, dynamic> json) =>
      _$CategoryBreakdownDataFromJson(json);
}
