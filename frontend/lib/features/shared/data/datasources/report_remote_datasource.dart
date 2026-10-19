import 'package:dio/dio.dart';
import 'package:monai/core/data/base_remote_data_source.dart';
import 'package:monai/features/shared/data/datasources/endpoint/report_endpoint.dart';
import 'package:monai/features/shared/data/model/monthly_report_response.dart';

abstract class ReportRemoteDataSource {
  /// `GET /reports/monthly?month={month}`.
  Future<MonthlyReportResponse> getMonthlyReport(String month);
}

class ReportRemoteDataSourceImpl extends ReportRemoteDataSource
    with BaseRemoteDataSource {
  ReportRemoteDataSourceImpl({required this._dio});

  final Dio _dio;

  @override
  Future<MonthlyReportResponse> getMonthlyReport(String month) =>
      safeApiCall(() async {
        final response = await _dio.get<Map<String, dynamic>>(
          ReportEndpoint.monthly,
          queryParameters: {'month': month},
        );
        return MonthlyReportResponse.fromJson(response.data ?? const {});
      });
}
