import 'package:monai/core/base/error/field_error.dart';

abstract final class BudgetLimitRule {
  static const field = 'limit_amount';
  static const min = 1;
  static const max = 999999999999;

  static FieldError? check(int limit) => switch (limit) {
    < min => const FieldError(
      field: field,
      code: 'min',
      message: 'must be at least 1',
      params: {'min': min},
    ),
    > max => const FieldError(
      field: field,
      code: 'max',
      message: 'must be at most 999999999999',
      params: {'max': max},
    ),
    _ => null,
  };
}
