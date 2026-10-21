part of 'session_expired_cubit.dart';

enum SignOutNotice { expired, passwordChanged }

@freezed
abstract class SessionExpiredState with _$SessionExpiredState {
  const factory SessionExpiredState({SignOutNotice? notice}) =
      _SessionExpiredState;
}
