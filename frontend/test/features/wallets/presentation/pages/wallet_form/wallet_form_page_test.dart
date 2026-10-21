import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:fpdart/fpdart.dart';
import 'package:mocktail/mocktail.dart';
import 'package:monai/core/ui/designsystem/theme/monai_theme.dart';
import 'package:monai/core/base/error/failure.dart';
import 'package:monai/core/ui/l10n/l10n.dart';
import 'package:monai/core/model/wallet_type.dart';
import 'package:monai/core/base/usecase.dart';
import 'package:monai/features/shared/domain/entity/payment_provider.dart';
import 'package:monai/features/shared/domain/entity/wallet_changes.dart';
import 'package:monai/features/shared/domain/entity/wallet_input.dart';
import 'package:monai/features/shared/domain/repository/wallet_repository.dart';
import 'package:monai/features/shared/domain/usecase/refresh_payment_providers_usecase.dart';
import 'package:monai/features/shared/domain/usecase/watch_payment_providers_usecase.dart';
import 'package:monai/features/shared/domain/usecase/watch_wallet_usecase.dart';
import 'package:monai/features/shared/domain/usecase/watch_wallets_usecase.dart';
import 'package:monai/features/wallets/domain/usecase/archive_wallet_usecase.dart';
import 'package:monai/features/wallets/domain/usecase/create_wallet_usecase.dart';
import 'package:monai/features/wallets/domain/usecase/delete_wallet_usecase.dart';
import 'package:monai/features/wallets/domain/usecase/update_wallet_usecase.dart';
import 'package:monai/features/wallets/presentation/model/wallet_failure.dart';
import 'package:monai/features/wallets/presentation/pages/wallet_form/bloc/wallet_form_bloc.dart';
import 'package:monai/features/wallets/presentation/pages/wallet_form/model/wallet_form_mode.dart';
import 'package:monai/features/wallets/presentation/pages/wallet_form/wallet_form_page.dart';

import '../../../../../helpers/entity_fixtures.dart';

class _MockRepository extends Mock implements WalletRepository {}

class _MockWatchProviders extends Mock
    implements WatchPaymentProvidersUseCase {}

class _MockRefreshProviders extends Mock
    implements RefreshPaymentProvidersUseCase {}

class _MockWatchWallet extends Mock implements WatchWalletUseCase {}

class _MockWatchWallets extends Mock implements WatchWalletsUseCase {}

const _gopay = PaymentProvider(
  id: 'p-gopay',
  slug: 'gopay',
  name: 'GoPay',
  type: WalletType.eWallet,
  aliases: [],
  sortOrder: 100,
);

void main() {
  late _MockRepository repository;

  final cash = wallet(id: 'w1', isDefault: true);
  final mandiri = wallet(
    id: 'w2',
    name: 'Mandiri',
    type: WalletType.bank,
    providerId: 'p-mandiri',
    initialBalance: 2000000,
    currentBalance: 2565000,
  );

  setUpAll(() {
    registerFallbackValue(const NoParams());
    registerFallbackValue(const WalletInput(name: ''));
    registerFallbackValue(const WalletChanges());
  });

  setUp(() => repository = _MockRepository());

  Future<void> pumpForm(
    WidgetTester tester, [
    WalletFormMode mode = const WalletFormMode.add(),
  ]) async {
    tester.view
      ..physicalSize = const Size(390, 1400)
      ..devicePixelRatio = 1;
    addTearDown(tester.view.reset);
    final watchProviders = _MockWatchProviders();
    when(() => watchProviders(any()))
        .thenAnswer((_) => Stream.value(const Right([_gopay])));
    final refreshProviders = _MockRefreshProviders();
    when(() => refreshProviders(any()))
        .thenAnswer((_) async => const Right([_gopay]));
    final watchWallet = _MockWatchWallet();
    when(() => watchWallet('w2'))
        .thenAnswer((_) => Stream.value(Right(mandiri)));
    final watchWallets = _MockWatchWallets();
    when(() => watchWallets(any()))
        .thenAnswer((_) => Stream.value(Right([cash, mandiri])));
    final bloc = WalletFormBloc(
      mode: mode,
      watchProviders: watchProviders,
      refreshProviders: refreshProviders,
      watchWallet: watchWallet,
      watchWallets: watchWallets,
      create: CreateWalletUseCase(repository),
      update: UpdateWalletUseCase(repository),
      archive: ArchiveWalletUseCase(repository),
      delete: DeleteWalletUseCase(repository),
    )..add(const WalletFormEvent.started());
    addTearDown(bloc.close);
    await tester.pumpWidget(
      MaterialApp(
        localizationsDelegates: AppLocalizations.localizationsDelegates,
        supportedLocales: AppLocalizations.supportedLocales,
        locale: const Locale('en'),
        theme: MonAITheme.light(),
        home: BlocProvider.value(value: bloc, child: const WalletFormUI()),
      ),
    );
    await tester.pumpAndSettle();
  }

  testWidgets('picking a provider names the wallet and fixes its type', (
    tester,
  ) async {
    // Arrange
    await pumpForm(tester);

    // Act
    await tester.tap(find.text('GoPay'));
    await tester.pumpAndSettle();

    // Assert
    final name = tester.widget<TextField>(find.byType(TextField).first);
    expect(name.controller?.text, 'GoPay');
    expect(find.text('Set by the provider.'), findsOneWidget);
    expect(
      find.text('You can rename it — e.g. “GoPay Bisnis”.'),
      findsOneWidget,
    );
  });

  testWidgets('saving a custom wallet with nothing filled in shows why', (
    tester,
  ) async {
    // Arrange
    await pumpForm(tester);

    // Act
    await tester.tap(find.widgetWithText(InkWell, 'Add wallet').last);
    await tester.pumpAndSettle();

    // Assert
    expect(find.text('Give the wallet a name'), findsOneWidget);
    expect(find.text('Pick a type'), findsOneWidget);
    verifyNever(() => repository.createWallet(any()));
  });

  testWidgets('editing the starting balance shows how the balance shifts', (
    tester,
  ) async {
    // Arrange
    await pumpForm(tester, const WalletFormMode.edit('w2'));

    // Act
    await tester.enterText(find.byType(TextField).last, '2500000');
    await tester.pumpAndSettle();

    // Assert
    expect(find.text('2.500.000'), findsOneWidget);
    expect(find.textContaining('Rp 2.565.000 → Rp 3.065.000'), findsOneWidget);
    expect(find.text('Rp 3.065.000'), findsOneWidget);
  });

  testWidgets('deleting a wallet with transactions offers to archive it', (
    tester,
  ) async {
    // Arrange
    when(() => repository.deleteWallet('w2')).thenAnswer(
      (_) async => const Left(
        Failure.validation([], code: WalletFailure.hasTransactionsCode),
      ),
    );
    await pumpForm(tester, const WalletFormMode.edit('w2'));

    // Act
    await tester.tap(find.text('Delete'));
    await tester.pumpAndSettle();
    await tester.tap(find.widgetWithText(InkWell, 'Delete').last);
    await tester.pumpAndSettle();

    // Assert
    expect(find.text('Archive Mandiri instead?'), findsOneWidget);
    expect(find.text('You can unarchive any time'), findsOneWidget);
  });

  testWidgets("editing names the current default", (tester) async {
    // Act
    await pumpForm(tester, const WalletFormMode.edit('w2'));

    // Assert
    expect(find.text('Cash is your default now'), findsOneWidget);
    expect(find.text('Type: Bank · set by the provider'), findsOneWidget);
  });
}
