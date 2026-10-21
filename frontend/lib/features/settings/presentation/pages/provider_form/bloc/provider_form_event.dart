part of 'provider_form_bloc.dart';

@freezed
sealed class ProviderFormEvent with _$ProviderFormEvent {
  /// The screen opened: load the provider being edited and follow the user.
  const factory ProviderFormEvent.started() = _Started;

  /// The signed-in user changed, and with it the permissions.
  const factory ProviderFormEvent.userChanged(User? user) = _UserChanged;

  /// The load error's retry.
  const factory ProviderFormEvent.retried() = _Retried;

  /// The name field was edited; carries the text for the ID preview.
  const factory ProviderFormEvent.nameEdited(String name) = _NameEdited;

  /// The sort order field was edited.
  const factory ProviderFormEvent.sortOrderEdited(String text) =
      _SortOrderEdited;

  const factory ProviderFormEvent.typePicked(WalletType type) = _TypePicked;

  /// The alias field was edited; a comma adds what came before it.
  const factory ProviderFormEvent.aliasTyped(String text) = _AliasTyped;

  /// Enter on the alias field: adds what is typed; commas split several.
  const factory ProviderFormEvent.aliasSubmitted(String text) = _AliasSubmitted;

  const factory ProviderFormEvent.aliasRemoved(String alias) = _AliasRemoved;

  /// On an existing provider, deactivating asks first and both apply at
  /// once.
  const factory ProviderFormEvent.activeToggled({required bool active}) =
      _ActiveToggled;

  /// Upload or Replace was tapped: pick an image from the gallery.
  const factory ProviderFormEvent.logoPickRequested() = _LogoPickRequested;

  /// Asks to confirm first.
  const factory ProviderFormEvent.deleteRequested() = _DeleteRequested;

  const factory ProviderFormEvent.dialogConfirmed() = _DialogConfirmed;

  const factory ProviderFormEvent.dialogDismissed() = _DialogDismissed;

  /// Save was tapped, with the text fields as typed.
  const factory ProviderFormEvent.saveRequested({
    required String name,
    required String aliasInput,
    required String sortOrder,
  }) = _SaveRequested;
}
