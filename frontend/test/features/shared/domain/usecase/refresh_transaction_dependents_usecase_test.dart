import 'package:flutter_test/flutter_test.dart';
import 'package:fpdart/fpdart.dart';
import 'package:mocktail/mocktail.dart';
import 'package:monai/core/base/error/failure.dart';
import 'package:monai/features/shared/domain/repository/budget_repository.dart';
import 'package:monai/features/shared/domain/repository/report_repository.dart';
import 'package:monai/features/shared/domain/repository/wallet_repository.dart';
import 'package:monai/features/shared/domain/usecase/refresh_transaction_dependents_usecase.dart';

import '../../../../helpers/entity_fixtures.dart';

class _MockWallets extends Mock implements WalletRepository {}

class _MockBudgets extends Mock implements BudgetRepository {}

class _MockReports extends Mock implements ReportRepository {}

void main() {
  late _MockWallets wallets;
  late _MockBudgets budgets;
  late _MockReports reports;
  late RefreshTransactionDependentsUseCase useCase;

  setUpAll(() => registerFallbackValue(DateTime(2026)));

  setUp(() {
    wallets = _MockWallets();
    budgets = _MockBudgets();
    reports = _MockReports();
    useCase = RefreshTransactionDependentsUseCase(
      wallets: wallets,
      budgets: budgets,
      reports: reports,
    );
    when(() => wallets.refreshWallets())
        .thenAnswer((_) async => const Right([]));
    when(() => budgets.refreshBudget(any()))
        .thenAnswer((_) async => const Right(null));
    when(() => reports.refreshMonthlyReport(any()))
        .thenAnswer((_) async => Right(monthlyReport()));
  });

  test('refreshes the wallets and each month once', () async {
    // Arrange
    final dates = [
      DateTime(2026, 10, 5),
      DateTime(2026, 10, 19),
      DateTime(2026, 9, 30),
    ];

    // Act
    final result = await useCase(dates);

    // Assert
    expect(result, const Right<Failure, bool>(true));
    verify(() => wallets.refreshWallets()).called(1);
    verify(() => budgets.refreshBudget(DateTime(2026, 10))).called(1);
    verify(() => budgets.refreshBudget(DateTime(2026, 9))).called(1);
    verify(() => reports.refreshMonthlyReport(DateTime(2026, 10))).called(1);
    verify(() => reports.refreshMonthlyReport(DateTime(2026, 9))).called(1);
  });

  test('succeeds with false when a refresh fails', () async {
    // Arrange
    when(() => wallets.refreshWallets())
        .thenAnswer((_) async => const Left(Failure.network()));

    // Act
    final result = await useCase([DateTime(2026, 10)]);

    // Assert
    expect(result, const Right<Failure, bool>(false));
  });
}
