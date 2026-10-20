import 'dart:async';

import 'package:flutter_test/flutter_test.dart';
import 'package:fpdart/fpdart.dart';
import 'package:mocktail/mocktail.dart';
import 'package:monai/core/error/failure.dart';
import 'package:monai/core/usecase/usecase.dart';
import 'package:monai/features/settings/domain/entity/settings_overview.dart';
import 'package:monai/features/settings/domain/usecase/watch_settings_overview_usecase.dart';
import 'package:monai/features/shared/domain/entity/user.dart';
import 'package:monai/features/shared/domain/usecase/watch_budget_usecase.dart';
import 'package:monai/features/shared/domain/usecase/watch_categories_usecase.dart';
import 'package:monai/features/shared/domain/usecase/watch_user_usecase.dart';
import 'package:monai/features/shared/domain/usecase/watch_wallets_usecase.dart';

import '../../../../helpers/entity_fixtures.dart';

class _MockWatchUser extends Mock implements WatchUserUseCase {}

class _MockWatchBudget extends Mock implements WatchBudgetUseCase {}

class _MockWatchCategories extends Mock implements WatchCategoriesUseCase {}

class _MockWatchWallets extends Mock implements WatchWalletsUseCase {}

void main() {
  final month = DateTime(2026, 10);
  late StreamController<Either<Failure, User?>> users;
  late _MockWatchBudget budgets;
  late WatchSettingsOverviewUseCase useCase;

  setUpAll(() {
    registerFallbackValue(const NoParams());
    registerFallbackValue(month);
  });

  setUp(() {
    users = StreamController();
    final userUseCase = _MockWatchUser();
    budgets = _MockWatchBudget();
    final categories = _MockWatchCategories();
    final wallets = _MockWatchWallets();
    when(() => userUseCase(any())).thenAnswer((_) => users.stream);
    when(() => budgets(any())).thenAnswer((_) => Stream.value(Right(budget())));
    when(
      () => categories(any()),
    ).thenAnswer((_) => Stream.value(Right([category(), category(id: 'c2')])));
    when(() => wallets(any()))
        .thenAnswer((_) => Stream.value(Right([wallet()])));
    useCase = WatchSettingsOverviewUseCase(
      user: userUseCase,
      budget: budgets,
      categories: categories,
      wallets: wallets,
    );
  });

  tearDown(() => users.close());

  test('rebuilds the overview when a section changes', () async {
    // Arrange
    final overviews = <SettingsOverview>[];
    final subscription = useCase(month)
        .listen((result) => overviews.add(result.toNullable()!));

    // Act
    users
      ..add(const Right(null))
      ..add(Right(user(name: 'Ana Putri')));
    await pumpEventQueue();
    await subscription.cancel();

    // Assert
    expect(overviews.map((o) => o.profile?.name), [null, 'Ana Putri']);
    expect(overviews.last.budgetLimit, 1000000);
    expect(overviews.last.categoryCount, 2);
    expect(overviews.last.walletCount, 1);
    verify(() => budgets(month)).called(1);
  });

  test('passes on a failed read', () async {
    // Arrange
    final results = <Either<Failure, SettingsOverview>>[];
    final subscription = useCase(month).listen(results.add);

    // Act
    users.add(const Left(Failure.cache()));
    await pumpEventQueue();
    await subscription.cancel();

    // Assert
    expect(results.single.getLeft().toNullable(), isA<CacheFailure>());
  });
}
