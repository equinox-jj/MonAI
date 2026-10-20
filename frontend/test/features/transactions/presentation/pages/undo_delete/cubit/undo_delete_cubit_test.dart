import 'dart:async';

import 'package:flutter_test/flutter_test.dart';
import 'package:fpdart/fpdart.dart';
import 'package:mocktail/mocktail.dart';
import 'package:monai/core/error/failure.dart';
import 'package:monai/core/usecase/usecase.dart';
import 'package:monai/features/shared/domain/entity/transaction.dart';
import 'package:monai/features/shared/domain/usecase/watch_transaction_deletions_usecase.dart';
import 'package:monai/features/transactions/domain/entity/transaction_lookups.dart';
import 'package:monai/features/transactions/domain/usecase/restore_transaction_usecase.dart';
import 'package:monai/features/transactions/domain/usecase/watch_transaction_lookups_usecase.dart';
import 'package:monai/features/transactions/presentation/model/transaction_failure.dart';
import 'package:monai/features/transactions/presentation/pages/undo_delete/cubit/undo_delete_cubit.dart';

import '../../../../../../helpers/entity_fixtures.dart';

class _MockWatchDeletions extends Mock
    implements WatchTransactionDeletionsUseCase {}

class _MockWatchLookups extends Mock
    implements WatchTransactionLookupsUseCase {}

class _MockRestore extends Mock implements RestoreTransactionUseCase {}

void main() {
  late StreamController<Either<Failure, Transaction>> deletions;
  late _MockRestore restore;
  late UndoDeleteCubit cubit;

  setUpAll(() => registerFallbackValue(const NoParams()));

  setUp(() {
    deletions = StreamController.broadcast();
    restore = _MockRestore();
    final watchDeletions = _MockWatchDeletions();
    when(() => watchDeletions(any())).thenAnswer((_) => deletions.stream);
    final watchLookups = _MockWatchLookups();
    when(() => watchLookups(any()))
        .thenAnswer((_) => Stream.value(const Right(TransactionLookups())));
    cubit = UndoDeleteCubit(
      watchDeletions: watchDeletions,
      watchLookups: watchLookups,
      restore: restore,
    )..started();
  });

  tearDown(() async {
    await cubit.close();
    await deletions.close();
  });

  Future<void> deleted(Transaction transaction) async {
    deletions.add(Right(transaction));
    await Future<void>.delayed(Duration.zero);
  }

  test('offers to undo a deleted transaction', () async {
    // Arrange
    final deletedTransaction = transaction();

    // Act
    await deleted(deletedTransaction);

    // Assert
    expect(cubit.state.deleted, deletedTransaction);
  });

  test('undo restores the transaction and hides the offer', () async {
    // Arrange
    final deletedTransaction = transaction();
    when(() => restore('t1'))
        .thenAnswer((_) async => Right(deletedTransaction));
    await deleted(deletedTransaction);

    // Act
    await cubit.undo();

    // Assert
    verify(() => restore('t1')).called(1);
    expect(cubit.state.deleted, isNull);
    expect(cubit.state.isRestoring, isFalse);
  });

  test('a failed restore says why once', () async {
    // Arrange
    when(() => restore('t1')).thenAnswer(
      (_) async => const Left(Failure.conflict(code: 'wallet_archived')),
    );
    await deleted(transaction());
    final failures = <TransactionFailure?>[];
    final sub = cubit.stream.listen((s) => failures.add(s.restoreFailure));

    // Act
    await cubit.undo();
    await Future<void>.delayed(Duration.zero);

    // Assert
    expect(failures, contains(TransactionFailure.walletArchived));
    expect(cubit.state.restoreFailure, isNull);
    await sub.cancel();
  });

  test('dismissing drops the offer without restoring', () async {
    // Arrange
    await deleted(transaction());

    // Act
    cubit.dismissed();

    // Assert
    expect(cubit.state.deleted, isNull);
    verifyNever(() => restore(any()));
  });
}
