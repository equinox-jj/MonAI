part of 'settings_bloc.dart';

@freezed
sealed class SettingsEvent with _$SettingsEvent {
  /// The screen opened.
  const factory SettingsEvent.started() = _Started;

  /// A sign-out was confirmed in its dialog; [allDevices] signs out
  /// everywhere.
  const factory SettingsEvent.signOutConfirmed({required bool allDevices}) =
      _SignOutConfirmed;

  /// The cache changed. Sent by the bloc itself.
  const factory SettingsEvent.overviewChanged(SettingsOverview overview) =
      _OverviewChanged;
}
