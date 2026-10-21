import 'dart:async';

import 'package:flutter_test/flutter_test.dart';
import 'package:fpdart/fpdart.dart';
import 'package:mocktail/mocktail.dart';
import 'package:monai/core/error/failure.dart';
import 'package:monai/core/error/field_error.dart';
import 'package:monai/core/model/ui_status.dart';
import 'package:monai/core/model/wallet_type.dart';
import 'package:monai/core/services/avatar_photo_service.dart';
import 'package:monai/core/usecase/usecase.dart';
import 'package:monai/features/settings/domain/entity/admin_payment_provider.dart';
import 'package:monai/features/settings/domain/logic/provider_rules.dart';
import 'package:monai/features/settings/domain/usecase/create_provider_usecase.dart';
import 'package:monai/features/settings/domain/usecase/delete_provider_usecase.dart';
import 'package:monai/features/settings/domain/usecase/get_admin_provider_usecase.dart';
import 'package:monai/features/settings/domain/usecase/set_provider_active_usecase.dart';
import 'package:monai/features/settings/domain/usecase/update_provider_usecase.dart';
import 'package:monai/features/settings/presentation/model/provider_failure.dart';
import 'package:monai/features/settings/presentation/pages/provider_form/bloc/provider_form_bloc.dart';
import 'package:monai/features/shared/domain/entity/user.dart';
import 'package:monai/features/shared/domain/usecase/watch_user_usecase.dart';

import '../../../../../../helpers/entity_fixtures.dart';

class _MockWatchUser extends Mock implements WatchUserUseCase {}

class _MockGetProvider extends Mock implements GetAdminProviderUseCase {}

class _MockCreate extends Mock implements CreateProviderUseCase {}

class _MockUpdate extends Mock implements UpdateProviderUseCase {}

class _MockSetActive extends Mock implements SetProviderActiveUseCase {}

class _MockDelete extends Mock implements DeleteProviderUseCase {}

class _MockPhotos extends Mock implements AvatarPhotoService {}

final _admin = userWith({
  kProviderCreatePermission,
  kProviderUpdatePermission,
  kProviderDeletePermission,
});

const _save = ProviderFormEvent.saveRequested(
  name: 'LinkAja',
  aliasInput: '',
  sortOrder: '100',
);

void main() {
  late _MockWatchUser watchUser;
  late _MockGetProvider getProvider;
  late _MockCreate create;
  late _MockUpdate update;
  late _MockSetActive setActive;
  late _MockDelete delete;
  late _MockPhotos photos;
  late StreamController<Either<Failure, User?>> users;

  setUpAll(() {
    registerFallbackValue(const NoParams());
    registerFallbackValue(
      const CreateProviderParams(
        input: ProviderInput(
          name: '',
          type: WalletType.cash,
          aliases: [],
          sortOrder: 0,
          isActive: true,
        ),
      ),
    );
    registerFallbackValue(
      UpdateProviderParams(
        original: adminProvider(),
        input: const ProviderInput(
          name: '',
          type: WalletType.cash,
          aliases: [],
          sortOrder: 0,
          isActive: true,
        ),
      ),
    );
    registerFallbackValue(const SetProviderActiveParams(id: '', active: true));
  });

  setUp(() {
    watchUser = _MockWatchUser();
    getProvider = _MockGetProvider();
    create = _MockCreate();
    update = _MockUpdate();
    setActive = _MockSetActive();
    delete = _MockDelete();
    photos = _MockPhotos();
    users = StreamController.broadcast();
    when(() => watchUser(any())).thenAnswer((_) => users.stream);
    when(() => getProvider('p1'))
        .thenAnswer((_) async => Right(adminProvider()));
  });

  tearDown(() => users.close());

  /// A started form for [providerId], with an admin signed in.
  Future<ProviderFormBloc> started({String? providerId}) async {
    final bloc = ProviderFormBloc(
      providerId: providerId,
      watchUser: watchUser,
      getProvider: getProvider,
      create: create,
      update: update,
      setActive: setActive,
      delete: delete,
      photos: photos,
    );
    addTearDown(bloc.close);
    bloc.add(const ProviderFormEvent.started());
    await pumpEventQueue();
    users.add(Right(_admin));
    await pumpEventQueue();
    return bloc;
  }

  Future<void> send(ProviderFormBloc bloc, ProviderFormEvent event) async {
    bloc.add(event);
    await pumpEventQueue();
  }

  group('a new provider', () {
    test('is ready once it has a name and a type', () async {
      // Arrange
      final bloc = await started();
      expect(bloc.state.isReady, isFalse);

      // Act
      await send(bloc, const ProviderFormEvent.nameEdited('Link Aja'));
      await send(bloc, const ProviderFormEvent.typePicked(WalletType.eWallet));

      // Assert
      expect(bloc.state.isReady, isTrue);
      expect(bloc.state.slug, 'link-aja');
    });

    test('a comma adds the aliases typed before it', () async {
      // Arrange
      final bloc = await started();

      // Act
      await send(bloc, const ProviderFormEvent.aliasTyped('LinkAja, link'));

      // Assert
      expect(bloc.state.aliases, ['linkaja', 'link']);
      expect(bloc.state.aliasInputResets, 1);
    });

    test('Save folds in the alias still being typed', () async {
      // Arrange
      final bloc = await started();
      await send(bloc, const ProviderFormEvent.typePicked(WalletType.eWallet));
      when(() => create(any())).thenAnswer(
        (_) async => Right(SavedProvider(provider: adminProvider())),
      );

      // Act
      await send(
        bloc,
        const ProviderFormEvent.saveRequested(
          name: 'LinkAja',
          aliasInput: 'linkaja',
          sortOrder: '100',
        ),
      );

      // Assert
      final params =
          verify(() => create(captureAny())).captured.single
              as CreateProviderParams;
      expect(params.input.aliases, ['linkaja']);
      expect(params.input.sortOrder, 100);
      expect(bloc.state.done, isTrue);
    });

    test('the status switch only changes the form', () async {
      // Arrange
      final bloc = await started();

      // Act
      await send(bloc, const ProviderFormEvent.activeToggled(active: false));

      // Assert
      expect(bloc.state.isActive, isFalse);
      expect(bloc.state.dialog, isNull);
      verifyNever(() => setActive(any()));
    });

    test('field errors land on their fields', () async {
      // Arrange
      final bloc = await started();
      await send(bloc, const ProviderFormEvent.typePicked(WalletType.bank));
      when(() => create(any())).thenAnswer(
        (_) async => const Left(
          Failure.validation([
            FieldError(field: 'aliases[0]', code: 'max_length', message: ''),
          ]),
        ),
      );

      // Act
      await send(bloc, _save);

      // Assert
      expect(bloc.state.aliasError?.field, 'aliases[0]');
      expect(bloc.state.isSaving, isFalse);
      expect(bloc.state.done, isFalse);
    });

    test('a conflict is reported, and the form stays', () async {
      // Arrange
      final bloc = await started();
      await send(bloc, const ProviderFormEvent.typePicked(WalletType.bank));
      when(() => create(any()))
          .thenAnswer((_) async => const Left(Failure.conflict()));

      // Act
      await send(bloc, _save);

      // Assert
      expect(bloc.state.actionFailure, ProviderFailure.conflict);
      expect(bloc.state.done, isFalse);
    });

    test('a failed logo stays on the saved provider to retry it', () async {
      // Arrange
      final bloc = await started();
      await send(bloc, const ProviderFormEvent.typePicked(WalletType.bank));
      when(() => photos.pick(AvatarPhotoSource.gallery))
          .thenAnswer((_) async => '/logo.png');
      await send(bloc, const ProviderFormEvent.logoPickRequested());
      when(() => create(any())).thenAnswer(
        (_) async => Right(
          SavedProvider(
            provider: adminProvider(),
            logoFailure: const Failure.unknown(code: 'photo_too_large'),
          ),
        ),
      );

      // Act
      await send(bloc, _save);

      // Assert
      expect(bloc.state.done, isFalse);
      expect(bloc.state.logoFailed, isTrue);
      expect(bloc.state.original?.id, 'p1');
      expect(bloc.state.newLogoPath, '/logo.png');
    });

    test('without the create permission it can not be saved', () async {
      // Arrange
      final bloc = await started();
      users.add(Right(userWith({kProviderUpdatePermission})));
      await pumpEventQueue();
      await send(bloc, const ProviderFormEvent.typePicked(WalletType.bank));

      // Act
      await send(bloc, _save);

      // Assert
      expect(bloc.state.canSave, isFalse);
      verifyNever(() => create(any()));
    });
  });

  group('an existing provider', () {
    test('loads and fills the form', () async {
      // Arrange
      // (GoPay from setUp)

      // Act
      final bloc = await started(providerId: 'p1');

      // Assert
      expect(bloc.state.status, UiStatus.success);
      expect(bloc.state.type, WalletType.eWallet);
      expect(bloc.state.aliases, ['gopay', 'gpay']);
      expect(bloc.state.slug, 'gopay');
      expect(bloc.state.canDelete, isTrue);
    });

    test('a failed load can be retried', () async {
      // Arrange
      when(() => getProvider('p1'))
          .thenAnswer((_) async => const Left(Failure.notFound()));
      final bloc = await started(providerId: 'p1');
      expect(bloc.state.loadFailure, ProviderFailure.notFound);
      when(() => getProvider('p1'))
          .thenAnswer((_) async => Right(adminProvider()));

      // Act
      await send(bloc, const ProviderFormEvent.retried());

      // Assert
      expect(bloc.state.status, UiStatus.success);
    });

    test('deactivating asks first, then applies at once', () async {
      // Arrange
      final bloc = await started(providerId: 'p1');
      when(() => setActive(any()))
          .thenAnswer((_) async => Right(adminProvider(isActive: false)));

      // Act
      await send(bloc, const ProviderFormEvent.activeToggled(active: false));
      final asked = bloc.state.dialog;
      await send(bloc, const ProviderFormEvent.dialogConfirmed());

      // Assert
      expect(asked, ProviderFormDialog.deactivate);
      expect(bloc.state.dialog, isNull);
      expect(bloc.state.isActive, isFalse);
      final params =
          verify(() => setActive(captureAny())).captured.single
              as SetProviderActiveParams;
      expect(params.active, isFalse);
    });

    test('dismissing the dialog changes nothing', () async {
      // Arrange
      final bloc = await started(providerId: 'p1');
      await send(bloc, const ProviderFormEvent.activeToggled(active: false));

      // Act
      await send(bloc, const ProviderFormEvent.dialogDismissed());

      // Assert
      expect(bloc.state.dialog, isNull);
      expect(bloc.state.isActive, isTrue);
      verifyNever(() => setActive(any()));
    });

    test('activating applies at once without asking', () async {
      // Arrange
      when(() => getProvider('p1'))
          .thenAnswer((_) async => Right(adminProvider(isActive: false)));
      final bloc = await started(providerId: 'p1');
      when(() => setActive(any()))
          .thenAnswer((_) async => Right(adminProvider()));

      // Act
      await send(bloc, const ProviderFormEvent.activeToggled(active: true));

      // Assert
      expect(bloc.state.dialog, isNull);
      expect(bloc.state.isActive, isTrue);
    });

    test('a system provider can not be switched off or deleted', () async {
      // Arrange
      when(() => getProvider('p1'))
          .thenAnswer((_) async => Right(adminProvider(isSystem: true)));
      final bloc = await started(providerId: 'p1');

      // Act
      await send(bloc, const ProviderFormEvent.activeToggled(active: false));
      await send(bloc, const ProviderFormEvent.deleteRequested());

      // Assert
      expect(bloc.state.dialog, isNull);
      expect(bloc.state.canDelete, isFalse);
    });

    test('deleting asks first, then closes the form', () async {
      // Arrange
      final bloc = await started(providerId: 'p1');
      when(() => delete('p1')).thenAnswer((_) async => const Right(unit));

      // Act
      await send(bloc, const ProviderFormEvent.deleteRequested());
      final asked = bloc.state.dialog;
      await send(bloc, const ProviderFormEvent.dialogConfirmed());

      // Assert
      expect(asked, ProviderFormDialog.delete);
      expect(bloc.state.done, isTrue);
    });

    test('a failed delete is reported and the form stays', () async {
      // Arrange
      final bloc = await started(providerId: 'p1');
      when(() => delete('p1')).thenAnswer(
        (_) async =>
            const Left(Failure.conflict(code: 'system_provider_locked')),
      );

      // Act
      await send(bloc, const ProviderFormEvent.deleteRequested());
      await send(bloc, const ProviderFormEvent.dialogConfirmed());

      // Assert
      expect(bloc.state.actionFailure, ProviderFailure.locked);
      expect(bloc.state.done, isFalse);
      expect(bloc.state.isDeleting, isFalse);
    });

    test('Save sends the form over the loaded provider', () async {
      // Arrange
      final bloc = await started(providerId: 'p1');
      when(() => update(any())).thenAnswer(
        (_) async => Right(SavedProvider(provider: adminProvider())),
      );

      // Act
      await send(
        bloc,
        const ProviderFormEvent.saveRequested(
          name: 'GoPay',
          aliasInput: '',
          sortOrder: '70',
        ),
      );

      // Assert
      final params =
          verify(() => update(captureAny())).captured.single
              as UpdateProviderParams;
      expect(params.original.id, 'p1');
      expect(params.input.sortOrder, 70);
      expect(bloc.state.done, isTrue);
    });
  });
}
