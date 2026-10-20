part of 'home_bloc.dart';

@freezed
abstract class HomeState with _$HomeState {
  const factory HomeState({
    /// [UiStatus.loading] while the first load runs with nothing cached
    /// (the skeleton), [UiStatus.failure] when that load failed (the error),
    /// otherwise [UiStatus.success] (the dashboard).
    @Default(UiStatus.initial) UiStatus status,

    /// What the cache holds; null before its first read.
    HomeDashboard? dashboard,

    /// A refresh is running.
    @Default(false) bool isRefreshing,

    /// The eye toggle masks every amount.
    @Default(false) bool isBalanceHidden,

    /// The month's budget was fetched, so a missing one means "not set".
    @Default(false) bool budgetLoaded,

    /// The month's transactions were fetched, so none means a first run.
    @Default(false) bool recentLoaded,

    /// Why the first load failed, with nothing cached.
    HomeLoadFailure? loadFailure,

    /// Why the last refresh failed while cached data is on screen; shown
    /// once as a snackbar.
    HomeLoadFailure? refreshFailure,
  }) = _HomeState;
}

/// What the budget section shows.
enum HomeBudgetDisplay {
  /// The month's budget and its progress.
  progress,

  /// The month has no budget: prompt to set one.
  prompt,

  /// Not fetched yet.
  hidden,
}

extension HomeStateX on HomeState {
  /// Something is cached to show while a refresh runs.
  bool get hasCache => dashboard?.hasCache ?? false;

  /// Nothing was recorded this month: the greeting says welcome, quick add
  /// and search are left out, and Recent becomes the empty prompt.
  bool get isFirstRun => recentLoaded && (dashboard?.recent.isEmpty ?? false);

  /// What the budget section shows.
  HomeBudgetDisplay get budgetDisplay => dashboard?.budget != null
      ? .progress
      : budgetLoaded
      ? .prompt
      : .hidden;

  /// The wallet cards are worth a section only with more than one wallet.
  bool get showWallets => (dashboard?.wallets.length ?? 0) > 1;

  /// The balance card prompts to add wallets with at most one.
  bool get promptAddWallets => (dashboard?.wallets.length ?? 0) <= 1;
}
