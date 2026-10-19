// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'monthly_report_response.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_MonthlyReportResponse _$MonthlyReportResponseFromJson(
  Map<String, dynamic> json,
) => _MonthlyReportResponse(
  success: json['success'] as bool?,
  message: json['message'] as String?,
  data: json['data'] == null
      ? null
      : MonthlyReportData.fromJson(json['data'] as Map<String, dynamic>),
);

Map<String, dynamic> _$MonthlyReportResponseToJson(
  _MonthlyReportResponse instance,
) => <String, dynamic>{
  'success': instance.success,
  'message': instance.message,
  'data': instance.data,
};

_MonthlyReportData _$MonthlyReportDataFromJson(
  Map<String, dynamic> json,
) => _MonthlyReportData(
  month: json['month'] as String?,
  incomeTotal: (json['income_total'] as num?)?.toInt(),
  expenseTotal: (json['expense_total'] as num?)?.toInt(),
  net: (json['net'] as num?)?.toInt(),
  previous: json['previous'] == null
      ? null
      : PreviousMonthData.fromJson(json['previous'] as Map<String, dynamic>),
  expenseChangePercent: (json['expense_change_percent'] as num?)?.toDouble(),
  categories: (json['categories'] as List<dynamic>?)
      ?.map((e) => CategoryBreakdownData.fromJson(e as Map<String, dynamic>))
      .toList(),
);

Map<String, dynamic> _$MonthlyReportDataToJson(_MonthlyReportData instance) =>
    <String, dynamic>{
      'month': instance.month,
      'income_total': instance.incomeTotal,
      'expense_total': instance.expenseTotal,
      'net': instance.net,
      'previous': instance.previous,
      'expense_change_percent': instance.expenseChangePercent,
      'categories': instance.categories,
    };

_PreviousMonthData _$PreviousMonthDataFromJson(Map<String, dynamic> json) =>
    _PreviousMonthData(
      month: json['month'] as String?,
      incomeTotal: (json['income_total'] as num?)?.toInt(),
      expenseTotal: (json['expense_total'] as num?)?.toInt(),
    );

Map<String, dynamic> _$PreviousMonthDataToJson(_PreviousMonthData instance) =>
    <String, dynamic>{
      'month': instance.month,
      'income_total': instance.incomeTotal,
      'expense_total': instance.expenseTotal,
    };

_CategoryBreakdownData _$CategoryBreakdownDataFromJson(
  Map<String, dynamic> json,
) => _CategoryBreakdownData(
  categoryId: json['category_id'] as String?,
  name: json['name'] as String?,
  icon: json['icon'] as String?,
  color: json['color'] as String?,
  amount: (json['amount'] as num?)?.toInt(),
  sharePercent: (json['share_percent'] as num?)?.toDouble(),
  previousAmount: (json['previous_amount'] as num?)?.toInt(),
  changePercent: (json['change_percent'] as num?)?.toDouble(),
);

Map<String, dynamic> _$CategoryBreakdownDataToJson(
  _CategoryBreakdownData instance,
) => <String, dynamic>{
  'category_id': instance.categoryId,
  'name': instance.name,
  'icon': instance.icon,
  'color': instance.color,
  'amount': instance.amount,
  'share_percent': instance.sharePercent,
  'previous_amount': instance.previousAmount,
  'change_percent': instance.changePercent,
};
