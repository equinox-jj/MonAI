part of 'wallet_form_bloc.dart';

@freezed
sealed class WalletFormEvent with _$WalletFormEvent {
  /// The form opened.
  const factory WalletFormEvent.started() = _Started;

  /// "Try again" when the edited wallet couldn't be loaded.
  const factory WalletFormEvent.retried() = _Retried;

  /// A provider in the grid, by slug; null is "Custom".
  const factory WalletFormEvent.providerPicked(String? slug) = _ProviderPicked;

  /// A custom wallet's type.
  const factory WalletFormEvent.typePicked(WalletType type) = _TypePicked;

  /// A card color, as `#RRGGBB`.
  const factory WalletFormEvent.colorPicked(String hex) = _ColorPicked;

  const factory WalletFormEvent.defaultToggled({required bool isDefault}) =
      _DefaultToggled;

  /// The name field's text changed.
  const factory WalletFormEvent.nameEdited(String name) = _NameEdited;

  /// The balance field's text changed.
  const factory WalletFormEvent.balanceEdited(String balance) = _BalanceEdited;

  /// Save, with the text fields' text.
  const factory WalletFormEvent.saveRequested({
    required String name,
    required String balance,
  }) = _SaveRequested;

  /// Editing only: "Archive", or "Archive" in the archive-instead dialog.
  const factory WalletFormEvent.archiveRequested() = _ArchiveRequested;

  /// Editing only: "Delete", once confirmed.
  const factory WalletFormEvent.deleteRequested() = _DeleteRequested;

  /// The cached provider catalog changed. Sent by the bloc itself.
  const factory WalletFormEvent.providersChanged(
    List<PaymentProvider> providers,
  ) = _ProvidersChanged;

  /// The cached wallets changed, for the default's name. Sent by the bloc
  /// itself.
  const factory WalletFormEvent.walletsChanged(List<Wallet> wallets) =
      _WalletsChanged;
}
