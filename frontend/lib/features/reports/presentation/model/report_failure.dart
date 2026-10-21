import 'package:monai/core/base/error/failure.dart';
import 'package:monai/core/ui/l10n/l10n.dart';

/// Why the report couldn't be loaded or refreshed, as the user is told.
enum ReportFailure {
  /// No connection or a timeout.
  network,

  /// Anything else.
  unexpected;

  /// The kind of [failure].
  static ReportFailure of(Failure failure) => switch (failure) {
    NetworkFailure() || TimeoutFailure() => network,
    _ => unexpected,
  };

  /// Shown in place of a report that never loaded.
  String loadMessage(AppLocalizations l10n) => switch (this) {
    network => l10n.reportLoadFailedNetwork,
    unexpected => l10n.reportLoadFailedUnexpected,
  };

  /// Shown over a saved report that couldn't be refreshed.
  String refreshMessage(AppLocalizations l10n) => switch (this) {
    network => l10n.reportRefreshFailedNetwork,
    unexpected => l10n.reportRefreshFailedUnexpected,
  };
}
