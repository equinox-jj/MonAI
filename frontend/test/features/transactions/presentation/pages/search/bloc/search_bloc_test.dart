import 'dart:async';

import 'package:flutter_test/flutter_test.dart';
import 'package:fpdart/fpdart.dart';
import 'package:mocktail/mocktail.dart';
import 'package:monai/core/error/failure.dart';
import 'package:monai/core/model/transaction_type.dart';
import 'package:monai/core/model/ui_status.dart';
import 'package:monai/core/usecase/usecase.dart';
import 'package:monai/features/shared/domain/entity/transaction.dart';
import 'package:monai/features/shared/domain/entity/transaction_search_page.dart';
import 'package:monai/features/shared/domain/usecase/watch_cached_expense_totals_usecase.dart';
import 'package:monai/features/transactions/domain/entity/transaction_lookups.dart';
import 'package:monai/features/transactions/domain/usecase/recent_searches_usecase.dart';
import 'package:monai/features/transactions/domain/usecase/search_transactions_usecase.dart';
import 'package:monai/features/transactions/domain/usecase/watch_cached_search_usecase.dart';
import 'package:monai/features/transactions/domain/usecase/watch_transaction_lookups_usecase.dart';
import 'package:monai/features/transactions/presentation/model/transaction_failure.dart';
import 'package:monai/features/transactions/presentation/pages/search/bloc/search_bloc.dart';

import '../../../../../../helpers/entity_fixtures.dart';

class _MockSearch extends Mock implements SearchTransactionsUseCase {}

class _MockWatchCachedSearch extends Mock implements WatchCachedSearchUseCase {}

class _MockWatchLookups extends Mock
    implements WatchTransactionLookupsUseCase {}

class _MockWatchExpenseTotals extends Mock
    implements WatchCachedExpenseTotalsUseCase {}

class _MockGetRecent extends Mock implements GetRecentSearchesUseCase {}

class _MockAddRecent extends Mock implements AddRecentSearchUseCase {}

void main() {
  late _MockSearch search;
  late _MockWatchCachedSearch watchCached;
  late _MockAddRecent addRecent;
  late SearchBloc bloc;

  setUpAll(() {
    registerFallbackValue(const NoParams());
    registerFallbackValue(
      SearchTransactionsParams(query: '', month: DateTime(2026)),
    );
    registerFallbackValue(const CachedSearchParams(query: '', limit: 20));
  });

  setUp(() {
    search = _MockSearch();
    watchCached = _MockWatchCachedSearch();
    addRecent = _MockAddRecent();
    final watchLookups = _MockWatchLookups();
    when(() => watchLookups(any()))
        .thenAnswer((_) => Stream.value(const Right(TransactionLookups())));
    final getRecent = _MockGetRecent();
    when(() => getRecent(any()))
        .thenAnswer((_) async => const Right(['parkir']));
    bloc = SearchBloc(
      search: search,
      watchCachedSearch: watchCached,
      watchLookups: watchLookups,
      watchExpenseTotals: _MockWatchExpenseTotals(),
      getRecentSearches: getRecent,
      addRecentSearch: addRecent,
      initialMonth: DateTime(2026, 9, 15),
      now: () => DateTime(2026, 10, 10),
      debounce: Duration.zero,
    )..add(const SearchEvent.started());
  });

  tearDown(() => bloc.close());

  Future<void> settle() =>
      Future<void>.delayed(const Duration(milliseconds: 5));

  Right<Failure, TransactionSearchPage> page(
    List<Transaction> items, {
    String? cursor,
  }) => Right(TransactionSearchPage(items: items, nextCursor: cursor));

  test('starts in the given month with the recent searches', () async {
    // Arrange
    // (the bloc from setUp)

    // Act
    await settle();

    // Assert
    expect(bloc.state.month, DateTime(2026, 9));
    expect(bloc.state.status, UiStatus.initial);
    expect(bloc.state.recentSearches, ['parkir']);
  });

  test('searches the month on the server as the user types', () async {
    // Arrange
    when(() => search(any()))
        .thenAnswer((_) async => page([transaction(note: 'Kopi susu')]));

    // Act
    bloc.add(const SearchEvent.queryChanged('kopi'));
    await settle();

    // Assert
    expect(bloc.state.status, UiStatus.success);
    expect(bloc.state.results.single.note, 'Kopi susu');
    final params =
        verify(() => search(captureAny())).captured.single
            as SearchTransactionsParams;
    expect(params.query, 'kopi');
    expect(params.month, DateTime(2026, 9));
  });

  test('nothing found is empty, a failure says why', () async {
    // Arrange
    when(() => search(any())).thenAnswer((_) async => page([]));
    bloc.add(const SearchEvent.queryChanged('zzz'));
    await settle();
    final empty = bloc.state.status;
    when(() => search(any()))
        .thenAnswer((_) async => const Left(Failure.network()));

    // Act
    bloc.add(const SearchEvent.queryChanged('zzzz'));
    await settle();

    // Assert
    expect(empty, UiStatus.empty);
    expect(bloc.state.status, UiStatus.failure);
    expect(bloc.state.failure, TransactionFailure.network);
  });

  test('blank text goes back to the recent searches', () async {
    // Arrange
    when(() => search(any())).thenAnswer((_) async => page([transaction()]));
    bloc.add(const SearchEvent.queryChanged('kopi'));
    await settle();

    // Act
    bloc.add(const SearchEvent.queryChanged('  '));
    await settle();

    // Assert
    expect(bloc.state.status, UiStatus.initial);
    expect(bloc.state.results, isEmpty);
  });

  test('loads the next server page', () async {
    // Arrange
    when(() => search(any())).thenAnswer((invocation) async {
      final params =
          invocation.positionalArguments.single as SearchTransactionsParams;
      return params.cursor == null
          ? page([transaction(id: 'a')], cursor: 'next')
          : page([transaction(id: 'b')]);
    });
    bloc.add(const SearchEvent.queryChanged('kopi'));
    await settle();

    // Act
    bloc.add(const SearchEvent.loadMoreRequested());
    await settle();

    // Assert
    expect(bloc.state.results.map((t) => t.id), ['a', 'b']);
    expect(bloc.state.hasMore, isFalse);
  });

  test('all months searches the cache on the device', () async {
    // Arrange
    when(() => watchCached(any()))
        .thenAnswer((_) => Stream.value(Right([transaction(id: 'old')])));
    bloc.add(const SearchEvent.queryChanged('kopi'));
    when(() => search(any())).thenAnswer((_) async => page([]));
    await settle();

    // Act
    bloc.add(const SearchEvent.allMonthsToggled(allMonths: true));
    await settle();

    // Assert
    expect(bloc.state.allMonths, isTrue);
    expect(bloc.state.results.single.id, 'old');
    verify(() => watchCached(any())).called(1);
  });

  test('a filter re-runs the search with it', () async {
    // Arrange
    when(() => search(any())).thenAnswer((_) async => page([transaction()]));
    bloc.add(const SearchEvent.queryChanged('kopi'));
    await settle();

    // Act
    bloc.add(const SearchEvent.typeFilterPicked(TransactionType.income));
    await settle();

    // Assert
    final params = verify(() => search(captureAny())).captured
        .cast<SearchTransactionsParams>();
    expect(params.last.filter.type, TransactionType.income);
  });

  test('a newer search wins over a slower older one', () async {
    // Arrange
    final slow = Completer<Either<Failure, TransactionSearchPage>>();
    when(() => search(any())).thenAnswer((invocation) {
      final params =
          invocation.positionalArguments.single as SearchTransactionsParams;
      return params.filter.type == null
          ? slow.future
          : Future.value(page([transaction(id: 'new')]));
    });
    bloc.add(const SearchEvent.queryChanged('ko'));
    await settle();

    // Act
    bloc.add(const SearchEvent.typeFilterPicked(TransactionType.expense));
    await settle();
    slow.complete(page([transaction(id: 'old')]));
    await settle();

    // Assert
    expect(bloc.state.results.single.id, 'new');
  });

  test('submitting remembers the search', () async {
    // Arrange
    when(() => search(any())).thenAnswer((_) async => page([]));
    when(() => addRecent('kopi'))
        .thenAnswer((_) async => const Right(['kopi', 'parkir']));
    bloc.add(const SearchEvent.queryChanged('kopi'));
    await settle();

    // Act
    bloc.add(const SearchEvent.submitted());
    await settle();

    // Assert
    expect(bloc.state.recentSearches, ['kopi', 'parkir']);
  });
}
