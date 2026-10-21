import 'dart:typed_data';

import 'package:fpdart/fpdart.dart';
import 'package:monai/core/base/error/failure.dart';
import 'package:monai/features/shared/domain/entity/transaction.dart';
import 'package:monai/features/shared/domain/entity/transaction_filter.dart';
import 'package:monai/features/shared/domain/entity/transaction_input.dart';
import 'package:monai/features/shared/domain/entity/transaction_search_page.dart';

/// Lists cover one month, newest first. Reads come from the cache; refreshes
/// and writes go to the server, then update the cache. Writes change wallet
/// balances, budgets and reports; the write use cases refresh them.
abstract class TransactionRepository {
  static const pageSize = 20;

  Stream<Either<Failure, List<Transaction>>> watchRecentTransactions(
    DateTime month, {
    required int limit,
  });

  Future<Either<Failure, List<Transaction>>> refreshRecentTransactions(
    DateTime month, {
    required int limit,
  });

  /// Grow [limit] by [pageSize] as the list scrolls, after
  /// [loadMoreTransactions].
  Stream<Either<Failure, List<Transaction>>> watchTransactions(
    DateTime month,
    TransactionFilter filter, {
    required int limit,
  });

  Future<Either<Failure, bool>> refreshTransactions(
    DateTime month,
    TransactionFilter filter,
  );

  /// The first page if it was never loaded; true when more pages follow. Makes
  /// no request past the last page.
  Future<Either<Failure, bool>> loadMoreTransactions(
    DateTime month,
    TransactionFilter filter,
  );

  Stream<Either<Failure, Map<DateTime, int>>> watchDailyNets(
    DateTime month,
    TransactionFilter filter,
  );

  Stream<Either<Failure, Map<DateTime, int>>> watchDailyOutflows(
    DateTime month,
    String walletId,
  );

  /// Results are cached so they open offline.
  Future<Either<Failure, TransactionSearchPage>> searchTransactions(
    String query, {
    required DateTime month,
    required TransactionFilter filter,
    String? cursor,
  });

  Stream<Either<Failure, List<Transaction>>> watchCachedSearch(
    String query,
    TransactionFilter filter, {
    required int limit,
  });

  Stream<Either<Failure, Transaction?>> watchTransaction(String id);

  /// One the server no longer has is dropped from the cache and fails as
  /// [NotFoundFailure].
  Future<Either<Failure, Transaction>> refreshTransaction(String id);

  Future<Either<Failure, Transaction>> createTransaction(
    TransactionInput input,
  );

  /// Keeps the source and receipt.
  Future<Either<Failure, Transaction>> updateTransaction(
    String id,
    TransactionInput input,
  );

  Future<Either<Failure, Transaction>> attachReceipt(
    String id,
    String receiptKey,
  );

  /// Can be restored. Succeeds when the server already deleted it. Gives the
  /// cached copy (null when it wasn't cached) for an undo message.
  Future<Either<Failure, Transaction?>> deleteTransaction(String id);

  Future<Either<Failure, Transaction>> restoreTransaction(String id);

  /// JPEG or WebP, at most 5 MB. The key it gives is valid for a day.
  Future<Either<Failure, String>> uploadReceipt(
    Uint8List bytes, {
    required String filename,
  });
}
