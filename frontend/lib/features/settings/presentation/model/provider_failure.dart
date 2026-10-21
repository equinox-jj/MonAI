import 'package:monai/core/base/error/failure.dart';
import 'package:monai/core/base/error/field_error.dart';
import 'package:monai/core/ui/l10n/l10n.dart';
import 'package:monai/features/settings/domain/validation/provider_input_validator.dart';

/// Why a provider action failed, as the admin screens say it. Branches on
/// the backend's stable error codes, never on the message.
enum ProviderFailure {
  /// No connection or a timeout.
  network,

  /// Another provider already uses the name's slug, or one of the aliases.
  conflict,

  /// System providers can't be deactivated or deleted.
  locked,

  /// The user's role no longer allows this.
  forbidden,

  /// The provider was already deleted.
  notFound,

  /// The logo stays over 512 KB even shrunk.
  logoTooLarge,

  /// The logo couldn't be read, or the server refused its type.
  logoUnsupported,

  /// The input broke a rule no field shows.
  invalid,

  /// Anything else.
  unexpected;

  /// The kind of [failure].
  static ProviderFailure of(Failure failure) => switch (failure) {
    NetworkFailure() || TimeoutFailure() => network,
    _ when failure.code == 'system_provider_locked' => locked,
    _ when failure.code == 'photo_too_large' => logoTooLarge,
    _ when failure.code == 'unreadable_image' => logoUnsupported,
    ConflictFailure() => conflict,
    ForbiddenFailure() => forbidden,
    NotFoundFailure() => notFound,
    ValidationFailure(:final fieldErrors) => switch (fieldErrors
        .where((e) => e.field == 'file')
        .firstOrNull
        ?.code) {
      'max_size' => logoTooLarge,
      final _? => logoUnsupported,
      null => invalid,
    },
    _ => unexpected,
  };

  String message(AppLocalizations l10n) => switch (this) {
    network => l10n.providerErrorNetwork,
    conflict => l10n.providerErrorConflict,
    locked => l10n.providerErrorLocked,
    forbidden => l10n.providerErrorForbidden,
    notFound => l10n.providerErrorNotFound,
    logoTooLarge => l10n.providerErrorLogoTooLarge,
    logoUnsupported => l10n.providerErrorLogoUnsupported,
    invalid => l10n.providerErrorAliasesInvalid,
    unexpected => l10n.providerErrorUnexpected,
  };
}

extension ProviderFieldErrorText on FieldError {
  /// The message under the name or alias field, from the device's checks or
  /// the server's.
  String text(AppLocalizations l10n) {
    final max = (params['max'] as num?)?.toInt();
    return switch ((field, code)) {
      (ProviderInputValidator.nameField, 'max_length') =>
        l10n.providerErrorNameTooLong(
          max ?? ProviderInputValidator.nameMaxLength,
        ),
      (ProviderInputValidator.nameField, _) => l10n.providerErrorNameRequired,
      // `aliases` is the list itself; `aliases[2]` one alias.
      (ProviderInputValidator.aliasesField, 'max_length') =>
        l10n.providerErrorAliasesTooMany(
          max ?? ProviderInputValidator.maxAliases,
        ),
      (final f, 'max_length')
          when f.startsWith('${ProviderInputValidator.aliasesField}[') =>
        l10n.providerErrorAliasTooLong(
          max ?? ProviderInputValidator.aliasMaxLength,
        ),
      _ => l10n.providerErrorAliasesInvalid,
    };
  }
}
