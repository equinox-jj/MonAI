import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:fpdart/fpdart.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/date_symbol_data_local.dart';
import 'package:mocktail/mocktail.dart';
import 'package:monai/core/designsystem/designsystem.dart';
import 'package:monai/core/error/failure.dart';
import 'package:monai/core/l10n/l10n.dart';
import 'package:monai/core/model/transaction_type.dart';
import 'package:monai/core/usecase/usecase.dart';
import 'package:monai/features/receipt/domain/entity/receipt_draft.dart';
import 'package:monai/features/receipt/domain/usecase/create_receipt_transaction_usecase.dart';
import 'package:monai/features/receipt/domain/usecase/parse_receipt_usecase.dart';
import 'package:monai/features/receipt/presentation/model/receipt_ai_failure.dart';
import 'package:monai/features/receipt/presentation/model/receipt_review_args.dart';
import 'package:monai/features/receipt/presentation/pages/receipt_review/bloc/receipt_review_bloc.dart';
import 'package:monai/features/receipt/presentation/pages/receipt_review/receipt_review_page.dart';
import 'package:monai/features/receipt/presentation/pages/receipt_review/widgets/receipt_review_photo.dart';
import 'package:monai/features/shared/domain/entity/transaction_input.dart';
import 'package:monai/features/shared/domain/usecase/watch_categories_usecase.dart';
import 'package:monai/features/shared/domain/usecase/watch_wallets_usecase.dart';

import '../../../../../helpers/entity_fixtures.dart';

class _MockSave extends Mock implements CreateReceiptTransactionUseCase {}

class _MockParse extends Mock implements ParseReceiptUseCase {}

class _MockWatchWallets extends Mock implements WatchWalletsUseCase {}

class _MockWatchCategories extends Mock implements WatchCategoriesUseCase {}

void main() {
  late _MockSave save;
  late _MockParse parse;

  final draft = ReceiptDraft(
    type: TransactionType.expense,
    amount: 187500,
    categoryId: 'c1',
    date: DateTime(2026, 10, 9),
    merchant: 'Toko Sumber Rejeki',
    confidence: const DraftConfidence(amount: 0.95, category: 0.9, date: 0.3),
    items: const [
      ReceiptItem(name: 'Beras 5 kg', amount: 74000),
      ReceiptItem(name: 'Telur 1 kg', amount: 29000),
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
    return initializeDateFormatting();
  });

  setUp(() {
    save = _MockSave();
    parse = _MockParse();
  });

  /// The AI sparkles shown, one per field it filled plus the banner's.
  final sparkles = find.byWidgetPredicate(
    (w) => w is MonAIIcon && w.icon == MonAIIcons.autoAwesome,
  );

  Future<void> openReview(
    WidgetTester tester, {
    ReceiptDraft? receipt,
    ReceiptAiFailure? aiFailure,
    Size size = const Size(390, 1100),
  }) async {
    tester.view
      ..physicalSize = size
      ..devicePixelRatio = 1;
    addTearDown(tester.view.reset);
    final watchWallets = _MockWatchWallets();
    final watchCategories = _MockWatchCategories();
    when(() => watchWallets(any())).thenAnswer(
      (_) => Stream.value(Right([wallet(name: 'BCA', isDefault: true)])),
    );
    when(() => watchCategories(any()))
        .thenAnswer((_) => Stream.value(Right([category(name: 'Shopping')])));
    final args = ReceiptReviewArgs(
      photoPath: '/tmp/missing.jpg',
      ocrText: 'TOTAL 187.500',
      draft: receipt ?? draft,
      aiFailure: aiFailure,
    );
    final bloc = ReceiptReviewBloc(
      args: args,
      save: save,
      parse: parse,
      watchWallets: watchWallets,
      watchCategories: watchCategories,
      now: () => DateTime(2026, 10, 10, 15),
    )..add(const ReceiptReviewEvent.started());
    addTearDown(bloc.close);
    final router = GoRouter(
      routes: [
        GoRoute(
          path: '/',
          builder: (_, _) => BlocProvider.value(
            value: bloc,
            child: ReceiptReviewUI(args: args),
          ),
        ),
        GoRoute(
          path: '/transactions/:id',
          builder: (_, state) => Text('detail ${state.pathParameters['id']}'),
        ),
      ],
    );
    addTearDown(router.dispose);
    await tester.pumpWidget(
      MaterialApp.router(
        routerConfig: router,
        localizationsDelegates: AppLocalizations.localizationsDelegates,
        supportedLocales: AppLocalizations.supportedLocales,
        locale: const Locale('en'),
        theme: MonAITheme.light(),
      ),
    );
    await tester.pumpAndSettle();
  }

  testWidgets('shows the draft with what the AI filled', (tester) async {
    // Arrange
    // (amount and category sure, date unsure, merchant read)

    // Act
    await openReview(tester);

    // Assert
    expect(find.text('Review draft'), findsOneWidget);
    expect(find.text('187.500'), findsOneWidget);
    expect(find.text('Toko Sumber Rejeki'), findsOneWidget);
    expect(find.text('Shopping'), findsOneWidget);
    expect(find.text('BCA'), findsOneWidget);
    expect(find.text('Fri, 9 Oct 2026'), findsNothing);
    expect(find.text('Yesterday, 9 Oct'), findsOneWidget);
    expect(sparkles, findsNWidgets(4));
    expect(find.text('Please check this value.'), findsOneWidget);
    expect(find.text('2 items found'), findsOneWidget);
    expect(find.text('Rp 103.000'), findsOneWidget);
  });

  testWidgets('a busy AI says so and offers to try again', (tester) async {
    // Arrange
    // (an empty draft)

    // Act
    await openReview(
      tester,
      receipt: ReceiptDraft.empty,
      aiFailure: ReceiptAiFailure.busy,
    );

    // Assert
    expect(find.textContaining('The AI is busy right now'), findsOneWidget);
    expect(find.text('Try again'), findsOneWidget);
    expect(sparkles, findsNothing);
    expect(find.textContaining('items found'), findsNothing);
  });

  testWidgets('trying again fills the fields from the new draft', (
    tester,
  ) async {
    // Arrange
    when(() => parse(any())).thenAnswer((_) async => Right(draft));
    await openReview(
      tester,
      receipt: ReceiptDraft.empty,
      aiFailure: ReceiptAiFailure.busy,
    );

    // Act
    await tester.tap(find.text('Try again'));
    await tester.pumpAndSettle();

    // Assert
    verify(() => parse('TOTAL 187.500')).called(1);
    expect(find.text('Try again'), findsNothing);
    expect(find.text('187.500'), findsOneWidget);
    expect(find.text('Toko Sumber Rejeki'), findsOneWidget);
    expect(find.text('2 items found'), findsOneWidget);
    expect(sparkles, findsNWidgets(4));
  });

  testWidgets('trying again while still busy says so', (tester) async {
    // Arrange
    when(() => parse(any()))
        .thenAnswer((_) async => const Left(Failure.serviceUnavailable()));
    await openReview(
      tester,
      receipt: ReceiptDraft.empty,
      aiFailure: ReceiptAiFailure.busy,
    );

    // Act
    await tester.tap(find.text('Try again'));
    await tester.pump();

    // Assert
    expect(
      find.text('The AI is still busy. Try again in a moment.'),
      findsOneWidget,
    );
    expect(find.text('Try again'), findsOneWidget);
  });

  testWidgets('saves the edited draft and opens the transaction', (
    tester,
  ) async {
    // Arrange
    when(() => save(any()))
        .thenAnswer((_) async => Right(transaction(id: 't9')));
    await openReview(tester);

    // Act
    await tester.enterText(find.text('187.500'), '190000');
    await tester.tap(find.text('Save expense'));
    await tester.pumpAndSettle();

    // Assert
    final params =
        verify(() => save(captureAny())).captured.single
            as CreateReceiptTransactionParams;
    expect(params.input.amount, 190000);
    expect(params.input.merchant, 'Toko Sumber Rejeki');
    expect(params.photoPath, '/tmp/missing.jpg');
    expect(find.text('detail t9'), findsOneWidget);
  });

  testWidgets('a failed save stays and says why', (tester) async {
    // Arrange
    when(() => save(any()))
        .thenAnswer((_) async => const Left(Failure.network()));
    await openReview(tester);

    // Act
    await tester.tap(find.text('Save expense'));
    await tester.pump();

    // Assert
    expect(find.textContaining("You're offline"), findsOneWidget);
    expect(find.byType(ReceiptReviewUI), findsOneWidget);
  });

  testWidgets('tablet landscape shows the photo beside the draft', (
    tester,
  ) async {
    // Arrange
    // (an expanded window)

    // Act
    await openReview(tester, size: const Size(1280, 800));

    // Assert
    expect(find.byType(ReceiptReviewPhoto), findsOneWidget);
    expect(find.text('Pinch to zoom'), findsOneWidget);
    expect(find.text('Retake'), findsOneWidget);
    expect(find.text('Save expense'), findsOneWidget);
  });
}
