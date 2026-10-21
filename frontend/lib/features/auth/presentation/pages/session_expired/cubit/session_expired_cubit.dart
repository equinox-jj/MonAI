import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:monai/core/network/session_manager.dart';

part 'session_expired_cubit.freezed.dart';
part 'session_expired_state.dart';

/// Follows the session so the app can say why it signed the user out: the
/// session expired, or the password was changed.
class SessionExpiredCubit extends Cubit<SessionExpiredState> {
  SessionExpiredCubit(this._sessionManager)
    : super(_stateOf(_sessionManager.status.value)) {
    _sessionManager.status.addListener(_onStatusChanged);
  }

  final SessionManager _sessionManager;

  void _onStatusChanged() => emit(_stateOf(_sessionManager.status.value));

  static SessionExpiredState _stateOf(SessionStatus status) =>
      SessionExpiredState(
        notice: switch (status) {
          .expired => .expired,
          .passwordChanged => .passwordChanged,
          .signedIn || .signedOut => null,
        },
      );

  /// The token is already cleared; signing out sends the router to Sign in.
  void signInAgainPressed() => _sessionManager.signedOut();

  @override
  Future<void> close() {
    _sessionManager.status.removeListener(_onStatusChanged);
    return super.close();
  }
}
