import 'package:flutter_test/flutter_test.dart';
import 'package:fpdart/fpdart.dart';
import 'package:mocktail/mocktail.dart';
import 'package:monai/core/base/error/failure.dart';
import 'package:monai/core/base/usecase.dart';
import 'package:monai/features/shared/domain/entity/transaction.dart';
import 'package:monai/features/shared/domain/event/transaction_deletion_events.dart';
import 'package:monai/features/shared/domain/repository/transaction_repository.dart';
import 'package:monai/features/shared/domain/usecase/delete_transaction_usecase.dart';
import 'package:monai/features/shared/domain/usecase/refresh_transaction_dependents_usecase.dart';
import 'package:monai/features/shared/domain/usecase/watch_transaction_deletions_usecase.dart';

import '../../../../helpers/entity_fixtures.dart';

class _MockRepository extends Mock implements TransactionRepository {}

class _MockRefreshDependents extends Mock
    implements RefreshTransactionDependentsUseCase {}

void main() {
  late _MockRepository repository;
  late _MockRefreshDependents refreshDependents;
  late TransactionDeletionEvents events;
  late DeleteTransactionUseCase useCase;

  setUp(() {
    repository = _MockRepository();
    refreshDependents = _MockRefreshDependents();
    events = TransactionDeletionEvents();
    useCase = DeleteTransactionUseCase(
      repository: repository,
      events: events,
      refreshDependents: refreshDependents,
    );
    when(() => refreshDependents(any()))
        .thenAnswer((_) async => const Right(true));
  });

  tearDown(() => events.dispose());

  test('announces the deleted transaction, then refreshes its month', () async {
    // Arrange
    final deleted = transaction(date: DateTime(2026, 9, 30));
    when(() => repository.deleteTransaction('t1'))
        .thenAnswer((_) async => Right(deleted));
    final announced = WatchTransactionDeletionsUseCase(events)(const NoParams())
        .first;

    // Act
    final result = await useCase('t1');

    // Assert
    expect(result, Right<Failure, Transaction?>(deleted));
    expect(await announced, Right<Failure, Transaction>(deleted));
    verify(() => refreshDependents([DateTime(2026, 9, 30)])).called(1);
  });

  test('without a cached copy it announces nothing but still refreshes '
      'the wallets', () async {
    // Arrange
    when(() => repository.deleteTransaction('t1'))
        .thenAnswer((_) async => const Right(null));
    final announced = <Object>[];
    final subscription = events.stream.listen(announced.add);

    // Act
    final result = await useCase('t1');
    await subscription.cancel();

    // Assert
    expect(result, const Right<Failure, Transaction?>(null));
    expect(announced, isEmpty);
    verify(() => refreshDependents(const [])).called(1);
  });

  test('a failed delete announces and refreshes nothing', () async {
    // Arrange
    when(() => repository.deleteTransaction('t1'))
        .thenAnswer((_) async => const Left(Failure.network()));

    // Act
    final result = await useCase('t1');

    // Assert
    expect(result.getLeft().toNullable(), isA<NetworkFailure>());
    verifyNever(() => refreshDependents(any()));
  });
}
