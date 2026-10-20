import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:fpdart/fpdart.dart';
import 'package:intl/date_symbol_data_local.dart';
import 'package:mocktail/mocktail.dart';
import 'package:monai/core/designsystem/theme/monai_theme.dart';
import 'package:monai/core/error/failure.dart';
import 'package:monai/core/l10n/l10n.dart';
import 'package:monai/core/model/transaction_source.dart';
import 'package:monai/core/model/transaction_type.dart';
import 'package:monai/core/usecase/usecase.dart';
import 'package:monai/features/shared/domain/entity/transaction.dart';
import 'package:monai/features/shared/domain/usecase/delete_transaction_usecase.dart';
import 'package:monai/features/transactions/domain/entity/transaction_lookups.dart';
import 'package:monai/features/transactions/domain/usecase/refresh_transaction_usecase.dart';
import 'package:monai/features/transactions/domain/usecase/watch_transaction_lookups_usecase.dart';
import 'package:monai/features/transactions/domain/usecase/watch_transaction_usecase.dart';
import 'package:monai/features/transactions/presentation/pages/transaction_detail/bloc/transaction_detail_bloc.dart';
import 'package:monai/features/transactions/presentation/pages/transaction_detail/transaction_detail_page.dart';

import '../../../../../helpers/entity_fixtures.dart';

class _MockWatchTransaction extends Mock implements WatchTransactionUseCase {}

class _MockRefreshTransaction extends Mock
    implements RefreshTransactionUseCase {}

class _MockWatchLookups extends Mock
    implements WatchTransactionLookupsUseCase {}

class _MockDelete extends Mock implements DeleteTransactionUseCase {}

void main() {
  late StreamController<Either<Failure, Transaction?>> cache;
  late _MockRefreshTransaction refresh;
  late _MockDelete delete;
  late bool closed;

  setUpAll(() {
    registerFallbackValue(const NoParams());
    return initializeDateFormatting();
  });

  setUp(() {
    cache = StreamController.broadcast();
    refresh = _MockRefreshTransaction();
    delete = _MockDelete();
    closed = false;
  });

  tearDown(() => cache.close());

  Future<void> pumpDetail(WidgetTester tester) async {
    final watch = _MockWatchTransaction();
    when(() => watch('t1')).thenAnswer((_) => cache.stream);
    final watchLookups = _MockWatchLookups();
    when(() => watchLookups(any())).thenAnswer(
      (_) => Stream.value(
        Right(
          TransactionLookups.of(
            categories: [category(name: 'Shopping')],
            wallets: [wallet(name: 'BCA Tabungan')],
          ),
        ),
      ),
    );
    final bloc = TransactionDetailBloc(
      id: 't1',
      watchTransaction: watch,
      refreshTransaction: refresh,
      watchLookups: watchLookups,
      delete: delete,
    )..add(const TransactionDetailEvent.started());
    addTearDown(bloc.close);
    await tester.pumpWidget(
      MaterialApp(
        localizationsDelegates: AppLocalizations.localizationsDelegates,
        supportedLocales: AppLocalizations.supportedLocales,
        locale: const Locale('en'),
        theme: MonAITheme.light(),
        home: BlocProvider.value(
          value: bloc,
          child: TransactionDetailUI(onClosed: () => closed = true),
        ),
      ),
    );
  }

  final shown = transaction(
    type: TransactionType.expense,
    amount: 187500,
    note: 'Belanja bulanan',
    merchant: 'Toko Sumber Rejeki',
    date: DateTime(2026, 10, 9),
    source: TransactionSource.receipt,
  );

  testWidgets('shows the amount and every field', (tester) async {
    // Arrange
    when(() => refresh('t1')).thenAnswer((_) async => Right(shown));
    await pumpDetail(tester);

    // Act
    cache.add(Right(shown));
    await tester.pumpAndSettle();

    // Assert
    expect(find.text('−Rp 187.500'), findsOneWidget);
    expect(find.text('Belanja bulanan'), findsWidgets);
    expect(find.text('Shopping'), findsOneWidget);
    expect(find.text('BCA Tabungan'), findsOneWidget);
    expect(find.text('Friday, 9 October 2026'), findsOneWidget);
    expect(find.text('Toko Sumber Rejeki'), findsOneWidget);
    expect(find.text('Receipt scan'), findsOneWidget);
  });

  testWidgets('Delete deletes it and closes the screen', (tester) async {
    // Arrange
    when(() => refresh('t1')).thenAnswer((_) async => Right(shown));
    when(() => delete('t1')).thenAnswer((_) async => Right(shown));
    await pumpDetail(tester);
    cache.add(Right(shown));
    await tester.pumpAndSettle();

    // Act
    await tester.tap(find.text('Delete'));
    await tester.pumpAndSettle();

    // Assert
    verify(() => delete('t1')).called(1);
    expect(closed, isTrue);
  });

  testWidgets('a transaction that no longer exists says so', (tester) async {
    // Arrange
    when(() => refresh('t1'))
        .thenAnswer((_) async => const Left(Failure.notFound()));

    // Act
    await pumpDetail(tester);
    await tester.pumpAndSettle();

    // Assert
    expect(find.text("Couldn't open the transaction"), findsOneWidget);
    expect(find.text('This transaction no longer exists.'), findsOneWidget);
    expect(find.text('Try again'), findsNothing);
  });
}
