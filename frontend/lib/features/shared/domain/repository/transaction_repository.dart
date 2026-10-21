import 'dart:typed_data';

import 'package:fpdart/fpdart.dart';
import 'package:monai/core/base/error/failure.dart';
import 'package:monai/features/shared/domain/entity/transaction.dart';
import 'package:monai/features/shared/domain/entity/transaction_filter.dart';
import 'package:monai/features/shared/domain/entity/transaction_input.dart';
import 'package:monai/features/shared/domain/entity/transaction_search_page.dart';

/// The user's transactions. Lists cover one month (the first of the month),
/// newest first. Reads come from the cache; refreshes and writes go to the
/// server and then update the cache.
///
/// Wallet balances, budgets and reports change with every write; the write
/// use cases refresh them.
abstract class TransactionRepository {
  /// Transactions per server page.
  static const pageSize = 20;

  /// The newest [limit] transactions of [month].
  Stream<Either<Failure, List<Transaction>>> watchRecentTransactions(
    DateTime month, {
    required int limit,
  });

  /// Re-fetches the newest [limit] transactions of [month] and gives them.
  Future<Either<Failure, List<Transaction>>> refreshRecentTransactions(
    DateTime month, {
    required int limit,
  });

  /// The first [limit] cached transactions of [month] that [filter] matches.
  /// Grow [limit] by [pageSize] as the list scrolls, after
  /// [loadMoreTransactions].
  Stream<Either<Failure, List<Transaction>>> watchTransactions(
    DateTime month,
    TransactionFilter filter, {
    required int limit,
  });

  /// Re-fetches the list's first page; true when more pages follow.
  Future<Either<Failure, bool>> refreshTransactions(
    DateTime month,
    TransactionFilter filter,
  );

  /// Fetches the list's next page (the first one if it was never loaded);
  /// true when more pages follow. Makes no request past the last page.
  Future<Either<Failure, bool>> loadMoreTransactions(
    DateTime month,
    TransactionFilter filter,
  );

  /// Each cached day's net (income minus expenses) of the list, for its day
  /// headers. Days are local midnight.
  Stream<Either<Failure, Map<DateTime, int>>> watchDailyNets(
    DateTime month,
    TransactionFilter filter,
  );

  /// Each cached day's money leaving [walletId] in [month]: expenses plus
  /// transfers out.
  Stream<Either<Failure, Map<DateTime, int>>> watchDailyOutflows(
    DateTime month,
    String walletId,
  );

  /// One page of server search over notes and merchants in [month]. The
  /// results are cached so they open offline.
  Future<Either<Failure, TransactionSearchPage>> searchTransactions(
    String query, {
    required DateTime month,
    required TransactionFilter filter,
    String? cursor,
  });

  /// Offline search over every cached transaction: notes and merchants whose
  /// words start with those of [query].
  Stream<Either<Failure, List<Transaction>>> watchCachedSearch(
    String query,
    TransactionFilter filter, {
    required int limit,
  });

  /// The transaction with [id], or null when it isn't cached.
  Stream<Either<Failure, Transaction?>> watchTransaction(String id);

  /// Re-fetches one transaction and gives the cached copy; one the server no
  /// longer has is dropped from the cache and fails as [NotFoundFailure].
  Future<Either<Failure, Transaction>> refreshTransaction(String id);

  /// Creates a transaction from validated [input].
  Future<Either<Failure, Transaction>> createTransaction(
    TransactionInput input,
  );

  /// Replaces every field of a transaction with validated [input], keeping
  /// its source and receipt.
  Future<Either<Failure, Transaction>> updateTransaction(
    String id,
    TransactionInput input,
  );

  /// Gives a transaction the receipt uploaded as [receiptKey].
  Future<Either<Failure, Transaction>> attachReceipt(
    String id,
    String receiptKey,
  );

  /// Deletes a transaction (it can be restored). Succeeds when the server
  /// already deleted it. Gives the cached copy, null when it wasn't cached,
  /// for an undo message.
  Future<Either<Failure, Transaction?>> deleteTransaction(String id);

  /// Undoes a delete.
  Future<Either<Failure, Transaction>> restoreTransaction(String id);

  /// Uploads a receipt photo (JPEG or WebP, at most 5 MB); gives the key to
  /// create or attach with, valid for a day.
  Future<Either<Failure, String>> uploadReceipt(
    Uint8List bytes, {
    required String filename,
  });
}
