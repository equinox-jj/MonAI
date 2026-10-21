import 'package:monai/core/base/error/field_error.dart';
import 'package:monai/core/ui/l10n/l10n.dart';
import 'package:monai/core/utils/money_format.dart';
import 'package:monai/features/budgets/domain/validation/budget_limit_rule.dart';

extension BudgetFieldErrorText on FieldError {
  String text(AppLocalizations l10n) => switch (field) {
    BudgetLimitRule.field => l10n.budgetErrorInvalidLimit(
      formatRupiah(BudgetLimitRule.min),
      formatRupiah(BudgetLimitRule.max),
    ),
    _ => message,
  };
}
