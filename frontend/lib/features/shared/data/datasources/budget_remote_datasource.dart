import 'package:dio/dio.dart';
import 'package:monai/core/data/base_remote_data_source.dart';
import 'package:monai/features/shared/data/datasources/endpoint/budget_endpoint.dart';
import 'package:monai/features/shared/data/model/budget_response.dart';
import 'package:monai/features/shared/data/model/set_budget_request.dart';

abstract class BudgetRemoteDataSource {
  /// `GET /budgets/{month}`; a 404 means no budget is set.
  Future<BudgetResponse> getBudget(String month);

  /// `PUT /budgets/{month}`.
  Future<BudgetResponse> setBudget(String month, SetBudgetRequest request);

  /// `DELETE /budgets/{month}`.
  Future<void> deleteBudget(String month);
}

class BudgetRemoteDataSourceImpl extends BudgetRemoteDataSource
    with BaseRemoteDataSource {
  BudgetRemoteDataSourceImpl({required this._dio});

  final Dio _dio;

  @override
  Future<BudgetResponse> getBudget(String month) => safeApiCall(() async {
    final response = await _dio.get<Map<String, dynamic>>(
      BudgetEndpoint.budget(month),
    );
    return BudgetResponse.fromJson(response.data ?? const {});
  });

  @override
  Future<BudgetResponse> setBudget(String month, SetBudgetRequest request) =>
      safeApiCall(() async {
        final response = await _dio.put<Map<String, dynamic>>(
          BudgetEndpoint.budget(month),
          data: request.toJson(),
        );
        return BudgetResponse.fromJson(response.data ?? const {});
      });

  @override
  Future<void> deleteBudget(String month) => safeApiCall(() async {
    await _dio.delete<Map<String, dynamic>>(BudgetEndpoint.budget(month));
  });
}
