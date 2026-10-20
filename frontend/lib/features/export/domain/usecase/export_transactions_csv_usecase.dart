import 'package:fpdart/fpdart.dart';
import 'package:monai/core/error/failure.dart';
import 'package:monai/core/usecase/usecase.dart';
import 'package:monai/features/export/domain/csv/transaction_csv_writer.dart';
import 'package:monai/features/export/domain/entity/csv_export.dart';
import 'package:monai/features/export/domain/repository/export_repository.dart';
import 'package:monai/features/shared/domain/entity/transaction.dart';
import 'package:monai/features/shared/domain/usecase/watch_all_wallets_usecase.dart';
import 'package:monai/features/shared/domain/usecase/watch_categories_usecase.dart';

/// Writes the transactions of a range of months to a CSV file to share.
/// They come from the server, so the file is complete; offline, from the
/// cache, and the file says it may be incomplete. Wallets and categories
/// are named, archived and hidden ones too.
///
/// Fails with code [invalidRange] for a range past this month or over 12
/// months, and [noTransactions] when there is nothing to write. Remembers
/// the separator for next time.
class ExportTransactionsCsvUseCase
    implements UseCase<ExportedCsv, ExportCsvParams> {
  /// [now] is the clock; tests pass a fixed one.
  ExportTransactionsCsvUseCase({
    required this._repository,
    required this._wallets,
    required this._categories,
    DateTime Function()? now,
  }) : _now = now ?? DateTime.now;

  static const invalidRange = 'invalid_range';
  static const noTransactions = 'no_transactions';

  final ExportRepository _repository;
  final WatchAllWalletsUseCase _wallets;
  final WatchCategoriesUseCase _categories;
  final DateTime Function() _now;

  @override
  Future<Either<Failure, ExportedCsv>> call(ExportCsvParams params) async {
    final range = params.range;
    if (!range.isValidAt(_now())) {
      return const Left(Failure.unknown(code: invalidRange));
    }
    await _repository.saveDelimiter(params.delimiter.name);

    final fetched = await _fetch(range);
    final List<Transaction> transactions;
    final bool isComplete;
    switch (fetched) {
      case Left(value: final failure):
        return Left(failure);
      case Right(value: (final list, final complete)):
        transactions = list;
        isComplete = complete;
    }
    if (transactions.isEmpty) {
      return Left(
        isComplete
            ? const Failure.notFound(code: noTransactions)
            // Offline with nothing cached: the months may not be empty.
            : const Failure.network(),
      );
    }

    final wallets = (await _wallets(
      const NoParams(),
    ).first).getOrElse((_) => const []);
    final categories = (await _categories(
      const NoParams(),
    ).first).getOrElse((_) => const []);
    final csv = TransactionCsvWriter.write(
      transactions,
      walletNames: {for (final w in wallets) w.id: w.name},
      categoryNames: {for (final c in categories) c.id: c.name},
      delimiter: params.delimiter,
    );
    final written = await _repository.writeFile(fileName(range), csv);
    return written.map(
      (path) => ExportedCsv(
        path: path,
        rowCount: transactions.length,
        isComplete: isComplete,
      ),
    );
  }

  /// `monai-transactions-2026-10.csv`, or
  /// `monai-transactions-2026-08_2026-10.csv` for several months.
  static String fileName(ExportRange range) {
    String month(DateTime m) =>
        '${m.year}-${m.month.toString().padLeft(2, '0')}';
    final span = range.length == 1
        ? month(range.from)
        : '${month(range.from)}_${month(range.to)}';
    return 'monai-transactions-$span.csv';
  }

  /// Every transaction of [range] and whether it came from the server. The
  /// first connection failure switches to the cache.
  Future<Either<Failure, (List<Transaction>, bool)>> _fetch(
    ExportRange range,
  ) async {
    final all = <Transaction>[];
    for (final month in range.months) {
      final result = await _repository.fetchMonth(month);
      switch (result) {
        case Right(:final value):
          all.addAll(value);
        case Left(value: NetworkFailure() || TimeoutFailure()):
          final cached = await _repository.cachedBetween(
            range.from,
            range.lastDay,
          );
          return cached.map((list) => (list, false));
        case Left(value: final failure):
          return Left(failure);
      }
    }
    return Right((all, true));
  }
}

class ExportCsvParams {
  const ExportCsvParams({required this.range, required this.delimiter});

  final ExportRange range;
  final CsvDelimiter delimiter;
}
