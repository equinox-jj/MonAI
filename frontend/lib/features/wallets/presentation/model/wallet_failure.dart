import 'package:monai/core/error/failure.dart';
import 'package:monai/core/l10n/l10n.dart';
import 'package:monai/features/wallets/domain/validation/default_wallet_rule.dart';

/// Why a wallets screen couldn't load or change something, as the user is
/// told.
enum WalletFailure {
  /// No connection or a timeout.
  network,

  /// The wallet no longer exists.
  notFound,

  /// The default wallet can't be archived or deleted.
  defaultWalletRequired,

  /// A wallet with transactions can only be archived.
  hasTransactions,

  /// An archived wallet can't be the default.
  archived,

  /// Another wallet already has the name.
  nameTaken,

  /// Anything else.
  unexpected;

  /// The server's `error.code` for a wallet with transactions.
  static const hasTransactionsCode = 'wallet_has_transactions';

  /// The kind of [failure].
  static WalletFailure of(Failure failure) => switch (failure) {
    NetworkFailure() || TimeoutFailure() => network,
    NotFoundFailure() => notFound,
    ConflictFailure() => nameTaken,
    _ when failure.code == DefaultWalletRule.code => defaultWalletRequired,
    _ when failure.code == hasTransactionsCode => hasTransactions,
    _ when failure.code == 'wallet_archived' => archived,
    _ => unexpected,
  };

  /// The message for a failed load or action.
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
