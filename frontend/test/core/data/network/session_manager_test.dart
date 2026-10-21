import 'package:flutter_test/flutter_test.dart';
import 'package:monai/core/data/network/session_manager.dart';

void main() {
  late SessionManager sessionManager;

  setUp(() => sessionManager = SessionManager());

  tearDown(() => sessionManager.dispose());

  test('starts signed out', () {
    // Arrange
    // (the manager from setUp)

    // Act
    final status = sessionManager.status.value;

    // Assert
    expect(status, SessionStatus.signedOut);
  });

  test('a signed-in session expires', () {
    // Arrange
    sessionManager.signedIn();

    // Act
    sessionManager.notifyExpired();

    // Assert
    expect(sessionManager.status.value, SessionStatus.expired);
  });

  test('expiry is ignored unless signed in', () {
    // Arrange
    final changes = <SessionStatus>[];
    sessionManager.status.addListener(
      () => changes.add(sessionManager.status.value),
    );

    // Act
    sessionManager.notifyExpired();
    sessionManager
      ..signedIn()
      ..notifyExpired()
      ..notifyExpired();

    // Assert
    expect(changes, [SessionStatus.signedIn, SessionStatus.expired]);
  });

  test('a signed-in session ends on a password change', () {
    // Arrange
    sessionManager.signedIn();

    // Act
    sessionManager.notifyPasswordChanged();

    // Assert
    expect(sessionManager.status.value, SessionStatus.passwordChanged);
  });

  test('a password change is ignored unless signed in', () {
    // Arrange
    // (signed out, from setUp)

    // Act
    sessionManager.notifyPasswordChanged();

    // Assert
    expect(sessionManager.status.value, SessionStatus.signedOut);
  });

  test('signing out leaves an expired session', () {
    // Arrange
    sessionManager
      ..signedIn()
      ..notifyExpired();

    // Act
    sessionManager.signedOut();

    // Assert
    expect(sessionManager.status.value, SessionStatus.signedOut);
  });
}
