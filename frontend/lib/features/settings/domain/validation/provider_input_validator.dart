import 'package:monai/core/base/error/field_error.dart';
import 'package:monai/features/settings/domain/entity/admin_payment_provider.dart';

/// The backend's rules, checked on the device first, in the shape of the
/// server's own 422: field `name`, `aliases` for the list and `aliases[i]` for
/// one alias.
abstract final class ProviderInputValidator {
  static const nameField = 'name';
  static const aliasesField = 'aliases';

  static const nameMaxLength = 50;
  static const aliasMaxLength = 50;
  static const maxAliases = 20;

  static final _nonSlug = RegExp('[^a-z0-9]+');
  static final _edgeHyphens = RegExp(r'^-+|-+$');

  /// As the API stores it: the name trimmed; the aliases trimmed, lowercase,
  /// sorted and without blanks or repeats.
  static ProviderInput normalized(ProviderInput input) => input.copyWith(
    name: input.name.trim(),
    aliases: normalizedAliases(input.aliases),
  );

  static List<String> normalizedAliases(Iterable<String> aliases) =>
      aliases.map(normalizedAlias).where((a) => a.isNotEmpty).toSet().toList()
        ..sort();

  static String normalizedAlias(String alias) => alias.trim().toLowerCase();

  static List<FieldError> validate(ProviderInput input) => [
    ?name(input.name),
    ?aliases(input.aliases),
  ];

  static FieldError? name(String name) {
    if (name.isEmpty) {
      return const FieldError(
        field: nameField,
        code: 'required',
        message: 'is required',
      );
    }
    if (name.runes.length > nameMaxLength) {
      return const FieldError(
        field: nameField,
        code: 'max_length',
        message: 'must be at most 50 characters',
        params: {'max': nameMaxLength},
      );
    }
    return null;
  }

  static FieldError? aliases(List<String> aliases) {
    if (aliases.length > maxAliases) {
      return const FieldError(
        field: aliasesField,
        code: 'max_length',
        message: 'must have at most 20 items',
        params: {'max': maxAliases},
      );
    }
    final tooLong = aliases.indexWhere((a) => a.runes.length > aliasMaxLength);
    if (tooLong != -1) {
      return FieldError(
        field: '$aliasesField[$tooLong]',
        code: 'max_length',
        message: 'must be at most 50 characters',
        params: const {'max': aliasMaxLength},
      );
    }
    return null;
  }

  /// The slug the server makes from [name]: lowercase letters and digits
  /// joined by single hyphens (`Bank BCA` → `bank-bca`). Shown as the
  /// provider's ID before it is created.
  static String slugOf(String name) {
    final slug = name
        .toLowerCase()
        .replaceAll(_nonSlug, '-')
        .replaceAll(_edgeHyphens, '');
    final capped = slug.length > nameMaxLength
        ? slug.substring(0, nameMaxLength)
        : slug;
    return capped.replaceAll(_edgeHyphens, '');
  }
}
