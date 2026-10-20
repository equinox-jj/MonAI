part of 'settings_bloc.dart';

@freezed
abstract class SettingsState with _$SettingsState {
  const factory SettingsState({
    /// What the cache holds; empty values until its first read.
    @Default(SettingsOverview()) SettingsOverview overview,

    /// The installed version; empty until read, or when it can't be.
    @Default('') String appVersion,

    /// A sign-out is running: its row shows progress and taps are ignored.
    @Default(false) bool isSigningOut,

    /// Why the last sign-out failed; shown once as a snackbar.
    SettingsSignOutFailure? signOutFailure,
  }) = _SettingsState;
}
