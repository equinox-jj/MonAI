import 'package:monai/core/model/category_type.dart';
import 'package:monai/core/ui/l10n/l10n.dart';

extension CategoryTypeText on CategoryType {
  String label(AppLocalizations l10n) => switch (this) {
    .expense => l10n.transactionTypeExpense,
    .income => l10n.transactionTypeIncome,
  };
}
