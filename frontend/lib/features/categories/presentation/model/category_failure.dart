import 'package:monai/core/base/error/failure.dart';
import 'package:monai/core/ui/l10n/l10n.dart';

enum CategoryFailure {
  network,
  locked,
  notFound,
  unexpected;

  static const lockedCode = 'system_category_locked';

  static CategoryFailure of(Failure failure) => switch (failure) {
    NetworkFailure() || TimeoutFailure() => network,
    NotFoundFailure() => notFound,
    _ when failure.code == lockedCode => locked,
    _ => unexpected,
  };

  String message(AppLocalizations l10n) => switch (this) {
    network => l10n.categoriesErrorNetwork,
    locked => l10n.categoriesErrorLocked,
    notFound => l10n.categoriesErrorNotFound,
    unexpected => l10n.categoriesErrorUnexpected,
  };

  String formMessage(AppLocalizations l10n) => switch (this) {
    network => l10n.categoryFormErrorNetwork,
    notFound => l10n.categoryFormErrorNotFound,
    locked => l10n.categoriesErrorLocked,
    unexpected => l10n.categoryFormErrorUnexpected,
  };
}
