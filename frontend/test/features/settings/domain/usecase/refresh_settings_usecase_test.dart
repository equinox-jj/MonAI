import 'package:flutter_test/flutter_test.dart';
import 'package:fpdart/fpdart.dart';
import 'package:mocktail/mocktail.dart';
import 'package:monai/core/error/failure.dart';
import 'package:monai/core/usecase/usecase.dart';
import 'package:monai/features/settings/domain/usecase/refresh_settings_usecase.dart';
import 'package:monai/features/shared/domain/usecase/refresh_budget_usecase.dart';
import 'package:monai/features/shared/domain/usecase/refresh_categories_usecase.dart';
import 'package:monai/features/shared/domain/usecase/refresh_user_usecase.dart';

import '../../../../helpers/entity_fixtures.dart';

class _MockRefreshUser extends Mock implements RefreshUserUseCase {}

class _MockRefreshBudget extends Mock implements RefreshBudgetUseCase {}

class _MockRefreshCategories extends Mock implements RefreshCategoriesUseCase {}

void main() {
  final month = DateTime(2026, 10);

  setUpAll(() {
    registerFallbackValue(const NoParams());
    registerFallbackValue(month);
  });

  test('refreshes every section and succeeds even when one fails', () async {
    // Arrange
    final users = _MockRefreshUser();
    final budgets = _MockRefreshBudget();
    final categories = _MockRefreshCategories();
    when(() => users(any())).thenAnswer((_) async => Right(user()));
    when(() => budgets(any()))
        .thenAnswer((_) async => const Left(Failure.network()));
    when(() => categories(any())).thenAnswer((_) async => const Right([]));

    // Act
    final result = await RefreshSettingsUseCase(
      user: users,
      budget: budgets,
      categories: categories,
    )(month);

    // Assert
    expect(result, const Right<Failure, Unit>(unit));
    verify(() => users(const NoParams())).called(1);
    verify(() => budgets(month)).called(1);
    verify(() => categories(const NoParams())).called(1);
  });
}
