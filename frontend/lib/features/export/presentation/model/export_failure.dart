import 'package:monai/core/error/failure.dart';
import 'package:monai/core/l10n/l10n.dart';
import 'package:monai/features/export/domain/usecase/export_transactions_csv_usecase.dart';

/// Why an export failed, as the sheet tells the user.
enum ExportFailure {
  /// Past this month, or over 12 months.
  invalidRange,

  /// No transactions in the months.
  empty,

  /// Offline, and none of the months' transactions are cached.
  network,

  /// Anything else.
  unexpected;

  /// The kind of [failure].
  static ExportFailure of(Failure failure) => switch (failure) {
    NetworkFailure() || TimeoutFailure() => network,
    _ when failure.code == ExportTransactionsCsvUseCase.invalidRange =>
      invalidRange,
    _ when failure.code == ExportTransactionsCsvUseCase.noTransactions => empty,
    _ => unexpected,
  };

  String message(AppLocalizations l10n) => switch (this) {
    invalidRange => l10n.exportErrorRange,
    empty => l10n.exportErrorEmpty,
    network => l10n.exportErrorNetwork,
    unexpected => l10n.exportErrorUnexpected,
  };
}
