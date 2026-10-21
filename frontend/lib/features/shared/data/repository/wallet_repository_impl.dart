import 'package:fpdart/fpdart.dart';
import 'package:monai/core/base/base_repository.dart';
import 'package:monai/core/base/error/exceptions.dart';
import 'package:monai/core/base/error/failure.dart';
import 'package:monai/core/data/database/monai_database.dart';
import 'package:monai/features/shared/data/datasources/wallet_local_datasource.dart';
import 'package:monai/features/shared/data/datasources/wallet_remote_datasource.dart';
import 'package:monai/features/shared/data/mapper/api_values.dart';
import 'package:monai/features/shared/data/mapper/wallet_mapper.dart';
import 'package:monai/features/shared/data/model/wallet_response.dart';
import 'package:monai/features/shared/domain/entity/wallet.dart';
import 'package:monai/features/shared/domain/entity/wallet_changes.dart';
import 'package:monai/features/shared/domain/entity/wallet_input.dart';
import 'package:monai/features/shared/domain/repository/wallet_repository.dart';

class WalletRepositoryImpl extends WalletRepository with BaseRepository {
  WalletRepositoryImpl({required this._remote, required this._local});

  final WalletRemoteDataSource _remote;
  final WalletLocalDataSource _local;

  @override
  Stream<Either<Failure, List<Wallet>>> watchWallets() => safeStream(
    () => _local.watchAll().map(
      (rows) => [
        for (final row in rows)
          if (!row.isArchived) row.toEntity(),
      ],
    ),
  );

  @override
  Stream<Either<Failure, List<Wallet>>> watchAllWallets() => safeStream(
    () => _local.watchAll().map(
      (rows) => rows.map((row) => row.toEntity()).toList(),
    ),
  );

  @override
  Stream<Either<Failure, Wallet?>> watchWallet(String id) =>
      safeStream(() => _local.watch(id).map((row) => row?.toEntity()));

  @override
  Future<Either<Failure, List<Wallet>>> refreshWallets() => safeCall(() async {
    final response = await _remote.getWallets();
    final rows = (response.data ?? const <WalletData>[])
        .map((data) => data.toRow())
        .toList();
    await _local.replaceAll(rows);
    return rows.map((row) => row.toEntity()).toList();
  });

  @override
  Future<Either<Failure, Wallet>> refreshWallet(String id) =>
      safeCall(() async {
        try {
          final row = _row(await _remote.getWallet(id));
          await _local.save(row);
          return row.toEntity();
        } on NotFoundException {
          await _local.deleteById(id);
          rethrow;
        }
      });

  @override
  Future<Either<Failure, Wallet>> createWallet(WalletInput input) =>
      _write(() => _remote.createWallet(input.toRequest()));

  @override
  Future<Either<Failure, Wallet>> updateWallet(
    String id,
    WalletChanges changes,
  ) => _write(() => _remote.updateWallet(id, changes.toRequest()));

  @override
  Future<Either<Failure, Wallet?>> deleteWallet(String id) =>
      safeCall(() async {
        final cached = await _local.find(id);
        await _remote.deleteWallet(id);
        await _local.deleteById(id);
        return cached?.toEntity();
      });

  Future<Either<Failure, Wallet>> _write(
    Future<WalletResponse> Function() request,
  ) => safeCall(() async {
    final row = _row(await request());
    await _local.save(row);
    return row.toEntity();
  });

  WalletRow _row(WalletResponse response) =>
      requireField(response.data).toRow();
}
