import 'dart:typed_data';

import 'package:flutter_test/flutter_test.dart';
import 'package:fpdart/fpdart.dart';
import 'package:mocktail/mocktail.dart';
import 'package:monai/core/database/monai_database.dart';
import 'package:monai/core/error/exceptions.dart';
import 'package:monai/core/error/failure.dart';
import 'package:monai/core/services/image_compressor_service.dart';
import 'package:monai/features/profile/data/datasources/profile_local_datasource.dart';
import 'package:monai/features/profile/data/datasources/profile_remote_datasource.dart';
import 'package:monai/features/profile/data/model/delete_account_request.dart';
import 'package:monai/features/profile/data/model/update_profile_request.dart';
import 'package:monai/features/profile/data/repository/profile_repository_impl.dart';
import 'package:monai/features/shared/data/model/me_response.dart';

import '../../../../helpers/api_fixtures.dart';
import '../../../../helpers/database_fixtures.dart';

class _MockRemote extends Mock implements ProfileRemoteDataSource {}

class _MockLocal extends Mock implements ProfileLocalDataSource {}

class _MockCompressor extends Mock implements ImageCompressorService {}

void main() {
  late _MockRemote remote;
  late _MockLocal local;
  late _MockCompressor compressor;
  late ProfileRepositoryImpl repository;

  final me = MeResponse.fromJson(envelope({...meJson(), 'name': 'Ana'}));

  setUpAll(() {
    registerFallbackValue(const UpdateProfileRequest(name: ''));
    registerFallbackValue(const DeleteAccountRequest(password: ''));
    registerFallbackValue(userRow());
    registerFallbackValue(Uint8List(0));
  });

  setUp(() {
    remote = _MockRemote();
    local = _MockLocal();
    compressor = _MockCompressor();
    repository = ProfileRepositoryImpl(
      remote: remote,
      local: local,
      compressor: compressor,
    );
    when(() => local.saveUser(any())).thenAnswer((_) async {});
  });

  test('a new name is sent, cached and given back', () async {
    // Arrange
    when(() => remote.updateProfile(any())).thenAnswer((_) async => me);

    // Act
    final result = await repository.updateName('Ana');

    // Assert
    expect(result.getOrElse((_) => throw StateError('')).name, 'Ana');
    verify(() => remote.updateProfile(const UpdateProfileRequest(name: 'Ana')))
        .called(1);
    final cached = verify(() => local.saveUser(captureAny())).captured.single;
    expect((cached as UserRow).name, 'Ana');
  });

  test('a photo is uploaded as WebP and the user cached', () async {
    // Arrange
    final bytes = Uint8List(10);
    when(
      () => remote.uploadAvatar(
        any(),
        filename: any(named: 'filename'),
        onProgress: any(named: 'onProgress'),
      ),
    ).thenAnswer((_) async => me);

    // Act
    final result = await repository.uploadAvatar(bytes);

    // Assert
    expect(result.isRight(), isTrue);
    verify(
      () => remote.uploadAvatar(
        bytes,
        filename: 'avatar.webp',
        onProgress: any(named: 'onProgress'),
      ),
    ).called(1);
    verify(() => local.saveUser(any())).called(1);
  });

  test('removing the photo clears it from the cache too', () async {
    // Arrange
    when(() => remote.removeAvatar()).thenAnswer((_) async {});
    when(() => local.clearAvatar()).thenAnswer((_) async {});

    // Act
    final result = await repository.removeAvatar();

    // Assert
    expect(result, const Right<Failure, Unit>(unit));
    verify(() => local.clearAvatar()).called(1);
  });

  test('a failed removal keeps the cached photo', () async {
    // Arrange
    when(() => remote.removeAvatar()).thenThrow(const NetworkException());

    // Act
    final result = await repository.removeAvatar();

    // Assert
    expect(result.getLeft().toNullable(), isA<NetworkFailure>());
    verifyNever(() => local.clearAvatar());
  });

  test('deleting the account sends the password', () async {
    // Arrange
    when(() => remote.deleteAccount(any())).thenAnswer((_) async {});

    // Act
    final result = await repository.deleteAccount('secret123');

    // Assert
    expect(result, const Right<Failure, Unit>(unit));
    verify(
      () => remote.deleteAccount(
        const DeleteAccountRequest(password: 'secret123'),
      ),
    ).called(1);
  });

  test('a wrong password keeps its code', () async {
    // Arrange
    when(() => remote.deleteAccount(any())).thenThrow(
      const ValidationException(
        [],
        message: 'The password is incorrect',
        code: 'invalid_password',
      ),
    );

    // Act
    final result = await repository.deleteAccount('wrong');

    // Assert
    expect(result.getLeft().toNullable()?.code, 'invalid_password');
  });

  test('compressing passes the compressor error on', () async {
    // Arrange
    when(() => compressor.compressAvatar(any()))
        .thenThrow(const UnknownException(code: 'photo_too_large'));

    // Act
    final result = await repository.compressAvatar('/tmp/me.jpg');

    // Assert
    expect(result.getLeft().toNullable()?.code, 'photo_too_large');
  });
}
