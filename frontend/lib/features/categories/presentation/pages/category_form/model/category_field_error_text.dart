import 'package:monai/core/base/error/field_error.dart';
import 'package:monai/core/ui/l10n/l10n.dart';
import 'package:monai/features/categories/domain/validation/category_input_validator.dart';

extension CategoryFieldErrorText on FieldError {
  String text(AppLocalizations l10n) => switch ((field, code)) {
    (CategoryInputValidator.nameField, 'max') => l10n.categoryFormNameTooLong(
      CategoryInputValidator.nameMax,
    ),
    (CategoryInputValidator.nameField, 'conflict') =>
      l10n.categoryFormNameTaken,
    (CategoryInputValidator.nameField, 'required' || 'notblank' || 'min') =>
      l10n.categoryFormNameRequired,
    (CategoryInputValidator.nameField, _) => l10n.categoryFormNameInvalid,
    _ => message,
  };
}
