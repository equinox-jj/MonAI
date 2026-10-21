part of 'manage_providers_bloc.dart';

@freezed
sealed class ManageProvidersEvent with _$ManageProvidersEvent {
  /// The screen opened: load the list and follow the user and changes.
  const factory ManageProvidersEvent.started() = _Started;

  /// The signed-in user changed, and with it the permissions.
  const factory ManageProvidersEvent.userChanged(User? user) = _UserChanged;

  /// The search text changed.
  const factory ManageProvidersEvent.queryChanged(String query) = _QueryChanged;

  /// Pull-to-refresh or the error's retry; [quiet] for a reload after a
  /// change elsewhere, which shows no spinner.
  const factory ManageProvidersEvent.refreshed({@Default(false) bool quiet}) =
      _Refreshed;
}
