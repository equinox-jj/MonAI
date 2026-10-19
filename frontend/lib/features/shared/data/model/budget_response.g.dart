// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'budget_response.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_BudgetResponse _$BudgetResponseFromJson(Map<String, dynamic> json) =>
    _BudgetResponse(
      success: json['success'] as bool?,
      message: json['message'] as String?,
      data: json['data'] == null
          ? null
          : BudgetData.fromJson(json['data'] as Map<String, dynamic>),
    );

Map<String, dynamic> _$BudgetResponseToJson(_BudgetResponse instance) =>
    <String, dynamic>{
      'success': instance.success,
      'message': instance.message,
      'data': instance.data,
    };

_BudgetData _$BudgetDataFromJson(Map<String, dynamic> json) => _BudgetData(
  month: json['month'] as String?,
  limitAmount: (json['limit_amount'] as num?)?.toInt(),
  spent: (json['spent'] as num?)?.toInt(),
  remaining: (json['remaining'] as num?)?.toInt(),
  progressPercent: (json['progress_percent'] as num?)?.toDouble(),
  status: json['status'] as String?,
);

Map<String, dynamic> _$BudgetDataToJson(_BudgetData instance) =>
    <String, dynamic>{
      'month': instance.month,
      'limit_amount': instance.limitAmount,
      'spent': instance.spent,
      'remaining': instance.remaining,
      'progress_percent': instance.progressPercent,
      'status': instance.status,
    };
