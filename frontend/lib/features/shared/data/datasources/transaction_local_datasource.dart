import 'package:monai/core/base/base_local_data_source.dart';
import 'package:monai/core/data/database/daos/transaction_dao.dart';
import 'package:monai/core/data/database/daos/transaction_filter.dart' as db;
import 'package:monai/core/data/database/fts_query.dart';
import 'package:monai/core/data/database/monai_database.dart';
import 'package:monai/features/shared/data/mapper/api_values.dart';
import 'package:monai/features/shared/domain/entity/transaction_filter.dart';

abstract class TransactionLocalDataSource {
  Stream<List<TransactionRow>> watchRecent(
    DateTime month, {
    required int limit,
  });

  Future<void> replaceRecent(
    DateTime month,
    List<TransactionRow> rows, {
    required bool hasMore,
  });

  Stream<List<TransactionRow>> watchPage(
    DateTime month,
    TransactionFilter filter, {
    required int limit,
  });

  Future<TransactionRemoteKeyRow?> remoteKey(
    DateTime month,
    TransactionFilter filter,
  );

  Future<void> replaceFirstPage(
    DateTime month,
    TransactionFilter filter,
    List<TransactionRow> rows, {
    required String? nextCursor,
  });

  Future<void> appendPage(
    DateTime month,
    TransactionFilter filter,
    List<TransactionRow> rows, {
    required String? nextCursor,
  });

  Stream<Map<DateTime, int>> watchDailyNets(
    DateTime month,
    TransactionFilter filter,
  );

  Stream<Map<DateTime, int>> watchDailyOutflows(
    DateTime month,
    String walletId,
  );

  Stream<List<TransactionRow>> watchSearch(
    String query,
    TransactionFilter filter, {
    required int limit,
  });

  Stream<TransactionRow?> watch(String id);

  Future<TransactionRow?> find(String id);

  Future<void> upsertAll(List<TransactionRow> rows);

  Future<void> deleteById(String id);
}

class TransactionLocalDataSourceImpl extends TransactionLocalDataSource
    with BaseLocalDataSource {
  TransactionLocalDataSourceImpl({required this._dao, DateTime Function()? now})
    : _now = now ?? DateTime.now;

  final TransactionDao _dao;
  final DateTime Function() _now;

  // Wide enough for any transaction, for searches across all dates.
  static final _allDatesFrom = DateTime(1970);
  static final _allDatesTo = DateTime(9999, 12, 31);

  /// The paging key of a list: `yyyy-MM|walletId|categoryId|type`, with
  /// empty parts for unset filters.
  static String queryKey(DateTime month, TransactionFilter filter) => [
    formatApiMonth(month),
    filter.walletId ?? '',
    filter.categoryId ?? '',
    filter.type?.name ?? '',
  ].join('|');

  @override
  Stream<List<TransactionRow>> watchRecent(
    DateTime month, {
    required int limit,
  }) {
    final (from, to) = _range(month);
    return safeCacheStream(() => _dao.watchRecent(from, to, limit: limit));
  }

  @override
  Future<void> replaceRecent(
    DateTime month,
    List<TransactionRow> rows, {
    required bool hasMore,
  }) {
    final (from, to) = _range(month);
    return safeCacheCall(
      () => _dao.replaceRecent(from, to, rows, hasMore: hasMore),
    );
  }

  @override
  Stream<List<TransactionRow>> watchPage(
    DateTime month,
    TransactionFilter filter, {
    required int limit,
  }) => safeCacheStream(
    () => _dao.watchPage(_dbFilter(month, filter), limit: limit),
  );

  @override
  Future<TransactionRemoteKeyRow?> remoteKey(
    DateTime month,
    TransactionFilter filter,
  ) => safeCacheCall(() => _dao.remoteKey(queryKey(month, filter)));

  @override
  Future<void> replaceFirstPage(
    DateTime month,
    TransactionFilter filter,
    List<TransactionRow> rows, {
    required String? nextCursor,
  }) => safeCacheCall(
    () => _dao.replaceQueryPage(
      _dbFilter(month, filter),
      rows,
      _key(month, filter, nextCursor),
    ),
  );

  @override
  Future<void> appendPage(
    DateTime month,
    TransactionFilter filter,
    List<TransactionRow> rows, {
    required String? nextCursor,
  }) => safeCacheCall(
    () => _dao.appendQueryPage(rows, _key(month, filter, nextCursor)),
  );

  @override
  Stream<Map<DateTime, int>> watchDailyNets(
    DateTime month,
    TransactionFilter filter,
  ) => safeCacheStream(
    () => _dao
        .watchDailyNets(_dbFilter(month, filter))
        .map((days) => {for (final day in days) day.date: day.net}),
  );

  @override
  Stream<Map<DateTime, int>> watchDailyOutflows(
    DateTime month,
    String walletId,
  ) {
    final (from, to) = _range(month);
    return safeCacheStream(
      () => _dao
          .watchDailyOutflows(from, to, walletId)
          .map((days) => {for (final day in days) day.date: day.amount}),
    );
  }

  @override
  Stream<List<TransactionRow>> watchSearch(
    String query,
    TransactionFilter filter, {
    required int limit,
  }) {
    final match = toFtsMatchQuery(query);
    if (match == null) return Stream.value(const []);
    return safeCacheStream(
      () => _dao.watchSearch(
        match,
        db.TransactionFilter(
          from: _allDatesFrom,
          to: _allDatesTo,
          walletId: filter.walletId,
          categoryId: filter.categoryId,
          type: filter.type,
        ),
        limit: limit,
      ),
    );
  }

  @override
  Stream<TransactionRow?> watch(String id) =>
      safeCacheStream(() => _dao.watch(id));

  @override
  Future<TransactionRow?> find(String id) =>
      safeCacheCall(() => _dao.watch(id).first);

  @override
  Future<void> upsertAll(List<TransactionRow> rows) =>
      safeCacheCall(() => _dao.upsertAll(rows));

  @override
  Future<void> deleteById(String id) =>
      safeCacheCall(() => _dao.deleteById(id));

  (DateTime, DateTime) _range(DateTime month) => (
    DateTime(month.year, month.month),
    DateTime(month.year, month.month + 1, 0),
  );

  db.TransactionFilter _dbFilter(DateTime month, TransactionFilter filter) {
    final (from, to) = _range(month);
    return db.TransactionFilter(
      from: from,
      to: to,
      walletId: filter.walletId,
      categoryId: filter.categoryId,
      type: filter.type,
    );
  }

  TransactionRemoteKeyRow _key(
    DateTime month,
    TransactionFilter filter,
    String? nextCursor,
  ) => TransactionRemoteKeyRow(
    queryKey: queryKey(month, filter),
    nextCursor: nextCursor,
    updatedAt: _now(),
  );
}
