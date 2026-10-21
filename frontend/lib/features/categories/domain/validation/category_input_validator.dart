import 'package:monai/core/base/error/field_error.dart';
import 'package:monai/features/shared/domain/entity/category_input.dart';

/// The backend's rules for a category name, checked before saving.
abstract final class CategoryInputValidator {
  /// The request field of the name.
  static const nameField = 'name';

  /// The longest name, in characters.
  static const nameMax = 30;

  /// The error for [name], trimmed first, or null when it is valid.
  static FieldError? name(String name) {
    final trimmed = name.trim();
    if (trimmed.isEmpty) {
      return const FieldError(
        field: nameField,
        code: 'required',
        message: 'is required',
      );
    }
    if (trimmed.length > nameMax) {
      return const FieldError(
        field: nameField,
        code: 'max',
        message: 'must be at most 30 characters',
        params: {'max': nameMax},
      );
    }
    return null;
  }

  /// Every error in [input].
  static List<FieldError> validate(CategoryInput input) => [?name(input.name)];
}
