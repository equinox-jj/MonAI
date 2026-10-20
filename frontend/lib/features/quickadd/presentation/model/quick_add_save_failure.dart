import 'package:monai/core/error/failure.dart';
import 'package:monai/core/l10n/l10n.dart';

/// Why saving a reviewed draft failed, as the user is told.
enum QuickAddSaveFailure {
  /// No connection or a timeout.
  network,

  /// The chosen wallet was archived meanwhile.
  walletArchived,

  /// Anything else.
  unexpected;

  /// The kind of [failure].
  static QuickAddSaveFailure of(Failure failure) => switch (failure) {
    NetworkFailure() || TimeoutFailure() => network,
    _ when failure.code == 'wallet_archived' => walletArchived,
    _ => unexpected,
  };

  String message(AppLocalizations l10n) => switch (this) {
    network => l10n.transactionsErrorNetwork,
    walletArchived => l10n.transactionsErrorWalletArchived,
    unexpected => l10n.transactionsErrorUnexpected,
  };
}
