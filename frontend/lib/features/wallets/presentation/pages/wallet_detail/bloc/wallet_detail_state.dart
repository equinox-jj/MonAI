part of 'wallet_detail_bloc.dart';

@freezed
abstract class WalletDetailState with _$WalletDetailState {
  const factory WalletDetailState({
    required String id,
    required DateTime today,
    required DateTime month,
    @Default(UiStatus.initial) UiStatus status,
    Wallet? wallet,
    @Default({}) Map<DateTime, int> outflows,
    @Default([]) List<Transaction> transactions,
    @Default({}) Map<String, Category> categories,
    @Default({}) Map<String, Wallet> wallets,
    @Default(false) bool loaded,
    @Default(false) bool isRefreshing,
    @Default(false) bool isArchiving,
    @Default(false) bool isSettingDefault,
    @Default(false) bool isGone,
    String? archivedName,
    WalletFailure? loadFailure,
    WalletFailure? actionFailure,
  }) = _WalletDetailState;
}

extension WalletDetailStateX on WalletDetailState {
  bool get isBusy => isArchiving || isSettingDefault;

  bool get canArchive => wallet != null && !wallet!.isDefault;

  List<int> get dailyOutflows => dailyOutflowSeries(
    outflows,
    month,
    month == monthOf(today)
        ? today.day
        : DateTime(month.year, month.month + 1, 0).day,
  );

  int get monthOutflow => outflows.values.fold<int>(0, (sum, v) => sum + v);
}
