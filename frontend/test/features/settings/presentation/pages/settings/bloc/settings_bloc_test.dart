import 'dart:async';

import 'package:flutter_test/flutter_test.dart';
import 'package:fpdart/fpdart.dart';
import 'package:mocktail/mocktail.dart';
import 'package:monai/core/base/error/failure.dart';
import 'package:monai/core/data/network/session_manager.dart';
import 'package:monai/core/base/usecase.dart';
import 'package:monai/features/settings/domain/entity/settings_overview.dart';
import 'package:monai/features/settings/presentation/pages/settings/bloc/settings_bloc.dart';

import '../../../../../../helpers/settings_fakes.dart';

void main() {
  late SettingsFakes fakes;
  late StreamController<Either<Failure, SettingsOverview>> cache;
  late SettingsBloc bloc;

  setUp(() {
    fakes = SettingsFakes();
    cache = StreamController.broadcast();
    when(() => fakes.watch(any())).thenAnswer((_) => cache.stream);
    bloc = SettingsBloc(
      watchOverview: fakes.watch,
      refresh: fakes.refresh,
      getAppVersion: fakes.appVersion,
      logout: fakes.logout,
      logoutAllDevices: fakes.logoutAllDevices,
      now: () => DateTime(2026, 10, 20, 9),
    );
  });

  tearDown(() async {
    await bloc.close();
    await cache.close();
    await fakes.appSettings.close();
  });

  test('shows the cache and refreshes the month in the background', () async {
    // Arrange
    bloc.add(const SettingsEvent.started());
    await pumpEventQueue();

    // Act
    cache.add(const Right(cachedOverview));
    await pumpEventQueue();

    // Assert
    expect(bloc.state.overview, cachedOverview);
    expect(bloc.state.appVersion, '1.0.0');
    verify(() => fakes.watch(DateTime(2026, 10))).called(1);
    verify(() => fakes.refresh(DateTime(2026, 10))).called(1);
  });

  test('a failed cache read keeps what is shown', () async {
    // Arrange
    bloc.add(const SettingsEvent.started());
    await pumpEventQueue();
    cache.add(const Right(cachedOverview));
    await pumpEventQueue();

    // Act
    cache.add(const Left(Failure.cache()));
    await pumpEventQueue();

    // Assert
    expect(bloc.state.overview, cachedOverview);
  });

  test('an unreadable version leaves it out', () async {
    // Arrange
    when(() => fakes.appVersion(any()))
        .thenAnswer((_) async => const Left(Failure.unknown()));

    // Act
    bloc.add(const SettingsEvent.started());
    await pumpEventQueue();

    // Assert
    expect(bloc.state.appVersion, isEmpty);
  });

  for (final allDevices in [false, true]) {
    test('signs out ${allDevices ? 'everywhere' : 'here'}', () async {
      // Arrange
      final done = Completer<Either<Failure, SessionStatus>>();
      when(() => fakes.logout(any())).thenAnswer((_) => done.future);
      when(() => fakes.logoutAllDevices(any())).thenAnswer((_) => done.future);

      // Act
      bloc.add(SettingsEvent.signOutConfirmed(allDevices: allDevices));
      await pumpEventQueue();
      final signingOut = bloc.state.isSigningOut;
      done.complete(const Right(SessionStatus.signedOut));
      await pumpEventQueue();

      // Assert
      expect(signingOut, isTrue);
      expect(bloc.state.isSigningOut, isFalse);
      expect(bloc.state.signOutFailure, isNull);
      if (allDevices) {
        verify(() => fakes.logoutAllDevices(const NoParams())).called(1);
        verifyNever(() => fakes.logout(any()));
      } else {
        verify(() => fakes.logout(const NoParams())).called(1);
        verifyNever(() => fakes.logoutAllDevices(any()));
      }
    });
  }

  test('a failed sign-out says why', () async {
    // Arrange
    when(() => fakes.logoutAllDevices(any()))
        .thenAnswer((_) async => const Left(Failure.network()));

    // Act
    bloc.add(const SettingsEvent.signOutConfirmed(allDevices: true));
    await pumpEventQueue();

    // Assert
    expect(bloc.state.isSigningOut, isFalse);
    expect(bloc.state.signOutFailure, SettingsSignOutFailure.network);
  });

  test('a second confirm while signing out is ignored', () async {
    // Arrange
    final done = Completer<Either<Failure, SessionStatus>>();
    when(() => fakes.logout(any())).thenAnswer((_) => done.future);

    // Act
    bloc
      ..add(const SettingsEvent.signOutConfirmed(allDevices: false))
      ..add(const SettingsEvent.signOutConfirmed(allDevices: false));
    await pumpEventQueue();
    done.complete(const Right(SessionStatus.signedOut));
    await pumpEventQueue();

    // Assert
    verify(() => fakes.logout(const NoParams())).called(1);
  });
}
