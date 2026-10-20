import 'package:monai/core/error/field_error.dart';

/// The backend's rule for a monthly limit, checked before saving.
abstract final class BudgetLimitRule {
  /// The request field the limit is sent in.
  static const field = 'limit_amount';

  /// The smallest limit, in rupiah.
  static const min = 1;

  /// The largest limit, in rupiah: twelve digits.
  static const max = 999999999999;

  /// The error for [limit], or null when it is within [min]..[max].
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
