import 'dart:async';

import 'package:flutter_test/flutter_test.dart';
import 'package:fpdart/fpdart.dart';
import 'package:mocktail/mocktail.dart';
import 'package:monai/core/base/error/failure.dart';
import 'package:monai/core/model/wallet_type.dart';
import 'package:monai/features/settings/domain/entity/admin_payment_provider.dart';
import 'package:monai/features/settings/domain/event/provider_change_events.dart';
import 'package:monai/features/settings/domain/repository/admin_provider_repository.dart';
import 'package:monai/features/settings/domain/usecase/create_provider_usecase.dart';
import 'package:monai/features/settings/domain/usecase/provider_logo_uploader.dart';

import '../../../../helpers/entity_fixtures.dart';

class _MockRepository extends Mock implements AdminProviderRepository {}

class _MockLogoUploader extends Mock implements ProviderLogoUploader {}

const _input = ProviderInput(
  name: ' GoPay ',
  type: WalletType.eWallet,
  aliases: ['GPay', 'gopay'],
  sortOrder: 50,
  isActive: true,
);

void main() {
  late _MockRepository repository;
  late _MockLogoUploader logoUploader;
  late ProviderChangeEvents events;
  late List<String> emitted;
  late StreamSubscription<String> listening;
  late CreateProviderUseCase create;

  setUpAll(() => registerFallbackValue(_input));

  setUp(() {
    repository = _MockRepository();
    logoUploader = _MockLogoUploader();
    events = ProviderChangeEvents();
    emitted = [];
    listening = events.stream.listen(emitted.add);
    create = CreateProviderUseCase(
      repository: repository,
      logoUploader: logoUploader,
      events: events,
    );
    when(() => repository.createProvider(any()))
        .thenAnswer((_) async => Right(adminProvider()));
  });

  tearDown(() async {
    await listening.cancel();
    await events.dispose();
  });

  test('creates the normalized input and announces it', () async {
    // Arrange
    const params = CreateProviderParams(input: _input);

    // Act
    final result = await create(params);
    await pumpEventQueue();

    // Assert
    verify(
      () => repository.createProvider(
        const ProviderInput(
          name: 'GoPay',
          type: WalletType.eWallet,
          aliases: ['gopay', 'gpay'],
          sortOrder: 50,
          isActive: true,
        ),
      ),
    ).called(1);
    verifyNever(
      () => repository.setActive(any(), active: any(named: 'active')),
    );
    expect(result.getOrElse((_) => throw StateError('')).logoFailure, isNull);
    expect(emitted, ['p1']);
  });

  test('invalid input fails without calling the server', () async {
    // Arrange
    final params = CreateProviderParams(input: _input.copyWith(name: '  '));

    // Act
    final result = await create(params);

    // Assert
    expect(result.getLeft().toNullable(), isA<ValidationFailure>());
    verifyNever(() => repository.createProvider(any()));
  });

  test('an inactive provider is switched off after it is created', () async {
    // Arrange
    when(() => repository.setActive('p1', active: false))
        .thenAnswer((_) async => Right(adminProvider(isActive: false)));
    final params = CreateProviderParams(
      input: _input.copyWith(isActive: false),
    );

    // Act
    final result = await create(params);

    // Assert
    expect(
      result.getOrElse((_) => throw StateError('')).provider.isActive,
      isFalse,
    );
  });

  test('a failed create announces nothing', () async {
    // Arrange
    when(
      () => repository.createProvider(any()),
    ).thenAnswer((_) async => const Left(Failure.conflict(code: 'conflict')));

    // Act
    final result = await create(const CreateProviderParams(input: _input));
    await pumpEventQueue();

    // Assert
    expect(result.getLeft().toNullable(), isA<ConflictFailure>());
    expect(emitted, isEmpty);
  });

  test('a failed logo still saves the provider and says so', () async {
    // Arrange
    when(() => logoUploader.upload('p1', '/logo.png')).thenAnswer(
      (_) async => const Left(Failure.unknown(code: 'photo_too_large')),
    );

    // Act
    final result = await create(
      const CreateProviderParams(input: _input, logoPath: '/logo.png'),
    );
    await pumpEventQueue();

    // Assert
    final saved = result.getOrElse((_) => throw StateError(''));
    expect(saved.provider.id, 'p1');
    expect(saved.logoFailure?.code, 'photo_too_large');
    expect(emitted, ['p1']);
  });

  test('an uploaded logo comes back on the provider', () async {
    // Arrange
    when(() => logoUploader.upload('p1', '/logo.png'))
        .thenAnswer((_) async => Right(adminProvider(logoUrl: 'https://l')));

    // Act
    final result = await create(
      const CreateProviderParams(input: _input, logoPath: '/logo.png'),
    );

    // Assert
    expect(
      result.getOrElse((_) => throw StateError('')).provider.logoUrl,
      'https://l',
    );
  });
}
