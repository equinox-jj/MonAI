part of 'home_bloc.dart';

@freezed
sealed class HomeEvent with _$HomeEvent {
  const factory HomeEvent.started() = _Started;
  const factory HomeEvent.refreshed() = _Refreshed;

  const factory HomeEvent.balanceVisibilityToggled() =
      _BalanceVisibilityToggled;

  const factory HomeEvent.dashboardChanged(HomeDashboard dashboard) =
      _DashboardChanged;
}
