import 'package:monai/core/base/error/failure.dart';
import 'package:monai/core/ui/l10n/l10n.dart';

enum ReportFailure {
  network,
  unexpected;

  static ReportFailure of(Failure failure) => switch (failure) {
    NetworkFailure() || TimeoutFailure() => network,
    _ => unexpected,
  };

  String loadMessage(AppLocalizations l10n) => switch (this) {
    network => l10n.reportLoadFailedNetwork,
    unexpected => l10n.reportLoadFailedUnexpected,
  };

  String refreshMessage(AppLocalizations l10n) => switch (this) {
    network => l10n.reportRefreshFailedNetwork,
    unexpected => l10n.reportRefreshFailedUnexpected,
  };
}
