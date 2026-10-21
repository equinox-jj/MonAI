part of 'wallet_form_bloc.dart';

@freezed
sealed class WalletFormEvent with _$WalletFormEvent {
  const factory WalletFormEvent.started() = _Started;
  const factory WalletFormEvent.retried() = _Retried;
  const factory WalletFormEvent.providerPicked(String? slug) = _ProviderPicked;
  const factory WalletFormEvent.typePicked(WalletType type) = _TypePicked;
  const factory WalletFormEvent.colorPicked(String hex) = _ColorPicked;

  const factory WalletFormEvent.defaultToggled({required bool isDefault}) =
      _DefaultToggled;

  const factory WalletFormEvent.nameEdited(String name) = _NameEdited;
  const factory WalletFormEvent.balanceEdited(String balance) = _BalanceEdited;

  const factory WalletFormEvent.saveRequested({
    required String name,
    required String balance,
  }) = _SaveRequested;

  const factory WalletFormEvent.archiveRequested() = _ArchiveRequested;
  const factory WalletFormEvent.deleteRequested() = _DeleteRequested;

  const factory WalletFormEvent.providersChanged(
    List<PaymentProvider> providers,
  ) = _ProvidersChanged;

  const factory WalletFormEvent.walletsChanged(List<Wallet> wallets) =
      _WalletsChanged;
}
