import 'dart:typed_data';

import 'package:fpdart/fpdart.dart';
import 'package:monai/core/data/base_repository.dart';
import 'package:monai/core/error/failure.dart';
import 'package:monai/core/services/image_compressor_service.dart';
import 'package:monai/features/settings/data/datasources/admin_provider_remote_datasource.dart';
import 'package:monai/features/settings/data/mapper/admin_provider_mapper.dart';
import 'package:monai/features/settings/data/model/admin_provider_response.dart';
import 'package:monai/features/settings/data/model/provider_status_request.dart';
import 'package:monai/features/settings/domain/entity/admin_payment_provider.dart';
import 'package:monai/features/settings/domain/repository/admin_provider_repository.dart';

class AdminProviderRepositoryImpl extends AdminProviderRepository
    with BaseRepository {
  AdminProviderRepositoryImpl({
    required this._remote,
    required this._compressor,
  });

  final AdminProviderRemoteDataSource _remote;
  final ImageCompressorService _compressor;

  /// The API's largest page.
  static const _pageSize = 100;

  /// Guards against a runaway loop; the catalog is far smaller.
  static const _maxPages = 20;

  static const _logoFilename = 'logo.webp';

  // The catalog is small, so every page is read at once.
  @override
  Future<Either<Failure, List<AdminPaymentProvider>>> listProviders() =>
      safeCall(() async {
        final providers = <AdminPaymentProvider>[];
        var page = 1;
        int totalPages;
        do {
          final response = await _remote.listProviders(
            page: page,
            perPage: _pageSize,
          );
          providers.addAll(
            (response.data ?? const <AdminProviderData>[]).map(
              (p) => p.toEntity(),
            ),
          );
          totalPages = response.meta?.totalPages ?? 1;
          page++;
        } while (page <= totalPages && page <= _maxPages);
        return providers..sort(_bySortOrderThenName);
      });

  @override
  Future<Either<Failure, AdminPaymentProvider>> getProvider(String id) =>
      safeCall(() async => (await _remote.getProvider(id)).toEntity());

  @override
  Future<Either<Failure, AdminPaymentProvider>> createProvider(
    ProviderInput input,
  ) => safeCall(
    () async =>
        (await _remote.createProvider(input.toCreateRequest())).toEntity(),
  );

  @override
  Future<Either<Failure, AdminPaymentProvider>> updateProvider(
    String id,
    ProviderChanges changes,
  ) => safeCall(
    () async => (await _remote.updateProvider(
      id,
      changes.toUpdateRequest(),
    )).toEntity(),
  );

  @override
  Future<Either<Failure, AdminPaymentProvider>> setActive(
    String id, {
    required bool active,
  }) => safeCall(
    () async => (await _remote.setStatus(
      id,
      ProviderStatusRequest(isActive: active),
    )).toEntity(),
  );

  @override
  Future<Either<Failure, Unit>> deleteProvider(String id) => safeCall(() async {
    await _remote.deleteProvider(id);
    return unit;
  });

  @override
  Future<Either<Failure, Uint8List>> compressLogo(String path) =>
      safeCall(() => _compressor.compressLogo(path));

  @override
  Future<Either<Failure, AdminPaymentProvider>> uploadLogo(
    String id,
    Uint8List bytes,
  ) => safeCall(
    () async => (await _remote.uploadLogo(
      id,
      bytes,
      filename: _logoFilename,
    )).toEntity(),
  );
}

int _bySortOrderThenName(AdminPaymentProvider a, AdminPaymentProvider b) {
  final bySort = a.sortOrder.compareTo(b.sortOrder);
  return bySort != 0 ? bySort : a.name.compareTo(b.name);
}
