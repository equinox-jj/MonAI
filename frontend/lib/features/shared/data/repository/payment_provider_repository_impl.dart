import 'package:fpdart/fpdart.dart';
import 'package:monai/core/data/base_repository.dart';
import 'package:monai/core/database/monai_database.dart';
import 'package:monai/core/error/failure.dart';
import 'package:monai/features/shared/data/datasources/payment_provider_local_datasource.dart';
import 'package:monai/features/shared/data/datasources/payment_provider_remote_datasource.dart';
import 'package:monai/features/shared/data/mapper/api_values.dart';
import 'package:monai/features/shared/data/mapper/payment_provider_mapper.dart';
import 'package:monai/features/shared/domain/entity/payment_provider.dart';
import 'package:monai/features/shared/domain/repository/payment_provider_repository.dart';

class PaymentProviderRepositoryImpl extends PaymentProviderRepository
    with BaseRepository {
  PaymentProviderRepositoryImpl({required this._remote, required this._local});

  final PaymentProviderRemoteDataSource _remote;
  final PaymentProviderLocalDataSource _local;

  @override
  Stream<Either<Failure, List<PaymentProvider>>> watchProviders() =>
      safeStream(() => _local.watchAll().map(_entities));

  @override
  Future<Either<Failure, List<PaymentProvider>>> refreshProviders() =>
      safeCall(() async {
        final result = await _remote.getCatalog(etag: await _local.etag());
        // Unchanged since the cached catalog.
        if (result == null) return _entities(await _local.watchAll().first);
        final catalog = requireField(result.body.data);
        final rows = (catalog.providers ?? const [])
            .map((data) => data.toRow())
            .toList();
        await _local.replaceCatalog(
          version: requireField(catalog.version),
          etag: result.etag,
          rows: rows,
        );
        return _entities(rows);
      });

  List<PaymentProvider> _entities(List<PaymentProviderRow> rows) =>
      rows.map((row) => row.toEntity()).toList();
}
