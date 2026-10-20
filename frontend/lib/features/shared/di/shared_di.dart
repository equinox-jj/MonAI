import 'package:monai/core/di/injector.dart';
import 'package:monai/features/shared/data/datasources/budget_local_datasource.dart';
import 'package:monai/features/shared/data/datasources/budget_remote_datasource.dart';
import 'package:monai/features/shared/data/datasources/category_local_datasource.dart';
import 'package:monai/features/shared/data/datasources/category_remote_datasource.dart';
import 'package:monai/features/shared/data/datasources/payment_provider_local_datasource.dart';
import 'package:monai/features/shared/data/datasources/payment_provider_remote_datasource.dart';
import 'package:monai/features/shared/data/datasources/report_local_datasource.dart';
import 'package:monai/features/shared/data/datasources/report_remote_datasource.dart';
import 'package:monai/features/shared/data/datasources/session_local_datasource.dart';
import 'package:monai/features/shared/data/datasources/session_remote_datasource.dart';
import 'package:monai/features/shared/data/datasources/transaction_local_datasource.dart';
import 'package:monai/features/shared/data/datasources/transaction_remote_datasource.dart';
import 'package:monai/features/shared/data/datasources/user_local_datasource.dart';
import 'package:monai/features/shared/data/datasources/user_remote_datasource.dart';
import 'package:monai/features/shared/data/datasources/wallet_local_datasource.dart';
import 'package:monai/features/shared/data/datasources/wallet_remote_datasource.dart';
import 'package:monai/features/shared/data/repository/budget_repository_impl.dart';
import 'package:monai/features/shared/data/repository/category_repository_impl.dart';
import 'package:monai/features/shared/data/repository/payment_provider_repository_impl.dart';
import 'package:monai/features/shared/data/repository/report_repository_impl.dart';
import 'package:monai/features/shared/data/repository/session_repository_impl.dart';
import 'package:monai/features/shared/data/repository/transaction_repository_impl.dart';
import 'package:monai/features/shared/data/repository/user_repository_impl.dart';
import 'package:monai/features/shared/data/repository/wallet_repository_impl.dart';
import 'package:monai/features/shared/domain/event/transaction_deletion_events.dart';
import 'package:monai/features/shared/domain/repository/budget_repository.dart';
import 'package:monai/features/shared/domain/repository/category_repository.dart';
import 'package:monai/features/shared/domain/repository/payment_provider_repository.dart';
import 'package:monai/features/shared/domain/repository/report_repository.dart';
import 'package:monai/features/shared/domain/repository/session_repository.dart';
import 'package:monai/features/shared/domain/repository/transaction_repository.dart';
import 'package:monai/features/shared/domain/repository/user_repository.dart';
import 'package:monai/features/shared/domain/repository/wallet_repository.dart';
import 'package:monai/features/shared/domain/usecase/create_transaction_usecase.dart';
import 'package:monai/features/shared/domain/usecase/delete_transaction_usecase.dart';
import 'package:monai/features/shared/domain/usecase/load_more_transactions_usecase.dart';
import 'package:monai/features/shared/domain/usecase/logout_all_devices_usecase.dart';
import 'package:monai/features/shared/domain/usecase/logout_usecase.dart';
import 'package:monai/features/shared/domain/usecase/refresh_budget_usecase.dart';
import 'package:monai/features/shared/domain/usecase/refresh_categories_usecase.dart';
import 'package:monai/features/shared/domain/usecase/refresh_monthly_report_usecase.dart';
import 'package:monai/features/shared/domain/usecase/refresh_payment_providers_usecase.dart';
import 'package:monai/features/shared/domain/usecase/refresh_recent_transactions_usecase.dart';
import 'package:monai/features/shared/domain/usecase/refresh_transaction_dependents_usecase.dart';
import 'package:monai/features/shared/domain/usecase/refresh_transactions_usecase.dart';
import 'package:monai/features/shared/domain/usecase/refresh_user_usecase.dart';
import 'package:monai/features/shared/domain/usecase/refresh_wallets_usecase.dart';
import 'package:monai/features/shared/domain/usecase/upload_receipt_usecase.dart';
import 'package:monai/features/shared/domain/usecase/watch_all_wallets_usecase.dart';
import 'package:monai/features/shared/domain/usecase/watch_budget_usecase.dart';
import 'package:monai/features/shared/domain/usecase/watch_categories_usecase.dart';
import 'package:monai/features/shared/domain/usecase/watch_cached_expense_totals_usecase.dart';
import 'package:monai/features/shared/domain/usecase/watch_monthly_report_usecase.dart';
import 'package:monai/features/shared/domain/usecase/watch_payment_providers_usecase.dart';
import 'package:monai/features/shared/domain/usecase/watch_recent_transactions_usecase.dart';
import 'package:monai/features/shared/domain/usecase/watch_transaction_deletions_usecase.dart';
import 'package:monai/features/shared/domain/usecase/watch_transactions_usecase.dart';
import 'package:monai/features/shared/domain/usecase/watch_user_usecase.dart';
import 'package:monai/features/shared/domain/usecase/watch_visible_categories_usecase.dart';
import 'package:monai/features/shared/domain/usecase/watch_wallet_daily_outflows_usecase.dart';
import 'package:monai/features/shared/domain/usecase/watch_wallet_usecase.dart';
import 'package:monai/features/shared/domain/usecase/watch_wallets_usecase.dart';

class SharedDI {
  SharedDI._();

  static Future<void> init() async {
    sl
      // ---- Data sources ----
      ..registerLazySingleton<WalletRemoteDataSource>(
        () => WalletRemoteDataSourceImpl(dio: sl()),
      )
      ..registerLazySingleton<WalletLocalDataSource>(
        () => WalletLocalDataSourceImpl(dao: sl()),
      )
      ..registerLazySingleton<PaymentProviderRemoteDataSource>(
        () => PaymentProviderRemoteDataSourceImpl(dio: sl()),
      )
      ..registerLazySingleton<PaymentProviderLocalDataSource>(
        () => PaymentProviderLocalDataSourceImpl(dao: sl()),
      )
      ..registerLazySingleton<CategoryRemoteDataSource>(
        () => CategoryRemoteDataSourceImpl(dio: sl()),
      )
      ..registerLazySingleton<CategoryLocalDataSource>(
        () => CategoryLocalDataSourceImpl(dao: sl()),
      )
      ..registerLazySingleton<TransactionRemoteDataSource>(
        () => TransactionRemoteDataSourceImpl(dio: sl()),
      )
      ..registerLazySingleton<TransactionLocalDataSource>(
        () => TransactionLocalDataSourceImpl(dao: sl()),
      )
      ..registerLazySingleton<BudgetRemoteDataSource>(
        () => BudgetRemoteDataSourceImpl(dio: sl()),
      )
      ..registerLazySingleton<BudgetLocalDataSource>(
        () => BudgetLocalDataSourceImpl(dao: sl()),
      )
      ..registerLazySingleton<ReportRemoteDataSource>(
        () => ReportRemoteDataSourceImpl(dio: sl()),
      )
      ..registerLazySingleton<ReportLocalDataSource>(
        () => ReportLocalDataSourceImpl(dao: sl()),
      )
      ..registerLazySingleton<UserRemoteDataSource>(
        () => UserRemoteDataSourceImpl(dio: sl()),
      )
      ..registerLazySingleton<UserLocalDataSource>(
        () => UserLocalDataSourceImpl(dao: sl()),
      )
      ..registerLazySingleton<SessionRemoteDataSource>(
        () => SessionRemoteDataSourceImpl(dio: sl()),
      )
      ..registerLazySingleton<SessionLocalDataSource>(
        () => SessionLocalDataSourceImpl(
          tokenStorage: sl(),
          localCache: sl(),
          sessionManager: sl(),
        ),
      )
      // ---- Repositories ----
      ..registerLazySingleton<WalletRepository>(
        () => WalletRepositoryImpl(remote: sl(), local: sl()),
      )
      ..registerLazySingleton<PaymentProviderRepository>(
        () => PaymentProviderRepositoryImpl(remote: sl(), local: sl()),
      )
      ..registerLazySingleton<CategoryRepository>(
        () => CategoryRepositoryImpl(remote: sl(), local: sl()),
      )
      ..registerLazySingleton<TransactionRepository>(
        () => TransactionRepositoryImpl(remote: sl(), local: sl()),
      )
      ..registerLazySingleton<BudgetRepository>(
        () => BudgetRepositoryImpl(remote: sl(), local: sl()),
      )
      ..registerLazySingleton<ReportRepository>(
        () => ReportRepositoryImpl(remote: sl(), local: sl()),
      )
      ..registerLazySingleton<UserRepository>(
        () => UserRepositoryImpl(remote: sl(), local: sl()),
      )
      ..registerLazySingleton<SessionRepository>(
        () => SessionRepositoryImpl(remote: sl(), local: sl()),
      )
      // ---- Events ----
      ..registerLazySingleton<TransactionDeletionEvents>(
        TransactionDeletionEvents.new,
        dispose: (events) => events.dispose(),
      )
      // ---- Use cases ----
      ..registerFactory(() => WatchWalletsUseCase(sl()))
      ..registerFactory(() => WatchAllWalletsUseCase(sl()))
      ..registerFactory(() => WatchWalletUseCase(sl()))
      ..registerFactory(() => RefreshWalletsUseCase(sl()))
      ..registerFactory(() => WatchPaymentProvidersUseCase(sl()))
      ..registerFactory(() => RefreshPaymentProvidersUseCase(sl()))
      ..registerFactory(() => WatchCategoriesUseCase(sl()))
      ..registerFactory(() => WatchVisibleCategoriesUseCase(sl()))
      ..registerFactory(() => RefreshCategoriesUseCase(sl()))
      ..registerFactory(() => WatchRecentTransactionsUseCase(sl()))
      ..registerFactory(() => RefreshRecentTransactionsUseCase(sl()))
      ..registerFactory(() => WatchTransactionsUseCase(sl()))
      ..registerFactory(() => RefreshTransactionsUseCase(sl()))
      ..registerFactory(() => LoadMoreTransactionsUseCase(sl()))
      ..registerFactory(() => WatchWalletDailyOutflowsUseCase(sl()))
      ..registerFactory(
        () => RefreshTransactionDependentsUseCase(
          wallets: sl(),
          budgets: sl(),
          reports: sl(),
        ),
      )
      ..registerFactory(
        () =>
            CreateTransactionUseCase(repository: sl(), refreshDependents: sl()),
      )
      ..registerFactory(
        () => DeleteTransactionUseCase(
          repository: sl(),
          events: sl(),
          refreshDependents: sl(),
        ),
      )
      ..registerFactory(() => WatchTransactionDeletionsUseCase(sl()))
      ..registerFactory(() => UploadReceiptUseCase(sl()))
      ..registerFactory(() => WatchBudgetUseCase(sl()))
      ..registerFactory(() => RefreshBudgetUseCase(sl()))
      ..registerFactory(() => WatchMonthlyReportUseCase(sl()))
      ..registerFactory(() => RefreshMonthlyReportUseCase(sl()))
      ..registerFactory(() => WatchCachedExpenseTotalsUseCase(sl()))
      ..registerFactory(() => WatchUserUseCase(sl()))
      ..registerFactory(() => RefreshUserUseCase(sl()))
      ..registerFactory(() => LogoutUseCase(sl()))
      ..registerFactory(() => LogoutAllDevicesUseCase(sl()));
  }
}
