import 'package:monai/core/base/error/failure.dart';
import 'package:monai/core/ui/l10n/l10n.dart';
import 'package:monai/features/export/domain/usecase/export_transactions_csv_usecase.dart';

enum ExportFailure {
  invalidRange,
  empty,
  network,
  unexpected;

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
