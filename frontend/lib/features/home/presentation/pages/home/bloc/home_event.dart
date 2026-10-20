part of 'home_bloc.dart';

@freezed
sealed class HomeEvent with _$HomeEvent {
  /// The screen opened.
  const factory HomeEvent.started() = _Started;

  /// Pull-to-refresh, or "Try again" on the error.
  const factory HomeEvent.refreshed() = _Refreshed;

  /// The eye on the balance card was tapped.
  const factory HomeEvent.balanceVisibilityToggled() =
      _BalanceVisibilityToggled;

  /// The cache changed. Sent by the bloc itself.
  const factory HomeEvent.dashboardChanged(HomeDashboard dashboard) =
      _DashboardChanged;
}
