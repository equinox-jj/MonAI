import 'package:flutter_test/flutter_test.dart';
import 'package:fpdart/fpdart.dart';
import 'package:mocktail/mocktail.dart';
import 'package:monai/core/base/error/failure.dart';
import 'package:monai/core/model/wallet_type.dart';
import 'package:monai/features/shared/domain/entity/wallet.dart';
import 'package:monai/features/shared/domain/entity/wallet_changes.dart';
import 'package:monai/features/shared/domain/entity/wallet_input.dart';
import 'package:monai/features/shared/domain/repository/wallet_repository.dart';
import 'package:monai/features/wallets/domain/usecase/archive_wallet_usecase.dart';
import 'package:monai/features/wallets/domain/usecase/create_wallet_usecase.dart';
import 'package:monai/features/wallets/domain/usecase/delete_wallet_usecase.dart';
import 'package:monai/features/wallets/domain/usecase/refresh_wallet_usecase.dart';
import 'package:monai/features/wallets/domain/usecase/set_default_wallet_usecase.dart';
import 'package:monai/features/wallets/domain/usecase/unarchive_wallet_usecase.dart';
import 'package:monai/features/wallets/domain/usecase/update_wallet_usecase.dart';

import '../../../../helpers/entity_fixtures.dart';

class _MockRepository extends Mock implements WalletRepository {}

void main() {
  late _MockRepository repository;
  final saved = wallet();

  setUpAll(() {
    registerFallbackValue(const WalletInput(name: ''));
    registerFallbackValue(const WalletChanges());
  });

  setUp(() {
    repository = _MockRepository();
    when(() => repository.createWallet(any()))
        .thenAnswer((_) async => Right(saved));
    when(() => repository.updateWallet(any(), any()))
        .thenAnswer((_) async => Right(saved));
    when(() => repository.deleteWallet(any()))
        .thenAnswer((_) async => Right(saved));
  });

  group('CreateWalletUseCase', () {
    test('creates the wallet with the trimmed name', () async {
      // Arrange
      const input = WalletInput(name: ' Cash ', type: WalletType.cash);

      // Act
      final result = await CreateWalletUseCase(repository)(input);

      // Assert
      expect(result, Right<Failure, Wallet>(saved));
      verify(
        () => repository.createWallet(
          const WalletInput(name: 'Cash', type: WalletType.cash),
        ),
      ).called(1);
    });

    test('invalid input fails without calling the server', () async {
      // Arrange
      const input = WalletInput(name: '   ');

      // Act
      final result = await CreateWalletUseCase(repository)(input);

      // Assert
      expect(result.getLeft().toNullable(), isA<ValidationFailure>());
      verifyNever(() => repository.createWallet(any()));
    });
  });

  group('UpdateWalletUseCase', () {
    final current = wallet(
      name: 'Cash',
      initialBalance: 1000,
      color: '#000000',
    );

    WalletInput formOf(Wallet wallet) => WalletInput(
      name: wallet.name,
      type: wallet.type,
      initialBalance: wallet.initialBalance,
      color: wallet.color,
      isDefault: wallet.isDefault,
    );

    test('sends only what changed', () async {
      // Arrange
      final input = formOf(current)
          .copyWith(name: ' Dompet ', initialBalance: 2000);

      // Act
      final result = await UpdateWalletUseCase(repository)(
        UpdateWalletParams(wallet: current, input: input),
      );

      // Assert
      expect(result, Right<Failure, Wallet>(saved));
      verify(
        () => repository.updateWallet(
          'w1',
          const WalletChanges(name: 'Dompet', initialBalance: 2000),
        ),
      ).called(1);
    });

    test('an unchanged form makes no request', () async {
      // Arrange
      final input = formOf(current);

      // Act
      final result = await UpdateWalletUseCase(repository)(
        UpdateWalletParams(wallet: current, input: input),
      );

      // Assert
      expect(result, Right<Failure, Wallet>(current));
      verifyNever(() => repository.updateWallet(any(), any()));
    });

    test('the default is only ever moved to this wallet', () async {
      // Arrange
      final madeDefault = formOf(current).copyWith(isDefault: true);
      final defaultWallet = current.copyWith(isDefault: true);
      final unsetDefault = formOf(defaultWallet).copyWith(isDefault: false);

      // Act
      await UpdateWalletUseCase(repository)(
        UpdateWalletParams(wallet: current, input: madeDefault),
      );
      final unchanged = await UpdateWalletUseCase(repository)(
        UpdateWalletParams(wallet: defaultWallet, input: unsetDefault),
      );

      // Assert
      verify(
        () =>
            repository.updateWallet('w1', const WalletChanges(isDefault: true)),
      ).called(1);
      expect(unchanged, Right<Failure, Wallet>(defaultWallet));
    });

    test('invalid input fails without calling the server', () async {
      // Arrange
      final input = formOf(current).copyWith(color: 'blue');

      // Act
      final result = await UpdateWalletUseCase(repository)(
        UpdateWalletParams(wallet: current, input: input),
      );

      // Assert
      expect(result.getLeft().toNullable(), isA<ValidationFailure>());
      verifyNever(() => repository.updateWallet(any(), any()));
    });
  });

  group('the default wallet', () {
    test('cannot be archived', () async {
      // Arrange
      final defaultWallet = wallet(isDefault: true);

      // Act
      final result = await ArchiveWalletUseCase(repository)(defaultWallet);

      // Assert
      expect(result.getLeft().toNullable()?.code, 'default_wallet_required');
      verifyNever(() => repository.updateWallet(any(), any()));
    });

    test('cannot be deleted', () async {
      // Arrange
      final defaultWallet = wallet(isDefault: true);

      // Act
      final result = await DeleteWalletUseCase(repository)(defaultWallet);

      // Assert
      expect(result.getLeft().toNullable()?.code, 'default_wallet_required');
      verifyNever(() => repository.deleteWallet(any()));
    });
  });

  group('other wallets', () {
    test('are archived and unarchived', () async {
      // Arrange
      final other = wallet(id: 'w2');

      // Act
      await ArchiveWalletUseCase(repository)(other);
      await UnarchiveWalletUseCase(repository)('w2');

      // Assert
      verifyInOrder([
        () => repository.updateWallet(
          'w2',
          const WalletChanges(isArchived: true),
        ),
        () => repository.updateWallet(
          'w2',
          const WalletChanges(isArchived: false),
        ),
      ]);
    });

    test('are deleted', () async {
      // Arrange
      final other = wallet(id: 'w2');

      // Act
      final result = await DeleteWalletUseCase(repository)(other);

      // Assert
      expect(result, Right<Failure, Wallet?>(saved));
      verify(() => repository.deleteWallet('w2')).called(1);
    });

    test('are made the default', () async {
      // Arrange
      // (repository stubbed in setUp)

      // Act
      await SetDefaultWalletUseCase(repository)('w2');

      // Assert
      verify(
        () =>
            repository.updateWallet('w2', const WalletChanges(isDefault: true)),
      ).called(1);
    });
  });

  test('RefreshWalletUseCase forwards the id', () async {
    // Arrange
    when(() => repository.refreshWallet('w1'))
        .thenAnswer((_) async => Right(saved));

    // Act
    final result = await RefreshWalletUseCase(repository)('w1');

    // Assert
    expect(result, Right<Failure, Wallet>(saved));
  });
}
