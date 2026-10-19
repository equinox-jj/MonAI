import 'package:flutter_test/flutter_test.dart';
import 'package:fpdart/fpdart.dart';
import 'package:mocktail/mocktail.dart';
import 'package:monai/core/error/failure.dart';
import 'package:monai/core/model/transaction_type.dart';
import 'package:monai/features/shared/domain/entity/transaction.dart';
import 'package:monai/features/shared/domain/entity/transaction_input.dart';
import 'package:monai/features/shared/domain/repository/transaction_repository.dart';
import 'package:monai/features/shared/domain/usecase/create_transaction_usecase.dart';
import 'package:monai/features/shared/domain/usecase/refresh_transaction_dependents_usecase.dart';

import '../../../../helpers/entity_fixtures.dart';

class _MockRepository extends Mock implements TransactionRepository {}

class _MockRefreshDependents extends Mock
    implements RefreshTransactionDependentsUseCase {}

void main() {
  late _MockRepository repository;
  late _MockRefreshDependents refreshDependents;
  late CreateTransactionUseCase useCase;

  final input = TransactionInput(
    type: TransactionType.expense,
    amount: 10000,
    walletId: 'w1',
    categoryId: 'c1',
    date: DateTime(2026, 10, 5),
    note: '  Kopi ',
  );

  setUpAll(() => registerFallbackValue(input));

  setUp(() {
    repository = _MockRepository();
    refreshDependents = _MockRefreshDependents();
    useCase = CreateTransactionUseCase(
      repository: repository,
      refreshDependents: refreshDependents,
      now: () => DateTime(2026, 10, 19),
    );
    when(() => refreshDependents(any()))
        .thenAnswer((_) async => const Right(true));
  });

  test('sends the cleaned-up input, then refreshes its month', () async {
    // Arrange
    final created = transaction(date: DateTime(2026, 10, 5));
    when(() => repository.createTransaction(any()))
        .thenAnswer((_) async => Right(created));

    // Act
    final result = await useCase(input);

    // Assert
    expect(result, Right<Failure, Transaction>(created));
    verify(() => repository.createTransaction(input.copyWith(note: 'Kopi')))
        .called(1);
    verify(() => refreshDependents([DateTime(2026, 10, 5)])).called(1);
  });

  test('invalid input fails without calling the server', () async {
    // Arrange
    final future = input.copyWith(date: DateTime(2026, 10, 20));

    // Act
    final result = await useCase(future);

    // Assert
    expect(
      result.getLeft().toNullable(),
      isA<ValidationFailure>().having(
        (f) => f.fieldErrors.single.code,
        'code',
        'future_date',
      ),
    );
    verifyNever(() => repository.createTransaction(any()));
  });

  test('a failed create refreshes nothing', () async {
    // Arrange
    when(() => repository.createTransaction(any()))
        .thenAnswer((_) async => const Left(Failure.network()));

    // Act
    final result = await useCase(input);

    // Assert
    expect(result.getLeft().toNullable(), isA<NetworkFailure>());
    verifyNever(() => refreshDependents(any()));
  });
}
