import 'package:fpdart/fpdart.dart';
import 'package:monai/core/base/base_repository.dart';
import 'package:monai/core/base/error/failure.dart';
import 'package:monai/features/export/data/datasources/export_local_datasource.dart';
import 'package:monai/features/export/domain/repository/export_repository.dart';
import 'package:monai/features/shared/data/datasources/transaction_remote_datasource.dart';
import 'package:monai/features/shared/data/mapper/api_values.dart';
import 'package:monai/features/shared/data/mapper/transaction_mapper.dart';
import 'package:monai/features/shared/data/model/transaction_response.dart';
import 'package:monai/features/shared/domain/entity/transaction.dart';

class ExportRepositoryImpl extends ExportRepository with BaseRepository {
  ExportRepositoryImpl({required this._remote, required this._local});

  /// The API's largest page.
  static const pageSize = 100;

  final TransactionRemoteDataSource _remote;
  final ExportLocalDataSource _local;

  @override
  Future<Either<Failure, List<Transaction>>> fetchMonth(DateTime month) =>
      safeCall(() async {
        final all = <Transaction>[];
        String? cursor;
        do {
          final response = await _remote.getTransactions(
            TransactionQuery(
              month: formatApiMonth(month),
              limit: pageSize,
              cursor: cursor,
            ),
          );
          final rows = [
            for (final data in response.data ?? const <TransactionData>[])
              data.toRow(),
          ];
          await _local.cache(rows);
          all.addAll(rows.map((r) => r.toEntity()));
          final meta = response.meta;
          cursor = (meta?.hasMore ?? false) ? meta?.nextCursor : null;
        } while (cursor != null);
        return all;
      });

  @override
  Future<Either<Failure, List<Transaction>>> cachedBetween(
    DateTime from,
    DateTime to,
  ) => safeCall(
    () async => [
      for (final row in await _local.between(from, to)) row.toEntity(),
    ],
  );

  @override
  Future<Either<Failure, String>> writeFile(String name, String content) =>
      safeCall(() => _local.writeExport(name, content));

  @override
  Future<Either<Failure, String?>> savedDelimiter() =>
      safeCall(_local.delimiter);

  @override
  Future<Either<Failure, Unit>> saveDelimiter(String name) =>
      safeCall(() async {
        await _local.saveDelimiter(name);
        return unit;
      });
}
