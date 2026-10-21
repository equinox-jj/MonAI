part of 'home_bloc.dart';

@freezed
abstract class HomeState with _$HomeState {
  const factory HomeState({
    @Default(UiStatus.initial) UiStatus status,
    HomeDashboard? dashboard,
    @Default(false) bool isRefreshing,
    @Default(false) bool isBalanceHidden,

    /// The month's budget was fetched, so a missing one means "not set".
    @Default(false) bool budgetLoaded,

    /// The month's transactions were fetched, so none means a first run.
    @Default(false) bool recentLoaded,
    HomeLoadFailure? loadFailure,
    HomeLoadFailure? refreshFailure,
  }) = _HomeState;
}
