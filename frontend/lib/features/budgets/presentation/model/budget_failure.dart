import 'package:monai/core/base/error/failure.dart';
import 'package:monai/core/ui/l10n/l10n.dart';

enum BudgetFailure {
  network,
  unexpected;

  static BudgetFailure of(Failure failure) => switch (failure) {
    NetworkFailure() || TimeoutFailure() => network,
    _ => unexpected,
  };

  String message(AppLocalizations l10n) => switch (this) {
    network => l10n.budgetErrorNetwork,
    unexpected => l10n.budgetErrorUnexpected,
  };
}
