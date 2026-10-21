import 'dart:typed_data';

import 'package:flutter_test/flutter_test.dart';
import 'package:fpdart/fpdart.dart';
import 'package:mocktail/mocktail.dart';
import 'package:monai/core/base/error/failure.dart';
import 'package:monai/core/data/network/session_manager.dart';
import 'package:monai/core/base/usecase.dart';
import 'package:monai/features/profile/domain/repository/profile_repository.dart';
import 'package:monai/features/profile/domain/usecase/change_avatar_usecase.dart';
import 'package:monai/features/profile/domain/usecase/delete_account_usecase.dart';
import 'package:monai/features/profile/domain/usecase/update_profile_name_usecase.dart';
import 'package:monai/features/profile/domain/validation/profile_input_validator.dart';
import 'package:monai/features/shared/domain/usecase/logout_usecase.dart';

import '../../../../helpers/entity_fixtures.dart';

class _MockRepository extends Mock implements ProfileRepository {}

class _MockLogout extends Mock implements LogoutUseCase {}

void main() {
  late _MockRepository repository;

  setUpAll(() {
    registerFallbackValue(const NoParams());
    registerFallbackValue(Uint8List(0));
  });

  setUp(() => repository = _MockRepository());

  group('UpdateProfileNameUseCase', () {
    test('saves the name without surrounding spaces', () async {
      // Arrange
      when(() => repository.updateName(any()))
          .thenAnswer((_) async => Right(user(name: 'Ana')));

      // Act
      await UpdateProfileNameUseCase(repository)('  Ana  ');

      // Assert
      verify(() => repository.updateName('Ana')).called(1);
    });

    test('a blank name fails without calling the server', () async {
      // Act
      final result = await UpdateProfileNameUseCase(repository)('   ');

      // Assert
      final failure = result.getLeft().toNullable();
      expect(failure, isA<ValidationFailure>());
      expect(
        (failure! as ValidationFailure).fieldErrors.single.code,
        'required',
      );
      verifyNever(() => repository.updateName(any()));
    });

    test('a name over 100 characters fails', () async {
      // Act
      final result = await UpdateProfileNameUseCase(repository)('a' * 101);

      // Assert
      final failure = result.getLeft().toNullable()! as ValidationFailure;
      expect(failure.fieldErrors.single.field, ProfileInputValidator.nameField);
      expect(failure.fieldErrors.single.code, 'max_length');
    });
  });

  group('ChangeAvatarUseCase', () {
    test('uploads the compressed photo', () async {
      // Arrange
      final bytes = Uint8List(3);
      when(() => repository.compressAvatar(any()))
          .thenAnswer((_) async => Right(bytes));
      when(
        () => repository.uploadAvatar(
          any(),
          onProgress: any(named: 'onProgress'),
        ),
      ).thenAnswer((_) async => Right(user()));

      // Act
      final result = await ChangeAvatarUseCase(repository)(
        const ChangeAvatarParams(path: '/tmp/me.jpg'),
      );

      // Assert
      expect(result.isRight(), isTrue);
      verify(() => repository.compressAvatar('/tmp/me.jpg')).called(1);
      verify(
        () => repository.uploadAvatar(
          bytes,
          onProgress: any(named: 'onProgress'),
        ),
      ).called(1);
    });

    test('a photo that cannot be shrunk is not uploaded', () async {
      // Arrange
      when(() => repository.compressAvatar(any())).thenAnswer(
        (_) async => const Left(Failure.unknown(code: 'photo_too_large')),
      );

      // Act
      final result = await ChangeAvatarUseCase(repository)(
        const ChangeAvatarParams(path: '/tmp/me.jpg'),
      );

      // Assert
      expect(result.getLeft().toNullable()?.code, 'photo_too_large');
      verifyNever(
        () => repository.uploadAvatar(
          any(),
          onProgress: any(named: 'onProgress'),
        ),
      );
    });
  });

  group('DeleteAccountUseCase', () {
    late _MockLogout logout;
    late DeleteAccountUseCase useCase;

    setUp(() {
      logout = _MockLogout();
      useCase = DeleteAccountUseCase(repository: repository, logout: logout);
      when(() => logout(any()))
          .thenAnswer((_) async => const Right(SessionStatus.signedOut));
    });

    test('deletes the account, then signs out', () async {
      // Arrange
      when(() => repository.deleteAccount(any()))
          .thenAnswer((_) async => const Right(unit));

      // Act
      final result = await useCase('secret123');

      // Assert
      expect(result, const Right<Failure, Unit>(unit));
      verifyInOrder([
        () => repository.deleteAccount('secret123'),
        () => logout(any()),
      ]);
    });

    test('an empty password fails without calling the server', () async {
      // Act
      final result = await useCase('');

      // Assert
      expect(result.getLeft().toNullable(), isA<ValidationFailure>());
      verifyNever(() => repository.deleteAccount(any()));
    });

    test('a refused delete keeps the session', () async {
      // Arrange
      when(() => repository.deleteAccount(any())).thenAnswer(
        (_) async =>
            const Left(Failure.validation([], code: 'invalid_password')),
      );

      // Act
      final result = await useCase('wrong');

      // Assert
      expect(result.getLeft().toNullable()?.code, 'invalid_password');
      verifyNever(() => logout(any()));
    });
  });
}
