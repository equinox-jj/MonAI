import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:monai/core/model/category_type.dart';
import 'package:monai/core/ui/designsystem/designsystem.dart';
import 'package:monai/core/ui/l10n/l10n.dart';
import 'package:monai/core/utils/extension/category_type_extension.dart';
import 'package:monai/features/shared/domain/entity/category.dart';
import 'package:monai/features/shared/domain/validation/transaction_input_validator.dart';
import 'package:monai/features/transactions/presentation/model/transaction_picker_options.dart';
import 'package:monai/features/transactions/presentation/pages/transaction_form/bloc/transaction_form_bloc.dart';
import 'package:monai/features/transactions/presentation/pages/transaction_form/model/transaction_form_state_extension.dart';
import 'package:monai/features/transactions/presentation/pages/transaction_form/widgets/transaction_form_field_error.dart';
import 'package:monai/features/transactions/presentation/widgets/transaction_category_filter_sheet.dart';
import 'package:monai/route_path.dart';

class TransactionFormCategory extends StatelessWidget {
  const TransactionFormCategory({super.key});

  void _pick(BuildContext context, String id) => context
      .read<TransactionFormBloc>()
      .add(TransactionFormEvent.categoryPicked(id));

  void _openPicker(BuildContext context) {
    final bloc = context.read<TransactionFormBloc>();
    final l10n = context.l10n;
    final type = bloc.state.categoryType;
    showMonAIBottomSheet<void>(
      context,
      title: l10n.transactionFormChooseCategory,
      titleTrailing: MonAICategoryTypePill(type: type, label: type.label(l10n)),
      builder: (_) => MonAICategoryPickerSheet(
        options: bloc.state.categories.map((c) => c.pickerOption).toList(),
        selectedId: bloc.state.draft.categoryId,
        onPick: (id) => bloc.add(TransactionFormEvent.categoryPicked(id)),
        doneLabel: l10n.transactionFormDone,
        useLabel: l10n.transactionFormUseCategory,
        emptyLabel: l10n.transactionFormNoCategories,
        newLabel: l10n.transactionFormNewCategory,
        onNew: () => _newCategory(context, bloc, type),
      ),
    );
  }

  Future<void> _newCategory(
    BuildContext context,
    TransactionFormBloc bloc,
    CategoryType type,
  ) async {
    final id = await context.push<String>(RoutePath.categoryNew(type));
    if (id != null && !bloc.isClosed) {
      bloc.add(TransactionFormEvent.categoryPicked(id));
    }
  }

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    final c = context.colors;
    return BlocSelector<
      TransactionFormBloc,
      TransactionFormState,
      (List<Category>, String?, bool)
    >(
      selector: (state) => (
        state.categories,
        state.draft.categoryId,
        state.isUnsure(TransactionInputValidator.categoryField),
      ),
      builder: (context, selected) {
        final (categories, selectedId, check) = selected;
        return Column(
          crossAxisAlignment: .stretch,
          spacing: MonAISpacing.x1_5,
          children: [
            Row(
              mainAxisAlignment: .spaceBetween,
              children: [
                Text(
                  check
                      ? l10n.transactionFormCategoryCheck
                      : l10n.transactionFormCategory,
                  style: context.textTheme.labelMedium?.copyWith(
                    color: check ? c.warning : c.textSecondary,
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
