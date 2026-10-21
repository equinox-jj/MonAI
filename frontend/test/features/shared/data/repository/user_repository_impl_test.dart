import 'package:flutter_test/flutter_test.dart';
import 'package:fpdart/fpdart.dart';
import 'package:mocktail/mocktail.dart';
import 'package:monai/core/data/database/monai_database.dart';
import 'package:monai/core/base/error/failure.dart';
import 'package:monai/features/shared/data/datasources/user_local_datasource.dart';
import 'package:monai/features/shared/data/datasources/user_remote_datasource.dart';
import 'package:monai/features/shared/data/mapper/user_mapper.dart';
import 'package:monai/features/shared/data/model/me_response.dart';
import 'package:monai/features/shared/data/repository/user_repository_impl.dart';
import 'package:monai/features/shared/domain/entity/user.dart';

import '../../../../helpers/api_fixtures.dart';
import '../../../../helpers/database_fixtures.dart';

class _MockRemote extends Mock implements UserRemoteDataSource {}

class _MockLocal extends Mock implements UserLocalDataSource {}

void main() {
  late _MockRemote remote;
  late _MockLocal local;
  late UserRepositoryImpl repository;

  setUpAll(() => registerFallbackValue(userRow()));

  setUp(() {
    remote = _MockRemote();
    local = _MockLocal();
    repository = UserRepositoryImpl(remote: remote, local: local);
  });

  test('caches the user with sorted permissions', () async {
    // Arrange
    when(() => remote.getMe())
        .thenAnswer((_) async => MeResponse.fromJson(envelope(meJson())));
    when(() => local.replace(any())).thenAnswer((_) async {});

    // Act
    final result = await repository.refreshUser();

    // Assert
    final row =
        verify(() => local.replace(captureAny())).captured.single as UserRow;
    expect(result, Right<Failure, User>(row.toEntity()));
    expect(row.permissions, ['transactions.read', 'wallet.update']);
    expect(row.roleSlug, 'user');
  });

  test('a user without a role is malformed and not cached', () async {
    // Arrange
    when(() => remote.getMe()).thenAnswer(
      (_) async => MeResponse.fromJson(envelope({...meJson(), 'role': null})),
    );

    // Act
    final result = await repository.refreshUser();

    // Assert
    expect(result.getLeft().toNullable(), isA<UnknownFailure>());
    verifyNever(() => local.replace(any()));
  });

  test('watchUser maps the cached row', () async {
    // Arrange
    when(() => local.watch()).thenAnswer((_) => Stream.value(userRow()));

    // Act
    final result = await repository.watchUser().first;

    // Assert
    final user = result.getRight().toNullable();
    expect(user?.hasPermission('transactions.read'), isTrue);
    expect(user?.role.name, 'User');
  });
}
