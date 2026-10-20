part of 'wallet_detail_bloc.dart';

@freezed
sealed class WalletDetailEvent with _$WalletDetailEvent {
  /// The screen opened.
  const factory WalletDetailEvent.started() = _Started;

  /// Pull-to-refresh, or "Try again" on the error.
  const factory WalletDetailEvent.refreshed() = _Refreshed;

  /// "Archive": hides the wallet from pickers.
  const factory WalletDetailEvent.archiveRequested() = _ArchiveRequested;

  /// "Make default" in the menu.
  const factory WalletDetailEvent.setDefaultRequested() = _SetDefaultRequested;

  /// The cached wallet changed; null once it's gone. Sent by the bloc
  /// itself.
  const factory WalletDetailEvent.walletChanged(Wallet? wallet) =
      _WalletChanged;

  /// The month's cached money out by day changed. Sent by the bloc itself.
  const factory WalletDetailEvent.outflowsChanged(Map<DateTime, int> outflows) =
      _OutflowsChanged;

  /// The month's cached transactions changed. Sent by the bloc itself.
  const factory WalletDetailEvent.transactionsChanged(
    List<Transaction> transactions,
  ) = _TransactionsChanged;

  /// The cached categories changed. Sent by the bloc itself.
  const factory WalletDetailEvent.categoriesChanged(List<Category> categories) =
      _CategoriesChanged;

  /// Every cached wallet changed, for transfer names. Sent by the bloc
  /// itself.
  const factory WalletDetailEvent.allWalletsChanged(List<Wallet> wallets) =
      _AllWalletsChanged;
}
