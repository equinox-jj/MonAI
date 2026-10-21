import 'package:flutter_test/flutter_test.dart';
import 'package:fpdart/fpdart.dart';
import 'package:mocktail/mocktail.dart';
import 'package:monai/core/base/error/failure.dart';
import 'package:monai/core/model/transaction_type.dart';
import 'package:monai/features/shared/domain/entity/transaction_input.dart';
import 'package:monai/features/shared/domain/repository/transaction_repository.dart';
import 'package:monai/features/shared/domain/usecase/refresh_transaction_dependents_usecase.dart';
import 'package:monai/features/transactions/domain/usecase/update_transaction_usecase.dart';

import '../../../../helpers/entity_fixtures.dart';

class _MockRepository extends Mock implements TransactionRepository {}

class _MockRefreshDependents extends Mock
    implements RefreshTransactionDependentsUseCase {}

void main() {
  late _MockRepository repository;
  late _MockRefreshDependents refreshDependents;
  late UpdateTransactionUseCase useCase;

  final original = transaction(date: DateTime(2026, 9, 30));
  final input = TransactionInput(
    type: TransactionType.expense,
    amount: 20000,
    walletId: 'w1',
    categoryId: 'c1',
    toWalletId: 'w2',
    date: DateTime(2026, 10, 2),
  );

  setUpAll(() => registerFallbackValue(input));

  setUp(() {
    repository = _MockRepository();
    refreshDependents = _MockRefreshDependents();
    useCase = UpdateTransactionUseCase(
      repository: repository,
      refreshDependents: refreshDependents,
      now: () => DateTime(2026, 10, 19),
    );
    when(() => refreshDependents(any()))
        .thenAnswer((_) async => const Right(true));
  });

  test(
    'saves the cleaned-up form and refreshes the old and new month',
    () async {
      // Arrange
      final updated = transaction(date: DateTime(2026, 10, 2));
      when(() => repository.updateTransaction(any(), any()))
          .thenAnswer((_) async => Right(updated));

      // Act
      final result = await useCase(
        UpdateTransactionParams(original: original, input: input),
      );

      // Assert
      expect(result.getRight().toNullable(), updated);
      verify(
        () => repository.updateTransaction(
          't1',
          input.copyWith(toWalletId: null),
        ),
      ).called(1);
      verify(
        () => refreshDependents([DateTime(2026, 9, 30), DateTime(2026, 10, 2)]),
      ).called(1);
    },
  );

  test('invalid input fails without calling the server', () async {
    // Arrange
    final invalid = input.copyWith(amount: 0);

    // Act
    final result = await useCase(
      UpdateTransactionParams(original: original, input: invalid),
    );

    // Assert
    expect(result.getLeft().toNullable(), isA<ValidationFailure>());
    verifyNever(() => repository.updateTransaction(any(), any()));
  });

  test('a failed update refreshes nothing', () async {
    // Arrange
    when(() => repository.updateTransaction(any(), any()))
        .thenAnswer((_) async => const Left(Failure.notFound()));

    // Act
    final result = await useCase(
      UpdateTransactionParams(original: original, input: input),
    );

    // Assert
    expect(result.getLeft().toNullable(), isA<NotFoundFailure>());
    verifyNever(() => refreshDependents(any()));
  });
}
