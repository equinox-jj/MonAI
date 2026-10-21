part of 'manage_providers_bloc.dart';

@freezed
sealed class ManageProvidersEvent with _$ManageProvidersEvent {
  const factory ManageProvidersEvent.started() = _Started;
  const factory ManageProvidersEvent.userChanged(User? user) = _UserChanged;
  const factory ManageProvidersEvent.queryChanged(String query) = _QueryChanged;

  const factory ManageProvidersEvent.refreshed({@Default(false) bool quiet}) =
      _Refreshed;
}
