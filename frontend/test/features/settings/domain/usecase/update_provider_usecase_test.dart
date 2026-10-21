import 'dart:async';

import 'package:flutter_test/flutter_test.dart';
import 'package:fpdart/fpdart.dart';
import 'package:mocktail/mocktail.dart';
import 'package:monai/core/error/failure.dart';
import 'package:monai/core/model/wallet_type.dart';
import 'package:monai/features/settings/domain/entity/admin_payment_provider.dart';
import 'package:monai/features/settings/domain/event/provider_change_events.dart';
import 'package:monai/features/settings/domain/repository/admin_provider_repository.dart';
import 'package:monai/features/settings/domain/usecase/provider_logo_uploader.dart';
import 'package:monai/features/settings/domain/usecase/update_provider_usecase.dart';

import '../../../../helpers/entity_fixtures.dart';

class _MockRepository extends Mock implements AdminProviderRepository {}

class _MockLogoUploader extends Mock implements ProviderLogoUploader {}

/// The form as loaded from [adminProvider], unchanged.
ProviderInput _unchanged() => const ProviderInput(
  name: 'GoPay',
  type: WalletType.eWallet,
  aliases: ['gopay', 'gpay'],
  sortOrder: 50,
  isActive: true,
);

void main() {
  late _MockRepository repository;
  late _MockLogoUploader logoUploader;
  late ProviderChangeEvents events;
  late List<String> emitted;
  late StreamSubscription<String> listening;
  late UpdateProviderUseCase update;
  final original = adminProvider(aliases: ['gpay', 'gopay']);

  setUpAll(() => registerFallbackValue(const ProviderChanges()));

  setUp(() {
    repository = _MockRepository();
    logoUploader = _MockLogoUploader();
    events = ProviderChangeEvents();
    emitted = [];
    listening = events.stream.listen(emitted.add);
    update = UpdateProviderUseCase(
      repository: repository,
      logoUploader: logoUploader,
      events: events,
    );
    when(() => repository.updateProvider(any(), any()))
        .thenAnswer((_) async => Right(adminProvider(sortOrder: 70)));
  });

  tearDown(() async {
    await listening.cancel();
    await events.dispose();
  });

  test('nothing changed saves nothing', () async {
    // Arrange
    final params = UpdateProviderParams(
      original: original,
      input: _unchanged(),
    );

    // Act
    final result = await update(params);
    await pumpEventQueue();

    // Assert
    expect(result.getOrElse((_) => throw StateError('')).provider, original);
    verifyNever(() => repository.updateProvider(any(), any()));
    expect(emitted, isEmpty);
  });

  test('sends only the changed fields and announces it', () async {
    // Arrange
    final params = UpdateProviderParams(
      original: original,
      input: _unchanged().copyWith(sortOrder: 70),
    );

    // Act
    await update(params);
    await pumpEventQueue();

    // Assert
    verify(
      () =>
          repository.updateProvider('p1', const ProviderChanges(sortOrder: 70)),
    ).called(1);
    expect(emitted, ['p1']);
  });

  test('a status change alone skips the field update', () async {
    // Arrange
    when(() => repository.setActive('p1', active: false))
        .thenAnswer((_) async => Right(adminProvider(isActive: false)));
    final params = UpdateProviderParams(
      original: original,
      input: _unchanged().copyWith(isActive: false),
    );

    // Act
    final result = await update(params);

    // Assert
    verifyNever(() => repository.updateProvider(any(), any()));
    expect(
      result.getOrElse((_) => throw StateError('')).provider.isActive,
      isFalse,
    );
  });

  test('a failed field update stops before the status', () async {
    // Arrange
    when(() => repository.updateProvider(any(), any()))
        .thenAnswer((_) async => const Left(Failure.conflict()));
    final params = UpdateProviderParams(
      original: original,
      input: _unchanged().copyWith(name: 'GoPay 2', isActive: false),
    );

    // Act
    final result = await update(params);
    await pumpEventQueue();

    // Assert
    expect(result.getLeft().toNullable(), isA<ConflictFailure>());
    verifyNever(
      () => repository.setActive(any(), active: any(named: 'active')),
    );
    expect(emitted, isEmpty);
  });

  test('a failed status after saved fields still reloads the list', () async {
    // Arrange
    when(() => repository.setActive('p1', active: false))
        .thenAnswer((_) async => const Left(Failure.network()));
    final params = UpdateProviderParams(
      original: original,
      input: _unchanged().copyWith(sortOrder: 70, isActive: false),
    );

    // Act
    final result = await update(params);
    await pumpEventQueue();

    // Assert
    expect(result.getLeft().toNullable(), isA<NetworkFailure>());
    expect(emitted, ['p1']);
  });

  test('a new logo alone is uploaded', () async {
    // Arrange
    when(() => logoUploader.upload('p1', '/logo.png'))
        .thenAnswer((_) async => Right(adminProvider(logoUrl: 'https://l')));
    final params = UpdateProviderParams(
      original: original,
      input: _unchanged(),
      logoPath: '/logo.png',
    );

    // Act
    final result = await update(params);

    // Assert
    verifyNever(() => repository.updateProvider(any(), any()));
    expect(
      result.getOrElse((_) => throw StateError('')).provider.logoUrl,
      'https://l',
    );
  });

  test('a failed logo keeps the saved fields and says so', () async {
    // Arrange
    when(() => logoUploader.upload('p1', '/logo.png')).thenAnswer(
      (_) async => const Left(Failure.unknown(code: 'unreadable_image')),
    );
    final params = UpdateProviderParams(
      original: original,
      input: _unchanged().copyWith(sortOrder: 70),
      logoPath: '/logo.png',
    );

    // Act
    final result = await update(params);

    // Assert
    final saved = result.getOrElse((_) => throw StateError(''));
    expect(saved.provider.sortOrder, 70);
    expect(saved.logoFailure?.code, 'unreadable_image');
  });

  test('invalid input fails without calling the server', () async {
    // Arrange
    final params = UpdateProviderParams(
      original: original,
      input: _unchanged().copyWith(name: ''),
    );

    // Act
    final result = await update(params);

    // Assert
    expect(result.getLeft().toNullable(), isA<ValidationFailure>());
    verifyNever(() => repository.updateProvider(any(), any()));
  });
}
