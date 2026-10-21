import 'package:monai/core/base/error/failure.dart';
import 'package:monai/core/ui/l10n/l10n.dart';

/// Why a profile change failed, as the user is told in a snackbar.
enum ProfileFailure {
  /// No connection or a timeout.
  network,

  /// Too many attempts; the server asks to wait.
  rateLimited,

  /// The only admin can't delete their account.
  lastAdmin,

  /// The photo stays over the upload limit even compressed.
  photoTooLarge,

  /// The photo isn't a JPEG, PNG or WebP.
  photoUnsupported,

  /// The photo file couldn't be opened.
  unreadablePhoto,

  /// Anything else.
  unexpected;

  /// The kind of [failure].
  static ProfileFailure of(Failure failure) => switch (failure) {
    NetworkFailure() || TimeoutFailure() => network,
    TooManyRequestsFailure() => rateLimited,
    _ when failure.code == 'last_admin' => lastAdmin,
    _ when failure.code == 'photo_too_large' => photoTooLarge,
    _ when failure.code == 'unreadable_image' => unreadablePhoto,
    ValidationFailure(:final fieldErrors) => switch (fieldErrors
        .where((e) => e.field == 'file')
        .firstOrNull
        ?.code) {
      'max_size' => photoTooLarge,
      'content_type' => photoUnsupported,
      _ => unexpected,
    },
    _ => unexpected,
  };

  String message(AppLocalizations l10n) => switch (this) {
    network => l10n.profileErrorNetwork,
    rateLimited => l10n.profileErrorRateLimited,
    lastAdmin => l10n.profileErrorLastAdmin,
    photoTooLarge => l10n.profileErrorPhotoTooLarge,
    photoUnsupported => l10n.profileErrorPhotoUnsupported,
    unreadablePhoto => l10n.profileErrorUnreadablePhoto,
    unexpected => l10n.profileErrorUnexpected,
  };
}

/// A change that went through, confirmed in a snackbar.
enum ProfileNotice { nameSaved, photoUpdated, photoRemoved }
