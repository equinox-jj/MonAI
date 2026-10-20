part of 'wallet_detail_bloc.dart';

@freezed
abstract class WalletDetailState with _$WalletDetailState {
  const factory WalletDetailState({
    required String id,

    /// The user's current date.
    required DateTime today,

    /// The first of the month the chart and the list show.
    required DateTime month,

    /// [UiStatus.loading] while nothing is cached, [UiStatus.failure] when
    /// that first load failed, otherwise [UiStatus.success].
    @Default(UiStatus.initial) UiStatus status,
    Wallet? wallet,

    /// Each day's money out of the wallet this month.
    @Default({}) Map<DateTime, int> outflows,

    /// This month's transactions in or out of the wallet, newest first.
    @Default([]) List<Transaction> transactions,

    /// Every cached category and wallet by id, for the rows' names.
    @Default({}) Map<String, Category> categories,
    @Default({}) Map<String, Wallet> wallets,

    /// The server answered once.
    @Default(false) bool loaded,
    @Default(false) bool isRefreshing,
    @Default(false) bool isArchiving,
    @Default(false) bool isSettingDefault,

    /// The server no longer has the wallet; the screen closes.
    @Default(false) bool isGone,

    /// Set once the wallet is archived; the screen closes.
    String? archivedName,

    /// Why the first load failed, with nothing cached.
    WalletFailure? loadFailure,

    /// Why a refresh or an action failed; shown once as a snackbar.
    WalletFailure? actionFailure,
  }) = _WalletDetailState;
}

extension WalletDetailStateX on WalletDetailState {
  bool get isBusy => isArchiving || isSettingDefault;

  /// The default wallet can't be archived.
  bool get canArchive => wallet != null && !wallet!.isDefault;

  /// Each day's money out from the 1st to today, or to the month's end for
  /// a past month.
  List<int> get dailyOutflows => dailyOutflowSeries(
    outflows,
    month,
    month == monthOf(today)
        ? today.day
        : DateTime(month.year, month.month + 1, 0).day,
  );

  /// The month's money out of the wallet.
  int get monthOutflow => outflows.values.fold<int>(0, (sum, v) => sum + v);
}
