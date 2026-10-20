import 'package:monai/core/l10n/l10n.dart';
import 'package:monai/core/model/wallet_type.dart';

extension WalletTypeText on WalletType {
  /// "Cash", "Bank", "E-wallet", "Other".
  String label(AppLocalizations l10n) => switch (this) {
    .cash => l10n.walletTypeCash,
    .bank => l10n.walletTypeBank,
    .eWallet => l10n.walletTypeEWallet,
    .other => l10n.walletTypeOther,
  };
}
