import 'dart:typed_data';

import 'package:flutter_test/flutter_test.dart';
import 'package:fpdart/fpdart.dart';
import 'package:mocktail/mocktail.dart';
import 'package:monai/core/base/error/exceptions.dart';
import 'package:monai/core/base/error/failure.dart';
import 'package:monai/core/model/wallet_type.dart';
import 'package:monai/core/data/services/image_compressor_service.dart';
import 'package:monai/features/settings/data/datasources/admin_provider_remote_datasource.dart';
import 'package:monai/features/settings/data/model/admin_provider_list_response.dart';
import 'package:monai/features/settings/data/model/admin_provider_response.dart';
import 'package:monai/features/settings/data/model/create_provider_request.dart';
import 'package:monai/features/settings/data/model/provider_status_request.dart';
import 'package:monai/features/settings/data/model/update_provider_request.dart';
import 'package:monai/features/settings/data/repository/admin_provider_repository_impl.dart';
import 'package:monai/features/settings/domain/entity/admin_payment_provider.dart';

import '../../../../helpers/api_fixtures.dart';

class _MockRemote extends Mock implements AdminProviderRemoteDataSource {}

class _MockCompressor extends Mock implements ImageCompressorService {}

AdminProviderData _data({
  String id = 'p1',
  String name = 'GoPay',
  int sortOrder = 50,
  bool isActive = true,
}) => AdminProviderData.fromJson(
  adminProviderJson(
    id: id,
    name: name,
    sortOrder: sortOrder,
    isActive: isActive,
  ),
);

AdminProviderResponse _one(AdminProviderData data) =>
    AdminProviderResponse(data: data);

AdminProviderListResponse _page(
  List<AdminProviderData> data, {
  required int totalPages,
}) => AdminProviderListResponse(
  data: data,
  meta: AdminProviderListMeta(totalPages: totalPages),
);

void main() {
  late _MockRemote remote;
  late _MockCompressor compressor;
  late AdminProviderRepositoryImpl repository;

  setUpAll(() {
    registerFallbackValue(
      const CreateProviderRequest(
        name: '',
        type: 'CASH',
        aliases: [],
        sortOrder: 0,
      ),
    );
    registerFallbackValue(const UpdateProviderRequest());
    registerFallbackValue(const ProviderStatusRequest(isActive: true));
    registerFallbackValue(Uint8List(0));
  });

  setUp(() {
    remote = _MockRemote();
    compressor = _MockCompressor();
    repository = AdminProviderRepositoryImpl(
      remote: remote,
      compressor: compressor,
    );
  });

  group('listProviders', () {
    test('reads every page and sorts by order, then name', () async {
      // Arrange
      when(() => remote.listProviders(page: 1, perPage: 100)).thenAnswer(
        (_) async => _page([
          _data(id: 'b', name: 'OVO', sortOrder: 60),
          _data(id: 'c', name: 'DANA', sortOrder: 60),
        ], totalPages: 2),
      );
      when(() => remote.listProviders(page: 2, perPage: 100)).thenAnswer(
        (_) async =>
            _page([_data(id: 'a', name: 'Cash', sortOrder: 0)], totalPages: 2),
      );

      // Act
      final result = await repository.listProviders();

      // Assert
      final names = result.getOrElse((_) => []).map((p) => p.name).toList();
      expect(names, ['Cash', 'DANA', 'OVO']);
    });

    test('stops at the page cap', () async {
      // Arrange
      when(
        () => remote.listProviders(
          page: any(named: 'page'),
          perPage: any(named: 'perPage'),
        ),
      ).thenAnswer((_) async => _page([_data()], totalPages: 999));

      // Act
      await repository.listProviders();

      // Assert
      verify(
        () => remote.listProviders(
          page: any(named: 'page'),
          perPage: any(named: 'perPage'),
        ),
      ).called(20);
    });

    test('a failed page fails the whole list', () async {
      // Arrange
      when(
        () => remote.listProviders(
          page: any(named: 'page'),
          perPage: any(named: 'perPage'),
        ),
      ).thenThrow(const NetworkException());

      // Act
      final result = await repository.listProviders();

      // Assert
      expect(result.getLeft().toNullable(), isA<NetworkFailure>());
    });
  });

  test('a provider without its timestamp is a malformed response', () async {
    // Arrange
    when(() => remote.getProvider('p1'))
        .thenAnswer((_) async => _one(_data().copyWith(updatedAt: null)));

    // Act
    final result = await repository.getProvider('p1');

    // Assert
    expect(result.isLeft(), isTrue);
  });

  test('creates from the input', () async {
    // Arrange
    when(() => remote.createProvider(any()))
        .thenAnswer((_) async => _one(_data()));

    // Act
    final result = await repository.createProvider(
      const ProviderInput(
        name: 'GoPay',
        type: WalletType.eWallet,
        aliases: ['gopay'],
        sortOrder: 50,
        isActive: true,
      ),
    );

    // Assert
    verify(
      () => remote.createProvider(
        const CreateProviderRequest(
          name: 'GoPay',
          type: 'E_WALLET',
          aliases: ['gopay'],
          sortOrder: 50,
        ),
      ),
    ).called(1);
    expect(result.getOrElse((_) => throw StateError('')).id, 'p1');
  });

  test('an update sends only the changes', () async {
    // Arrange
    when(() => remote.updateProvider(any(), any()))
        .thenAnswer((_) async => _one(_data()));

    // Act
    await repository.updateProvider(
      'p1',
      const ProviderChanges(type: WalletType.bank),
    );

    // Assert
    verify(
      () => remote.updateProvider(
        'p1',
        const UpdateProviderRequest(type: 'BANK'),
      ),
    ).called(1);
  });

  test('sets the status', () async {
    // Arrange
    when(() => remote.setStatus(any(), any()))
        .thenAnswer((_) async => _one(_data(isActive: false)));

    // Act
    final result = await repository.setActive('p1', active: false);

    // Assert
    verify(
      () =>
          remote.setStatus('p1', const ProviderStatusRequest(isActive: false)),
    ).called(1);
    expect(result.getOrElse((_) => throw StateError('')).isActive, isFalse);
  });

  test('a locked system provider keeps its code', () async {
    // Arrange
    when(() => remote.deleteProvider('p1'))
        .thenThrow(const ConflictException(code: 'system_provider_locked'));

    // Act
    final result = await repository.deleteProvider('p1');

    // Assert
    expect(result.getLeft().toNullable()?.code, 'system_provider_locked');
  });

  test('deleting succeeds with unit', () async {
    // Arrange
    when(() => remote.deleteProvider('p1')).thenAnswer((_) async {});

    // Act
    final result = await repository.deleteProvider('p1');

    // Assert
    expect(result, const Right<Failure, Unit>(unit));
  });

  test('compresses the logo with the logo rules', () async {
    // Arrange
    final bytes = Uint8List.fromList([1, 2]);
    when(() => compressor.compressLogo('/logo.png'))
        .thenAnswer((_) async => bytes);

    // Act
    final result = await repository.compressLogo('/logo.png');

    // Assert
    expect(result, Right<Failure, Uint8List>(bytes));
  });

  test('uploads the logo as a WebP file', () async {
    // Arrange
    when(
      () => remote.uploadLogo(any(), any(), filename: any(named: 'filename')),
    ).thenAnswer((_) async => _one(_data()));

    // Act
    await repository.uploadLogo('p1', Uint8List.fromList([1]));

    // Assert
    verify(() => remote.uploadLogo('p1', any(), filename: 'logo.webp'))
        .called(1);
  });
}
