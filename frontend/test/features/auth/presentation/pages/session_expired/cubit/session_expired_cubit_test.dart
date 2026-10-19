import 'package:flutter_test/flutter_test.dart';
import 'package:monai/core/network/session_manager.dart';
import 'package:monai/features/auth/presentation/pages/session_expired/cubit/session_expired_cubit.dart';

void main() {
  late SessionManager sessionManager;
  late SessionExpiredCubit cubit;

  setUp(() {
    sessionManager = SessionManager()..signedIn();
    cubit = SessionExpiredCubit(sessionManager);
  });

  tearDown(() async {
    await cubit.close();
    sessionManager.dispose();
  });

  test('shows the dialog once the session expires', () {
    // Arrange
    expect(cubit.state.expired, isFalse);

    // Act
    sessionManager.notifyExpired();

    // Assert
    expect(cubit.state.expired, isTrue);
  });

  test('Sign in again signs out and hides the dialog', () {
    // Arrange
    sessionManager.notifyExpired();

    // Act
    cubit.signInAgainPressed();

    // Assert
    expect(sessionManager.status.value, SessionStatus.signedOut);
    expect(cubit.state.expired, isFalse);
  });
}
