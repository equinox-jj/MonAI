import 'dart:async';

import 'package:flutter_test/flutter_test.dart';
import 'package:fpdart/fpdart.dart';
import 'package:mocktail/mocktail.dart';
import 'package:monai/core/base/error/failure.dart';
import 'package:monai/core/model/ui_status.dart';
import 'package:monai/core/base/usecase.dart';
import 'package:monai/features/shared/domain/entity/transaction.dart';
import 'package:monai/features/shared/domain/usecase/delete_transaction_usecase.dart';
import 'package:monai/features/transactions/domain/entity/transaction_lookups.dart';
import 'package:monai/features/transactions/domain/usecase/refresh_transaction_usecase.dart';
import 'package:monai/features/transactions/domain/usecase/watch_transaction_lookups_usecase.dart';
import 'package:monai/features/transactions/domain/usecase/watch_transaction_usecase.dart';
import 'package:monai/features/transactions/presentation/model/transaction_failure.dart';
import 'package:monai/features/transactions/presentation/pages/transaction_detail/bloc/transaction_detail_bloc.dart';

import '../../../../../../helpers/entity_fixtures.dart';

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
  late TransactionDetailBloc bloc;

  setUpAll(() => registerFallbackValue(const NoParams()));

  setUp(() {
    cache = StreamController.broadcast();
    refresh = _MockRefreshTransaction();
    delete = _MockDelete();
    final watch = _MockWatchTransaction();
    when(() => watch('t1')).thenAnswer((_) => cache.stream);
    final watchLookups = _MockWatchLookups();
    when(() => watchLookups(any()))
        .thenAnswer((_) => Stream.value(const Right(TransactionLookups())));
    bloc = TransactionDetailBloc(
      id: 't1',
      watchTransaction: watch,
      refreshTransaction: refresh,
      watchLookups: watchLookups,
      delete: delete,
    );
  });

  tearDown(() async {
    await bloc.close();
    await cache.close();
  });

  Future<void> settle() => Future<void>.delayed(Duration.zero);

  test('shows the cached transaction while it refreshes', () async {
    // Arrange
    final refreshed = Completer<Either<Failure, Transaction>>();
    when(() => refresh('t1')).thenAnswer((_) => refreshed.future);
    bloc.add(const TransactionDetailEvent.started());
    await settle();

    // Act
    cache.add(Right(transaction()));
    await settle();

    // Assert
    expect(bloc.state.status, UiStatus.success);
    expect(bloc.state.isRefreshing, isTrue);
    refreshed.complete(Right(transaction()));
  });

  test('a failed fetch with nothing cached is an error', () async {
    // Arrange
    when(() => refresh('t1'))
        .thenAnswer((_) async => const Left(Failure.notFound()));

    // Act
    bloc.add(const TransactionDetailEvent.started());
    await settle();

    // Assert
    expect(bloc.state.status, UiStatus.failure);
    expect(bloc.state.loadFailure, TransactionFailure.notFound);
  });

  test('retry fetches again', () async {
    // Arrange
    when(() => refresh('t1'))
        .thenAnswer((_) async => const Left(Failure.network()));
    bloc.add(const TransactionDetailEvent.started());
    await settle();

    // Act
    bloc.add(const TransactionDetailEvent.retried());
    await settle();

    // Assert
    verify(() => refresh('t1')).called(2);
  });

  test('closes once deleted', () async {
    // Arrange
    when(() => refresh('t1')).thenAnswer((_) async => Right(transaction()));
    when(() => delete('t1')).thenAnswer((_) async => Right(transaction()));
    bloc.add(const TransactionDetailEvent.started());
    await settle();
    cache.add(Right(transaction()));
    await settle();

    // Act
    bloc.add(const TransactionDetailEvent.deleteRequested());
    await settle();

    // Assert
    verify(() => delete('t1')).called(1);
    expect(bloc.state.isClosed, isTrue);
  });

  test('closes when the transaction leaves the cache', () async {
    // Arrange
    when(() => refresh('t1')).thenAnswer((_) async => Right(transaction()));
    bloc.add(const TransactionDetailEvent.started());
    await settle();
    cache.add(Right(transaction()));
    await settle();

    // Act
    cache.add(const Right(null));
    await settle();

    // Assert
    expect(bloc.state.isClosed, isTrue);
  });

  test('a failed delete stays open and says why once', () async {
    // Arrange
    when(() => refresh('t1')).thenAnswer((_) async => Right(transaction()));
    when(() => delete('t1'))
        .thenAnswer((_) async => const Left(Failure.network()));
    bloc.add(const TransactionDetailEvent.started());
    await settle();
    cache.add(Right(transaction()));
    await settle();
    final failures = <TransactionFailure?>[];
    final sub = bloc.stream.listen((s) => failures.add(s.actionFailure));

    // Act
    bloc.add(const TransactionDetailEvent.deleteRequested());
    await settle();

    // Assert
    expect(bloc.state.isClosed, isFalse);
    expect(failures, contains(TransactionFailure.network));
    expect(bloc.state.actionFailure, isNull);
    await sub.cancel();
  });
}
