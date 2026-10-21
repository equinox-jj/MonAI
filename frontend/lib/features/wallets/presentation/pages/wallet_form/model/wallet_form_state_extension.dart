import 'package:monai/core/base/error/field_error.dart';
import 'package:monai/features/shared/domain/entity/payment_provider.dart';
import 'package:monai/features/wallets/domain/logic/wallet_form_rules.dart';
import 'package:monai/features/wallets/presentation/pages/wallet_form/bloc/wallet_form_bloc.dart';
import 'package:monai/features/wallets/presentation/pages/wallet_form/model/wallet_form_mode.dart';

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
