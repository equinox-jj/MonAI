part of 'settings_bloc.dart';

@freezed
sealed class SettingsEvent with _$SettingsEvent {
  const factory SettingsEvent.started() = _Started;

  const factory SettingsEvent.signOutConfirmed({required bool allDevices}) =
      _SignOutConfirmed;

  const factory SettingsEvent.overviewChanged(SettingsOverview overview) =
      _OverviewChanged;
}
