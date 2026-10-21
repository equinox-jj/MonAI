import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:fpdart/fpdart.dart';
import 'package:mocktail/mocktail.dart';
import 'package:monai/core/ui/designsystem/theme/monai_theme.dart';
import 'package:monai/core/ui/l10n/l10n.dart';
import 'package:monai/core/model/wallet_type.dart';
import 'package:monai/core/base/usecase.dart';
import 'package:monai/features/shared/domain/entity/wallet.dart';
import 'package:monai/features/shared/domain/usecase/refresh_wallets_usecase.dart';
import 'package:monai/features/shared/domain/usecase/watch_all_wallets_usecase.dart';
import 'package:monai/features/wallets/domain/usecase/unarchive_wallet_usecase.dart';
import 'package:monai/features/wallets/presentation/pages/archived_wallets/archived_wallets_page.dart';
import 'package:monai/features/wallets/presentation/pages/archived_wallets/bloc/archived_wallets_bloc.dart';

import '../../../../../helpers/entity_fixtures.dart';

class _MockWatchAllWallets extends Mock implements WatchAllWalletsUseCase {}

class _MockRefreshWallets extends Mock implements RefreshWalletsUseCase {}

class _MockUnarchive extends Mock implements UnarchiveWalletUseCase {}

void main() {
  late _MockUnarchive unarchive;
  late List<Wallet> all;

  final mandiri = wallet(
    id: 'w2',
    name: 'Mandiri',
    type: WalletType.bank,
    currentBalance: 3065000,
    isArchived: true,
  );

  setUpAll(() => registerFallbackValue(const NoParams()));

  setUp(() {
    unarchive = _MockUnarchive();
    all = [wallet(id: 'w1', isDefault: true), mandiri];
  });

  Future<void> pumpPage(WidgetTester tester) async {
    final watchAllWallets = _MockWatchAllWallets();
    when(() => watchAllWallets(any()))
        .thenAnswer((_) => Stream.value(Right(all)));
    final refreshWallets = _MockRefreshWallets();
    when(() => refreshWallets(any())).thenAnswer((_) async => Right(all));
    final bloc = ArchivedWalletsBloc(
      watchAllWallets: watchAllWallets,
      refreshWallets: refreshWallets,
      unarchive: unarchive,
    )..add(const ArchivedWalletsEvent.started());
    addTearDown(bloc.close);
    await tester.pumpWidget(
      MaterialApp(
        localizationsDelegates: AppLocalizations.localizationsDelegates,
        supportedLocales: AppLocalizations.supportedLocales,
        locale: const Locale('en'),
        theme: MonAITheme.light(),
        home: BlocProvider.value(value: bloc, child: const ArchivedWalletsUI()),
      ),
    );
    await tester.pumpAndSettle();
  }

  testWidgets('lists the archived wallets with their type and balance', (
    tester,
  ) async {
    // Act
    await pumpPage(tester);

    // Assert
    expect(find.text('Mandiri'), findsOneWidget);
    expect(find.text('Bank · Rp 3.065.000'), findsOneWidget);
    expect(find.text('Cash'), findsNothing);
  });

  testWidgets('nothing archived says so', (tester) async {
    // Arrange
    all = [wallet(id: 'w1', isDefault: true)];

    // Act
    await pumpPage(tester);

    // Assert
    expect(find.text('No archived wallets'), findsOneWidget);
  });

  testWidgets('unarchiving confirms the wallet is back', (tester) async {
    // Arrange
    when(() => unarchive('w2'))
        .thenAnswer((_) async => Right(mandiri.copyWith(isArchived: false)));
    await pumpPage(tester);

    // Act
    await tester.tap(find.text('Unarchive'));
    await tester.pumpAndSettle();

    // Assert
    verify(() => unarchive('w2')).called(1);
    expect(find.text('Mandiri is back in your wallets'), findsOneWidget);
  });
}
