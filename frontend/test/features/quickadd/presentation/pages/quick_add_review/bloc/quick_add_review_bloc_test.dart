import 'package:flutter_test/flutter_test.dart';
import 'package:fpdart/fpdart.dart';
import 'package:mocktail/mocktail.dart';
import 'package:monai/core/ui/designsystem/components/monai_marked_field.dart';
import 'package:monai/core/base/error/failure.dart';
import 'package:monai/core/base/error/field_error.dart';
import 'package:monai/core/model/transaction_type.dart';
import 'package:monai/core/base/usecase.dart';
import 'package:monai/features/quickadd/domain/usecase/save_quick_add_draft_usecase.dart';
import 'package:monai/features/quickadd/presentation/model/quick_add_field.dart';
import 'package:monai/features/quickadd/presentation/model/quick_add_review_args.dart';
import 'package:monai/features/quickadd/presentation/model/quick_add_save_failure.dart';
import 'package:monai/features/quickadd/presentation/pages/quick_add_review/bloc/quick_add_review_bloc.dart';
import 'package:monai/features/shared/domain/entity/draft_confidence.dart';
import 'package:monai/features/shared/domain/entity/quick_add_draft.dart';
import 'package:monai/features/shared/domain/entity/transaction_input.dart';
import 'package:monai/features/shared/domain/usecase/watch_categories_usecase.dart';
import 'package:monai/features/shared/domain/usecase/watch_wallets_usecase.dart';
import 'package:monai/features/shared/domain/validation/transaction_input_validator.dart';

import '../../../../../../helpers/entity_fixtures.dart';

class _MockSave extends Mock implements SaveQuickAddDraftUseCase {}

class _MockWatchWallets extends Mock implements WatchWalletsUseCase {}

class _MockWatchCategories extends Mock implements WatchCategoriesUseCase {}

final _today = DateTime(2026, 10, 10);

final _coffee = QuickAddDraft(
  type: TransactionType.expense,
  date: DateTime(2026, 10, 9),
  amount: 25000,
  walletId: 'w1',
  categoryId: 'food',
  note: 'Kopi',
  confidence: const DraftConfidence(
    amount: 0.95,
    wallet: 0.5,
    category: 0.85,
    date: 0.95,
  ),
);

final _parking = QuickAddDraft(
  type: TransactionType.expense,
  date: DateTime(2026, 10, 9),
  amount: 5000,
  walletId: 'w1',
  categoryId: 'transport',
  note: 'Parkir',
  confidence: const DraftConfidence(amount: 0.95, category: 0.85),
);

void main() {
  late _MockSave save;
  late _MockWatchWallets watchWallets;
  late _MockWatchCategories watchCategories;

  setUpAll(() {
    registerFallbackValue(const NoParams());
    registerFallbackValue(
      TransactionInput(
        type: TransactionType.expense,
        amount: 1,
        date: DateTime(2026),
      ),
    );
  });

  setUp(() {
    save = _MockSave();
    watchWallets = _MockWatchWallets();
    watchCategories = _MockWatchCategories();
    when(() => watchWallets(any()))
        .thenAnswer((_) => Stream.value(Right([wallet(isDefault: true)])));
    when(() => watchCategories(any())).thenAnswer(
      (_) => Stream.value(
        Right([
          category(id: 'food'),
          category(id: 'transport', name: 'Transport'),
        ]),
      ),
    );
  });

  Future<QuickAddReviewBloc> started() async {
    final bloc = QuickAddReviewBloc(
      args: QuickAddReviewArgs(
        phrase: 'kopi 25rb parkir 5rb kmrn',
        drafts: [_coffee, _parking],
      ),
      save: save,
      watchWallets: watchWallets,
      watchCategories: watchCategories,
      now: () => DateTime(2026, 10, 10, 15),
    )..add(const QuickAddReviewEvent.started());
    await Future<void>.delayed(Duration.zero);
    addTearDown(bloc.close);
    return bloc;
  }

  Future<void> send(QuickAddReviewBloc bloc, QuickAddReviewEvent event) {
    bloc.add(event);
    return Future<void>.delayed(Duration.zero);
  }

  test('starts on the first draft with its fields marked', () async {
    // Act
    final bloc = await started();

    // Assert
    expect(bloc.state.index, 0);
    expect(bloc.state.today, _today);
    expect(bloc.state.current, _coffee);
    expect(bloc.state.marks, {
      QuickAddField.amount: MonAIFieldMark.ai,
      QuickAddField.category: MonAIFieldMark.ai,
      QuickAddField.wallet: MonAIFieldMark.check,
      QuickAddField.date: MonAIFieldMark.ai,
    });
  });

  test('picking a wallet clears its mark', () async {
    // Arrange
    final bloc = await started();

    // Act
    await send(bloc, const QuickAddReviewEvent.walletPicked('w2'));

    // Assert
    expect(bloc.state.current.walletId, 'w2');
    expect(bloc.state.markOf(QuickAddField.wallet), isNull);
  });

  test(
    'saves the draft with the typed amount and note, then the next',
    () async {
      // Arrange
      when(() => save(any()))
          .thenAnswer((_) async => Right(transaction(id: 't1')));
      final bloc = await started();

      // Act
      await send(
        bloc,
        const QuickAddReviewEvent.saveRequested(amount: '27.000', note: 'Kopi'),
      );

      // Assert
      final input =
          verify(() => save(captureAny())).captured.single as TransactionInput;
      expect(input.amount, 27000);
      expect(input.note, 'Kopi');
      expect(input.walletId, 'w1');
      expect(input.categoryId, 'food');
      expect(input.date, DateTime(2026, 10, 9));
      expect(bloc.state.index, 1);
      expect(bloc.state.current, _parking);
      expect(bloc.state.results, [
        QuickAddReviewResult.saved(transaction(id: 't1')),
      ]);
    },
  );

  test('skipping the last draft finishes with a summary', () async {
    // Arrange
    when(() => save(any()))
        .thenAnswer((_) async => Right(transaction(id: 't1')));
    final bloc = await started();
    await send(
      bloc,
      const QuickAddReviewEvent.saveRequested(amount: '25.000', note: 'Kopi'),
    );

    // Act
    await send(bloc, const QuickAddReviewEvent.skipRequested());

    // Assert
    expect(bloc.state.isDone, isTrue);
    expect(bloc.state.savedCount, 1);
    expect(bloc.state.results.last, const QuickAddReviewResult.skipped());
  });

  test('a rejected save shows the errors and stays on the draft', () async {
    // Arrange
    when(() => save(any())).thenAnswer(
      (_) async => const Left(
        Failure.validation([
          FieldError(
            field: TransactionInputValidator.amountField,
            code: 'min',
            message: 'must be greater than 0',
          ),
        ]),
      ),
    );
    final bloc = await started();

    // Act
    await send(
      bloc,
      const QuickAddReviewEvent.saveRequested(amount: '', note: ''),
    );

    // Assert
    expect(bloc.state.index, 0);
    expect(bloc.state.autovalidate, isTrue);
    expect(bloc.state.errorOf(QuickAddField.amount)?.code, 'min');
  });

  test('a fixed amount clears its error once a save failed', () async {
    // Arrange
    when(() => save(any())).thenAnswer(
      (_) async => const Left(
        Failure.validation([
          FieldError(
            field: TransactionInputValidator.amountField,
            code: 'min',
            message: 'must be greater than 0',
          ),
        ]),
      ),
    );
    final bloc = await started();
    await send(
      bloc,
      const QuickAddReviewEvent.saveRequested(amount: '', note: ''),
    );

    // Act
    await send(bloc, const QuickAddReviewEvent.amountEdited('5.000'));

    // Assert
    expect(bloc.state.errorOf(QuickAddField.amount), isNull);
  });

  test('another failed save says why once', () async {
    // Arrange
    when(() => save(any()))
        .thenAnswer((_) async => const Left(Failure.network()));
    final bloc = await started();
    final failures = <QuickAddSaveFailure>[];
    bloc.stream.listen((s) {
      if (s.actionFailure case final failure?) failures.add(failure);
    });

    // Act
    await send(
      bloc,
      const QuickAddReviewEvent.saveRequested(amount: '25.000', note: ''),
    );

    // Assert
    expect(failures, [QuickAddSaveFailure.network]);
    expect(bloc.state.actionFailure, isNull);
    expect(bloc.state.isSaving, isFalse);
    expect(bloc.state.index, 0);
  });

  test('a future date cannot be picked', () async {
    // Arrange
    final bloc = await started();

    // Act
    await send(bloc, QuickAddReviewEvent.datePicked(DateTime(2026, 10, 11)));

    // Assert
    expect(bloc.state.current.date, DateTime(2026, 10, 9));
  });
}
