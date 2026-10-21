import 'package:flutter_test/flutter_test.dart';
import 'package:fpdart/fpdart.dart';
import 'package:mocktail/mocktail.dart';
import 'package:monai/core/base/error/failure.dart';
import 'package:monai/features/budgets/domain/usecase/set_budget_usecase.dart';
import 'package:monai/features/budgets/domain/validation/budget_limit_rule.dart';
import 'package:monai/features/shared/domain/entity/budget.dart';
import 'package:monai/features/shared/domain/repository/budget_repository.dart';

import '../../../../helpers/entity_fixtures.dart';

class _MockRepository extends Mock implements BudgetRepository {}

void main() {
  late _MockRepository repository;
  late SetBudgetUseCase useCase;
  final october = DateTime(2026, 10);

  setUp(() {
    repository = _MockRepository();
    useCase = SetBudgetUseCase(repository);
  });

  test('saves a limit within the rule', () async {
    // Arrange
    final saved = budget();
    when(() => repository.setBudget(october, 3000000))
        .thenAnswer((_) async => Right(saved));

    // Act
    final result = await useCase((month: october, limit: 3000000));

    // Assert
    expect(result, Right<Failure, Budget>(saved));
  });

  for (final (limit, code) in [(0, 'min'), (1000000000000, 'max')]) {
    test('rejects $limit without asking the server', () async {
      // Act
      final result = await useCase((month: october, limit: limit));

      // Assert
      final failure = result.getLeft().toNullable();
      expect(failure, isA<ValidationFailure>());
      final error = (failure! as ValidationFailure).fieldErrors.single;
      expect((error.field, error.code), (BudgetLimitRule.field, code));
      verifyNever(() => repository.setBudget(any(), any()));
    });
  }
}
