import 'package:flutter_test/flutter_test.dart';
import 'package:monai/core/data/network/session_manager.dart';
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

  test('shows the expired notice once the session expires', () {
    // Arrange
    expect(cubit.state.notice, isNull);

    // Act
    sessionManager.notifyExpired();

    // Assert
    expect(cubit.state.notice, SignOutNotice.expired);
  });

  test('shows the password-changed notice after a password change', () {
    // Arrange
    expect(cubit.state.notice, isNull);

    // Act
    sessionManager.notifyPasswordChanged();

    // Assert
    expect(cubit.state.notice, SignOutNotice.passwordChanged);
  });

  test('starts with the notice of a session already ended', () async {
    // Arrange
    sessionManager.notifyPasswordChanged();

    // Act
    final restarted = SessionExpiredCubit(sessionManager);
    addTearDown(restarted.close);

    // Assert
    expect(restarted.state.notice, SignOutNotice.passwordChanged);
  });

  test('Sign in again signs out and hides the dialog', () {
    // Arrange
    sessionManager.notifyExpired();

    // Act
    cubit.signInAgainPressed();

    // Assert
    expect(sessionManager.status.value, SessionStatus.signedOut);
    expect(cubit.state.notice, isNull);
  });

  test('Sign in after a password change signs out and hides it', () {
    // Arrange
    sessionManager.notifyPasswordChanged();

    // Act
    cubit.signInAgainPressed();

    // Assert
    expect(sessionManager.status.value, SessionStatus.signedOut);
    expect(cubit.state.notice, isNull);
  });
}
