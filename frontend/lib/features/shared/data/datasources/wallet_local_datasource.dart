import 'package:monai/core/base/base_local_data_source.dart';
import 'package:monai/core/data/database/daos/wallet_dao.dart';
import 'package:monai/core/data/database/monai_database.dart';

abstract class WalletLocalDataSource {
  /// Every cached wallet, archived ones included; default first, then by
  /// name.
  Stream<List<WalletRow>> watchAll();

  /// The wallet with [id], or null when it isn't cached.
  Stream<WalletRow?> watch(String id);

  /// The cached wallet with [id] now, or null when it isn't cached.
  Future<WalletRow?> find(String id);

  /// Replaces the whole cache with the server's list.
  Future<void> replaceAll(List<WalletRow> rows);

  /// Caches one wallet. When it is the default, the other cached wallets stop
  /// being the default, as the server does.
  Future<void> save(WalletRow row);

  Future<void> deleteById(String id);
}

class WalletLocalDataSourceImpl extends WalletLocalDataSource
    with BaseLocalDataSource {
  WalletLocalDataSourceImpl({required this._dao});

  final WalletDao _dao;

  @override
  Stream<List<WalletRow>> watchAll() => safeCacheStream(_dao.watchAll);

  @override
  Stream<WalletRow?> watch(String id) => safeCacheStream(() => _dao.watch(id));

  @override
  Future<WalletRow?> find(String id) =>
      safeCacheCall(() => _dao.watch(id).first);

  @override
  Future<void> replaceAll(List<WalletRow> rows) =>
      safeCacheCall(() => _dao.replaceAll(rows));

  @override
  Future<void> save(WalletRow row) => safeCacheCall(() async {
    if (!row.isDefault) return _dao.upsertAll([row]);
    final formerDefaults = (await _dao.watchAll().first)
        .where((wallet) => wallet.isDefault && wallet.id != row.id)
        .map((wallet) => wallet.copyWith(isDefault: false));
    await _dao.upsertAll([...formerDefaults, row]);
  });

  @override
  Future<void> deleteById(String id) =>
      safeCacheCall(() => _dao.deleteById(id));
}
