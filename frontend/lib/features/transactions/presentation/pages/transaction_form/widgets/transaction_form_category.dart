import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:monai/core/designsystem/designsystem.dart';
import 'package:monai/core/l10n/l10n.dart';
import 'package:monai/features/shared/domain/entity/category.dart';
import 'package:monai/features/shared/domain/validation/transaction_input_validator.dart';
import 'package:monai/features/transactions/presentation/pages/transaction_form/bloc/transaction_form_bloc.dart';
import 'package:monai/features/transactions/presentation/pages/transaction_form/widgets/transaction_category_picker_sheet.dart';
import 'package:monai/features/transactions/presentation/pages/transaction_form/widgets/transaction_form_field_error.dart';
import 'package:monai/features/transactions/presentation/widgets/transaction_category_filter_sheet.dart';

/// The categories of the form's type as a row of chips, with "All
/// categories" for the full grid. Hidden for transfers.
class TransactionFormCategory extends StatelessWidget {
  const TransactionFormCategory({super.key});

  void _pick(BuildContext context, String id) => context
      .read<TransactionFormBloc>()
      .add(TransactionFormEvent.categoryPicked(id));

  void _openPicker(BuildContext context) {
    final bloc = context.read<TransactionFormBloc>();
    showMonAIBottomSheet<void>(
      context,
      title: context.l10n.transactionFormChooseCategory,
      builder: (_) => TransactionCategoryPickerSheet(
        categories: bloc.state.categories,
        selectedId: bloc.state.draft.categoryId,
        onPick: (id) => bloc.add(TransactionFormEvent.categoryPicked(id)),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    final c = context.colors;
    return BlocSelector<
      TransactionFormBloc,
      TransactionFormState,
      (List<Category>, String?)
    >(
      selector: (state) => (state.categories, state.draft.categoryId),
      builder: (context, selected) {
        final (categories, selectedId) = selected;
        return Column(
          crossAxisAlignment: .stretch,
          spacing: MonAISpacing.x1_5,
          children: [
            Row(
              mainAxisAlignment: .spaceBetween,
              children: [
                Text(
                  l10n.transactionFormCategory,
                  style: context.textTheme.labelMedium?.copyWith(
                    color: c.textSecondary,
                  ),
                ),
                MonAITextLink(
                  label: l10n.transactionFormAllCategories,
                  onPressed: () => _openPicker(context),
                ),
              ],
            ),
            SizedBox(
              height: MonAISizes.choiceChip,
              child: ListView.separated(
                scrollDirection: .horizontal,
                itemCount: categories.length,
                separatorBuilder: (_, _) =>
                    const SizedBox(width: MonAISpacing.x2),
                itemBuilder: (context, index) {
                  final category = categories[index];
                  return CategoryChoiceChip(
                    category: category,
                    selected: category.id == selectedId,
                    onTap: () => _pick(context, category.id),
                  );
                },
              ),
            ),
            const TransactionFormFieldError(
              fields: [TransactionInputValidator.categoryField],
            ),
          ],
        );
      },
    );
  }
}
