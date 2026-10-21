import 'package:flutter/foundation.dart';

/// Whether a user is signed in on this device.
enum SessionStatus {
  /// No token: the auth screens are shown.
  signedOut,

  /// A token is stored and the app is usable.
  signedIn,

  /// The server rejected the token. It is already cleared; the app stays on
  /// the current screen behind the session-expired dialog until the user
  /// chooses to sign in again.
  expired,

  /// The password was changed, which signed out every device. Like
  /// [expired], the token is already cleared and the app stays on the
  /// current screen behind the password-changed dialog until the user signs
  /// in again.
  passwordChanged,
}

/// Holds the session's [SessionStatus], so the router can follow sign-in,
/// sign-out and expiry without coupling networking to navigation.
class SessionManager {
  final _status = ValueNotifier(SessionStatus.signedOut);

  /// The current status; the router refreshes on every change.
  ValueListenable<SessionStatus> get status => _status;

  /// A token was stored.
  void signedIn() => _status.value = .signedIn;

  /// The token was removed, or the user acknowledged an expired session or
  /// a password change.
  void signedOut() => _status.value = .signedOut;

  /// The server rejected the token. Only a signed-in session can expire, so
  /// several requests failing at once show one dialog.
  void notifyExpired() {
    if (_status.value == .signedIn) _status.value = .expired;
  }

  /// The password was changed and the token cleared; shows the
  /// password-changed dialog. Only a signed-in session can end this way.
  void notifyPasswordChanged() {
    if (_status.value == .signedIn) _status.value = .passwordChanged;
  }

  /// Releases the listenable.
  void dispose() => _status.dispose();
}
