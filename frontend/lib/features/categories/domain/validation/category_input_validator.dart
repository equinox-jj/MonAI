import 'package:monai/core/base/error/field_error.dart';
import 'package:monai/features/shared/domain/entity/category_input.dart';

abstract final class CategoryInputValidator {
  static const nameField = 'name';
  static const nameMax = 30;

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

  static List<FieldError> validate(CategoryInput input) => [?name(input.name)];
}
