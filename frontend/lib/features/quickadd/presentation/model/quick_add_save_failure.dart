import 'package:monai/core/base/error/failure.dart';
import 'package:monai/core/ui/l10n/l10n.dart';

enum QuickAddSaveFailure {
  network,
  walletArchived,
  unexpected;

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
