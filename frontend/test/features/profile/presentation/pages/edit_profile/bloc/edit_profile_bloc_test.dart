import 'package:flutter_test/flutter_test.dart';
import 'package:fpdart/fpdart.dart';
import 'package:mocktail/mocktail.dart';
import 'package:monai/core/error/failure.dart';
import 'package:monai/core/error/field_error.dart';
import 'package:monai/core/services/avatar_photo_service.dart';
import 'package:monai/core/usecase/usecase.dart';
import 'package:monai/features/profile/domain/usecase/change_avatar_usecase.dart';
import 'package:monai/features/profile/domain/usecase/delete_account_usecase.dart';
import 'package:monai/features/profile/domain/usecase/remove_avatar_usecase.dart';
import 'package:monai/features/profile/domain/usecase/update_profile_name_usecase.dart';
import 'package:monai/features/profile/presentation/model/profile_failure.dart';
import 'package:monai/features/profile/presentation/pages/edit_profile/bloc/edit_profile_bloc.dart';
import 'package:monai/features/shared/domain/entity/user.dart';
import 'package:monai/features/shared/domain/usecase/watch_user_usecase.dart';

import '../../../../../../helpers/entity_fixtures.dart';

class _MockWatchUser extends Mock implements WatchUserUseCase {}

class _MockUpdateName extends Mock implements UpdateProfileNameUseCase {}

class _MockChangeAvatar extends Mock implements ChangeAvatarUseCase {}

class _MockRemoveAvatar extends Mock implements RemoveAvatarUseCase {}

class _MockDeleteAccount extends Mock implements DeleteAccountUseCase {}

class _MockPhotos extends Mock implements AvatarPhotoService {}

const _labels = AvatarCropLabels(title: 'Crop', done: 'Done', cancel: 'Cancel');

void main() {
  late _MockWatchUser watchUser;
  late _MockUpdateName updateName;
  late _MockChangeAvatar changeAvatar;
  late _MockRemoveAvatar removeAvatar;
  late _MockDeleteAccount deleteAccount;
  late _MockPhotos photos;

  final ana = user(name: 'Ana');

  setUpAll(() {
    registerFallbackValue(const NoParams());
    registerFallbackValue(const ChangeAvatarParams(path: ''));
    registerFallbackValue(AvatarPhotoSource.gallery);
  });

  setUp(() {
    watchUser = _MockWatchUser();
    updateName = _MockUpdateName();
    changeAvatar = _MockChangeAvatar();
    removeAvatar = _MockRemoveAvatar();
    deleteAccount = _MockDeleteAccount();
    photos = _MockPhotos();
    when(() => watchUser(any()))
        .thenAnswer((_) => Stream.value(Right<Failure, User?>(ana)));
  });

  Future<EditProfileBloc> started() async {
    final bloc = EditProfileBloc(
      watchUser: watchUser,
      updateName: updateName,
      changeAvatar: changeAvatar,
      removeAvatar: removeAvatar,
      deleteAccount: deleteAccount,
      photos: photos,
    )..add(const EditProfileEvent.started());
    await Future<void>.delayed(Duration.zero);
    await Future<void>.delayed(Duration.zero);
    addTearDown(bloc.close);
    return bloc;
  }

  Future<void> send(EditProfileBloc bloc, EditProfileEvent event) async {
    bloc.add(event);
    await Future<void>.delayed(Duration.zero);
    await Future<void>.delayed(Duration.zero);
  }

  List<T> collect<T>(EditProfileBloc bloc, T? Function(EditProfileState) of) {
    final seen = <T>[];
    bloc.stream.listen((state) {
      if (of(state) case final value?) seen.add(value);
    });
    return seen;
  }

  group('name', () {
    test('Save is offered only once the name changes', () async {
      // Arrange
      final bloc = await started();

      // Act
      await send(bloc, const EditProfileEvent.nameEdited('Ana '));
      final unchanged = bloc.state.canSave;
      await send(bloc, const EditProfileEvent.nameEdited('Ana Putri'));

      // Assert
      expect(unchanged, isFalse);
      expect(bloc.state.canSave, isTrue);
    });

    test('saving says so once and settles the name', () async {
      // Arrange
      when(() => updateName(any()))
          .thenAnswer((_) async => Right(user(name: 'Ana Putri')));
      final bloc = await started();
      await send(bloc, const EditProfileEvent.nameEdited('Ana Putri'));
      final notices = collect(bloc, (s) => s.notice);

      // Act
      await send(bloc, const EditProfileEvent.saveRequested('Ana Putri'));

      // Assert
      expect(notices, [ProfileNotice.nameSaved]);
      expect(bloc.state.canSave, isFalse);
      expect(bloc.state.user?.name, 'Ana Putri');
      verify(() => updateName('Ana Putri')).called(1);
    });

    test('a rejected name shows its error, checked again as typed', () async {
      // Arrange
      when(() => updateName(any())).thenAnswer(
        (_) async => const Left(
          Failure.validation([
            FieldError(field: 'name', code: 'required', message: ''),
          ]),
        ),
      );
      final bloc = await started();
      await send(bloc, const EditProfileEvent.nameEdited(' '));
      await send(bloc, const EditProfileEvent.saveRequested(' '));
      final error = bloc.state.nameError;

      // Act
      await send(bloc, const EditProfileEvent.nameEdited('Budi'));

      // Assert
      expect(error?.code, 'required');
      expect(bloc.state.nameError, isNull);
    });
  });

  group('photo', () {
    test('a picked and cropped photo is uploaded with progress', () async {
      // Arrange
      when(() => photos.pick(any())).thenAnswer((_) async => '/tmp/raw.jpg');
      when(
        () => photos.cropSquare(
          any(),
          title: any(named: 'title'),
          done: any(named: 'done'),
          cancel: any(named: 'cancel'),
        ),
      ).thenAnswer((_) async => '/tmp/square.jpg');
      when(() => changeAvatar(any())).thenAnswer((invocation) async {
        final params =
            invocation.positionalArguments.single as ChangeAvatarParams;
        params.onProgress?.call(0.5);
        return Right(ana);
      });
      final bloc = await started();
      final progress = collect(bloc, (s) => s.uploadProgress);
      final notices = collect(bloc, (s) => s.notice);

      // Act
      await send(
        bloc,
        const EditProfileEvent.photoSourcePicked(
          AvatarPhotoSource.camera,
          _labels,
        ),
      );

      // Assert
      expect(progress, [0, 0.5]);
      expect(notices, [ProfileNotice.photoUpdated]);
      expect(bloc.state.uploadProgress, isNull);
      verify(() => photos.pick(AvatarPhotoSource.camera)).called(1);
      final params =
          verify(() => changeAvatar(captureAny())).captured.single
              as ChangeAvatarParams;
      expect(params.path, '/tmp/square.jpg');
    });

    test('cancelling the crop uploads nothing', () async {
      // Arrange
      when(() => photos.pick(any())).thenAnswer((_) async => '/tmp/raw.jpg');
      when(
        () => photos.cropSquare(
          any(),
          title: any(named: 'title'),
          done: any(named: 'done'),
          cancel: any(named: 'cancel'),
        ),
      ).thenAnswer((_) async => null);
      final bloc = await started();

      // Act
      await send(
        bloc,
        const EditProfileEvent.photoSourcePicked(
          AvatarPhotoSource.gallery,
          _labels,
        ),
      );

      // Assert
      expect(bloc.state.isChangingPhoto, isFalse);
      verifyNever(() => changeAvatar(any()));
    });

    test('a photo too large says why once', () async {
      // Arrange
      when(() => photos.pick(any())).thenAnswer((_) async => '/tmp/raw.jpg');
      when(
        () => photos.cropSquare(
          any(),
          title: any(named: 'title'),
          done: any(named: 'done'),
          cancel: any(named: 'cancel'),
        ),
      ).thenAnswer((_) async => '/tmp/square.jpg');
      when(() => changeAvatar(any())).thenAnswer(
        (_) async => const Left(Failure.unknown(code: 'photo_too_large')),
      );
      final bloc = await started();
      final failures = collect(bloc, (s) => s.failure);

      // Act
      await send(
        bloc,
        const EditProfileEvent.photoSourcePicked(
          AvatarPhotoSource.gallery,
          _labels,
        ),
      );

      // Assert
      expect(failures, [ProfileFailure.photoTooLarge]);
      expect(bloc.state.failure, isNull);
      expect(bloc.state.uploadProgress, isNull);
    });

    test('removing the photo says so', () async {
      // Arrange
      when(() => watchUser(any())).thenAnswer(
        (_) => Stream.value(
          Right<Failure, User?>(ana.copyWith(avatarUrl: 'https://x/a.webp')),
        ),
      );
      when(() => removeAvatar(any()))
          .thenAnswer((_) async => const Right(unit));
      final bloc = await started();
      final notices = collect(bloc, (s) => s.notice);

      // Act
      await send(bloc, const EditProfileEvent.removePhotoRequested());

      // Assert
      expect(notices, [ProfileNotice.photoRemoved]);
      expect(bloc.state.isRemovingPhoto, isFalse);
    });

    test('there is nothing to remove without a photo', () async {
      // Arrange
      final bloc = await started();

      // Act
      await send(bloc, const EditProfileEvent.removePhotoRequested());

      // Assert
      verifyNever(() => removeAvatar(any()));
    });
  });

  group('delete account', () {
    test('an empty password asks for it instead of confirming', () async {
      // Arrange
      final bloc = await started();
      final asks = collect(bloc, (s) => s.askDelete ? true : null);

      // Act
      await send(bloc, const EditProfileEvent.deleteRequested(''));

      // Assert
      expect(asks, isEmpty);
      expect(bloc.state.passwordError?.code, 'required');
    });

    test('a typed password asks to confirm once', () async {
      // Arrange
      final bloc = await started();
      final asks = collect(bloc, (s) => s.askDelete ? true : null);

      // Act
      await send(bloc, const EditProfileEvent.deleteRequested('secret123'));

      // Assert
      expect(asks, [true]);
      expect(bloc.state.askDelete, isFalse);
    });

    test('confirming deletes the account', () async {
      // Arrange
      when(() => deleteAccount(any()))
          .thenAnswer((_) async => const Right(unit));
      final bloc = await started();

      // Act
      await send(bloc, const EditProfileEvent.deleteConfirmed('secret123'));

      // Assert
      verify(() => deleteAccount('secret123')).called(1);
      expect(bloc.state.isDeleting, isFalse);
    });

    test('a wrong password shows under the field', () async {
      // Arrange
      when(() => deleteAccount(any())).thenAnswer(
        (_) async =>
            const Left(Failure.validation([], code: 'invalid_password')),
      );
      final bloc = await started();

      // Act
      await send(bloc, const EditProfileEvent.deleteConfirmed('wrong'));

      // Assert
      expect(bloc.state.passwordError?.code, 'invalid_password');
      expect(bloc.state.isDeleting, isFalse);
    });

    test('typing clears the password error', () async {
      // Arrange
      final bloc = await started();
      await send(bloc, const EditProfileEvent.deleteRequested(''));

      // Act
      await send(bloc, const EditProfileEvent.passwordEdited());

      // Assert
      expect(bloc.state.passwordError, isNull);
    });

    test('the last admin is told why', () async {
      // Arrange
      when(() => deleteAccount(any())).thenAnswer(
        (_) async => const Left(Failure.validation([], code: 'last_admin')),
      );
      final bloc = await started();
      final failures = collect(bloc, (s) => s.failure);

      // Act
      await send(bloc, const EditProfileEvent.deleteConfirmed('secret123'));

      // Assert
      expect(failures, [ProfileFailure.lastAdmin]);
    });
  });
}
