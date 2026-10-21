import 'dart:async';

import 'package:flutter_test/flutter_test.dart';
import 'package:fpdart/fpdart.dart';
import 'package:mocktail/mocktail.dart';
import 'package:monai/core/base/error/failure.dart';
import 'package:monai/core/model/ui_status.dart';
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
import 'package:monai/features/wallets/domain/validation/wallet_input_validator.dart';
import 'package:monai/features/wallets/presentation/model/wallet_failure.dart';
import 'package:monai/features/wallets/presentation/pages/wallet_form/bloc/wallet_form_bloc.dart';
import 'package:monai/features/wallets/presentation/pages/wallet_form/model/wallet_form_mode.dart';

import '../../../../../../helpers/entity_fixtures.dart';

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
  late _MockWatchProviders watchProviders;
  late _MockRefreshProviders refreshProviders;
  late _MockWatchWallet watchWallet;
  late _MockWatchWallets watchWallets;

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

  setUp(() {
    repository = _MockRepository();
    watchProviders = _MockWatchProviders();
    refreshProviders = _MockRefreshProviders();
    watchWallet = _MockWatchWallet();
    watchWallets = _MockWatchWallets();
    when(() => watchProviders(any()))
        .thenAnswer((_) => Stream.value(const Right([_gopay])));
    when(() => refreshProviders(any()))
        .thenAnswer((_) async => const Right([_gopay]));
    when(() => watchWallets(any()))
        .thenAnswer((_) => Stream.value(Right([cash, mandiri])));
    when(() => watchWallet('w2'))
        .thenAnswer((_) => Stream.value(Right(mandiri)));
  });

  Future<WalletFormBloc> started([
    WalletFormMode mode = const WalletFormMode.add(),
  ]) async {
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
    await Future<void>.delayed(Duration.zero);
    return bloc;
  }

  Future<void> send(WalletFormBloc bloc, WalletFormEvent event) {
    bloc.add(event);
    return Future<void>.delayed(Duration.zero);
  }

  List<WalletFormState> record(WalletFormBloc bloc) {
    final states = <WalletFormState>[];
    final sub = bloc.stream.listen(states.add);
    addTearDown(sub.cancel);
    return states;
  }

  group('adding', () {
    test('starts custom with the catalog and the default name', () async {
      // Act
      final bloc = await started();

      // Assert
      expect(bloc.state.status, UiStatus.success);
      expect(bloc.state.providers, [_gopay]);
      expect(bloc.state.providerSlug, isNull);
      expect(bloc.state.isTypeLocked, isFalse);
      expect(bloc.state.defaultWalletName, 'Cash');
    });

    test('picking a provider fills the name once and locks its type', () async {
      // Arrange
      final bloc = await started();
      final states = record(bloc);

      // Act
      await send(bloc, const WalletFormEvent.providerPicked('gopay'));
      await send(bloc, const WalletFormEvent.typePicked(WalletType.cash));

      // Assert
      expect(states.map((s) => s.nameFill), contains('GoPay'));
      expect(bloc.state.nameFill, isNull);
      expect(bloc.state.type, WalletType.eWallet);
      expect(bloc.state.isTypeLocked, isTrue);
    });

    test('saves a provider wallet with its id and the typed balance', () async {
      // Arrange
      final bloc = await started();
      final created = wallet(id: 'w9', name: 'GoPay');
      when(() => repository.createWallet(any()))
          .thenAnswer((_) async => Right(created));
      await send(bloc, const WalletFormEvent.providerPicked('gopay'));

      // Act
      await send(
        bloc,
        const WalletFormEvent.saveRequested(
          name: 'GoPay',
          balance: '1.250.000',
        ),
      );

      // Assert
      final input =
          verify(() => repository.createWallet(captureAny())).captured.single
              as WalletInput;
      expect(input.providerId, 'p-gopay');
      expect(input.initialBalance, 1250000);
      expect(bloc.state.outcome, const WalletFormOutcome.saved('w9'));
    });

    test('a custom wallet without a name or type shows both errors, '
        'then re-checks them as they change', () async {
      // Arrange
      final bloc = await started();

      // Act
      await send(
        bloc,
        const WalletFormEvent.saveRequested(name: ' ', balance: '0'),
      );
      final errors = bloc.state.errors.keys.toSet();
      await send(bloc, const WalletFormEvent.nameEdited('Tabungan'));
      await send(bloc, const WalletFormEvent.typePicked(WalletType.other));

      // Assert
      expect(errors, {
        WalletInputValidator.nameField,
        WalletInputValidator.typeField,
      });
      expect(bloc.state.autovalidate, isTrue);
      expect(bloc.state.errors, isEmpty);
      verifyNever(() => repository.createWallet(any()));
    });

    test('a name the server says is taken shows on the name', () async {
      // Arrange
      final bloc = await started();
      when(
        () => repository.createWallet(any()),
      ).thenAnswer((_) async => const Left(Failure.conflict(code: 'conflict')));
      await send(bloc, const WalletFormEvent.typePicked(WalletType.cash));

      // Act
      await send(
        bloc,
        const WalletFormEvent.saveRequested(name: 'Cash', balance: '0'),
      );

      // Assert
      expect(
        bloc.state.errorOf(WalletInputValidator.nameField)?.code,
        'conflict',
      );
      expect(bloc.state.isSaving, isFalse);
    });
  });

  group('editing', () {
    test('loads the wallet into the form', () async {
      // Act
      final bloc = await started(const WalletFormMode.edit('w2'));

      // Assert
      expect(bloc.state.status, UiStatus.success);
      expect(bloc.state.original, mandiri);
      expect(bloc.state.type, WalletType.bank);
      expect(bloc.state.initialBalance, 2000000);
      expect(bloc.state.balanceShift, isNull);
    });

    test('a wallet gone from the cache fails as not found', () async {
      // Arrange
      when(() => watchWallet('w2'))
          .thenAnswer((_) => Stream.value(const Right(null)));

      // Act
      final bloc = await started(const WalletFormMode.edit('w2'));

      // Assert
      expect(bloc.state.status, UiStatus.failure);
      expect(bloc.state.loadFailure, WalletFailure.notFound);
    });

    test('a new starting balance previews the shifted balance', () async {
      // Arrange
      final bloc = await started(const WalletFormMode.edit('w2'));

      // Act
      await send(bloc, const WalletFormEvent.balanceEdited('2.500.000'));

      // Assert
      expect(bloc.state.balanceShift, (from: 2565000, to: 3065000));
    });

    test('saves only what changed', () async {
      // Arrange
      final bloc = await started(const WalletFormMode.edit('w2'));
      when(() => repository.updateWallet(any(), any()))
          .thenAnswer((_) async => Right(mandiri));
      await send(bloc, const WalletFormEvent.colorPicked('#0891B2'));

      // Act
      await send(
        bloc,
        const WalletFormEvent.saveRequested(
          name: 'Mandiri',
          balance: '2.000.000',
        ),
      );

      // Assert
      verify(
        () => repository.updateWallet(
          'w2',
          const WalletChanges(color: '#0891B2'),
        ),
      ).called(1);
      expect(bloc.state.outcome, const WalletFormOutcome.saved('w2'));
    });

    test('deleting a wallet with transactions offers to archive', () async {
      // Arrange
      final bloc = await started(const WalletFormMode.edit('w2'));
      when(() => repository.deleteWallet('w2')).thenAnswer(
        (_) async => const Left(
          Failure.validation([], code: WalletFailure.hasTransactionsCode),
        ),
      );
      final states = record(bloc);

      // Act
      await send(bloc, const WalletFormEvent.deleteRequested());

      // Assert
      expect(states.map((s) => s.offerArchive), contains(true));
      expect(bloc.state.offerArchive, isFalse);
      expect(bloc.state.outcome, isNull);
    });

    test('archiving closes the form with the name', () async {
      // Arrange
      final bloc = await started(const WalletFormMode.edit('w2'));
      when(() => repository.updateWallet('w2', any()))
          .thenAnswer((_) async => Right(mandiri.copyWith(isArchived: true)));

      // Act
      await send(bloc, const WalletFormEvent.archiveRequested());

      // Assert
      expect(bloc.state.outcome, const WalletFormOutcome.archived('Mandiri'));
    });

    test('the default wallet stays default and is not archived', () async {
      // Arrange
      when(() => watchWallet('w1'))
          .thenAnswer((_) => Stream.value(Right(cash)));
      final bloc = await started(const WalletFormMode.edit('w1'));
      final states = record(bloc);

      // Act
      await send(bloc, const WalletFormEvent.defaultToggled(isDefault: false));
      await send(bloc, const WalletFormEvent.archiveRequested());

      // Assert
      expect(bloc.state.isDefault, isTrue);
      expect(
        states.map((s) => s.actionFailure),
        contains(WalletFailure.defaultWalletRequired),
      );
      verifyNever(() => repository.updateWallet(any(), any()));
    });
  });
}
