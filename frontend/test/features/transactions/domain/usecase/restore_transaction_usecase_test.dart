import 'package:flutter_test/flutter_test.dart';
import 'package:fpdart/fpdart.dart';
import 'package:mocktail/mocktail.dart';
import 'package:monai/core/error/failure.dart';
import 'package:monai/features/shared/domain/repository/transaction_repository.dart';
import 'package:monai/features/shared/domain/usecase/refresh_transaction_dependents_usecase.dart';
import 'package:monai/features/transactions/domain/usecase/restore_transaction_usecase.dart';

import '../../../../helpers/entity_fixtures.dart';

class _MockRepository extends Mock implements TransactionRepository {}

class _MockRefreshDependents extends Mock
    implements RefreshTransactionDependentsUseCase {}

void main() {
  late _MockRepository repository;
  late _MockRefreshDependents refreshDependents;
  late RestoreTransactionUseCase useCase;

  setUp(() {
    repository = _MockRepository();
    refreshDependents = _MockRefreshDependents();
    useCase = RestoreTransactionUseCase(
      repository: repository,
      refreshDependents: refreshDependents,
    );
    when(() => refreshDependents(any()))
        .thenAnswer((_) async => const Right(true));
  });

  test('restores, then refreshes the month of the restored one', () async {
    // Arrange
    final restored = transaction(date: DateTime(2026, 10, 3));
    when(() => repository.restoreTransaction('t1'))
        .thenAnswer((_) async => Right(restored));

    // Act
    final result = await useCase('t1');

    // Assert
    expect(result.getRight().toNullable(), restored);
    verify(() => refreshDependents([DateTime(2026, 10, 3)])).called(1);
  });

  test('a refused restore keeps its code and refreshes nothing', () async {
    // Arrange
    when(() => repository.restoreTransaction('t1')).thenAnswer(
      (_) async => const Left(Failure.validation([], code: 'wallet_archived')),
    );

    // Act
    final result = await useCase('t1');

    // Assert
    expect(result.getLeft().toNullable()?.code, 'wallet_archived');
    verifyNever(() => refreshDependents(any()));
  });
}
