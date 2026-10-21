import 'package:monai/core/base/error/failure.dart';
import 'package:monai/core/ui/l10n/l10n.dart';
import 'package:monai/features/wallets/domain/validation/default_wallet_rule.dart';

enum WalletFailure {
  network,
  notFound,
  defaultWalletRequired,
  hasTransactions,
  archived,
  nameTaken,
  unexpected;

  static const hasTransactionsCode = 'wallet_has_transactions';

  static WalletFailure of(Failure failure) => switch (failure) {
    NetworkFailure() || TimeoutFailure() => network,
    NotFoundFailure() => notFound,
    ConflictFailure() => nameTaken,
    _ when failure.code == DefaultWalletRule.code => defaultWalletRequired,
    _ when failure.code == hasTransactionsCode => hasTransactions,
    _ when failure.code == 'wallet_archived' => archived,
    _ => unexpected,
  };

  String message(AppLocalizations l10n) => switch (this) {
    network => l10n.walletsErrorNetwork,
    notFound => l10n.walletsErrorNotFound,
    defaultWalletRequired => l10n.walletsErrorDefaultRequired,
    hasTransactions => l10n.walletsErrorHasTransactions,
    archived => l10n.walletsErrorArchived,
    nameTaken => l10n.walletFormErrorNameTaken,
    unexpected => l10n.walletsErrorUnexpected,
  };
}
