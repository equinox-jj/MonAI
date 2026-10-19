import 'package:dio/dio.dart';
import 'package:monai/core/data/base_remote_data_source.dart';
import 'package:monai/features/shared/data/datasources/endpoint/wallet_endpoint.dart';
import 'package:monai/features/shared/data/model/create_wallet_request.dart';
import 'package:monai/features/shared/data/model/update_wallet_request.dart';
import 'package:monai/features/shared/data/model/wallet_list_response.dart';
import 'package:monai/features/shared/data/model/wallet_response.dart';

abstract class WalletRemoteDataSource {
  /// `GET /wallets?include_archived=true`.
  Future<WalletListResponse> getWallets();

  /// `GET /wallets/{id}`.
  Future<WalletResponse> getWallet(String id);

  /// `POST /wallets`.
  Future<WalletResponse> createWallet(CreateWalletRequest request);

  /// `PATCH /wallets/{id}`.
  Future<WalletResponse> updateWallet(String id, UpdateWalletRequest request);

  /// `DELETE /wallets/{id}`.
  Future<void> deleteWallet(String id);
}

class WalletRemoteDataSourceImpl extends WalletRemoteDataSource
    with BaseRemoteDataSource {
  WalletRemoteDataSourceImpl({required this._dio});

  final Dio _dio;

  // Archived wallets too: old transactions still need their names.
  @override
  Future<WalletListResponse> getWallets() => safeApiCall(() async {
    final response = await _dio.get<Map<String, dynamic>>(
      WalletEndpoint.wallets,
      queryParameters: {'include_archived': true},
    );
    return WalletListResponse.fromJson(response.data ?? const {});
  });

  @override
  Future<WalletResponse> getWallet(String id) => safeApiCall(() async {
    final response = await _dio.get<Map<String, dynamic>>(
      WalletEndpoint.wallet(id),
    );
    return WalletResponse.fromJson(response.data ?? const {});
  });

  @override
  Future<WalletResponse> createWallet(CreateWalletRequest request) =>
      safeApiCall(() async {
        final response = await _dio.post<Map<String, dynamic>>(
          WalletEndpoint.wallets,
          data: request.toJson(),
        );
        return WalletResponse.fromJson(response.data ?? const {});
      });

  @override
  Future<WalletResponse> updateWallet(String id, UpdateWalletRequest request) =>
      safeApiCall(() async {
        final response = await _dio.patch<Map<String, dynamic>>(
          WalletEndpoint.wallet(id),
          data: request.toJson(),
        );
        return WalletResponse.fromJson(response.data ?? const {});
      });

  @override
  Future<void> deleteWallet(String id) => safeApiCall(() async {
    await _dio.delete<Map<String, dynamic>>(WalletEndpoint.wallet(id));
  });
}
