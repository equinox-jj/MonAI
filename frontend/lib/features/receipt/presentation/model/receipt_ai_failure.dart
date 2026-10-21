import 'package:monai/core/base/error/failure.dart';
import 'package:monai/core/ui/l10n/l10n.dart';

/// Why the AI gave no draft for a receipt, as the review tells the user.
enum ReceiptAiFailure {
  /// No connection: the text never reached the AI.
  offline,

  /// The AI was overloaded, rate-limited, slow or down; usually short-lived.
  busy;

  /// The kind of [failure].
  static ReceiptAiFailure of(Failure failure) => switch (failure) {
    NetworkFailure() => offline,
    _ => busy,
  };

  /// The banner under the review's title.
  String banner(AppLocalizations l10n) => switch (this) {
    offline => l10n.receiptReviewAiOffline,
    busy => l10n.receiptReviewAiBusy,
  };

  /// The snackbar when trying again fails the same way.
  String retryFailed(AppLocalizations l10n) => switch (this) {
    offline => l10n.transactionsErrorNetwork,
    busy => l10n.receiptReviewStillBusy,
  };
}
