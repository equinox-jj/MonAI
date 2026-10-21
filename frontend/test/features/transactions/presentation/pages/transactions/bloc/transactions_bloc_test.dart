import 'dart:async';

import 'package:flutter_test/flutter_test.dart';
import 'package:fpdart/fpdart.dart';
import 'package:mocktail/mocktail.dart';
import 'package:monai/core/base/error/failure.dart';
import 'package:monai/core/model/transaction_type.dart';
import 'package:monai/core/model/ui_status.dart';
import 'package:monai/core/base/usecase.dart';
import 'package:monai/features/shared/domain/entity/monthly_report.dart';
import 'package:monai/features/shared/domain/entity/transaction.dart';
import 'package:monai/features/shared/domain/entity/transaction_filter.dart';
import 'package:monai/features/shared/domain/usecase/delete_transaction_usecase.dart';
import 'package:monai/features/shared/domain/usecase/load_more_transactions_usecase.dart';
import 'package:monai/features/shared/domain/usecase/refresh_categories_usecase.dart';
import 'package:monai/features/shared/domain/usecase/refresh_monthly_report_usecase.dart';
import 'package:monai/features/shared/domain/usecase/refresh_transactions_usecase.dart';
import 'package:monai/features/shared/domain/usecase/refresh_wallets_usecase.dart';
import 'package:monai/features/shared/domain/usecase/transaction_list_params.dart';
import 'package:monai/features/shared/domain/usecase/watch_cached_expense_totals_usecase.dart';
import 'package:monai/features/shared/domain/usecase/watch_monthly_report_usecase.dart';
import 'package:monai/features/shared/domain/usecase/watch_transactions_usecase.dart';
import 'package:monai/features/transactions/domain/entity/transaction_lookups.dart';
import 'package:monai/features/transactions/domain/usecase/watch_daily_nets_usecase.dart';
import 'package:monai/features/transactions/domain/usecase/watch_transaction_lookups_usecase.dart';
import 'package:monai/features/transactions/presentation/model/transaction_failure.dart';
import 'package:monai/features/transactions/presentation/pages/transactions/bloc/transactions_bloc.dart';

import '../../../../../../helpers/entity_fixtures.dart';

class _MockWatchTransactions extends Mock implements WatchTransactionsUseCase {}

class _MockRefreshTransactions extends Mock
    implements RefreshTransactionsUseCase {}

class _MockLoadMore extends Mock implements LoadMoreTransactionsUseCase {}

class _MockWatchDailyNets extends Mock implements WatchDailyNetsUseCase {}

class _MockWatchReport extends Mock implements WatchMonthlyReportUseCase {}

class _MockRefreshReport extends Mock implements RefreshMonthlyReportUseCase {}

class _MockWatchLookups extends Mock
    implements WatchTransactionLookupsUseCase {}

class _MockRefreshWallets extends Mock implements RefreshWalletsUseCase {}

class _MockRefreshCategories extends Mock implements RefreshCategoriesUseCase {}

class _MockWatchExpenseTotals extends Mock
    implements WatchCachedExpenseTotalsUseCase {}

class _MockDelete extends Mock implements DeleteTransactionUseCase {}

void main() {
  final october = DateTime(2026, 10);
  final september = DateTime(2026, 9);

  late _MockWatchTransactions watchTransactions;
  late _MockRefreshTransactions refreshTransactions;
  late _MockLoadMore loadMore;
  late _MockWatchDailyNets watchDailyNets;
  late _MockWatchReport watchReport;
  late _MockRefreshReport refreshReport;
  late _MockWatchLookups watchLookups;
  late _MockRefreshWallets refreshWallets;
  late _MockRefreshCategories refreshCategories;
  late _MockWatchExpenseTotals watchExpenseTotals;
  late _MockDelete delete;
  late StreamController<Either<Failure, List<Transaction>>> rows;

  setUpAll(() {
    registerFallbackValue(const NoParams());
    registerFallbackValue(TransactionListParams(month: DateTime(2026)));
    registerFallbackValue(
      TransactionPageParams(month: DateTime(2026), limit: 20),
    );
    registerFallbackValue(DateTime(2026));
  });

  setUp(() {
    watchTransactions = _MockWatchTransactions();
    refreshTransactions = _MockRefreshTransactions();
    loadMore = _MockLoadMore();
    watchDailyNets = _MockWatchDailyNets();
    watchReport = _MockWatchReport();
    refreshReport = _MockRefreshReport();
    watchLookups = _MockWatchLookups();
    refreshWallets = _MockRefreshWallets();
    refreshCategories = _MockRefreshCategories();
    watchExpenseTotals = _MockWatchExpenseTotals();
    delete = _MockDelete();
    rows = StreamController.broadcast();

    when(() => watchTransactions(any())).thenAnswer((_) => rows.stream);
    when(() => watchDailyNets(any()))
        .thenAnswer((_) => Stream.value(const Right({})));
    when(() => watchReport(any()))
        .thenAnswer((_) => Stream.value(const Right(null)));
    when(() => refreshReport(any())).thenAnswer(
      (_) async => const Left<Failure, MonthlyReport>(Failure.notFound()),
    );
    when(() => watchLookups(any()))
        .thenAnswer((_) => Stream.value(const Right(TransactionLookups())));
    when(() => refreshWallets(any())).thenAnswer((_) async => const Right([]));
    when(() => refreshCategories(any()))
        .thenAnswer((_) async => const Right([]));
    when(() => refreshTransactions(any()))
        .thenAnswer((_) async => const Right(false));
  });

  tearDown(() => rows.close());

  TransactionsBloc build() => TransactionsBloc(
    watchTransactions: watchTransactions,
    refreshTransactions: refreshTransactions,
    loadMore: loadMore,
    watchDailyNets: watchDailyNets,
    watchReport: watchReport,
    refreshReport: refreshReport,
    watchLookups: watchLookups,
    refreshWallets: refreshWallets,
    refreshCategories: refreshCategories,
    watchExpenseTotals: watchExpenseTotals,
    delete: delete,
    now: () => DateTime(2026, 10, 20, 9),
  );

  /// Lets the bloc handle what the streams and futures sent.
  Future<void> settle() => Future<void>.delayed(Duration.zero);

  test('starts on the current month with the skeleton', () {
    // Arrange
    final bloc = build();

    // Act
    final state = bloc.state;

    // Assert
    expect(state.month, october);
    expect(state.canShowNextMonth, isFalse);
    expect(state.status, UiStatus.initial);
    unawaited(bloc.close());
  });

  test('shows cached rows, then the refreshed page', () async {
    // Arrange
    when(() => refreshTransactions(any()))
        .thenAnswer((_) async => const Right(true));
    final bloc = build()..add(const TransactionsEvent.started());
    await settle();

    // Act
    rows.add(Right([transaction()]));
    await settle();
    await settle();

    // Assert
    expect(bloc.state.status, UiStatus.success);
    expect(bloc.state.transactions.single.id, 't1');
    expect(bloc.state.hasMore, isTrue);
    expect(bloc.state.listLoaded, isTrue);
    await bloc.close();
  });

  test('a month with nothing in it is empty once fetched', () async {
    // Arrange
    final bloc = build();

    // Act
    bloc.add(const TransactionsEvent.started());
    await settle();
    rows.add(const Right([]));
    await settle();
    await settle();

    // Assert
    expect(bloc.state.status, UiStatus.empty);
    await bloc.close();
  });

  test('a failed first load with nothing cached is an error', () async {
    // Arrange
    when(() => refreshTransactions(any()))
        .thenAnswer((_) async => const Left(Failure.network()));
    final bloc = build();

    // Act
    bloc.add(const TransactionsEvent.started());
    await settle();
    await settle();

    // Assert
    expect(bloc.state.status, UiStatus.failure);
    expect(bloc.state.loadFailure, TransactionFailure.network);
    await bloc.close();
  });

  test('a failed refresh keeps the cache and says so once', () async {
    // Arrange
    final refresh = Completer<Either<Failure, bool>>();
    when(() => refreshTransactions(any())).thenAnswer((_) => refresh.future);
    final bloc = build();
    final failures = <TransactionFailure?>[];
    final sub = bloc.stream.listen((s) => failures.add(s.actionFailure));
    bloc.add(const TransactionsEvent.started());
    await settle();
    rows.add(Right([transaction()]));
    await settle();

    // Act
    refresh.complete(const Left(Failure.network()));
    await settle();

    // Assert
    expect(bloc.state.status, UiStatus.success);
    expect(failures, contains(TransactionFailure.network));
    expect(bloc.state.actionFailure, isNull);
    await sub.cancel();
    await bloc.close();
  });

  test('moves back a month and watches it, but not past today', () async {
    // Arrange
    final bloc = build()..add(const TransactionsEvent.started());
    await settle();

    // Act
    bloc
      ..add(const TransactionsEvent.nextMonthPressed())
      ..add(const TransactionsEvent.previousMonthPressed());
    await settle();

    // Assert
    expect(bloc.state.month, september);
    expect(bloc.state.canShowNextMonth, isTrue);
    final watched = verify(() => watchTransactions(captureAny())).captured
        .cast<TransactionPageParams>();
    expect(watched.map((p) => p.month), [october, september]);
    await bloc.close();
  });

  test('a picked filter re-watches and re-fetches the list', () async {
    // Arrange
    final bloc = build()..add(const TransactionsEvent.started());
    await settle();

    // Act
    bloc.add(const TransactionsEvent.typeFilterPicked(TransactionType.income));
    await settle();

    // Assert
    const filter = TransactionFilter(type: TransactionType.income);
    expect(bloc.state.filter, filter);
    expect(bloc.state.hasFilter, isTrue);
    final fetched = verify(() => refreshTransactions(captureAny())).captured
        .cast<TransactionListParams>();
    expect(fetched.last.filter, filter);
    await bloc.close();
  });

  test('loading more fetches a page and shows more rows', () async {
    // Arrange
    when(() => refreshTransactions(any()))
        .thenAnswer((_) async => const Right(true));
    when(() => loadMore(any())).thenAnswer((_) async => const Right(false));
    final bloc = build()..add(const TransactionsEvent.started());
    await settle();

    // Act
    bloc.add(const TransactionsEvent.loadMoreRequested());
    await settle();

    // Assert
    expect(bloc.state.limit, 40);
    expect(bloc.state.hasMore, isFalse);
    final watched = verify(() => watchTransactions(captureAny())).captured
        .cast<TransactionPageParams>();
    expect(watched.last.limit, 40);
    await bloc.close();
  });

  test('does not load more on the last page', () async {
    // Arrange
    final bloc = build()..add(const TransactionsEvent.started());
    await settle();

    // Act
    bloc.add(const TransactionsEvent.loadMoreRequested());
    await settle();

    // Assert
    verifyNever(() => loadMore(any()));
    await bloc.close();
  });

  test('a swiped row hides at once and stays hidden once deleted', () async {
    // Arrange
    final completer = Completer<Either<Failure, Transaction?>>();
    when(() => delete('t1')).thenAnswer((_) => completer.future);
    final bloc = build()..add(const TransactionsEvent.started());
    await settle();
    rows.add(Right([transaction(), transaction(id: 't2')]));
    await settle();

    // Act
    bloc.add(const TransactionsEvent.deleteRequested('t1'));
    await settle();
    final whileDeleting = bloc.state.visibleTransactions.map((t) => t.id);
    rows.add(Right([transaction(id: 't2')]));
    completer.complete(Right(transaction()));
    await settle();

    // Assert
    expect(whileDeleting, ['t2']);
    expect(bloc.state.deletingIds, isEmpty);
    expect(bloc.state.visibleTransactions.map((t) => t.id), ['t2']);
    await bloc.close();
  });

  test('a failed delete brings the row back and says why', () async {
    // Arrange
    when(() => delete('t1'))
        .thenAnswer((_) async => const Left(Failure.network()));
    final bloc = build()..add(const TransactionsEvent.started());
    await settle();
    rows.add(Right([transaction()]));
    await settle();
    final failures = <TransactionFailure?>[];
    final sub = bloc.stream.listen((s) => failures.add(s.actionFailure));

    // Act
    bloc.add(const TransactionsEvent.deleteRequested('t1'));
    await settle();

    // Assert
    expect(bloc.state.visibleTransactions.single.id, 't1');
    expect(failures, contains(TransactionFailure.network));
    await sub.cancel();
    await bloc.close();
  });

  test('watches the totals of the year the month picker shows', () async {
    // Arrange
    when(() => watchExpenseTotals(2025))
        .thenAnswer((_) => Stream.value(Right({DateTime(2025, 12): 50000})));
    final bloc = build();

    // Act
    bloc.add(const TransactionsEvent.monthPickerYearShown(2025));
    await settle();

    // Assert
    expect(bloc.state.monthPickerTotals, {DateTime(2025, 12): 50000});
    await bloc.close();
  });
}
