import 'dart:async';

import 'package:flutter_test/flutter_test.dart';
import 'package:fpdart/fpdart.dart';
import 'package:mocktail/mocktail.dart';
import 'package:monai/core/error/failure.dart';
import 'package:monai/core/model/ui_status.dart';
import 'package:monai/core/usecase/usecase.dart';
import 'package:monai/features/settings/domain/entity/admin_payment_provider.dart';
import 'package:monai/features/settings/domain/event/provider_change_events.dart';
import 'package:monai/features/settings/domain/logic/provider_rules.dart';
import 'package:monai/features/settings/domain/usecase/get_admin_providers_usecase.dart';
import 'package:monai/features/settings/domain/usecase/watch_provider_changes_usecase.dart';
import 'package:monai/features/settings/presentation/model/provider_failure.dart';
import 'package:monai/features/settings/presentation/pages/manage_providers/bloc/manage_providers_bloc.dart';
import 'package:monai/features/shared/domain/entity/user.dart';
import 'package:monai/features/shared/domain/usecase/watch_user_usecase.dart';

import '../../../../../../helpers/entity_fixtures.dart';

class _MockWatchUser extends Mock implements WatchUserUseCase {}

class _MockGetProviders extends Mock implements GetAdminProvidersUseCase {}

void main() {
  late _MockWatchUser watchUser;
  late _MockGetProviders getProviders;
  late ProviderChangeEvents events;
  late StreamController<Either<Failure, User?>> users;
  late ManageProvidersBloc bloc;

  final providers = [
    adminProvider(id: 'a', name: 'Cash', isSystem: true, aliases: ['tunai']),
    adminProvider(id: 'b', name: 'GoPay', aliases: ['gpay']),
  ];

  setUpAll(() => registerFallbackValue(const NoParams()));

  setUp(() {
    watchUser = _MockWatchUser();
    getProviders = _MockGetProviders();
    events = ProviderChangeEvents();
    users = StreamController.broadcast();
    when(() => watchUser(any())).thenAnswer((_) => users.stream);
    when(() => getProviders(any())).thenAnswer((_) async => Right(providers));
    bloc = ManageProvidersBloc(
      watchUser: watchUser,
      getProviders: getProviders,
      watchChanges: WatchProviderChangesUseCase(events),
    );
  });

  tearDown(() async {
    await bloc.close();
    await users.close();
    await events.dispose();
  });

  Future<void> start() async {
    bloc.add(const ManageProvidersEvent.started());
    await pumpEventQueue();
  }

  test('loads every provider on start', () async {
    // Arrange
    // (two providers from setUp)

    // Act
    await start();

    // Assert
    expect(bloc.state.status, UiStatus.success);
    expect(bloc.state.providers, providers);
  });

  test('a failed first load shows the error state', () async {
    // Arrange
    when(() => getProviders(any()))
        .thenAnswer((_) async => const Left(Failure.network()));

    // Act
    await start();

    // Assert
    expect(bloc.state.status, UiStatus.failure);
    expect(bloc.state.loadFailure, ProviderFailure.network);
  });

  test('a failed refresh keeps the list and reports it once', () async {
    // Arrange
    await start();
    when(() => getProviders(any()))
        .thenAnswer((_) async => const Left(Failure.network()));

    // Act
    bloc.add(const ManageProvidersEvent.refreshed());
    await pumpEventQueue();

    // Assert
    expect(bloc.state.status, UiStatus.success);
    expect(bloc.state.providers, providers);
    expect(bloc.state.refreshFailure, ProviderFailure.network);
    expect(bloc.state.isRefreshing, isFalse);
  });

  test('searching filters by name or alias', () async {
    // Arrange
    await start();

    // Act
    bloc.add(const ManageProvidersEvent.queryChanged('TUNAI'));
    await pumpEventQueue();

    // Assert
    expect(bloc.state.shown.map((p) => p.id), ['a']);
  });

  test('reloads when a provider changes elsewhere', () async {
    // Arrange
    await start();
    final added = [...providers, adminProvider(id: 'c', name: 'OVO')];
    when(() => getProviders(any())).thenAnswer((_) async => Right(added));

    // Act
    events.emit('c');
    await pumpEventQueue();

    // Assert
    expect(bloc.state.providers, added);
    verify(() => getProviders(any())).called(2);
  });

  test('permissions follow the signed-in user', () async {
    // Arrange
    await start();

    // Act
    users.add(Right(userWith({kProviderCreatePermission})));
    await pumpEventQueue();

    // Assert
    expect(bloc.state.canCreate, isTrue);
    expect(bloc.state.canEdit, isFalse);
  });

  test('only the latest of overlapping loads lands', () async {
    // Arrange
    await start();
    final slow = Completer<Either<Failure, List<AdminPaymentProvider>>>();
    final latest = [adminProvider(id: 'z', name: 'Zed')];
    when(() => getProviders(any())).thenAnswer((_) => slow.future);

    // Act
    bloc.add(const ManageProvidersEvent.refreshed());
    await pumpEventQueue();
    when(() => getProviders(any())).thenAnswer((_) async => Right(latest));
    bloc.add(const ManageProvidersEvent.refreshed());
    await pumpEventQueue();
    slow.complete(Right(providers));
    await pumpEventQueue();

    // Assert
    expect(bloc.state.providers, latest);
  });
}
