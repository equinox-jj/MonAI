part of 'wallet_form_bloc.dart';

@freezed
abstract class WalletFormState with _$WalletFormState {
  const factory WalletFormState({
    required WalletFormMode mode,
    @Default(UiStatus.initial) UiStatus status,
    @Default([]) List<PaymentProvider> providers,

    /// Null for a custom wallet. A slug, not an id, so the pick survives the
    /// bundled catalog being replaced.
    String? providerSlug,
    WalletType? type,
    String? color,
    @Default(false) bool isDefault,
    @Default(0) int initialBalance,
    Wallet? original,
    String? defaultWalletName,
    @Default({}) Map<String, FieldError> errors,
    @Default(false) bool autovalidate,
    @Default(false) bool isSaving,
    @Default(false) bool isArchiving,
    @Default(false) bool isDeleting,
    String? nameFill,
    @Default(false) bool offerArchive,
    WalletFormOutcome? outcome,
    WalletFailure? loadFailure,
    WalletFailure? actionFailure,
  }) = _WalletFormState;
}

extension WalletFormStateX on WalletFormState {
  bool get isEdit => mode is EditWalletMode;

  bool get isBusy => isSaving || isArchiving || isDeleting;

  PaymentProvider? get selectedProvider =>
      providers.where((p) => p.slug == providerSlug).firstOrNull;

  bool get isTypeLocked => isEdit || providerSlug != null;

  ({int from, int to})? get balanceShift => switch (original) {
    final wallet? when wallet.initialBalance != initialBalance => (
      from: wallet.currentBalance,
      to: shiftedBalance(wallet, initialBalance),
    ),
    _ => null,
  };

  FieldError? errorOf(String field) => errors[field];
}
