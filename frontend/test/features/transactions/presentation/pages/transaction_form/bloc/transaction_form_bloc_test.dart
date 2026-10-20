import 'package:flutter_test/flutter_test.dart';
import 'package:fpdart/fpdart.dart';
import 'package:mocktail/mocktail.dart';
import 'package:monai/core/error/failure.dart';
import 'package:monai/core/error/field_error.dart';
import 'package:monai/core/model/category_type.dart';
import 'package:monai/core/model/transaction_type.dart';
import 'package:monai/core/model/ui_status.dart';
import 'package:monai/core/usecase/usecase.dart';
import 'package:monai/features/shared/domain/entity/transaction.dart';
import 'package:monai/features/shared/domain/entity/transaction_input.dart';
import 'package:monai/features/shared/domain/usecase/create_transaction_usecase.dart';
import 'package:monai/features/shared/domain/usecase/delete_transaction_usecase.dart';
import 'package:monai/features/shared/domain/validation/transaction_input_validator.dart';
import 'package:monai/features/transactions/domain/entity/transaction_lookups.dart';
import 'package:monai/features/transactions/domain/usecase/get_transaction_usecase.dart';
import 'package:monai/features/transactions/domain/usecase/update_transaction_usecase.dart';
import 'package:monai/features/transactions/domain/usecase/watch_transaction_lookups_usecase.dart';
import 'package:monai/features/transactions/presentation/model/transaction_failure.dart';
import 'package:monai/features/transactions/presentation/pages/transaction_form/bloc/transaction_form_bloc.dart';
import 'package:monai/features/transactions/presentation/pages/transaction_form/model/transaction_form_mode.dart';

import '../../../../../../helpers/entity_fixtures.dart';

class _MockGet extends Mock implements GetTransactionUseCase {}

class _MockCreate extends Mock implements CreateTransactionUseCase {}

class _MockUpdate extends Mock implements UpdateTransactionUseCase {}

class _MockDelete extends Mock implements DeleteTransactionUseCase {}

class _MockWatchLookups extends Mock
    implements WatchTransactionLookupsUseCase {}

void main() {
  late _MockGet get;
  late _MockCreate create;
  late _MockUpdate update;
  late _MockDelete delete;
  late _MockWatchLookups watchLookups;

  final lookups = TransactionLookups.of(
    categories: [
      category(),
      category(id: 'c2', name: 'Salary', type: CategoryType.income),
    ],
    wallets: [
      wallet(id: 'w1', name: 'Cash'),
      wallet(id: 'w2', name: 'BCA', isDefault: true),
      wallet(id: 'w3', name: 'Old', isArchived: true),
    ],
  );

  setUpAll(() {
    registerFallbackValue(const NoParams());
    registerFallbackValue(
      TransactionInput(
        type: TransactionType.expense,
        amount: 1,
        date: DateTime(2026),
      ),
    );
    registerFallbackValue(
      UpdateTransactionParams(
        original: transaction(),
        input: TransactionInput(
          type: TransactionType.expense,
          amount: 1,
          date: DateTime(2026),
        ),
      ),
    );
  });

  setUp(() {
    get = _MockGet();
    create = _MockCreate();
    update = _MockUpdate();
    delete = _MockDelete();
    watchLookups = _MockWatchLookups();
    when(() => watchLookups(any()))
        .thenAnswer((_) => Stream.value(Right(lookups)));
  });

  TransactionFormBloc build([
    TransactionFormMode mode = const TransactionFormMode.add(),
  ]) => TransactionFormBloc(
    mode: mode,
    getTransaction: get,
    create: create,
    update: update,
    delete: delete,
    watchLookups: watchLookups,
    now: () => DateTime(2026, 10, 10, 15),
  );

  Future<TransactionFormBloc> started([
    TransactionFormMode mode = const TransactionFormMode.add(),
  ]) async {
    final bloc = build(mode)..add(const TransactionFormEvent.started());
    await Future<void>.delayed(Duration.zero);
    addTearDown(bloc.close);
    return bloc;
  }

  Future<void> send(TransactionFormBloc bloc, TransactionFormEvent event) {
    bloc.add(event);
    return Future<void>.delayed(Duration.zero);
  }

  test('a new expense starts today from the default wallet', () async {
    // Arrange
    // (lookups with BCA as the default wallet)

    // Act
    final bloc = await started();

    // Assert
    expect(bloc.state.status, UiStatus.success);
    expect(bloc.state.draft.date, DateTime(2026, 10, 10));
    expect(bloc.state.draft.walletId, 'w2');
    expect(bloc.state.wallets.map((w) => w.id), ['w1', 'w2']);
  });

  test('the keypad types, adds three zeros and deletes', () async {
    // Arrange
    final bloc = await started();

    // Act
    await send(bloc, const TransactionFormEvent.digitPressed(3));
    await send(bloc, const TransactionFormEvent.digitPressed(5));
    await send(bloc, const TransactionFormEvent.tripleZeroPressed());
    await send(bloc, const TransactionFormEvent.digitPressed(1));
    await send(bloc, const TransactionFormEvent.backspacePressed());

    // Assert
    expect(bloc.state.draft.amount, 35000);
  });

  test('ignores keys past the largest amount', () async {
    // Arrange
    final bloc = await started();
    for (var i = 0; i < 12; i++) {
      await send(bloc, const TransactionFormEvent.digitPressed(9));
    }

    // Act
    await send(bloc, const TransactionFormEvent.digitPressed(9));

    // Assert
    expect(bloc.state.draft.amount, TransactionInputValidator.amountMax);
  });

  test('a transfer drops the category and picks another wallet', () async {
    // Arrange
    final bloc = await started();
    await send(bloc, const TransactionFormEvent.categoryPicked('c1'));

    // Act
    await send(
      bloc,
      const TransactionFormEvent.typeSelected(TransactionType.transfer),
    );

    // Assert
    expect(bloc.state.draft.categoryId, isNull);
    expect(bloc.state.draft.walletId, 'w2');
    expect(bloc.state.draft.toWalletId, 'w1');
  });

  test('switching to income keeps only an income category', () async {
    // Arrange
    final bloc = await started();
    await send(bloc, const TransactionFormEvent.categoryPicked('c1'));

    // Act
    await send(
      bloc,
      const TransactionFormEvent.typeSelected(TransactionType.income),
    );

    // Assert
    expect(bloc.state.draft.categoryId, isNull);
    expect(bloc.state.categories.map((c) => c.id), ['c2']);
  });

  test('saves a new transaction with the note and closes', () async {
    // Arrange
    when(() => create(any()))
        .thenAnswer((_) async => Right(transaction(id: 'new')));
    final bloc = await started();
    await send(bloc, const TransactionFormEvent.digitPressed(5));
    await send(bloc, const TransactionFormEvent.categoryPicked('c1'));

    // Act
    await send(bloc, const TransactionFormEvent.saveRequested(note: 'Kopi'));

    // Assert
    final input =
        verify(() => create(captureAny())).captured.single as TransactionInput;
    expect(input.amount, 5);
    expect(input.walletId, 'w2');
    expect(input.categoryId, 'c1');
    expect(input.note, 'Kopi');
    expect(bloc.state.outcome, const TransactionFormOutcome.saved('new'));
  });

  test('a rejected save shows field errors that clear as fixed', () async {
    // Arrange
    when(() => create(any())).thenAnswer(
      (_) async => const Left(
        Failure.validation([
          FieldError(field: 'amount', code: 'min', message: 'min'),
          FieldError(field: 'category_id', code: 'required', message: 'req'),
        ]),
      ),
    );
    final bloc = await started();
    await send(bloc, const TransactionFormEvent.saveRequested(note: ''));

    // Act
    await send(bloc, const TransactionFormEvent.digitPressed(5));

    // Assert
    expect(bloc.state.autovalidate, isTrue);
    expect(bloc.state.errorOf('amount'), isNull);
    expect(bloc.state.errorOf('category_id')?.code, 'required');
  });

  test('another failed save says why once', () async {
    // Arrange
    when(() => create(any()))
        .thenAnswer((_) async => const Left(Failure.network()));
    final bloc = await started();
    final failures = <TransactionFailure?>[];
    final sub = bloc.stream.listen((s) => failures.add(s.actionFailure));

    // Act
    await send(bloc, const TransactionFormEvent.saveRequested(note: ''));

    // Assert
    expect(failures, contains(TransactionFailure.network));
    expect(bloc.state.actionFailure, isNull);
    expect(bloc.state.isSaving, isFalse);
    expect(bloc.state.outcome, isNull);
    await sub.cancel();
  });

  test('closing an untouched form closes at once', () async {
    // Arrange
    final bloc = await started();

    // Act
    await send(bloc, const TransactionFormEvent.closeRequested(note: ''));

    // Assert
    expect(bloc.state.outcome, const TransactionFormOutcome.closed());
  });

  test('closing with changes asks first', () async {
    // Arrange
    final bloc = await started();
    final asked = <bool>[];
    final sub = bloc.stream.listen((s) => asked.add(s.askDiscard));

    // Act
    await send(bloc, const TransactionFormEvent.closeRequested(note: 'x'));
    await send(bloc, const TransactionFormEvent.discardConfirmed());

    // Assert
    expect(asked, contains(true));
    expect(bloc.state.outcome, const TransactionFormOutcome.closed());
    await sub.cancel();
  });

  group('editing', () {
    final original = transaction(
      id: 't1',
      amount: 35000,
      note: 'Makan siang',
      date: DateTime(2026, 10, 9),
    );

    test('loads the transaction and saves it as an update', () async {
      // Arrange
      when(() => get('t1')).thenAnswer((_) async => Right(original));
      when(() => update(any())).thenAnswer((_) async => Right(original));
      final bloc = await started(const TransactionFormMode.edit('t1'));

      // Act
      await send(bloc, const TransactionFormEvent.digitPressed(0));
      await send(
        bloc,
        const TransactionFormEvent.saveRequested(note: 'Makan siang'),
      );

      // Assert
      expect(bloc.state.changedFromAmount, 35000);
      final params =
          verify(() => update(captureAny())).captured.single
              as UpdateTransactionParams;
      expect(params.original, original);
      expect(params.input.amount, 350000);
      expect(bloc.state.outcome, const TransactionFormOutcome.saved('t1'));
    });

    test('an unchanged edit closes without asking', () async {
      // Arrange
      when(() => get('t1')).thenAnswer((_) async => Right(original));
      final bloc = await started(const TransactionFormMode.edit('t1'));

      // Act
      await send(
        bloc,
        const TransactionFormEvent.closeRequested(note: 'Makan siang'),
      );

      // Assert
      expect(bloc.state.outcome, const TransactionFormOutcome.closed());
    });

    test('delete deletes it and closes', () async {
      // Arrange
      when(() => get('t1')).thenAnswer((_) async => Right(original));
      when(() => delete('t1')).thenAnswer((_) async => Right(original));
      final bloc = await started(const TransactionFormMode.edit('t1'));

      // Act
      await send(bloc, const TransactionFormEvent.deleteRequested());

      // Assert
      expect(bloc.state.outcome, const TransactionFormOutcome.deleted('t1'));
    });

    test('a failed load is an error, and retry loads again', () async {
      // Arrange
      when(() => get('t1')).thenAnswer(
        (_) async => const Left<Failure, Transaction>(Failure.network()),
      );
      final bloc = await started(const TransactionFormMode.edit('t1'));

      // Act
      await send(bloc, const TransactionFormEvent.retried());

      // Assert
      expect(bloc.state.status, UiStatus.failure);
      expect(bloc.state.loadFailure, TransactionFailure.network);
      verify(() => get('t1')).called(2);
    });
  });
}
