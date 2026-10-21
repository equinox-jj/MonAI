import 'package:fpdart/fpdart.dart';
import 'package:mocktail/mocktail.dart';
import 'package:monai/core/app/injector.dart';
import 'package:monai/core/base/error/failure.dart';
import 'package:monai/core/base/usecase.dart';
import 'package:monai/features/shared/domain/entity/monthly_report.dart';
import 'package:monai/features/shared/domain/usecase/delete_transaction_usecase.dart';
import 'package:monai/features/shared/domain/usecase/load_more_transactions_usecase.dart';
import 'package:monai/features/shared/domain/usecase/refresh_categories_usecase.dart';
import 'package:monai/features/shared/domain/usecase/refresh_monthly_report_usecase.dart';
import 'package:monai/features/shared/domain/usecase/refresh_transactions_usecase.dart';
import 'package:monai/features/shared/domain/usecase/refresh_wallets_usecase.dart';
import 'package:monai/features/shared/domain/usecase/transaction_list_params.dart';
import 'package:monai/features/shared/domain/usecase/watch_cached_expense_totals_usecase.dart';
import 'package:monai/features/shared/domain/usecase/watch_monthly_report_usecase.dart';
import 'package:monai/features/shared/domain/usecase/watch_transaction_deletions_usecase.dart';
import 'package:monai/features/shared/domain/usecase/watch_transactions_usecase.dart';
import 'package:monai/features/transactions/domain/entity/transaction_lookups.dart';
import 'package:monai/features/transactions/domain/usecase/restore_transaction_usecase.dart';
import 'package:monai/features/transactions/domain/usecase/watch_daily_nets_usecase.dart';
import 'package:monai/features/transactions/domain/usecase/watch_transaction_lookups_usecase.dart';
import 'package:monai/features/transactions/presentation/pages/transactions/bloc/transactions_bloc.dart';
import 'package:monai/features/transactions/presentation/pages/undo_delete/cubit/undo_delete_cubit.dart';

class _MockWatchDeletions extends Mock
    implements WatchTransactionDeletionsUseCase {}

class _MockWatchLookups extends Mock
    implements WatchTransactionLookupsUseCase {}

class _MockRestore extends Mock implements RestoreTransactionUseCase {}

class _MockWatchTransactions extends Mock implements WatchTransactionsUseCase {}

class _MockRefreshTransactions extends Mock
    implements RefreshTransactionsUseCase {}

class _MockWatchDailyNets extends Mock implements WatchDailyNetsUseCase {}

class _MockWatchReport extends Mock implements WatchMonthlyReportUseCase {}

class _MockRefreshReport extends Mock implements RefreshMonthlyReportUseCase {}

class _MockRefreshWallets extends Mock implements RefreshWalletsUseCase {}

class _MockRefreshCategories extends Mock implements RefreshCategoriesUseCase {}

/// Registers the transaction screens the signed-in shell shows, backed by an
/// empty cache that never changes: the undo-delete wrapper and the
/// Transactions tab. For widget tests that reach the shell.
void registerQuietTransactionScreens() {
  registerFallbackValue(const NoParams());
  registerFallbackValue(DateTime(2026));
  registerFallbackValue(TransactionListParams(month: DateTime(2026)));
  registerFallbackValue(
    TransactionPageParams(month: DateTime(2026), limit: 20),
  );

  final deletions = _MockWatchDeletions();
  when(() => deletions(any())).thenAnswer((_) => const Stream.empty());
  final lookups = _MockWatchLookups();
  when(() => lookups(any()))
      .thenAnswer((_) => Stream.value(const Right(TransactionLookups())));
  sl.registerFactory(
    () => UndoDeleteCubit(
      watchDeletions: deletions,
      watchLookups: lookups,
      restore: _MockRestore(),
    ),
  );

  final watchTransactions = _MockWatchTransactions();
  when(() => watchTransactions(any()))
      .thenAnswer((_) => Stream.value(const Right([])));
  final refreshTransactions = _MockRefreshTransactions();
  when(() => refreshTransactions(any()))
      .thenAnswer((_) async => const Right(false));
  final watchDailyNets = _MockWatchDailyNets();
  when(() => watchDailyNets(any()))
      .thenAnswer((_) => Stream.value(const Right({})));
  final watchReport = _MockWatchReport();
  when(() => watchReport(any()))
      .thenAnswer((_) => Stream.value(const Right(null)));
  final refreshReport = _MockRefreshReport();
  when(() => refreshReport(any())).thenAnswer(
    (_) async => const Left<Failure, MonthlyReport>(Failure.notFound()),
  );
  final refreshWallets = _MockRefreshWallets();
  when(() => refreshWallets(any())).thenAnswer((_) async => const Right([]));
  final refreshCategories = _MockRefreshCategories();
  when(() => refreshCategories(any())).thenAnswer((_) async => const Right([]));
  sl.registerFactory(
    () => TransactionsBloc(
      watchTransactions: watchTransactions,
      refreshTransactions: refreshTransactions,
      loadMore: _MockLoadMore(),
      watchDailyNets: watchDailyNets,
      watchReport: watchReport,
      refreshReport: refreshReport,
      watchLookups: lookups,
      refreshWallets: refreshWallets,
      refreshCategories: refreshCategories,
      watchExpenseTotals: _MockWatchExpenseTotals(),
      delete: _MockDelete(),
    ),
  );
}

class _MockLoadMore extends Mock implements LoadMoreTransactionsUseCase {}

class _MockWatchExpenseTotals extends Mock
    implements WatchCachedExpenseTotalsUseCase {}

class _MockDelete extends Mock implements DeleteTransactionUseCase {}
