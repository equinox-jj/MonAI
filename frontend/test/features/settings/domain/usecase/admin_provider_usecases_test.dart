import 'dart:async';
import 'dart:typed_data';

import 'package:flutter_test/flutter_test.dart';
import 'package:fpdart/fpdart.dart';
import 'package:mocktail/mocktail.dart';
import 'package:monai/core/base/error/failure.dart';
import 'package:monai/core/base/usecase.dart';
import 'package:monai/features/settings/domain/event/provider_change_events.dart';
import 'package:monai/features/settings/domain/repository/admin_provider_repository.dart';
import 'package:monai/features/settings/domain/usecase/delete_provider_usecase.dart';
import 'package:monai/features/settings/domain/usecase/get_admin_provider_usecase.dart';
import 'package:monai/features/settings/domain/usecase/get_admin_providers_usecase.dart';
import 'package:monai/features/settings/domain/usecase/provider_logo_uploader.dart';
import 'package:monai/features/settings/domain/usecase/set_provider_active_usecase.dart';
import 'package:monai/features/settings/domain/usecase/watch_provider_changes_usecase.dart';

import '../../../../helpers/entity_fixtures.dart';

class _MockRepository extends Mock implements AdminProviderRepository {}

void main() {
  late _MockRepository repository;
  late ProviderChangeEvents events;
  late List<String> emitted;
  late StreamSubscription<String> listening;

  setUpAll(() => registerFallbackValue(Uint8List(0)));

  setUp(() {
    repository = _MockRepository();
    events = ProviderChangeEvents();
    emitted = [];
    listening = events.stream.listen(emitted.add);
  });

  tearDown(() async {
    await listening.cancel();
    await events.dispose();
  });

  test('lists every provider from the repository', () async {
    // Arrange
    final providers = [adminProvider()];
    when(() => repository.listProviders())
        .thenAnswer((_) async => Right(providers));

    // Act
    final result = await GetAdminProvidersUseCase(repository)(const NoParams());

    // Assert
    expect(result.getOrElse((_) => []), providers);
  });

  test('gets one provider by id', () async {
    // Arrange
    when(() => repository.getProvider('p1'))
        .thenAnswer((_) async => Right(adminProvider()));

    // Act
    final result = await GetAdminProviderUseCase(repository)('p1');

    // Assert
    expect(result.isRight(), isTrue);
  });

  group('SetProviderActiveUseCase', () {
    test('announces the change once it saved', () async {
      // Arrange
      when(() => repository.setActive('p1', active: false))
          .thenAnswer((_) async => Right(adminProvider(isActive: false)));
      final setActive = SetProviderActiveUseCase(
        repository: repository,
        events: events,
      );

      // Act
      await setActive(const SetProviderActiveParams(id: 'p1', active: false));
      await pumpEventQueue();

      // Assert
      expect(emitted, ['p1']);
    });

    test('announces nothing when it failed', () async {
      // Arrange
      when(() => repository.setActive('p1', active: false))
          .thenAnswer((_) async => const Left(Failure.conflict()));
      final setActive = SetProviderActiveUseCase(
        repository: repository,
        events: events,
      );

      // Act
      await setActive(const SetProviderActiveParams(id: 'p1', active: false));
      await pumpEventQueue();

      // Assert
      expect(emitted, isEmpty);
    });
  });

  group('DeleteProviderUseCase', () {
    test('announces the delete once it went through', () async {
      // Arrange
      when(() => repository.deleteProvider('p1'))
          .thenAnswer((_) async => const Right(unit));
      final delete = DeleteProviderUseCase(
        repository: repository,
        events: events,
      );

      // Act
      final result = await delete('p1');
      await pumpEventQueue();

      // Assert
      expect(result.isRight(), isTrue);
      expect(emitted, ['p1']);
    });

    test('announces nothing when it failed', () async {
      // Arrange
      when(() => repository.deleteProvider('p1'))
          .thenAnswer((_) async => const Left(Failure.network()));
      final delete = DeleteProviderUseCase(
        repository: repository,
        events: events,
      );

      // Act
      await delete('p1');
      await pumpEventQueue();

      // Assert
      expect(emitted, isEmpty);
    });
  });

  test('watching gives each changed id', () async {
    // Arrange
    final watch = WatchProviderChangesUseCase(events);
    final seen = <Either<Failure, String>>[];
    final sub = watch(const NoParams()).listen(seen.add);
    addTearDown(sub.cancel);

    // Act
    events.emit('p9');
    await pumpEventQueue();

    // Assert
    expect(seen, [const Right<Failure, String>('p9')]);
  });

  group('ProviderLogoUploader', () {
    test('compresses, then uploads the bytes', () async {
      // Arrange
      final bytes = Uint8List.fromList([1, 2]);
      when(() => repository.compressLogo('/logo.png'))
          .thenAnswer((_) async => Right(bytes));
      when(() => repository.uploadLogo('p1', bytes))
          .thenAnswer((_) async => Right(adminProvider(logoUrl: 'https://l')));

      // Act
      final result = await ProviderLogoUploader(repository)
          .upload('p1', '/logo.png');

      // Assert
      expect(
        result.getOrElse((_) => throw StateError('')).logoUrl,
        'https://l',
      );
    });

    test('an unreadable image is not uploaded', () async {
      // Arrange
      when(() => repository.compressLogo('/logo.png')).thenAnswer(
        (_) async => const Left(Failure.unknown(code: 'unreadable_image')),
      );

      // Act
      final result = await ProviderLogoUploader(repository)
          .upload('p1', '/logo.png');

      // Assert
      expect(result.getLeft().toNullable()?.code, 'unreadable_image');
      verifyNever(() => repository.uploadLogo(any(), any()));
    });
  });
}
