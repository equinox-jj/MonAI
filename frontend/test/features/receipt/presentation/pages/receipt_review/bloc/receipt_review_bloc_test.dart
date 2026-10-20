import 'dart:async';

import 'package:flutter_test/flutter_test.dart';
import 'package:fpdart/fpdart.dart';
import 'package:mocktail/mocktail.dart';
import 'package:monai/core/error/failure.dart';
import 'package:monai/core/error/field_error.dart';
import 'package:monai/core/model/category_type.dart';
import 'package:monai/core/model/transaction_source.dart';
import 'package:monai/core/model/transaction_type.dart';
import 'package:monai/core/usecase/usecase.dart';
import 'package:monai/features/receipt/domain/entity/receipt_draft.dart';
import 'package:monai/features/receipt/domain/usecase/create_receipt_transaction_usecase.dart';
import 'package:monai/features/receipt/domain/usecase/parse_receipt_usecase.dart';
import 'package:monai/features/receipt/presentation/model/receipt_ai_failure.dart';
import 'package:monai/features/receipt/presentation/model/receipt_failure.dart';
import 'package:monai/features/receipt/presentation/model/receipt_review_args.dart';
import 'package:monai/features/receipt/presentation/pages/receipt_review/bloc/receipt_review_bloc.dart';
import 'package:monai/features/receipt/presentation/pages/receipt_review/model/receipt_field.dart';
import 'package:monai/features/shared/domain/entity/transaction_input.dart';
import 'package:monai/features/shared/domain/usecase/watch_categories_usecase.dart';
import 'package:monai/features/shared/domain/usecase/watch_wallets_usecase.dart';
import 'package:monai/features/shared/domain/validation/transaction_input_validator.dart';

import '../../../../../../helpers/entity_fixtures.dart';

class _MockSave extends Mock implements CreateReceiptTransactionUseCase {}

class _MockParse extends Mock implements ParseReceiptUseCase {}

class _MockWatchWallets extends Mock implements WatchWalletsUseCase {}

class _MockWatchCategories extends Mock implements WatchCategoriesUseCase {}

void main() {
  late _MockSave save;
  late _MockParse parse;
  late _MockWatchWallets watchWallets;
  late _MockWatchCategories watchCategories;

  final wallets = [
    wallet(id: 'w1', name: 'Cash'),
    wallet(id: 'w2', name: 'BCA', isDefault: true),
  ];
  final categories = [
    category(id: 'c1', name: 'Shopping'),
    category(id: 'c2', name: 'Salary', type: CategoryType.income),
    category(id: 'c3', name: 'Old', isHidden: true),
  ];

  final draft = ReceiptDraft(
    type: TransactionType.expense,
    amount: 187500,
    categoryId: 'c1',
    date: DateTime(2026, 10, 9),
    merchant: 'Toko Sumber Rejeki',
    confidence: const DraftConfidence(
      type: 0.9,
      amount: 0.95,
      category: 0.7,
      date: 0.4,
    ),
    items: const [
      ReceiptItem(name: 'Beras 5 kg', amount: 74000),
      ReceiptItem(name: 'Minyak goreng 2 L', amount: 38500),
      ReceiptItem(name: 'Kantong'),
    ],
  );

  setUpAll(() {
    registerFallbackValue(const NoParams());
    registerFallbackValue(
      CreateReceiptTransactionParams(
        input: TransactionInput(
          type: TransactionType.expense,
          amount: 1,
          date: DateTime(2026),
        ),
        photoPath: '',
      ),
    );
  });

  setUp(() {
    save = _MockSave();
    parse = _MockParse();
    watchWallets = _MockWatchWallets();
    watchCategories = _MockWatchCategories();
    when(() => watchWallets(any()))
        .thenAnswer((_) => Stream.value(Right(wallets)));
    when(() => watchCategories(any()))
        .thenAnswer((_) => Stream.value(Right(categories)));
  });

  Future<ReceiptReviewBloc> started({
    ReceiptDraft? receipt,
    ReceiptAiFailure? aiFailure,
  }) async {
    final bloc = ReceiptReviewBloc(
      args: ReceiptReviewArgs(
        photoPath: '/tmp/receipt.jpg',
        ocrText: 'TOTAL 187.500',
        draft: receipt ?? draft,
        aiFailure: aiFailure,
      ),
      save: save,
      parse: parse,
      watchWallets: watchWallets,
      watchCategories: watchCategories,
      now: () => DateTime(2026, 10, 10, 15),
    )..add(const ReceiptReviewEvent.started());
    await Future<void>.delayed(Duration.zero);
    addTearDown(bloc.close);
    return bloc;
  }

  Future<void> send(ReceiptReviewBloc bloc, ReceiptReviewEvent event) {
    bloc.add(event);
    return Future<void>.delayed(Duration.zero);
  }

  group('starts from the draft', () {
    test('with its type, category and date', () async {
      // Arrange
      // (the draft above)

      // Act
      final bloc = await started();

      // Assert
      expect(bloc.state.type, TransactionType.expense);
      expect(bloc.state.categoryId, 'c1');
      expect(bloc.state.date, DateTime(2026, 10, 9));
      expect(bloc.state.today, DateTime(2026, 10, 10));
    });

    test('marks sure fields as AI and unsure ones for checking', () async {
      // Arrange
      // (amount 0.95, category exactly 0.7, date 0.4, merchant filled)

      // Act
      final bloc = await started();

      // Assert
      expect(bloc.state.marks, {
        ReceiptField.amount: FieldMark.ai,
        ReceiptField.merchant: FieldMark.ai,
        ReceiptField.category: FieldMark.ai,
        ReceiptField.date: FieldMark.check,
      });
    });

    test('uses the default wallet, unmarked, when none was read', () async {
      // Arrange
      // (the draft names no wallet)

      // Act
      final bloc = await started();

      // Assert
      expect(bloc.state.walletId, 'w2');
      expect(bloc.state.marks.containsKey(ReceiptField.wallet), isFalse);
    });

    test('keeps and marks a wallet the AI read', () async {
      // Arrange
      final receipt = draft.copyWith(
        walletId: 'w1',
        confidence: draft.confidence.copyWith(wallet: 0.3),
      );

      // Act
      final bloc = await started(receipt: receipt);

      // Assert
      expect(bloc.state.walletId, 'w1');
      expect(bloc.state.marks[ReceiptField.wallet], FieldMark.check);
    });

    test('a date after today becomes today, marked for checking', () async {
      // Arrange
      final receipt = draft.copyWith(
        date: DateTime(2026, 12, 1),
        confidence: draft.confidence.copyWith(date: 0.99),
      );

      // Act
      final bloc = await started(receipt: receipt);

      // Assert
      expect(bloc.state.date, DateTime(2026, 10, 10));
      expect(bloc.state.marks[ReceiptField.date], FieldMark.check);
    });

    test('a missing date is today, unmarked', () async {
      // Arrange
      final receipt = draft.copyWith(date: null);

      // Act
      final bloc = await started(receipt: receipt);

      // Assert
      expect(bloc.state.date, DateTime(2026, 10, 10));
      expect(bloc.state.marks.containsKey(ReceiptField.date), isFalse);
    });

    test('an income stays an income; anything else is an expense', () async {
      // Arrange
      final income = draft.copyWith(type: TransactionType.income);
      final none = draft.copyWith(type: null);

      // Act
      final incomeBloc = await started(receipt: income);
      final noneBloc = await started(receipt: none);

      // Assert
      expect(incomeBloc.state.type, TransactionType.income);
      expect(noneBloc.state.type, TransactionType.expense);
    });

    test('marks nothing when the AI failed', () async {
      // Arrange
      // (an empty draft)

      // Act
      final bloc = await started(
        receipt: ReceiptDraft.empty,
        aiFailure: ReceiptAiFailure.busy,
      );

      // Assert
      expect(bloc.state.aiFailed, isTrue);
      expect(bloc.state.marks, isEmpty);
      expect(bloc.state.categoryId, isNull);
      expect(bloc.state.walletId, 'w2');
    });

    test('lists the visible categories of its type', () async {
      // Arrange
      // (Shopping, Salary (income), Old (hidden))

      // Act
      final bloc = await started();

      // Assert
      expect(bloc.state.categories.map((c) => c.id), ['c1']);
      expect(bloc.state.wallets, wallets);
    });

    test('totals the items with an amount', () async {
      // Arrange
      // (74.000 + 38.500 + an item without one)

      // Act
      final bloc = await started();

      // Assert
      expect(bloc.state.items, hasLength(3));
      expect(bloc.state.itemsTotal, 112500);
    });
  });

  group('editing', () {
    test('switching the type clears the category and its mark', () async {
      // Arrange
      final bloc = await started();

      // Act
      await send(
        bloc,
        const ReceiptReviewEvent.typeSelected(TransactionType.income),
      );

      // Assert
      expect(bloc.state.type, TransactionType.income);
      expect(bloc.state.categoryId, isNull);
      expect(bloc.state.marks.containsKey(ReceiptField.category), isFalse);
      expect(bloc.state.categories.map((c) => c.id), ['c2']);
    });

    test('a transfer cannot be selected', () async {
      // Arrange
      final bloc = await started();

      // Act
      await send(
        bloc,
        const ReceiptReviewEvent.typeSelected(TransactionType.transfer),
      );

      // Assert
      expect(bloc.state.type, TransactionType.expense);
    });

    test('a picked category, wallet or date loses its mark', () async {
      // Arrange
      final bloc = await started(
        receipt: draft.copyWith(
          walletId: 'w1',
          confidence: draft.confidence.copyWith(wallet: 0.9),
        ),
      );

      // Act
      await send(bloc, const ReceiptReviewEvent.categoryPicked('c1'));
      await send(bloc, const ReceiptReviewEvent.walletPicked('w2'));
      await send(bloc, ReceiptReviewEvent.datePicked(DateTime(2026, 10, 8)));

      // Assert
      expect(bloc.state.walletId, 'w2');
      expect(bloc.state.date, DateTime(2026, 10, 8));
      expect(bloc.state.marks, {
        ReceiptField.amount: FieldMark.ai,
        ReceiptField.merchant: FieldMark.ai,
      });
    });

    test('a date after today cannot be picked', () async {
      // Arrange
      final bloc = await started();

      // Act
      await send(bloc, ReceiptReviewEvent.datePicked(DateTime(2026, 10, 11)));

      // Assert
      expect(bloc.state.date, DateTime(2026, 10, 9));
    });

    test('typing in the amount or merchant removes its mark', () async {
      // Arrange
      final bloc = await started();

      // Act
      await send(bloc, const ReceiptReviewEvent.amountEdited('190.000'));
      await send(bloc, const ReceiptReviewEvent.merchantEdited('Toko'));

      // Assert
      expect(bloc.state.marks.containsKey(ReceiptField.amount), isFalse);
      expect(bloc.state.marks.containsKey(ReceiptField.merchant), isFalse);
    });
  });

  group('trying the AI again', () {
    Future<ReceiptReviewBloc> failed() =>
        started(receipt: ReceiptDraft.empty, aiFailure: ReceiptAiFailure.busy);

    test('sends the same text and fills the draft in', () async {
      // Arrange
      when(() => parse(any())).thenAnswer((_) async => Right(draft));
      final bloc = await failed();

      // Act
      await send(bloc, const ReceiptReviewEvent.retryRequested());

      // Assert
      verify(() => parse('TOTAL 187.500')).called(1);
      expect(bloc.state.aiFailure, isNull);
      expect(bloc.state.isRetrying, isFalse);
      expect(bloc.state.draft, draft);
      expect(bloc.state.draftVersion, 1);
      expect(bloc.state.categoryId, 'c1');
      expect(bloc.state.date, DateTime(2026, 10, 9));
      expect(bloc.state.walletId, 'w2');
      expect(bloc.state.itemsTotal, 112500);
      expect(bloc.state.marks[ReceiptField.amount], FieldMark.ai);
      expect(bloc.state.marks[ReceiptField.date], FieldMark.check);
    });

    test('shows that it is waiting for the AI', () async {
      // Arrange
      final reply = Completer<Either<Failure, ReceiptDraft>>();
      when(() => parse(any())).thenAnswer((_) => reply.future);
      final bloc = await failed();

      // Act
      await send(bloc, const ReceiptReviewEvent.retryRequested());
      final waiting = bloc.state.isRetrying;
      await send(bloc, const ReceiptReviewEvent.retryRequested());
      reply.complete(Right(draft));
      await Future<void>.delayed(Duration.zero);

      // Assert
      expect(waiting, isTrue);
      verify(() => parse(any())).called(1);
    });

    test('another failure keeps the fields empty and says so once', () async {
      // Arrange
      when(() => parse(any()))
          .thenAnswer((_) async => const Left(Failure.network()));
      final bloc = await failed();
      final reported = <ReceiptAiFailure?>[];
      final sub = bloc.stream.listen((s) => reported.add(s.retryFailure));
      addTearDown(sub.cancel);

      // Act
      await send(bloc, const ReceiptReviewEvent.retryRequested());

      // Assert
      expect(reported, contains(ReceiptAiFailure.offline));
      expect(bloc.state.retryFailure, isNull);
      expect(bloc.state.aiFailure, ReceiptAiFailure.offline);
      expect(bloc.state.draftVersion, 0);
      expect(bloc.state.isRetrying, isFalse);
    });

    test('does nothing once the AI has read the receipt', () async {
      // Arrange
      final bloc = await started();

      // Act
      await send(bloc, const ReceiptReviewEvent.retryRequested());

      // Assert
      verifyNever(() => parse(any()));
    });
  });

  group('saving', () {
    test('saves the receipt with its photo', () async {
      // Arrange
      when(() => save(any()))
          .thenAnswer((_) async => Right(transaction(id: 't9')));
      final bloc = await started();

      // Act
      await send(
        bloc,
        const ReceiptReviewEvent.saveRequested(
          amount: '187.500',
          merchant: ' Toko Sumber Rejeki ',
          note: 'Belanja bulanan',
        ),
      );

      // Assert
      final params =
          verify(() => save(captureAny())).captured.single
              as CreateReceiptTransactionParams;
      expect(params.photoPath, '/tmp/receipt.jpg');
      expect(
        params.input,
        TransactionInput(
          type: TransactionType.expense,
          amount: 187500,
          date: DateTime(2026, 10, 9),
          walletId: 'w2',
          categoryId: 'c1',
          merchant: ' Toko Sumber Rejeki ',
          note: 'Belanja bulanan',
          source: TransactionSource.receipt,
        ),
      );
      expect(bloc.state.savedId, 't9');
      expect(bloc.state.isSaving, isFalse);
    });

    test('shows the field errors of an invalid save', () async {
      // Arrange
      const amountError = FieldError(
        field: TransactionInputValidator.amountField,
        code: 'required',
        message: 'required',
      );
      when(
        () => save(any()),
      ).thenAnswer((_) async => const Left(Failure.validation([amountError])));
      final bloc = await started();

      // Act
      await send(
        bloc,
        const ReceiptReviewEvent.saveRequested(
          amount: '',
          merchant: '',
          note: '',
        ),
      );

      // Assert
      expect(bloc.state.errors, {
        TransactionInputValidator.amountField: amountError,
      });
      expect(bloc.state.savedId, isNull);
    });

    test('after a failed save, a fixed amount clears its error', () async {
      // Arrange
      const amountError = FieldError(
        field: TransactionInputValidator.amountField,
        code: 'required',
        message: 'required',
      );
      when(
        () => save(any()),
      ).thenAnswer((_) async => const Left(Failure.validation([amountError])));
      final bloc = await started();
      await send(
        bloc,
        const ReceiptReviewEvent.saveRequested(
          amount: '',
          merchant: '',
          note: '',
        ),
      );

      // Act
      await send(bloc, const ReceiptReviewEvent.amountEdited('5.000'));

      // Assert
      expect(bloc.state.errors, isEmpty);
    });

    test('reports any other failure once', () async {
      // Arrange
      when(() => save(any()))
          .thenAnswer((_) async => const Left(Failure.network()));
      final bloc = await started();
      final failures = <ReceiptFailure?>[];
      final sub = bloc.stream.listen((s) => failures.add(s.actionFailure));
      addTearDown(sub.cancel);

      // Act
      await send(
        bloc,
        const ReceiptReviewEvent.saveRequested(
          amount: '187.500',
          merchant: '',
          note: '',
        ),
      );

      // Assert
      expect(failures, contains(ReceiptFailure.network));
      expect(bloc.state.actionFailure, isNull);
      expect(bloc.state.isSaving, isFalse);
    });

    test('a second save while saving does nothing', () async {
      // Arrange
      when(() => save(any())).thenAnswer((_) async {
        await Future<void>.delayed(const Duration(milliseconds: 10));
        return Right(transaction(id: 't9'));
      });
      final bloc = await started();
      const event = ReceiptReviewEvent.saveRequested(
        amount: '187.500',
        merchant: '',
        note: '',
      );

      // Act
      bloc
        ..add(event)
        ..add(event);
      await Future<void>.delayed(const Duration(milliseconds: 30));

      // Assert
      verify(() => save(any())).called(1);
    });
  });
}
