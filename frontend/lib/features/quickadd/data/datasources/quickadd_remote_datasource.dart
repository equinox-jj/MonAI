import 'package:dio/dio.dart';
import 'package:monai/core/base/base_remote_data_source.dart';
import 'package:monai/features/quickadd/data/datasources/endpoint/quickadd_endpoint.dart';
import 'package:monai/features/quickadd/data/model/parse_transaction_request.dart';
import 'package:monai/features/quickadd/data/model/parse_transaction_response.dart';

abstract class QuickaddRemoteDataSource {
  Future<ParseTransactionResponse> parseTransaction(
    ParseTransactionRequest request,
  );
}

class QuickaddRemoteDataSourceImpl extends QuickaddRemoteDataSource
    with BaseRemoteDataSource {
  QuickaddRemoteDataSourceImpl({required this._dio});

  final Dio _dio;

  @override
  Future<ParseTransactionResponse> parseTransaction(
    ParseTransactionRequest request,
  ) => safeApiCall(() async {
    final response = await _dio.post<Map<String, dynamic>>(
      QuickaddEndpoint.parse,
      data: request.toJson(),
    );
    return ParseTransactionResponse.fromJson(response.data ?? const {});
  });
}
