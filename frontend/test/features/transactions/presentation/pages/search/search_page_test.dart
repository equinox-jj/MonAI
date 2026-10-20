import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:fpdart/fpdart.dart';
import 'package:intl/date_symbol_data_local.dart';
import 'package:mocktail/mocktail.dart';
import 'package:monai/core/designsystem/theme/monai_theme.dart';
import 'package:monai/core/l10n/l10n.dart';
import 'package:monai/core/usecase/usecase.dart';
import 'package:monai/features/shared/domain/entity/transaction_search_page.dart';
import 'package:monai/features/shared/domain/usecase/watch_cached_expense_totals_usecase.dart';
import 'package:monai/features/transactions/domain/entity/transaction_lookups.dart';
import 'package:monai/features/transactions/domain/usecase/recent_searches_usecase.dart';
import 'package:monai/features/transactions/domain/usecase/search_transactions_usecase.dart';
import 'package:monai/features/transactions/domain/usecase/watch_cached_search_usecase.dart';
import 'package:monai/features/transactions/domain/usecase/watch_transaction_lookups_usecase.dart';
import 'package:monai/features/transactions/presentation/pages/search/bloc/search_bloc.dart';
import 'package:monai/features/transactions/presentation/pages/search/search_page.dart';

import '../../../../../helpers/entity_fixtures.dart';

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

  setUpAll(() {
    registerFallbackValue(const NoParams());
    registerFallbackValue(
      SearchTransactionsParams(query: '', month: DateTime(2026)),
    );
    return initializeDateFormatting();
  });

  setUp(() => search = _MockSearch());

  Future<void> pumpSearch(WidgetTester tester) async {
    final watchLookups = _MockWatchLookups();
    when(() => watchLookups(any())).thenAnswer(
      (_) => Stream.value(
        Right(
          TransactionLookups.of(
            categories: [category()],
            wallets: [wallet(name: 'Cash')],
          ),
        ),
      ),
    );
    final getRecent = _MockGetRecent();
    when(() => getRecent(any()))
        .thenAnswer((_) async => const Right(['parkir']));
    final addRecent = _MockAddRecent();
    when(() => addRecent(any()))
        .thenAnswer((_) async => const Right(['parkir']));
    final bloc = SearchBloc(
      search: search,
      watchCachedSearch: _MockWatchCachedSearch(),
      watchLookups: watchLookups,
      watchExpenseTotals: _MockWatchExpenseTotals(),
      getRecentSearches: getRecent,
      addRecentSearch: addRecent,
      now: () => DateTime(2026, 10, 10),
      debounce: Duration.zero,
    )..add(const SearchEvent.started());
    await tester.pumpWidget(
      MaterialApp(
        localizationsDelegates: AppLocalizations.localizationsDelegates,
        supportedLocales: AppLocalizations.supportedLocales,
        locale: const Locale('en'),
        theme: MonAITheme.light(),
        // The tree closes the bloc: awaiting its debounce in a teardown
        // would wait on fake time forever.
        home: BlocProvider(create: (_) => bloc, child: const SearchUI()),
      ),
    );
    await tester.pumpAndSettle();
  }

  testWidgets('offers the recent searches while blank', (tester) async {
    // Arrange
    // (one recent search)

    // Act
    await pumpSearch(tester);

    // Assert
    expect(find.text('RECENT SEARCHES'), findsOneWidget);
    expect(find.text('parkir'), findsOneWidget);
    // The design's chips: the month, then Wallet, Category and Type.
    expect(find.text('Oct 2026'), findsOneWidget);
    expect(find.text('All types'), findsNothing);
  });

  testWidgets('shows what matches the typed text', (tester) async {
    // Arrange
    when(() => search(any())).thenAnswer(
      (_) async => Right(
        TransactionSearchPage(
          items: [
            transaction(
              note: 'Kopi susu',
              amount: 25000,
              date: DateTime(2026, 10, 10),
            ),
          ],
        ),
      ),
    );
    await pumpSearch(tester);

    // Act
    await tester.enterText(find.byType(EditableText), 'kopi');
    await tester.pumpAndSettle();

    // Assert
    expect(find.text('1 result'), findsOneWidget);
    expect(find.text('Kopi susu'), findsOneWidget);
    expect(find.text('Food · Cash · 10 Oct'), findsOneWidget);
    expect(find.text('Search all months'), findsOneWidget);
  });

  testWidgets('says when nothing matches', (tester) async {
    // Arrange
    when(() => search(any()))
        .thenAnswer((_) async => const Right(TransactionSearchPage(items: [])));
    await pumpSearch(tester);

    // Act
    await tester.enterText(find.byType(EditableText), 'zzz');
    await tester.pumpAndSettle();

    // Assert
    expect(find.text('No results for “zzz”'), findsOneWidget);
    expect(find.text('Nothing in October 2026 matches “zzz”.'), findsOneWidget);
  });

  testWidgets('a recent search fills the box and searches', (tester) async {
    // Arrange
    when(() => search(any()))
        .thenAnswer((_) async => const Right(TransactionSearchPage(items: [])));
    await pumpSearch(tester);

    // Act
    await tester.tap(find.text('parkir'));
    await tester.pumpAndSettle();

    // Assert
    final params =
        verify(() => search(captureAny())).captured.single
            as SearchTransactionsParams;
    expect(params.query, 'parkir');
    expect(find.text('No results for “parkir”'), findsOneWidget);
  });
}
