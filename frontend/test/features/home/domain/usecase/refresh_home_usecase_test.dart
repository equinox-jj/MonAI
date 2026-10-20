import 'package:flutter_test/flutter_test.dart';
import 'package:fpdart/fpdart.dart';
import 'package:mocktail/mocktail.dart';
import 'package:monai/core/error/failure.dart';
import 'package:monai/core/usecase/usecase.dart';
import 'package:monai/features/home/domain/usecase/refresh_home_usecase.dart';
import 'package:monai/features/shared/domain/usecase/recent_transactions_params.dart';
import 'package:monai/features/shared/domain/usecase/refresh_budget_usecase.dart';
import 'package:monai/features/shared/domain/usecase/refresh_categories_usecase.dart';
import 'package:monai/features/shared/domain/usecase/refresh_monthly_report_usecase.dart';
import 'package:monai/features/shared/domain/usecase/refresh_recent_transactions_usecase.dart';
import 'package:monai/features/shared/domain/usecase/refresh_user_usecase.dart';
import 'package:monai/features/shared/domain/usecase/refresh_wallets_usecase.dart';

import '../../../../helpers/entity_fixtures.dart';

class _MockRefreshUser extends Mock implements RefreshUserUseCase {}

class _MockRefreshWallets extends Mock implements RefreshWalletsUseCase {}

class _MockRefreshCategories extends Mock implements RefreshCategoriesUseCase {}

class _MockRefreshRecent extends Mock
    implements RefreshRecentTransactionsUseCase {}

class _MockRefreshBudget extends Mock implements RefreshBudgetUseCase {}

class _MockRefreshReport extends Mock implements RefreshMonthlyReportUseCase {}

void main() {
  final month = DateTime(2026, 10);
  late _MockRefreshUser user;
  late _MockRefreshWallets wallets;
  late _MockRefreshCategories categories;
  late _MockRefreshRecent recent;
  late _MockRefreshBudget budget;
  late _MockRefreshReport report;
  late RefreshHomeUseCase useCase;

  setUpAll(() {
    registerFallbackValue(const NoParams());
    registerFallbackValue(RecentTransactionsParams(month: month, limit: 1));
  });

  setUp(() {
    user = _MockRefreshUser();
    wallets = _MockRefreshWallets();
    categories = _MockRefreshCategories();
    recent = _MockRefreshRecent();
    budget = _MockRefreshBudget();
    report = _MockRefreshReport();
    useCase = RefreshHomeUseCase(
      user: user,
      wallets: wallets,
      categories: categories,
      recent: recent,
      budget: budget,
      report: report,
    );
    when(() => user(any())).thenAnswer((_) async => Right(user0));
    when(() => wallets(any())).thenAnswer((_) async => const Right([]));
    when(() => categories(any())).thenAnswer((_) async => const Right([]));
    when(() => recent(any())).thenAnswer((_) async => const Right([]));
    when(() => budget(any())).thenAnswer((_) async => const Right(null));
    when(() => report(any())).thenAnswer((_) async => Right(monthlyReport()));
  });

  test('refreshes every section of the month', () async {
    // Arrange
    final params = month;

    // Act
    final result = (await useCase(params)).toNullable()!;

    // Assert
    expect(result.failure, isNull);
    expect(result.budgetLoaded, isTrue);
    expect(result.recentLoaded, isTrue);
    verify(() => budget(month)).called(1);
    verify(() => report(month)).called(1);
    final params0 =
        verify(() => recent(captureAny())).captured.single
            as RecentTransactionsParams;
    expect(params0.month, month);
    expect(params0.limit, 5);
  });

  test('being offline wins over any other failure', () async {
    // Arrange
    when(() => budget(any()))
        .thenAnswer((_) async => const Left(Failure.server(500)));
    when(() => wallets(any()))
        .thenAnswer((_) async => const Left(Failure.network()));

    // Act
    final result = (await useCase(month)).toNullable()!;

    // Assert
    expect(result.failure, HomeLoadFailure.network);
    expect(result.budgetLoaded, isFalse);
    expect(result.recentLoaded, isTrue);
  });

  test('reports any other failure as unexpected', () async {
    // Arrange
    when(() => recent(any()))
        .thenAnswer((_) async => const Left(Failure.server(500)));

    // Act
    final result = (await useCase(month)).toNullable()!;

    // Assert
    expect(result.failure, HomeLoadFailure.unexpected);
    expect(result.recentLoaded, isFalse);
  });
}

final user0 = user();
