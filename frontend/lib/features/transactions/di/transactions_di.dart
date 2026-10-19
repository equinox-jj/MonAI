import 'package:monai/core/di/injector.dart';
import 'package:monai/features/transactions/domain/usecase/attach_receipt_usecase.dart';
import 'package:monai/features/transactions/domain/usecase/get_transaction_usecase.dart';
import 'package:monai/features/transactions/domain/usecase/refresh_transaction_usecase.dart';
import 'package:monai/features/transactions/domain/usecase/restore_transaction_usecase.dart';
import 'package:monai/features/transactions/domain/usecase/search_transactions_usecase.dart';
import 'package:monai/features/transactions/domain/usecase/update_transaction_usecase.dart';
import 'package:monai/features/transactions/domain/usecase/watch_cached_search_usecase.dart';
import 'package:monai/features/transactions/domain/usecase/watch_daily_nets_usecase.dart';
import 'package:monai/features/transactions/domain/usecase/watch_transaction_usecase.dart';

/// The transactions feature's use cases; its repository is shared (see
/// `SharedDI`).
class TransactionsDI {
  TransactionsDI._();

  static Future<void> init() async {
    sl
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
      ..registerFactory(() => AttachReceiptUseCase(sl()));
  }
}
