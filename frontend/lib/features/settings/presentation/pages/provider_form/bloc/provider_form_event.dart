part of 'provider_form_bloc.dart';

@freezed
sealed class ProviderFormEvent with _$ProviderFormEvent {
  const factory ProviderFormEvent.started() = _Started;
  const factory ProviderFormEvent.userChanged(User? user) = _UserChanged;
  const factory ProviderFormEvent.retried() = _Retried;
  const factory ProviderFormEvent.nameEdited(String name) = _NameEdited;

  const factory ProviderFormEvent.sortOrderEdited(String text) =
      _SortOrderEdited;

  const factory ProviderFormEvent.typePicked(WalletType type) = _TypePicked;
  const factory ProviderFormEvent.aliasTyped(String text) = _AliasTyped;
  const factory ProviderFormEvent.aliasSubmitted(String text) = _AliasSubmitted;

  const factory ProviderFormEvent.aliasRemoved(String alias) = _AliasRemoved;

  const factory ProviderFormEvent.activeToggled({required bool active}) =
      _ActiveToggled;

  const factory ProviderFormEvent.logoPickRequested() = _LogoPickRequested;
  const factory ProviderFormEvent.deleteRequested() = _DeleteRequested;

  const factory ProviderFormEvent.dialogConfirmed() = _DialogConfirmed;

  const factory ProviderFormEvent.dialogDismissed() = _DialogDismissed;

  const factory ProviderFormEvent.saveRequested({
    required String name,
    required String aliasInput,
    required String sortOrder,
  }) = _SaveRequested;
}
