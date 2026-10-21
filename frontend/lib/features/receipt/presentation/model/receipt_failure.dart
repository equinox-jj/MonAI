import 'package:monai/core/base/error/failure.dart';
import 'package:monai/core/ui/l10n/l10n.dart';

enum ReceiptFailure {
  network,
  photoTooLarge,
  unreadablePhoto,
  walletArchived,
  unexpected;

  static ReceiptFailure of(Failure failure) => switch (failure) {
    NetworkFailure() || TimeoutFailure() => network,
    _ when failure.code == 'photo_too_large' => photoTooLarge,
    _ when failure.code == 'unreadable_image' => unreadablePhoto,
    _ when failure.code == 'wallet_archived' => walletArchived,
    _ => unexpected,
  };

  String message(AppLocalizations l10n) => switch (this) {
    network => l10n.transactionsErrorNetwork,
    photoTooLarge => l10n.receiptErrorPhotoTooLarge,
    unreadablePhoto => l10n.receiptErrorUnreadablePhoto,
    walletArchived => l10n.transactionsErrorWalletArchived,
    unexpected => l10n.transactionsErrorUnexpected,
  };
}
