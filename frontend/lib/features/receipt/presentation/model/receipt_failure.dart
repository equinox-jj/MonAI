import 'package:monai/core/base/error/failure.dart';
import 'package:monai/core/ui/l10n/l10n.dart';

/// Why saving a scanned receipt failed, as the user is told.
enum ReceiptFailure {
  /// No connection or a timeout.
  network,

  /// The photo stays over the upload limit even compressed.
  photoTooLarge,

  /// The photo file couldn't be read.
  unreadablePhoto,

  /// The chosen wallet was archived meanwhile.
  walletArchived,

  /// Anything else.
  unexpected;

  /// The kind of [failure].
  static ReceiptFailure of(Failure failure) => switch (failure) {
    NetworkFailure() || TimeoutFailure() => network,
    _ when failure.code == 'photo_too_large' => photoTooLarge,
    _ when failure.code == 'unreadable_image' => unreadablePhoto,
    _ when failure.code == 'wallet_archived' => walletArchived,
    _ => unexpected,
  };

  /// The message for a failed save.
  String message(AppLocalizations l10n) => switch (this) {
    network => l10n.transactionsErrorNetwork,
    photoTooLarge => l10n.receiptErrorPhotoTooLarge,
    unreadablePhoto => l10n.receiptErrorUnreadablePhoto,
    walletArchived => l10n.transactionsErrorWalletArchived,
    unexpected => l10n.transactionsErrorUnexpected,
  };
}
