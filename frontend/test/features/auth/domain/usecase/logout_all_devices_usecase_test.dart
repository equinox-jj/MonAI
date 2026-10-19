import 'package:flutter_test/flutter_test.dart';
import 'package:fpdart/fpdart.dart';
import 'package:mocktail/mocktail.dart';
import 'package:monai/core/error/failure.dart';
import 'package:monai/core/network/session_manager.dart';
import 'package:monai/core/usecase/usecase.dart';
import 'package:monai/features/auth/domain/repository/auth_repository.dart';
import 'package:monai/features/auth/domain/usecase/logout_all_devices_usecase.dart';

class _MockAuthRepository extends Mock implements AuthRepository {}

void main() {
  test('signs out of every device', () async {
    // Arrange
    final repository = _MockAuthRepository();
    when(() => repository.logoutAllDevices())
        .thenAnswer((_) async => const Right(SessionStatus.signedOut));

    // Act
    final result = await LogoutAllDevicesUseCase(repository)(const NoParams());

    // Assert
    expect(
      result,
      const Right<Failure, SessionStatus>(SessionStatus.signedOut),
    );
    verify(() => repository.logoutAllDevices()).called(1);
  });
}
