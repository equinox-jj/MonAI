import 'dart:typed_data';

import 'package:dio/dio.dart';
import 'package:monai/core/base/base_remote_data_source.dart';
import 'package:monai/features/settings/data/datasources/endpoint/admin_provider_endpoint.dart';
import 'package:monai/features/settings/data/model/admin_provider_list_response.dart';
import 'package:monai/features/settings/data/model/admin_provider_response.dart';
import 'package:monai/features/settings/data/model/create_provider_request.dart';
import 'package:monai/features/settings/data/model/provider_status_request.dart';
import 'package:monai/features/settings/data/model/update_provider_request.dart';

abstract class AdminProviderRemoteDataSource {
  /// `GET /admin/payment-providers`: page [page] of every status;
  /// [perPage] is at most 100.
  Future<AdminProviderListResponse> listProviders({
    required int page,
    required int perPage,
  });

  /// `GET /admin/payment-providers/{id}`.
  Future<AdminProviderResponse> getProvider(String id);

  /// `POST /admin/payment-providers`.
  Future<AdminProviderResponse> createProvider(CreateProviderRequest request);

  /// `PATCH /admin/payment-providers/{id}`.
  Future<AdminProviderResponse> updateProvider(
    String id,
    UpdateProviderRequest request,
  );

  /// `PATCH /admin/payment-providers/{id}/status`.
  Future<AdminProviderResponse> setStatus(
    String id,
    ProviderStatusRequest request,
  );

  /// `DELETE /admin/payment-providers/{id}`.
  Future<void> deleteProvider(String id);

  /// `PUT /admin/payment-providers/{id}/logo`, multipart `file`.
  Future<AdminProviderResponse> uploadLogo(
    String id,
    Uint8List bytes, {
    required String filename,
  });
}

class AdminProviderRemoteDataSourceImpl extends AdminProviderRemoteDataSource
    with BaseRemoteDataSource {
  AdminProviderRemoteDataSourceImpl({required this._dio});

  final Dio _dio;

  /// Every status, inactive providers included.
  static const _allStatuses = 'ALL';

  @override
  Future<AdminProviderListResponse> listProviders({
    required int page,
    required int perPage,
  }) => safeApiCall(() async {
    final response = await _dio.get<Map<String, dynamic>>(
      AdminProviderEndpoint.providers,
      queryParameters: {
        'page': page,
        'per_page': perPage,
        'status': _allStatuses,
      },
    );
    return AdminProviderListResponse.fromJson(response.data ?? const {});
  });

  @override
  Future<AdminProviderResponse> getProvider(String id) =>
      _provider(() => _dio.get(AdminProviderEndpoint.provider(id)));

  @override
  Future<AdminProviderResponse> createProvider(CreateProviderRequest request) =>
      _provider(
        () =>
            _dio.post(AdminProviderEndpoint.providers, data: request.toJson()),
      );

  @override
  Future<AdminProviderResponse> updateProvider(
    String id,
    UpdateProviderRequest request,
  ) => _provider(
    () =>
        _dio.patch(AdminProviderEndpoint.provider(id), data: request.toJson()),
  );

  @override
  Future<AdminProviderResponse> setStatus(
    String id,
    ProviderStatusRequest request,
  ) => _provider(
    () => _dio.patch(AdminProviderEndpoint.status(id), data: request.toJson()),
  );

  @override
  Future<void> deleteProvider(String id) => safeApiCall(() async {
    await _dio.delete<void>(AdminProviderEndpoint.provider(id));
  });

  @override
  Future<AdminProviderResponse> uploadLogo(
    String id,
    Uint8List bytes, {
    required String filename,
  }) => _provider(
    () => _dio.put(
      AdminProviderEndpoint.logo(id),
      data: FormData.fromMap({
        'file': MultipartFile.fromBytes(bytes, filename: filename),
      }),
    ),
  );

  Future<AdminProviderResponse> _provider(
    Future<Response<Map<String, dynamic>>> Function() request,
  ) => safeApiCall(() async {
    final response = await request();
    return AdminProviderResponse.fromJson(response.data ?? const {});
  });
}
