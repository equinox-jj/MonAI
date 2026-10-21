import 'package:monai/core/base/error/failure.dart';
import 'package:monai/core/ui/l10n/l10n.dart';

/// Why a categories screen couldn't load or change something, as the user
/// is told.
enum CategoryFailure {
  /// No connection or a timeout.
  network,

  /// A default or system category can't be changed that way.
  locked,

  /// The category no longer exists.
  notFound,

  /// Anything else.
  unexpected;

  /// The server's `error.code` for a default or system category.
  static const lockedCode = 'system_category_locked';

  /// The kind of [failure].
  static CategoryFailure of(Failure failure) => switch (failure) {
    NetworkFailure() || TimeoutFailure() => network,
    NotFoundFailure() => notFound,
    _ when failure.code == lockedCode => locked,
    _ => unexpected,
  };

  /// The message on the list.
  String message(AppLocalizations l10n) => switch (this) {
    network => l10n.categoriesErrorNetwork,
    locked => l10n.categoriesErrorLocked,
    notFound => l10n.categoriesErrorNotFound,
    unexpected => l10n.categoriesErrorUnexpected,
  };

  /// The message on the form.
  String formMessage(AppLocalizations l10n) => switch (this) {
    network => l10n.categoryFormErrorNetwork,
    notFound => l10n.categoryFormErrorNotFound,
    locked => l10n.categoriesErrorLocked,
    unexpected => l10n.categoryFormErrorUnexpected,
  };
}
