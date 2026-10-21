import 'dart:typed_data';

import 'package:dio/dio.dart';
import 'package:monai/core/base/base_remote_data_source.dart';
import 'package:monai/features/shared/data/datasources/endpoint/transaction_endpoint.dart';
import 'package:monai/features/shared/data/model/attach_receipt_request.dart';
import 'package:monai/features/shared/data/model/receipt_upload_response.dart';
import 'package:monai/features/shared/data/model/transaction_list_response.dart';
import 'package:monai/features/shared/data/model/transaction_request.dart';
import 'package:monai/features/shared/data/model/transaction_response.dart';

class TransactionQuery {
  const TransactionQuery({
    required this.month,
    required this.limit,
    this.walletId,
    this.categoryId,
    this.type,
    this.search,
    this.cursor,
  });

  /// `yyyy-MM`.
  final String month;
  final int limit;
  final String? walletId;
  final String? categoryId;
  final String? type;
  final String? search;
  final String? cursor;

  Map<String, dynamic> toQueryParameters() => {
    'month': month,
    'limit': limit,
    'wallet_id': ?walletId,
    'category_id': ?categoryId,
    'type': ?type,
    'q': ?search,
    'cursor': ?cursor,
  };
}

abstract class TransactionRemoteDataSource {
  Future<TransactionListResponse> getTransactions(TransactionQuery query);

  Future<TransactionResponse> getTransaction(String id);

  Future<TransactionResponse> createTransaction(TransactionRequest request);

  Future<TransactionResponse> updateTransaction(
    String id,
    TransactionRequest request,
  );

  Future<TransactionResponse> attachReceipt(
    String id,
    AttachReceiptRequest request,
  );

  Future<void> deleteTransaction(String id);

  Future<TransactionResponse> restoreTransaction(String id);

  Future<ReceiptUploadResponse> uploadReceipt(
    Uint8List bytes, {
    required String filename,
  });
}

class TransactionRemoteDataSourceImpl extends TransactionRemoteDataSource
    with BaseRemoteDataSource {
  TransactionRemoteDataSourceImpl({required this._dio});

  final Dio _dio;

  @override
  Future<TransactionListResponse> getTransactions(TransactionQuery query) =>
      safeApiCall(() async {
        final response = await _dio.get<Map<String, dynamic>>(
          TransactionEndpoint.transactions,
          queryParameters: query.toQueryParameters(),
        );
        return TransactionListResponse.fromJson(response.data ?? const {});
      });

  @override
  Future<TransactionResponse> getTransaction(String id) =>
      safeApiCall(() async {
        final response = await _dio.get<Map<String, dynamic>>(
          TransactionEndpoint.transaction(id),
        );
        return TransactionResponse.fromJson(response.data ?? const {});
      });

  @override
  Future<TransactionResponse> createTransaction(TransactionRequest request) =>
      safeApiCall(() async {
        final response = await _dio.post<Map<String, dynamic>>(
          TransactionEndpoint.transactions,
          data: request.toJson(),
        );
        return TransactionResponse.fromJson(response.data ?? const {});
      });

  @override
  Future<TransactionResponse> updateTransaction(
    String id,
    TransactionRequest request,
  ) => _patch(id, request.toJson());

  @override
  Future<TransactionResponse> attachReceipt(
    String id,
    AttachReceiptRequest request,
  ) => _patch(id, request.toJson());

  @override
  Future<void> deleteTransaction(String id) => safeApiCall(() async {
    await _dio.delete<Map<String, dynamic>>(
      TransactionEndpoint.transaction(id),
    );
  });

  @override
  Future<TransactionResponse> restoreTransaction(String id) =>
      safeApiCall(() async {
        final response = await _dio.post<Map<String, dynamic>>(
          TransactionEndpoint.restore(id),
        );
        return TransactionResponse.fromJson(response.data ?? const {});
      });

  // The server sniffs the image type from the bytes.
  @override
  Future<ReceiptUploadResponse> uploadReceipt(
    Uint8List bytes, {
    required String filename,
  }) => safeApiCall(() async {
    final response = await _dio.post<Map<String, dynamic>>(
      TransactionEndpoint.receipt,
      data: FormData.fromMap({
        'file': MultipartFile.fromBytes(bytes, filename: filename),
      }),
    );
    return ReceiptUploadResponse.fromJson(response.data ?? const {});
  });

  Future<TransactionResponse> _patch(String id, Map<String, dynamic> body) =>
      safeApiCall(() async {
        final response = await _dio.patch<Map<String, dynamic>>(
          TransactionEndpoint.transaction(id),
          data: body,
        );
        return TransactionResponse.fromJson(response.data ?? const {});
      });
}
