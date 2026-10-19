import 'package:dio/dio.dart';
import 'package:monai/core/data/base_remote_data_source.dart';
import 'package:monai/features/shared/data/datasources/endpoint/budget_endpoint.dart';
import 'package:monai/features/shared/data/model/budget_response.dart';

abstract class BudgetRemoteDataSource {
  /// `GET /budgets/{month}`; a 404 means no budget is set.
  Future<BudgetResponse> getBudget(String month);
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
}
