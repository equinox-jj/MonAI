import 'package:dio/dio.dart';
import 'package:monai/core/base/base_remote_data_source.dart';
import 'package:monai/features/receipt/data/datasources/endpoint/receipt_endpoint.dart';
import 'package:monai/features/receipt/data/model/parse_receipt_request.dart';
import 'package:monai/features/receipt/data/model/parse_receipt_response.dart';

abstract class ReceiptRemoteDataSource {
  /// `POST /ai/parse-receipt`.
  Future<ParseReceiptResponse> parseReceipt(ParseReceiptRequest request);
}

class ReceiptRemoteDataSourceImpl extends ReceiptRemoteDataSource
    with BaseRemoteDataSource {
  ReceiptRemoteDataSourceImpl({required this._dio});

  final Dio _dio;

  @override
  Future<ParseReceiptResponse> parseReceipt(ParseReceiptRequest request) =>
      safeApiCall(() async {
        final response = await _dio.post<Map<String, dynamic>>(
          ReceiptEndpoint.parse,
          data: request.toJson(),
        );
        return ParseReceiptResponse.fromJson(response.data ?? const {});
      });
}
