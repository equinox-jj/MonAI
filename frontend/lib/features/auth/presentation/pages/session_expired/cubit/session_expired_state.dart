part of 'session_expired_cubit.dart';

@freezed
abstract class SessionExpiredState with _$SessionExpiredState {
  const factory SessionExpiredState({
    /// The server rejected the token; the dialog is shown until the user
    /// signs in again.
    @Default(false) bool expired,
  }) = _SessionExpiredState;
}
