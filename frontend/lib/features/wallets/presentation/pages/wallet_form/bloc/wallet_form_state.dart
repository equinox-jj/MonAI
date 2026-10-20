part of 'wallet_form_bloc.dart';

@freezed
abstract class WalletFormState with _$WalletFormState {
  const factory WalletFormState({
    required WalletFormMode mode,

    /// [UiStatus.loading] while the edited wallet loads,
    /// [UiStatus.failure] when it couldn't be, otherwise
    /// [UiStatus.success].
    @Default(UiStatus.initial) UiStatus status,

    /// The catalog to pick from; adding only.
    @Default([]) List<PaymentProvider> providers,

    /// The picked provider's slug; null for a custom wallet. A slug, not an
    /// id, so the pick survives the bundled catalog being replaced.
    String? providerSlug,

    /// A custom wallet's type, or the provider's or edited wallet's.
    WalletType? type,

    /// The card color, `#RRGGBB`; null for the type's own.
    String? color,
    @Default(false) bool isDefault,

    /// The starting balance as typed, for the balance-shift note.
    @Default(0) int initialBalance,

    /// The wallet being edited.
    Wallet? original,

    /// The current default wallet's name.
    String? defaultWalletName,

    /// One error per invalid field, keyed by the API's field name.
    @Default({}) Map<String, FieldError> errors,

    /// A save failed on the input, so errors update as the user edits.
    @Default(false) bool autovalidate,
    @Default(false) bool isSaving,
    @Default(false) bool isArchiving,
    @Default(false) bool isDeleting,

    /// A provider was picked: the name field takes this text once.
    String? nameFill,

    /// Delete was refused for the wallet's transactions: the archive-instead
    /// dialog shows once.
    @Default(false) bool offerArchive,

    /// Set once the form is done; the screen closes.
    WalletFormOutcome? outcome,

    /// Why the edited wallet couldn't be loaded.
    WalletFailure? loadFailure,

    /// Why a save, archive or delete failed; shown once as a snackbar.
    WalletFailure? actionFailure,
  }) = _WalletFormState;
}

extension WalletFormStateX on WalletFormState {
  bool get isEdit => mode is EditWalletMode;

  bool get isBusy => isSaving || isArchiving || isDeleting;

  PaymentProvider? get selectedProvider =>
      providers.where((p) => p.slug == providerSlug).firstOrNull;

  /// A provider's or an existing wallet's type can't be changed.
  bool get isTypeLocked => isEdit || providerSlug != null;

  /// The edited wallet's current balance before and after the starting
  /// balance change; null while it's unchanged.
  ({int from, int to})? get balanceShift => switch (original) {
    final wallet? when wallet.initialBalance != initialBalance => (
      from: wallet.currentBalance,
      to: shiftedBalance(wallet, initialBalance),
    ),
    _ => null,
  };

  FieldError? errorOf(String field) => errors[field];
}
