import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:monai/core/data/network/session_manager.dart';

part 'session_expired_cubit.freezed.dart';
part 'session_expired_state.dart';

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

  void signInAgainPressed() => _sessionManager.signedOut();

  @override
  Future<void> close() {
    _sessionManager.status.removeListener(_onStatusChanged);
    return super.close();
  }
}
