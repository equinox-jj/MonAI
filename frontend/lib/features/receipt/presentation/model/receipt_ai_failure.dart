import 'package:monai/core/base/error/failure.dart';
import 'package:monai/core/ui/l10n/l10n.dart';

enum ReceiptAiFailure {
  offline,
  busy;

  static ReceiptAiFailure of(Failure failure) => switch (failure) {
    NetworkFailure() => offline,
    _ => busy,
  };

  String banner(AppLocalizations l10n) => switch (this) {
    offline => l10n.receiptReviewAiOffline,
    busy => l10n.receiptReviewAiBusy,
  };

  String retryFailed(AppLocalizations l10n) => switch (this) {
    offline => l10n.transactionsErrorNetwork,
    busy => l10n.receiptReviewStillBusy,
  };
}
