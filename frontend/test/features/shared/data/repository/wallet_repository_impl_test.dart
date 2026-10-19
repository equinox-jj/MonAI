import 'package:flutter_test/flutter_test.dart';
import 'package:fpdart/fpdart.dart';
import 'package:mocktail/mocktail.dart';
import 'package:monai/core/database/monai_database.dart';
import 'package:monai/core/error/exceptions.dart';
import 'package:monai/core/error/failure.dart';
import 'package:monai/core/model/wallet_type.dart';
import 'package:monai/features/shared/data/datasources/wallet_local_datasource.dart';
import 'package:monai/features/shared/data/datasources/wallet_remote_datasource.dart';
import 'package:monai/features/shared/data/mapper/wallet_mapper.dart';
import 'package:monai/features/shared/data/model/create_wallet_request.dart';
import 'package:monai/features/shared/data/model/update_wallet_request.dart';
import 'package:monai/features/shared/data/model/wallet_list_response.dart';
import 'package:monai/features/shared/data/model/wallet_response.dart';
import 'package:monai/features/shared/data/repository/wallet_repository_impl.dart';
import 'package:monai/features/shared/domain/entity/wallet.dart';
import 'package:monai/features/shared/domain/entity/wallet_changes.dart';
import 'package:monai/features/shared/domain/entity/wallet_input.dart';

import '../../../../helpers/api_fixtures.dart';
import '../../../../helpers/database_fixtures.dart';

class _MockRemote extends Mock implements WalletRemoteDataSource {}

class _MockLocal extends Mock implements WalletLocalDataSource {}

WalletResponse _response({String id = 'w1', bool isDefault = false}) =>
    WalletResponse.fromJson(envelope(walletJson(id: id, isDefault: isDefault)));

void main() {
  late _MockRemote remote;
  late _MockLocal local;
  late WalletRepositoryImpl repository;

  setUpAll(() {
    registerFallbackValue(walletRow());
    registerFallbackValue(
      const CreateWalletRequest(initialBalance: 0, isDefault: false),
    );
    registerFallbackValue(const UpdateWalletRequest());
  });

  setUp(() {
    remote = _MockRemote();
    local = _MockLocal();
    repository = WalletRepositoryImpl(remote: remote, local: local);
    when(() => local.replaceAll(any())).thenAnswer((_) async {});
    when(() => local.save(any())).thenAnswer((_) async {});
    when(() => local.deleteById(any())).thenAnswer((_) async {});
  });

  group('watch', () {
    test('watchWallets leaves archived wallets out', () async {
      // Arrange
      when(() => local.watchAll()).thenAnswer(
        (_) => Stream.value([
          walletRow(id: 'w1'),
          walletRow(id: 'w2').copyWith(isArchived: true),
        ]),
      );

      // Act
      final result = await repository.watchWallets().first;

      // Assert
      expect(result.getRight().toNullable()?.map((w) => w.id), ['w1']);
    });

    test('watchAllWallets keeps archived wallets', () async {
      // Arrange
      when(() => local.watchAll()).thenAnswer(
        (_) => Stream.value([
          walletRow(id: 'w1'),
          walletRow(id: 'w2').copyWith(isArchived: true),
        ]),
      );

      // Act
      final result = await repository.watchAllWallets().first;

      // Assert
      expect(result.getRight().toNullable(), hasLength(2));
    });

    test('a cache error arrives as a CacheFailure', () async {
      // Arrange
      when(
        () => local.watch('w1'),
      ).thenAnswer((_) => Stream.error(const CacheException(message: 'boom')));

      // Act
      final result = await repository.watchWallet('w1').first;

      // Assert
      expect(result.getLeft().toNullable(), isA<CacheFailure>());
    });
  });

  group('refreshWallets', () {
    test('replaces the cache with the server list', () async {
      // Arrange
      when(() => remote.getWallets()).thenAnswer(
        (_) async => WalletListResponse.fromJson(
          envelope([walletJson(id: 'w1'), walletJson(id: 'w2', name: 'BCA')]),
        ),
      );

      // Act
      final result = await repository.refreshWallets();

      // Assert
      final rows =
          verify(() => local.replaceAll(captureAny())).captured.single
              as List<WalletRow>;
      expect(rows, hasLength(2));
      expect(
        result.getRight().toNullable(),
        rows.map((row) => row.toEntity()).toList(),
      );
    });

    test('a malformed wallet fails without touching the cache', () async {
      // Arrange
      when(() => remote.getWallets()).thenAnswer(
        (_) async => WalletListResponse.fromJson(
          envelope([
            {...walletJson(), 'type': 'CRYPTO'},
          ]),
        ),
      );

      // Act
      final result = await repository.refreshWallets();

      // Assert
      expect(result.getLeft().toNullable(), isA<UnknownFailure>());
      verifyNever(() => local.replaceAll(any()));
    });

    test('a network failure keeps the cache', () async {
      // Arrange
      when(() => remote.getWallets()).thenThrow(const NetworkException());

      // Act
      final result = await repository.refreshWallets();

      // Assert
      expect(result.getLeft().toNullable(), isA<NetworkFailure>());
      verifyNever(() => local.replaceAll(any()));
    });
  });

  group('refreshWallet', () {
    test('caches the fetched wallet', () async {
      // Arrange
      when(() => remote.getWallet('w1')).thenAnswer((_) async => _response());

      // Act
      final result = await repository.refreshWallet('w1');

      // Assert
      final row =
          verify(() => local.save(captureAny())).captured.single as WalletRow;
      expect(result, Right<Failure, Wallet>(row.toEntity()));
    });

    test('drops a wallet the server no longer has', () async {
      // Arrange
      when(() => remote.getWallet('w1'))
          .thenThrow(const NotFoundException(code: 'not_found'));

      // Act
      final result = await repository.refreshWallet('w1');

      // Assert
      expect(result.getLeft().toNullable(), isA<NotFoundFailure>());
      verify(() => local.deleteById('w1')).called(1);
    });
  });

  group('writes', () {
    test('createWallet sends the input and caches the result', () async {
      // Arrange
      when(() => remote.createWallet(any()))
          .thenAnswer((_) async => _response(isDefault: true));

      // Act
      final result = await repository.createWallet(
        const WalletInput(name: 'Cash', type: WalletType.cash),
      );

      // Assert
      expect(result.getRight().toNullable()?.isDefault, isTrue);
      verify(
        () => remote.createWallet(
          const CreateWalletRequest(
            name: 'Cash',
            type: 'CASH',
            initialBalance: 0,
            isDefault: false,
          ),
        ),
      ).called(1);
      final saved =
          verify(() => local.save(captureAny())).captured.single as WalletRow;
      expect(saved.isDefault, isTrue);
    });

    test('a blank name is left to the provider', () async {
      // Arrange
      when(() => remote.createWallet(any()))
          .thenAnswer((_) async => _response());

      // Act
      await repository.createWallet(
        const WalletInput(name: '', providerId: 'p1'),
      );

      // Assert
      verify(
        () => remote.createWallet(
          const CreateWalletRequest(
            providerId: 'p1',
            initialBalance: 0,
            isDefault: false,
          ),
        ),
      ).called(1);
    });

    test('updateWallet sends only the changes', () async {
      // Arrange
      when(() => remote.updateWallet(any(), any()))
          .thenAnswer((_) async => _response());

      // Act
      final result = await repository.updateWallet(
        'w1',
        const WalletChanges(isArchived: true),
      );

      // Assert
      expect(result.isRight(), isTrue);
      verify(
        () => remote.updateWallet(
          'w1',
          const UpdateWalletRequest(isArchived: true),
        ),
      ).called(1);
    });

    test('a rejected write keeps its code and caches nothing', () async {
      // Arrange
      when(() => remote.updateWallet(any(), any())).thenThrow(
        const ValidationException([], code: 'default_wallet_required'),
      );

      // Act
      final result = await repository.updateWallet(
        'w1',
        const WalletChanges(isDefault: false),
      );

      // Assert
      expect(
        result.getLeft().toNullable(),
        isA<ValidationFailure>().having(
          (f) => f.code,
          'code',
          'default_wallet_required',
        ),
      );
      verifyNever(() => local.save(any()));
    });

    test('deleteWallet deletes on the server, then the cache, and gives the '
        'cached copy', () async {
      // Arrange
      final cached = walletRow();
      when(() => local.find('w1')).thenAnswer((_) async => cached);
      when(() => remote.deleteWallet('w1')).thenAnswer((_) async {});

      // Act
      final result = await repository.deleteWallet('w1');

      // Assert
      expect(result, Right<Failure, Wallet?>(cached.toEntity()));
      verifyInOrder([
        () => remote.deleteWallet('w1'),
        () => local.deleteById('w1'),
      ]);
    });
  });
}
