import 'dart:typed_data';

import 'package:fpdart/fpdart.dart';
import 'package:monai/core/base/base_repository.dart';
import 'package:monai/core/data/database/monai_database.dart';
import 'package:monai/core/base/error/exceptions.dart';
import 'package:monai/core/base/error/failure.dart';
import 'package:monai/features/shared/data/datasources/transaction_local_datasource.dart';
import 'package:monai/features/shared/data/datasources/transaction_remote_datasource.dart';
import 'package:monai/features/shared/data/mapper/api_values.dart';
import 'package:monai/features/shared/data/mapper/transaction_mapper.dart';
import 'package:monai/features/shared/data/model/attach_receipt_request.dart';
import 'package:monai/features/shared/data/model/transaction_list_response.dart';
import 'package:monai/features/shared/data/model/transaction_response.dart';
import 'package:monai/features/shared/domain/entity/transaction.dart';
import 'package:monai/features/shared/domain/entity/transaction_filter.dart';
import 'package:monai/features/shared/domain/entity/transaction_input.dart';
import 'package:monai/features/shared/domain/entity/transaction_search_page.dart';
import 'package:monai/features/shared/domain/repository/transaction_repository.dart';

class TransactionRepositoryImpl extends TransactionRepository
    with BaseRepository {
  TransactionRepositoryImpl({required this._remote, required this._local});

  final TransactionRemoteDataSource _remote;
  final TransactionLocalDataSource _local;

  static const _pageSize = TransactionRepository.pageSize;

  @override
  Stream<Either<Failure, List<Transaction>>> watchRecentTransactions(
    DateTime month, {
    required int limit,
  }) =>
      safeStream(() => _local.watchRecent(month, limit: limit).map(_entities));

  @override
  Future<Either<Failure, List<Transaction>>> refreshRecentTransactions(
    DateTime month, {
    required int limit,
  }) => safeCall(() async {
    final response = await _remote.getTransactions(
      TransactionQuery(month: formatApiMonth(month), limit: limit),
    );
    final rows = _rows(response);
    await _local.replaceRecent(
      month,
      rows,
      hasMore: response.meta?.hasMore ?? false,
    );
    return _entities(rows);
  });

  @override
  Stream<Either<Failure, List<Transaction>>> watchTransactions(
    DateTime month,
    TransactionFilter filter, {
    required int limit,
  }) => safeStream(
    () => _local.watchPage(month, filter, limit: limit).map(_entities),
  );

  @override
  Future<Either<Failure, bool>> refreshTransactions(
    DateTime month,
    TransactionFilter filter,
  ) => safeCall(() => _loadFirstPage(month, filter));

  @override
  Future<Either<Failure, bool>> loadMoreTransactions(
    DateTime month,
    TransactionFilter filter,
  ) => safeCall(() async {
    final key = await _local.remoteKey(month, filter);
    if (key == null) return _loadFirstPage(month, filter);
    final cursor = key.nextCursor;
    if (cursor == null) return false;
    final response = await _remote.getTransactions(
      _query(month, filter, cursor: cursor),
    );
    final nextCursor = _nextCursor(response);
    await _local.appendPage(
      month,
      filter,
      _rows(response),
      nextCursor: nextCursor,
    );
    return nextCursor != null;
  });

  @override
  Stream<Either<Failure, Map<DateTime, int>>> watchDailyNets(
    DateTime month,
    TransactionFilter filter,
  ) => safeStream(() => _local.watchDailyNets(month, filter));

  @override
  Stream<Either<Failure, Map<DateTime, int>>> watchDailyOutflows(
    DateTime month,
    String walletId,
  ) => safeStream(() => _local.watchDailyOutflows(month, walletId));

  @override
  Future<Either<Failure, TransactionSearchPage>> searchTransactions(
    String query, {
    required DateTime month,
    required TransactionFilter filter,
    String? cursor,
  }) => safeCall(() async {
    final response = await _remote.getTransactions(
      _query(month, filter, search: query, cursor: cursor),
    );
    final rows = _rows(response);
    await _local.upsertAll(rows);
    return TransactionSearchPage(
      items: _entities(rows),
      nextCursor: _nextCursor(response),
    );
  });

  @override
  Stream<Either<Failure, List<Transaction>>> watchCachedSearch(
    String query,
    TransactionFilter filter, {
    required int limit,
  }) => safeStream(
    () => _local.watchSearch(query, filter, limit: limit).map(_entities),
  );

  @override
  Stream<Either<Failure, Transaction?>> watchTransaction(String id) =>
      safeStream(() => _local.watch(id).map((row) => row?.toEntity()));

  @override
  Future<Either<Failure, Transaction>> refreshTransaction(String id) =>
      safeCall(() async {
        try {
          final row = _row(await _remote.getTransaction(id));
          await _local.upsertAll([row]);
          return row.toEntity();
        } on NotFoundException {
          await _local.deleteById(id);
          rethrow;
        }
      });

  @override
  Future<Either<Failure, Transaction>> createTransaction(
    TransactionInput input,
  ) => _write(() => _remote.createTransaction(input.toCreateRequest()));

  @override
  Future<Either<Failure, Transaction>> updateTransaction(
    String id,
    TransactionInput input,
  ) => _write(() => _remote.updateTransaction(id, input.toUpdateRequest()));

  @override
  Future<Either<Failure, Transaction>> attachReceipt(
    String id,
    String receiptKey,
  ) => _write(
    () =>
        _remote.attachReceipt(id, AttachReceiptRequest(receiptKey: receiptKey)),
  );

  @override
  Future<Either<Failure, Transaction?>> deleteTransaction(String id) =>
      safeCall(() async {
        final cached = await _local.find(id);
        try {
          await _remote.deleteTransaction(id);
        } on NotFoundException {
          // Already gone on the server: the cache just catches up.
        }
        await _local.deleteById(id);
        return cached?.toEntity();
      });

  @override
  Future<Either<Failure, Transaction>> restoreTransaction(String id) =>
      _write(() => _remote.restoreTransaction(id));

  @override
  Future<Either<Failure, String>> uploadReceipt(
    Uint8List bytes, {
    required String filename,
  }) => safeCall(() async {
    final response = await _remote.uploadReceipt(bytes, filename: filename);
    return requireField(response.data?.receiptKey);
  });

  Future<bool> _loadFirstPage(DateTime month, TransactionFilter filter) async {
    final response = await _remote.getTransactions(_query(month, filter));
    final nextCursor = _nextCursor(response);
    await _local.replaceFirstPage(
      month,
      filter,
      _rows(response),
      nextCursor: nextCursor,
    );
    return nextCursor != null;
  }

  Future<Either<Failure, Transaction>> _write(
    Future<TransactionResponse> Function() request,
  ) => safeCall(() async {
    final row = _row(await request());
    await _local.upsertAll([row]);
    return row.toEntity();
  });

  TransactionQuery _query(
    DateTime month,
    TransactionFilter filter, {
    String? search,
    String? cursor,
  }) => TransactionQuery(
    month: formatApiMonth(month),
    limit: _pageSize,
    walletId: filter.walletId,
    categoryId: filter.categoryId,
    type: filter.type?.apiValue,
    search: search,
    cursor: cursor,
  );

  /// The cursor of the next page; null on the last page.
  String? _nextCursor(TransactionListResponse response) =>
      (response.meta?.hasMore ?? false) ? response.meta?.nextCursor : null;

  TransactionRow _row(TransactionResponse response) =>
      requireField(response.data).toRow();

  List<TransactionRow> _rows(TransactionListResponse response) =>
      (response.data ?? const []).map((data) => data.toRow()).toList();

  List<Transaction> _entities(List<TransactionRow> rows) =>
      rows.map((row) => row.toEntity()).toList();
}
