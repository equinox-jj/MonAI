part of 'wallet_detail_bloc.dart';

@freezed
sealed class WalletDetailEvent with _$WalletDetailEvent {
  const factory WalletDetailEvent.started() = _Started;
  const factory WalletDetailEvent.refreshed() = _Refreshed;
  const factory WalletDetailEvent.archiveRequested() = _ArchiveRequested;
  const factory WalletDetailEvent.setDefaultRequested() = _SetDefaultRequested;

  const factory WalletDetailEvent.walletChanged(Wallet? wallet) =
      _WalletChanged;

  const factory WalletDetailEvent.outflowsChanged(Map<DateTime, int> outflows) =
      _OutflowsChanged;

  const factory WalletDetailEvent.transactionsChanged(
    List<Transaction> transactions,
  ) = _TransactionsChanged;

  const factory WalletDetailEvent.categoriesChanged(List<Category> categories) =
      _CategoriesChanged;

  const factory WalletDetailEvent.allWalletsChanged(List<Wallet> wallets) =
      _AllWalletsChanged;
}
