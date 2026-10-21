import 'package:flutter/foundation.dart';

enum SessionStatus {
  signedOut,
  signedIn,

  /// The server rejected the token, which is already cleared. The app stays on
  /// the current screen behind the session-expired dialog until the user signs
  /// in again.
  expired,

  /// The password was changed, signing out every device. Like [expired], but
  /// behind the password-changed dialog.
  passwordChanged,
}

class SessionManager {
  final _status = ValueNotifier(SessionStatus.signedOut);

  ValueListenable<SessionStatus> get status => _status;

  void signedIn() => _status.value = .signedIn;

  void signedOut() => _status.value = .signedOut;

  /// Only a signed-in session can expire, so several requests failing at once
  /// show one dialog.
  void notifyExpired() {
    if (_status.value == .signedIn) _status.value = .expired;
  }

  void notifyPasswordChanged() {
    if (_status.value == .signedIn) _status.value = .passwordChanged;
  }

  void dispose() => _status.dispose();
}
