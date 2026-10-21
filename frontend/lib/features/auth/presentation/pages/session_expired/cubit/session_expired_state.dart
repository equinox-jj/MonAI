part of 'session_expired_cubit.dart';

/// Why the app signed the user out while they were using it.
enum SignOutNotice {
  /// The server rejected the token.
  expired,

  /// The password was changed, which signs out every device.
  passwordChanged,
}

@freezed
abstract class SessionExpiredState with _$SessionExpiredState {
  const factory SessionExpiredState({
    /// The dialog to show until the user signs in again; null for none.
    SignOutNotice? notice,
  }) = _SessionExpiredState;
}
