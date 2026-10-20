import 'package:flutter_test/flutter_test.dart';
import 'package:fpdart/fpdart.dart';
import 'package:mocktail/mocktail.dart';
import 'package:monai/core/error/failure.dart';
import 'package:monai/core/model/transaction_type.dart';
import 'package:monai/core/usecase/usecase.dart';
import 'package:monai/features/quickadd/domain/entity/quick_add_reading.dart';
import 'package:monai/features/quickadd/domain/parser/quick_add_parser.dart';
import 'package:monai/features/quickadd/domain/usecase/complete_drafts_with_ai_usecase.dart';
import 'package:monai/features/quickadd/domain/usecase/read_quick_add_phrase_usecase.dart';
import 'package:monai/features/quickadd/domain/usecase/watch_quick_add_context_usecase.dart';
import 'package:monai/features/quickadd/presentation/model/quick_add_review_args.dart';
import 'package:monai/features/quickadd/presentation/pages/quick_add/bloc/quick_add_bloc.dart';
import 'package:monai/features/shared/domain/entity/draft_confidence.dart';
import 'package:monai/features/shared/domain/entity/quick_add_draft.dart';

import '../../../../../../helpers/entity_fixtures.dart';

class _MockWatchContext extends Mock implements WatchQuickAddContextUseCase {}

class _MockRead extends Mock implements ReadQuickAddPhraseUseCase {}

class _MockComplete extends Mock implements CompleteDraftsWithAiUseCase {}

final _today = DateTime(2026, 10, 10);
final _context = ParseContext(
  wallets: [wallet(isDefault: true)],
  categories: [category()],
  providers: const [],
  today: _today,
);

QuickAddDraft _draft({int? amount = 35000, double amountConfidence = 0.95}) =>
    QuickAddDraft(
      type: TransactionType.expense,
      date: _today,
      amount: amount,
      walletId: 'w1',
      categoryId: 'c1',
      confidence: DraftConfidence(amount: amountConfidence, category: 0.85),
    );

void main() {
  late _MockWatchContext watchContext;
  late _MockRead read;
  late _MockComplete complete;

  setUpAll(() {
    registerFallbackValue(const NoParams());
    registerFallbackValue(
      ReadQuickAddPhraseParams(text: '', context: _context),
    );
    registerFallbackValue(
      CompleteDraftsParams(text: '', local: const [], context: _context),
    );
  });

  setUp(() {
    watchContext = _MockWatchContext();
    read = _MockRead();
    complete = _MockComplete();
    when(() => watchContext(any()))
        .thenAnswer((_) => Stream.value(Right(_context)));
  });

  Future<QuickAddBloc> started() async {
    final bloc = QuickAddBloc(
      watchContext: watchContext,
      read: read,
      complete: complete,
    )..add(const QuickAddEvent.started());
    await Future<void>.delayed(Duration.zero);
    addTearDown(bloc.close);
    return bloc;
  }

  Future<void> send(QuickAddBloc bloc, QuickAddEvent event) async {
    bloc.add(event);
    await Future<void>.delayed(Duration.zero);
    await Future<void>.delayed(Duration.zero);
  }

  void stubRead(List<QuickAddDraft> drafts) =>
      when(() => read(any())).thenAnswer((_) async => Right(drafts));

  test('typing reads the phrase on the phone', () async {
    // Arrange
    stubRead([_draft()]);
    final bloc = await started();

    // Act
    await send(bloc, const QuickAddEvent.textChanged('kopi 35rb '));

    // Assert
    expect(bloc.state.phrase, 'kopi 35rb');
    expect(bloc.state.drafts, [_draft()]);
    expect(bloc.state.engine, DraftEngine.local);
  });

  test('continuing with one sure draft opens the form', () async {
    // Arrange
    stubRead([_draft()]);
    final bloc = await started();
    await send(bloc, const QuickAddEvent.textChanged('kopi 35rb'));
    final navigations = <QuickAddNavigation>[];
    bloc.stream.listen((s) {
      if (s.navigation case final navigation?) navigations.add(navigation);
    });

    // Act
    await send(bloc, const QuickAddEvent.continueRequested('kopi 35rb'));

    // Assert
    expect(navigations, [QuickAddNavigation.form(_draft())]);
    expect(bloc.state.navigation, isNull);
    verifyNever(() => complete(any()));
  });

  test('continuing with several drafts opens the review', () async {
    // Arrange
    final drafts = [_draft(), _draft(amount: 5000)];
    stubRead(drafts);
    final bloc = await started();
    await send(bloc, const QuickAddEvent.textChanged('kopi 35rb parkir 5rb'));
    final navigations = <QuickAddNavigation>[];
    bloc.stream.listen((s) {
      if (s.navigation case final navigation?) navigations.add(navigation);
    });

    // Act
    await send(bloc, const QuickAddEvent.continueRequested(''));

    // Assert
    expect(navigations, [
      QuickAddNavigation.review(
        QuickAddReviewArgs(phrase: 'kopi 35rb parkir 5rb', drafts: drafts),
      ),
    ]);
  });

  test('an unsure reading asks the AI first and shows its drafts', () async {
    // Arrange
    stubRead([_draft(amount: null, amountConfidence: 0)]);
    final aiDraft = _draft(amount: 50000, amountConfidence: 0.9);
    when(() => complete(any())).thenAnswer(
      (_) async =>
          Right(QuickAddReading(drafts: [aiDraft], engine: DraftEngine.ai)),
    );
    final bloc = await started();
    await send(bloc, const QuickAddEvent.textChanged('bayar arisan'));

    // Act
    await send(bloc, const QuickAddEvent.continueRequested('bayar arisan'));

    // Assert
    expect(bloc.state.drafts, [aiDraft]);
    expect(bloc.state.engine, DraftEngine.ai);
    expect(bloc.state.isAsking, isFalse);
    expect(bloc.state.navigation, isNull);
  });

  test('a fallback reading keeps why, and the next tap goes on', () async {
    // Arrange
    final local = [_draft(amount: null, amountConfidence: 0)];
    stubRead(local);
    when(() => complete(any())).thenAnswer(
      (_) async => Right(
        QuickAddReading(
          drafts: local,
          engine: DraftEngine.fallback,
          aiFailure: QuickAddAiFailure.rateLimited,
        ),
      ),
    );
    final bloc = await started();
    await send(bloc, const QuickAddEvent.textChanged('bayar arisan'));
    await send(bloc, const QuickAddEvent.continueRequested('bayar arisan'));
    final navigations = <QuickAddNavigation>[];
    bloc.stream.listen((s) {
      if (s.navigation case final navigation?) navigations.add(navigation);
    });

    // Act
    await send(bloc, const QuickAddEvent.continueRequested('bayar arisan'));

    // Assert
    expect(bloc.state.aiFailure, QuickAddAiFailure.rateLimited);
    expect(navigations, [QuickAddNavigation.form(local.single)]);
    verify(() => complete(any())).called(1);
  });

  test('typing after the AI read the phrase reads it locally again', () async {
    // Arrange
    stubRead([_draft(amount: null, amountConfidence: 0)]);
    when(() => complete(any())).thenAnswer(
      (_) async =>
          Right(QuickAddReading(drafts: [_draft()], engine: DraftEngine.ai)),
    );
    final bloc = await started();
    await send(bloc, const QuickAddEvent.textChanged('arisan'));
    await send(bloc, const QuickAddEvent.continueRequested('arisan'));

    // Act
    await send(bloc, const QuickAddEvent.textChanged('arisan tante'));

    // Assert
    expect(bloc.state.engine, DraftEngine.local);
    expect(bloc.state.phrase, 'arisan tante');
  });

  test('nothing to continue with does nothing', () async {
    // Arrange
    stubRead(const []);
    final bloc = await started();
    await send(bloc, const QuickAddEvent.textChanged('   '));

    // Act
    await send(bloc, const QuickAddEvent.continueRequested('   '));

    // Assert
    expect(bloc.state.canContinue, isFalse);
    verifyNever(() => complete(any()));
  });

  test('a failed context read leaves the phrase unread', () async {
    // Arrange
    when(() => watchContext(any()))
        .thenAnswer((_) => Stream.value(const Left(Failure.cache())));
    stubRead([_draft()]);
    final bloc = await started();

    // Act
    await send(bloc, const QuickAddEvent.textChanged('kopi 35rb'));

    // Assert
    expect(bloc.state.drafts, isEmpty);
    verifyNever(() => read(any()));
  });
}
