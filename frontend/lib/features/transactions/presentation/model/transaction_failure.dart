import 'package:monai/core/error/failure.dart';
import 'package:monai/core/l10n/l10n.dart';

/// Why a transactions screen couldn't load or change something, as the user
/// is told.
enum TransactionFailure {
  /// No connection or a timeout.
  network,

  /// The transaction no longer exists.
  notFound,

  /// A restore needs a wallet that has been archived since.
  walletArchived,

  /// Anything else.
  unexpected;

  /// The kind of [failure].
  static TransactionFailure of(Failure failure) => switch (failure) {
    NetworkFailure() || TimeoutFailure() => network,
    NotFoundFailure() => notFound,
    _ when failure.code == 'wallet_archived' => walletArchived,
    _ => unexpected,
  };

  /// The message for a failed load or action.
  String message(AppLocalizations l10n) => switch (this) {
    network => l10n.transactionsErrorNetwork,
    notFound => l10n.transactionsErrorNotFound,
    walletArchived => l10n.transactionsErrorWalletArchived,
    unexpected => l10n.transactionsErrorUnexpected,
  };
}
