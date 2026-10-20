import 'dart:async';

import 'package:flutter_test/flutter_test.dart';
import 'package:fpdart/fpdart.dart';
import 'package:mocktail/mocktail.dart';
import 'package:monai/core/error/failure.dart';
import 'package:monai/core/usecase/usecase.dart';
import 'package:monai/features/home/domain/entity/home_dashboard.dart';
import 'package:monai/features/home/domain/usecase/watch_home_dashboard_usecase.dart';
import 'package:monai/features/shared/domain/entity/user.dart';
import 'package:monai/features/shared/domain/usecase/recent_transactions_params.dart';
import 'package:monai/features/shared/domain/usecase/watch_all_wallets_usecase.dart';
import 'package:monai/features/shared/domain/usecase/watch_budget_usecase.dart';
import 'package:monai/features/shared/domain/usecase/watch_categories_usecase.dart';
import 'package:monai/features/shared/domain/usecase/watch_monthly_report_usecase.dart';
import 'package:monai/features/shared/domain/usecase/watch_recent_transactions_usecase.dart';
import 'package:monai/features/shared/domain/usecase/watch_user_usecase.dart';

import '../../../../helpers/entity_fixtures.dart';

class _MockWatchUser extends Mock implements WatchUserUseCase {}

class _MockWatchWallets extends Mock implements WatchAllWalletsUseCase {}

class _MockWatchCategories extends Mock implements WatchCategoriesUseCase {}

class _MockWatchRecent extends Mock implements WatchRecentTransactionsUseCase {}

class _MockWatchBudget extends Mock implements WatchBudgetUseCase {}

class _MockWatchReport extends Mock implements WatchMonthlyReportUseCase {}

void main() {
  final now = DateTime(2026, 10, 20, 19);
  late StreamController<Either<Failure, User?>> users;
  late _MockWatchRecent recent;
  late _MockWatchBudget budget;
  late WatchHomeDashboardUseCase useCase;

  setUpAll(() {
    registerFallbackValue(const NoParams());
    registerFallbackValue(RecentTransactionsParams(month: now, limit: 1));
  });

  setUp(() {
    users = StreamController();
    final userUseCase = _MockWatchUser();
    final wallets = _MockWatchWallets();
    final categories = _MockWatchCategories();
    recent = _MockWatchRecent();
    budget = _MockWatchBudget();
    final report = _MockWatchReport();
    when(() => userUseCase(any())).thenAnswer((_) => users.stream);
    when(() => wallets(any()))
        .thenAnswer((_) => Stream.value(Right([wallet(isDefault: true)])));
    when(() => categories(any()))
        .thenAnswer((_) => Stream.value(Right([category()])));
    when(() => recent(any()))
        .thenAnswer((_) => Stream.value(Right([transaction()])));
    when(() => budget(any())).thenAnswer((_) => Stream.value(Right(budget0)));
    when(() => report(any()))
        .thenAnswer((_) => Stream.value(Right(monthlyReport())));
    useCase = WatchHomeDashboardUseCase(
      user: userUseCase,
      wallets: wallets,
      categories: categories,
      recent: recent,
      budget: budget,
      report: report,
    );
  });

  tearDown(() => users.close());

  test('combines every section of the month into the dashboard', () async {
    // Arrange
    final first = useCase(now).first;

    // Act
    users.add(Right(user(name: 'Joshua')));
    final dashboard = (await first).toNullable()!;

    // Assert
    expect(dashboard.userName, 'Joshua');
    expect(dashboard.greeting, HomeGreeting.evening);
    expect(dashboard.totalBalance, 100000);
    expect(dashboard.budget, budget0);
    expect(dashboard.recent.single.categoryName, 'Food');
    verify(() => budget(DateTime(2026, 10))).called(1);
    final params =
        verify(() => recent(captureAny())).captured.single
            as RecentTransactionsParams;
    expect(params.month, DateTime(2026, 10));
  });

  test('passes on a failed read and keeps going', () async {
    // Arrange
    final events = useCase(now).take(2).toList();

    // Act
    users
      ..add(const Left(Failure.cache()))
      ..add(Right(user()));
    final results = await events;

    // Assert
    expect(results.first.isLeft(), isTrue);
    expect(results.last.isRight(), isTrue);
  });
}

final budget0 = budget();
