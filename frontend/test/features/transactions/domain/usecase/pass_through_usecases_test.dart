import 'package:flutter_test/flutter_test.dart';
import 'package:fpdart/fpdart.dart';
import 'package:mocktail/mocktail.dart';
import 'package:monai/core/base/error/failure.dart';
import 'package:monai/features/shared/domain/entity/transaction.dart';
import 'package:monai/features/shared/domain/entity/transaction_filter.dart';
import 'package:monai/features/shared/domain/repository/transaction_repository.dart';
import 'package:monai/features/shared/domain/usecase/transaction_list_params.dart';
import 'package:monai/features/transactions/domain/usecase/refresh_transaction_usecase.dart';
import 'package:monai/features/transactions/domain/usecase/watch_daily_nets_usecase.dart';
import 'package:monai/features/transactions/domain/usecase/watch_transaction_usecase.dart';

import '../../../../helpers/entity_fixtures.dart';

class _MockRepository extends Mock implements TransactionRepository {}

// The transactions use cases that only forward to the repository.
void main() {
  late _MockRepository repository;
  final october = DateTime(2026, 10);

  setUp(() => repository = _MockRepository());

  test('watch and refresh one transaction forward its id', () async {
    // Arrange
    final fetched = transaction();
    when(() => repository.watchTransaction('t1'))
        .thenAnswer((_) => Stream.value(const Right(null)));
    when(() => repository.refreshTransaction('t1'))
        .thenAnswer((_) async => Right(fetched));

    // Act
    await WatchTransactionUseCase(repository)('t1').first;
    final refreshed = await RefreshTransactionUseCase(repository)('t1');

    // Assert
    expect(refreshed, Right<Failure, Transaction>(fetched));
    verify(() => repository.watchTransaction('t1')).called(1);
  });

  test('daily nets forward the month and filter', () async {
    // Arrange
    const filter = TransactionFilter(categoryId: 'c1');
    when(() => repository.watchDailyNets(october, filter))
        .thenAnswer((_) => Stream.value(const Right({})));

    // Act
    await WatchDailyNetsUseCase(repository)(
      TransactionListParams(month: october, filter: filter),
    ).first;

    // Assert
    verify(() => repository.watchDailyNets(october, filter)).called(1);
  });
}
