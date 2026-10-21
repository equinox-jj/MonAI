import 'package:monai/core/app/injector.dart';
import 'package:monai/features/transactions/data/datasources/search_history_local_datasource.dart';
import 'package:monai/features/transactions/data/repository/search_history_repository_impl.dart';
import 'package:monai/features/transactions/domain/repository/search_history_repository.dart';
import 'package:monai/features/transactions/domain/usecase/recent_searches_usecase.dart';
import 'package:monai/features/transactions/domain/usecase/attach_receipt_usecase.dart';
import 'package:monai/features/transactions/domain/usecase/get_transaction_usecase.dart';
import 'package:monai/features/transactions/domain/usecase/refresh_transaction_usecase.dart';
import 'package:monai/features/transactions/domain/usecase/restore_transaction_usecase.dart';
import 'package:monai/features/transactions/domain/usecase/search_transactions_usecase.dart';
import 'package:monai/features/transactions/domain/usecase/update_transaction_usecase.dart';
import 'package:monai/features/transactions/domain/usecase/watch_cached_search_usecase.dart';
import 'package:monai/features/transactions/domain/usecase/watch_daily_nets_usecase.dart';
import 'package:monai/features/transactions/domain/usecase/watch_transaction_lookups_usecase.dart';
import 'package:monai/features/transactions/domain/usecase/watch_transaction_usecase.dart';
import 'package:monai/features/transactions/presentation/pages/search/bloc/search_bloc.dart';
import 'package:monai/features/transactions/presentation/pages/transaction_detail/bloc/transaction_detail_bloc.dart';
import 'package:monai/features/transactions/presentation/pages/transaction_form/bloc/transaction_form_bloc.dart';
import 'package:monai/features/transactions/presentation/pages/transaction_form/model/transaction_form_mode.dart';
import 'package:monai/features/transactions/presentation/pages/transactions/bloc/transactions_bloc.dart';
import 'package:monai/features/transactions/presentation/pages/undo_delete/cubit/undo_delete_cubit.dart';

class TransactionsDI {
  TransactionsDI._();

  static Future<void> init() async {
    sl
      ..registerLazySingleton<SearchHistoryLocalDataSource>(
        () => SearchHistoryLocalDataSourceImpl(preferences: sl()),
      )
      ..registerLazySingleton<SearchHistoryRepository>(
        () => SearchHistoryRepositoryImpl(local: sl()),
      )
      ..registerFactory(() => GetRecentSearchesUseCase(sl()))
      ..registerFactory(() => AddRecentSearchUseCase(sl()))
      ..registerFactory(
        () =>
            UpdateTransactionUseCase(repository: sl(), refreshDependents: sl()),
      )
      ..registerFactory(
        () => RestoreTransactionUseCase(
          repository: sl(),
          refreshDependents: sl(),
        ),
      )
      ..registerFactory(() => WatchTransactionUseCase(sl()))
      ..registerFactory(() => RefreshTransactionUseCase(sl()))
      ..registerFactory(() => GetTransactionUseCase(sl()))
      ..registerFactory(() => WatchDailyNetsUseCase(sl()))
      ..registerFactory(() => SearchTransactionsUseCase(sl()))
      ..registerFactory(() => WatchCachedSearchUseCase(sl()))
      ..registerFactory(() => AttachReceiptUseCase(sl()))
      ..registerFactory(
        () => WatchTransactionLookupsUseCase(categories: sl(), wallets: sl()),
      )
      ..registerFactory(
        () => TransactionsBloc(
          watchTransactions: sl(),
          refreshTransactions: sl(),
          loadMore: sl(),
          watchDailyNets: sl(),
          watchReport: sl(),
          refreshReport: sl(),
          watchLookups: sl(),
          refreshWallets: sl(),
          refreshCategories: sl(),
          watchExpenseTotals: sl(),
          delete: sl(),
        ),
      )
      ..registerFactoryParam<TransactionDetailBloc, String, void>(
        (id, _) => TransactionDetailBloc(
          id: id,
          watchTransaction: sl(),
          refreshTransaction: sl(),
          watchLookups: sl(),
          delete: sl(),
        ),
      )
      ..registerFactoryParam<TransactionFormBloc, TransactionFormMode, void>(
        (mode, _) => TransactionFormBloc(
          mode: mode,
          getTransaction: sl(),
          create: sl(),
          update: sl(),
          delete: sl(),
          watchLookups: sl(),
        ),
      )
      ..registerFactoryParam<SearchBloc, DateTime?, void>(
        (initialMonth, _) => SearchBloc(
          initialMonth: initialMonth,
          search: sl(),
          watchCachedSearch: sl(),
          watchLookups: sl(),
          watchExpenseTotals: sl(),
          getRecentSearches: sl(),
          addRecentSearch: sl(),
        ),
      )
      ..registerFactory(
        () => UndoDeleteCubit(
          watchDeletions: sl(),
          watchLookups: sl(),
          restore: sl(),
        ),
      );
  }
}
