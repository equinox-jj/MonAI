import 'package:flutter_test/flutter_test.dart';
import 'package:fpdart/fpdart.dart';
import 'package:mocktail/mocktail.dart';
import 'package:monai/core/error/failure.dart';
import 'package:monai/features/shared/domain/entity/transaction.dart';
import 'package:monai/features/shared/domain/repository/transaction_repository.dart';
import 'package:monai/features/transactions/domain/usecase/get_transaction_usecase.dart';

import '../../../../helpers/entity_fixtures.dart';

class _MockRepository extends Mock implements TransactionRepository {}

void main() {
  late _MockRepository repository;
  late GetTransactionUseCase useCase;

  setUp(() {
    repository = _MockRepository();
    useCase = GetTransactionUseCase(repository);
  });

  void stubCache(List<Either<Failure, Transaction?>> reads) {
    final queue = [...reads];
    when(() => repository.watchTransaction('t1'))
        .thenAnswer((_) => Stream.value(queue.removeAt(0)));
  }

  test('gives the cached one without calling the server', () async {
    // Arrange
    final cached = transaction();
    stubCache([Right(cached)]);

    // Act
    final result = await useCase('t1');

    // Assert
    expect(result, Right<Failure, Transaction>(cached));
    verifyNever(() => repository.refreshTransaction(any()));
  });

  test('fetches one that is not cached', () async {
    // Arrange
    final fetched = transaction();
    stubCache([const Right(null), Right(fetched)]);
    when(() => repository.refreshTransaction('t1'))
        .thenAnswer((_) async => Right(fetched));

    // Act
    final result = await useCase('t1');

    // Assert
    expect(result, Right<Failure, Transaction>(fetched));
  });

  test('fails as the fetch failed', () async {
    // Arrange
    stubCache([const Right(null)]);
    when(() => repository.refreshTransaction('t1'))
        .thenAnswer((_) async => const Left(Failure.notFound()));

    // Act
    final result = await useCase('t1');

    // Assert
    expect(result.getLeft().toNullable(), isA<NotFoundFailure>());
  });
}
