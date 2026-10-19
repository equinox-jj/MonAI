import 'package:flutter_test/flutter_test.dart';
import 'package:fpdart/fpdart.dart';
import 'package:mocktail/mocktail.dart';
import 'package:monai/core/error/failure.dart';
import 'package:monai/features/shared/domain/entity/transaction.dart';
import 'package:monai/features/shared/domain/entity/transaction_filter.dart';
import 'package:monai/features/shared/domain/entity/transaction_search_page.dart';
import 'package:monai/features/shared/domain/repository/transaction_repository.dart';
import 'package:monai/features/transactions/domain/usecase/search_transactions_usecase.dart';
import 'package:monai/features/transactions/domain/usecase/watch_cached_search_usecase.dart';

import '../../../../helpers/entity_fixtures.dart';

class _MockRepository extends Mock implements TransactionRepository {}

void main() {
  late _MockRepository repository;
  final october = DateTime(2026, 10);

  setUpAll(() {
    registerFallbackValue(const TransactionFilter());
    registerFallbackValue(DateTime(2026));
  });

  setUp(() => repository = _MockRepository());

  group('SearchTransactionsUseCase', () {
    test('searches the server with the trimmed text', () async {
      // Arrange
      final page = TransactionSearchPage(items: [transaction()]);
      when(
        () => repository.searchTransactions(
          any(),
          month: any(named: 'month'),
          filter: any(named: 'filter'),
          cursor: any(named: 'cursor'),
        ),
      ).thenAnswer((_) async => Right(page));

      // Act
      final result = await SearchTransactionsUseCase(repository)(
        SearchTransactionsParams(query: '  kopi ', month: october),
      );

      // Assert
      expect(result, Right<Failure, TransactionSearchPage>(page));
      verify(
        () => repository.searchTransactions(
          'kopi',
          month: october,
          filter: const TransactionFilter(),
        ),
      ).called(1);
    });

    test('blank text finds nothing without calling the server', () async {
      // Arrange
      // (no stubs: the repository must not be called)

      // Act
      final result = await SearchTransactionsUseCase(repository)(
        SearchTransactionsParams(query: '   ', month: october),
      );

      // Assert
      expect(result.getRight().toNullable()?.items, isEmpty);
      verifyZeroInteractions(repository);
    });
  });

  group('WatchCachedSearchUseCase', () {
    test('searches the cache with the trimmed text', () async {
      // Arrange
      when(
        () => repository.watchCachedSearch(
          any(),
          any(),
          limit: any(named: 'limit'),
        ),
      ).thenAnswer((_) => Stream.value(Right([transaction()])));

      // Act
      final result = await WatchCachedSearchUseCase(repository)(
        const CachedSearchParams(query: ' kopi ', limit: 20),
      ).first;

      // Assert
      expect(result.getRight().toNullable(), hasLength(1));
      verify(
        () => repository.watchCachedSearch(
          'kopi',
          const TransactionFilter(),
          limit: 20,
        ),
      ).called(1);
    });

    test('blank text finds nothing without reading the cache', () async {
      // Arrange
      // (no stubs: the repository must not be called)

      // Act
      final result = await WatchCachedSearchUseCase(repository)(
        const CachedSearchParams(query: '', limit: 20),
      ).first;

      // Assert
      expect(result, const Right<Failure, List<Transaction>>([]));
      verifyZeroInteractions(repository);
    });
  });
}
