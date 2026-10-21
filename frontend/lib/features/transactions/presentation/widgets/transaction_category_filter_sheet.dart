import 'package:flutter/material.dart';
import 'package:monai/core/ui/designsystem/designsystem.dart';
import 'package:monai/core/ui/l10n/l10n.dart';
import 'package:monai/core/model/category_type.dart';
import 'package:monai/features/shared/domain/entity/category.dart';

/// The categories in an Expense and an Income group; Apply sends the choice
/// (null for all) to [onApply] and closes. Show it with
/// [showMonAIBottomSheet].
class TransactionCategoryFilterSheet extends StatefulWidget {
  const TransactionCategoryFilterSheet({
    required this.categories,
    required this.selectedId,
    required this.onApply,
    super.key,
  });

  final List<Category> categories;
  final String? selectedId;
  final ValueChanged<String?> onApply;

  @override
  State<TransactionCategoryFilterSheet> createState() =>
      _TransactionCategoryFilterSheetState();
}

class _TransactionCategoryFilterSheetState
    extends State<TransactionCategoryFilterSheet> {
  late final _selected = ValueNotifier<String?>(widget.selectedId);

  @override
  void dispose() {
    _selected.dispose();
    super.dispose();
  }

  void _toggle(String id) =>
      _selected.value = _selected.value == id ? null : id;

  void _clear() => _selected.value = null;

  void _apply() {
    widget.onApply(_selected.value);
    Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    final groups = [
      (
        label: l10n.transactionTypeExpense,
        items: widget.categories.where((c) => c.type == CategoryType.expense),
      ),
      (
        label: l10n.transactionTypeIncome,
        items: widget.categories.where((c) => c.type == CategoryType.income),
      ),
    ].where((group) => group.items.isNotEmpty).toList();

    return ValueListenableBuilder(
      valueListenable: _selected,
      builder: (context, selected, _) => Column(
        mainAxisSize: .min,
        crossAxisAlignment: .stretch,
        spacing: MonAISpacing.x3_5,
        children: [
          Flexible(
            child: ListView.separated(
              shrinkWrap: true,
              itemCount: groups.length,
              separatorBuilder: (_, _) =>
                  const SizedBox(height: MonAISpacing.x4),
              itemBuilder: (context, index) => _CategoryGroup(
                label: groups[index].label,
                categories: groups[index].items.toList(),
                selectedId: selected,
                onToggle: _toggle,
              ),
            ),
          ),
          MonAISheetButtons(
            secondaryLabel: l10n.filterClear,
            onSecondary: _clear,
            primaryLabel: selected == null
                ? l10n.filterShowAll
                : l10n.filterApply,
            onPrimary: _apply,
          ),
        ],
      ),
    );
  }
}

class _CategoryGroup extends StatelessWidget {
  const _CategoryGroup({
    required this.label,
    required this.categories,
    required this.selectedId,
    required this.onToggle,
  });

  final String label;
  final List<Category> categories;
  final String? selectedId;
  final ValueChanged<String> onToggle;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: .start,
      spacing: MonAISpacing.x2,
      children: [
        Text(
          label.toUpperCase(),
          style: context.textTheme.labelSmall?.copyWith(
            color: context.colors.textTertiary,
          ),
        ),
        Wrap(
          spacing: MonAISpacing.x2,
          runSpacing: MonAISpacing.x2,
          children: categories
              .map(
                (category) => CategoryChoiceChip(
                  category: category,
                  selected: category.id == selectedId,
                  onTap: () => onToggle(category.id),
                ),
              )
              .toList(),
        ),
      ],
    );
  }
}

/// A category as a pill: its icon in a tinted circle and its name, checked
/// when [selected].
class CategoryChoiceChip extends StatelessWidget {
  const CategoryChoiceChip({
    required this.category,
    required this.selected,
    required this.onTap,
    super.key,
  });

  final Category category;
  final bool selected;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final c = context.colors;
    return Semantics(
      button: true,
      selected: selected,
      child: Material(
        color: selected ? c.primaryContainer : c.surface,
        shape: RoundedRectangleBorder(
          borderRadius: MonAIRadius.fullAll,
          side: BorderSide(
            color: selected ? c.primaryContainerBorder : c.border,
          ),
        ),
        clipBehavior: .antiAlias,
        child: InkWell(
          onTap: onTap,
          child: Padding(
            padding: const .fromLTRB(
              MonAISpacing.x1,
              MonAISpacing.x1,
              MonAISpacing.x3,
              MonAISpacing.x1,
            ),
            child: Row(
              mainAxisSize: .min,
              spacing: MonAISpacing.x1_5,
              children: [
                MonAICategoryIcon(
                  icon: categoryIcon(category.icon),
                  color: CategoryColors.parse(category.color),
                  size: MonAISizes.avatarSmall,
                ),
                Text(
                  category.name,
                  style: context.textTheme.labelLarge?.copyWith(
                    color: c.textPrimary,
                  ),
                ),
                if (selected)
                  MonAIIcon(
                    MonAIIcons.check,
                    size: MonAISizes.iconSm,
                    color: c.accent,
                  ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
