import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:fpdart/fpdart.dart';
import 'package:intl/date_symbol_data_local.dart';
import 'package:mocktail/mocktail.dart';
import 'package:monai/core/designsystem/theme/monai_theme.dart';
import 'package:monai/core/error/failure.dart';
import 'package:monai/core/error/field_error.dart';
import 'package:monai/core/l10n/l10n.dart';
import 'package:monai/core/model/transaction_type.dart';
import 'package:monai/core/usecase/usecase.dart';
import 'package:monai/features/shared/domain/entity/transaction_input.dart';
import 'package:monai/features/shared/domain/usecase/create_transaction_usecase.dart';
import 'package:monai/features/shared/domain/usecase/delete_transaction_usecase.dart';
import 'package:monai/features/transactions/domain/entity/transaction_lookups.dart';
import 'package:monai/features/transactions/domain/usecase/get_transaction_usecase.dart';
import 'package:monai/features/transactions/domain/usecase/update_transaction_usecase.dart';
import 'package:monai/features/transactions/domain/usecase/watch_transaction_lookups_usecase.dart';
import 'package:monai/features/transactions/presentation/pages/transaction_form/bloc/transaction_form_bloc.dart';
import 'package:monai/features/transactions/presentation/pages/transaction_form/model/transaction_form_mode.dart';
import 'package:monai/features/transactions/presentation/pages/transaction_form/transaction_form_page.dart';
import 'package:monai/features/transactions/presentation/pages/transaction_form/widgets/transaction_form_keypad.dart';

import '../../../../../helpers/entity_fixtures.dart';

class _MockGet extends Mock implements GetTransactionUseCase {}

class _MockCreate extends Mock implements CreateTransactionUseCase {}

class _MockUpdate extends Mock implements UpdateTransactionUseCase {}

class _MockDelete extends Mock implements DeleteTransactionUseCase {}

class _MockWatchLookups extends Mock
    implements WatchTransactionLookupsUseCase {}

void main() {
  late _MockGet get;
  late _MockCreate create;

  setUpAll(() {
    registerFallbackValue(const NoParams());
    registerFallbackValue(
      TransactionInput(
        type: TransactionType.expense,
        amount: 1,
        date: DateTime(2026),
      ),
    );
    return initializeDateFormatting();
  });

  setUp(() {
    get = _MockGet();
    create = _MockCreate();
  });

  /// Opens the form over a launcher screen, so closing it can be seen.
  Future<void> openForm(
    WidgetTester tester, [
    TransactionFormMode mode = const TransactionFormMode.add(),
  ]) async {
    tester.view
      ..physicalSize = const Size(390, 900)
      ..devicePixelRatio = 1;
    addTearDown(tester.view.reset);
    final watchLookups = _MockWatchLookups();
    when(() => watchLookups(any())).thenAnswer(
      (_) => Stream.value(
        Right(
          TransactionLookups.of(
            categories: [
              category(),
              category(id: 'c2', name: 'Transport'),
            ],
            wallets: [wallet(name: 'GoPay', isDefault: true)],
          ),
        ),
      ),
    );
    final bloc = TransactionFormBloc(
      mode: mode,
      getTransaction: get,
      create: create,
      update: _MockUpdate(),
      delete: _MockDelete(),
      watchLookups: watchLookups,
      now: () => DateTime(2026, 10, 10, 15),
    )..add(const TransactionFormEvent.started());
    addTearDown(bloc.close);
    await tester.pumpWidget(
      MaterialApp(
        localizationsDelegates: AppLocalizations.localizationsDelegates,
        supportedLocales: AppLocalizations.supportedLocales,
        locale: const Locale('en'),
        theme: MonAITheme.light(),
        home: Builder(
          builder: (context) => Scaffold(
            body: TextButton(
              onPressed: () => Navigator.push(
                context,
                MaterialPageRoute<void>(
                  builder: (_) => BlocProvider.value(
                    value: bloc,
                    child: const TransactionFormUI(),
                  ),
                ),
              ),
              child: const Text('open'),
            ),
          ),
        ),
      ),
    );
    await tester.tap(find.text('open'));
    await tester.pumpAndSettle();
  }

  testWidgets('types an expense on the keypad and saves it', (tester) async {
    // Arrange
    when(() => create(any()))
        .thenAnswer((_) async => Right(transaction(id: 'new')));
    await openForm(tester);

    // Act
    await tester.tap(find.text('3'));
    await tester.tap(find.text('5'));
    await tester.tap(find.text('000'));
    await tester.tap(find.text('Food'));
    await tester.enterText(find.byType(EditableText), 'Kopi');
    await tester.tap(find.text('Save expense'));
    await tester.pumpAndSettle();

    // Assert
    expect(find.text('35.000'), findsNothing);
    final input =
        verify(() => create(captureAny())).captured.single as TransactionInput;
    expect(input.amount, 35000);
    expect(input.categoryId, 'c1');
    expect(input.note, 'Kopi');
    expect(find.byType(TransactionFormUI), findsNothing);
  });

  testWidgets('a rejected save shows what to fix', (tester) async {
    // Arrange
    when(() => create(any())).thenAnswer(
      (_) async => const Left(
        Failure.validation([
          FieldError(field: 'category_id', code: 'required', message: 'x'),
        ]),
      ),
    );
    await openForm(tester);

    // Act
    await tester.tap(find.text('Save expense'));
    await tester.pumpAndSettle();

    // Assert
    expect(find.text('Pick a category'), findsOneWidget);
    expect(find.byType(TransactionFormUI), findsOneWidget);
  });

  testWidgets('closing with changes asks, then discards', (tester) async {
    // Arrange
    await openForm(tester);
    await tester.tap(find.text('7'));

    // Act
    await tester.tap(find.byTooltip('Close'));
    await tester.pumpAndSettle();
    expect(find.text('Discard changes?'), findsOneWidget);
    await tester.tap(find.text('Discard'));
    await tester.pumpAndSettle();

    // Assert
    expect(find.byType(TransactionFormUI), findsNothing);
  });

  testWidgets('editing shows the saved amount and note', (tester) async {
    // Arrange
    when(() => get('t1')).thenAnswer(
      (_) async => Right(transaction(amount: 35000, note: 'Makan siang')),
    );

    // Act
    await openForm(tester, const TransactionFormMode.edit('t1'));
    await tester.tap(find.text('0'));
    await tester.pumpAndSettle();

    // Assert
    expect(find.text('Edit transaction'), findsOneWidget);
    expect(find.text('Makan siang'), findsOneWidget);
    expect(find.text('Was Rp 35.000'), findsOneWidget);
    expect(find.text('Save changes'), findsOneWidget);
  });

  testWidgets('hides the keypad while the keyboard is up', (tester) async {
    // Arrange
    await openForm(tester);
    expect(find.byType(TransactionFormKeypad), findsOneWidget);

    // Act
    tester.view.viewInsets = const FakeViewPadding(bottom: 300);
    await tester.pump();

    // Assert
    expect(find.byType(TransactionFormKeypad), findsNothing);
  });

  testWidgets('shows the keypad again when the keyboard closes', (
    tester,
  ) async {
    // Arrange
    await openForm(tester);
    tester.view.viewInsets = const FakeViewPadding(bottom: 300);
    await tester.pump();

    // Act
    tester.view.viewInsets = FakeViewPadding.zero;
    await tester.pump();

    // Assert
    expect(find.byType(TransactionFormKeypad), findsOneWidget);
  });

  testWidgets('keeps Save above the keyboard', (tester) async {
    // Arrange
    await openForm(tester);

    // Act
    tester.view.viewInsets = const FakeViewPadding(bottom: 300);
    await tester.pump();

    // Assert
    final save = tester.getRect(find.text('Save expense'));
    expect(save.bottom, lessThanOrEqualTo(900 - 300));
  });
}
