part of 'settings_bloc.dart';

@freezed
abstract class SettingsState with _$SettingsState {
  const factory SettingsState({
    @Default(SettingsOverview()) SettingsOverview overview,
    @Default('') String appVersion,
    @Default(false) bool isSigningOut,
    SettingsSignOutFailure? signOutFailure,
  }) = _SettingsState;
}
