import 'dart:typed_data';

import 'package:flutter_test/flutter_test.dart';
import 'package:fpdart/fpdart.dart';
import 'package:mocktail/mocktail.dart';
import 'package:monai/core/error/failure.dart';
import 'package:monai/core/model/category_type.dart';
import 'package:monai/core/usecase/usecase.dart';
import 'package:monai/features/shared/domain/entity/budget.dart';
import 'package:monai/features/shared/domain/entity/category.dart';
import 'package:monai/features/shared/domain/entity/monthly_report.dart';
import 'package:monai/features/shared/domain/entity/payment_provider.dart';
import 'package:monai/features/shared/domain/entity/transaction.dart';
import 'package:monai/features/shared/domain/entity/transaction_filter.dart';
import 'package:monai/features/shared/domain/entity/user.dart';
import 'package:monai/features/shared/domain/entity/wallet.dart';
import 'package:monai/features/shared/domain/repository/budget_repository.dart';
import 'package:monai/features/shared/domain/repository/category_repository.dart';
import 'package:monai/features/shared/domain/repository/payment_provider_repository.dart';
import 'package:monai/features/shared/domain/repository/report_repository.dart';
import 'package:monai/features/shared/domain/repository/transaction_repository.dart';
import 'package:monai/features/shared/domain/repository/user_repository.dart';
import 'package:monai/features/shared/domain/repository/wallet_repository.dart';
import 'package:monai/features/shared/domain/usecase/load_more_transactions_usecase.dart';
import 'package:monai/features/shared/domain/usecase/recent_transactions_params.dart';
import 'package:monai/features/shared/domain/usecase/refresh_budget_usecase.dart';
import 'package:monai/features/shared/domain/usecase/refresh_categories_usecase.dart';
import 'package:monai/features/shared/domain/usecase/refresh_monthly_report_usecase.dart';
import 'package:monai/features/shared/domain/usecase/refresh_payment_providers_usecase.dart';
import 'package:monai/features/shared/domain/usecase/refresh_recent_transactions_usecase.dart';
import 'package:monai/features/shared/domain/usecase/refresh_transactions_usecase.dart';
import 'package:monai/features/shared/domain/usecase/refresh_user_usecase.dart';
import 'package:monai/features/shared/domain/usecase/refresh_wallets_usecase.dart';
import 'package:monai/features/shared/domain/usecase/transaction_list_params.dart';
import 'package:monai/features/shared/domain/usecase/upload_receipt_usecase.dart';
import 'package:monai/features/shared/domain/usecase/watch_all_wallets_usecase.dart';
import 'package:monai/features/shared/domain/usecase/watch_budget_usecase.dart';
import 'package:monai/features/shared/domain/usecase/watch_categories_usecase.dart';
import 'package:monai/features/shared/domain/usecase/watch_cached_expense_totals_usecase.dart';
import 'package:monai/features/shared/domain/usecase/watch_monthly_report_usecase.dart';
import 'package:monai/features/shared/domain/usecase/watch_payment_providers_usecase.dart';
import 'package:monai/features/shared/domain/usecase/watch_recent_transactions_usecase.dart';
import 'package:monai/features/shared/domain/usecase/watch_transactions_usecase.dart';
import 'package:monai/features/shared/domain/usecase/watch_user_usecase.dart';
import 'package:monai/features/shared/domain/usecase/watch_visible_categories_usecase.dart';
import 'package:monai/features/shared/domain/usecase/watch_wallet_daily_outflows_usecase.dart';
import 'package:monai/features/shared/domain/usecase/watch_wallet_usecase.dart';
import 'package:monai/features/shared/domain/usecase/watch_wallets_usecase.dart';

import '../../../../helpers/entity_fixtures.dart';

class _MockWallets extends Mock implements WalletRepository {}

class _MockProviders extends Mock implements PaymentProviderRepository {}

class _MockCategories extends Mock implements CategoryRepository {}

class _MockTransactions extends Mock implements TransactionRepository {}

class _MockBudgets extends Mock implements BudgetRepository {}

class _MockReports extends Mock implements ReportRepository {}

class _MockUsers extends Mock implements UserRepository {}

// The shared use cases that only forward to their repository: each one must
// call the right method with its params.
void main() {
  final october = DateTime(2026, 10);
  const filter = TransactionFilter(walletId: 'w1');

  group('wallets', () {
    late _MockWallets repository;

    setUp(() => repository = _MockWallets());

    test('watch and refresh forward to the repository', () async {
      // Arrange
      when(() => repository.watchWallets())
          .thenAnswer((_) => Stream.value(const Right([])));
      when(() => repository.watchAllWallets())
          .thenAnswer((_) => Stream.value(const Right([])));
      when(() => repository.watchWallet('w1'))
          .thenAnswer((_) => Stream.value(const Right(null)));
      final wallets = [wallet()];
      when(() => repository.refreshWallets())
          .thenAnswer((_) async => Right(wallets));

      // Act
      await WatchWalletsUseCase(repository)(const NoParams()).first;
      await WatchAllWalletsUseCase(repository)(const NoParams()).first;
      await WatchWalletUseCase(repository)('w1').first;
      final refreshed = await RefreshWalletsUseCase(repository)(
        const NoParams(),
      );

      // Assert
      expect(refreshed, Right<Failure, List<Wallet>>(wallets));
      verify(() => repository.watchWallets()).called(1);
      verify(() => repository.watchAllWallets()).called(1);
      verify(() => repository.watchWallet('w1')).called(1);
    });
  });

  group('payment providers', () {
    test('watch and refresh forward to the repository', () async {
      // Arrange
      final repository = _MockProviders();
      when(() => repository.watchProviders())
          .thenAnswer((_) => Stream.value(const Right([])));
      final providers = <PaymentProvider>[];
      when(() => repository.refreshProviders())
          .thenAnswer((_) async => Right(providers));

      // Act
      await WatchPaymentProvidersUseCase(repository)(const NoParams()).first;
      final refreshed = await RefreshPaymentProvidersUseCase(repository)(
        const NoParams(),
      );

      // Assert
      expect(refreshed, Right<Failure, List<PaymentProvider>>(providers));
      verify(() => repository.watchProviders()).called(1);
    });
  });

  group('categories', () {
    test('watch and refresh forward to the repository', () async {
      // Arrange
      final repository = _MockCategories();
      when(() => repository.watchCategories())
          .thenAnswer((_) => Stream.value(const Right([])));
      when(() => repository.watchVisibleCategories(CategoryType.income))
          .thenAnswer((_) => Stream.value(const Right([])));
      final categories = <Category>[];
      when(() => repository.refreshCategories())
          .thenAnswer((_) async => Right(categories));

      // Act
      await WatchCategoriesUseCase(repository)(const NoParams()).first;
      await WatchVisibleCategoriesUseCase(repository)(CategoryType.income)
          .first;
      final refreshed = await RefreshCategoriesUseCase(repository)(
        const NoParams(),
      );

      // Assert
      expect(refreshed, Right<Failure, List<Category>>(categories));
      verify(() => repository.watchCategories()).called(1);
      verify(() => repository.watchVisibleCategories(CategoryType.income))
          .called(1);
    });
  });

  group('transactions', () {
    late _MockTransactions repository;

    setUp(() => repository = _MockTransactions());

    test('recent transactions forward the month and limit', () async {
      // Arrange
      final params = RecentTransactionsParams(month: october, limit: 5);
      when(() => repository.watchRecentTransactions(october, limit: 5))
          .thenAnswer((_) => Stream.value(const Right([])));
      final recent = [transaction()];
      when(() => repository.refreshRecentTransactions(october, limit: 5))
          .thenAnswer((_) async => Right(recent));

      // Act
      await WatchRecentTransactionsUseCase(repository)(params).first;
      final refreshed = await RefreshRecentTransactionsUseCase(repository)(
        params,
      );

      // Assert
      expect(refreshed, Right<Failure, List<Transaction>>(recent));
      verify(() => repository.watchRecentTransactions(october, limit: 5))
          .called(1);
    });

    test('a list forwards its month, filter and limit', () async {
      // Arrange
      when(() => repository.watchTransactions(october, filter, limit: 40))
          .thenAnswer((_) => Stream.value(const Right([])));
      when(() => repository.refreshTransactions(october, filter))
          .thenAnswer((_) async => const Right(true));
      when(() => repository.loadMoreTransactions(october, filter))
          .thenAnswer((_) async => const Right(false));
      final list = TransactionListParams(month: october, filter: filter);

      // Act
      await WatchTransactionsUseCase(repository)(
        TransactionPageParams(month: october, filter: filter, limit: 40),
      ).first;
      final refreshed = await RefreshTransactionsUseCase(repository)(list);
      final more = await LoadMoreTransactionsUseCase(repository)(list);

      // Assert
      expect(refreshed, const Right<Failure, bool>(true));
      expect(more, const Right<Failure, bool>(false));
      verify(() => repository.watchTransactions(october, filter, limit: 40))
          .called(1);
    });

    test('wallet outflows forward the month and wallet', () async {
      // Arrange
      when(() => repository.watchDailyOutflows(october, 'w1'))
          .thenAnswer((_) => Stream.value(const Right({})));

      // Act
      await WatchWalletDailyOutflowsUseCase(repository)(
        WalletDailyOutflowsParams(month: october, walletId: 'w1'),
      ).first;

      // Assert
      verify(() => repository.watchDailyOutflows(october, 'w1')).called(1);
    });

    test('a receipt upload forwards the photo', () async {
      // Arrange
      final bytes = Uint8List(3);
      when(() => repository.uploadReceipt(bytes, filename: 'r.webp'))
          .thenAnswer((_) async => const Right('receipts/k'));

      // Act
      final result = await UploadReceiptUseCase(repository)(
        UploadReceiptParams(bytes: bytes, filename: 'r.webp'),
      );

      // Assert
      expect(result, const Right<Failure, String>('receipts/k'));
    });
  });

  group('budgets, reports and the user', () {
    test('watch and refresh forward to their repositories', () async {
      // Arrange
      final budgets = _MockBudgets();
      final reports = _MockReports();
      final users = _MockUsers();
      final cachedBudget = budget();
      final cachedReport = monthlyReport();
      final cachedUser = user();
      when(() => budgets.watchBudget(october))
          .thenAnswer((_) => Stream.value(const Right(null)));
      when(() => budgets.refreshBudget(october))
          .thenAnswer((_) async => Right(cachedBudget));
      when(() => reports.watchMonthlyReport(october))
          .thenAnswer((_) => Stream.value(const Right(null)));
      when(() => reports.refreshMonthlyReport(october))
          .thenAnswer((_) async => Right(cachedReport));
      when(() => users.watchUser())
          .thenAnswer((_) => Stream.value(const Right(null)));
      when(() => users.refreshUser())
          .thenAnswer((_) async => Right(cachedUser));

      // Act
      await WatchBudgetUseCase(budgets)(october).first;
      final refreshedBudget = await RefreshBudgetUseCase(budgets)(october);
      await WatchMonthlyReportUseCase(reports)(october).first;
      final refreshedReport = await RefreshMonthlyReportUseCase(reports)(
        october,
      );
      await WatchUserUseCase(users)(const NoParams()).first;
      final refreshedUser = await RefreshUserUseCase(users)(const NoParams());

      // Assert
      expect(refreshedBudget, Right<Failure, Budget?>(cachedBudget));
      expect(refreshedReport, Right<Failure, MonthlyReport>(cachedReport));
      expect(refreshedUser, Right<Failure, User>(cachedUser));
      verify(() => budgets.watchBudget(october)).called(1);
      verify(() => reports.watchMonthlyReport(october)).called(1);
      verify(() => users.watchUser()).called(1);
    });

    test('expense totals forward the year', () async {
      // Arrange
      final reports = _MockReports();
      when(() => reports.watchExpenseTotals(2026))
          .thenAnswer((_) => Stream.value(const Right({})));

      // Act
      await WatchCachedExpenseTotalsUseCase(reports)(2026).first;

      // Assert
      verify(() => reports.watchExpenseTotals(2026)).called(1);
    });
  });
}
