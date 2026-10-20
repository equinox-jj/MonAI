import 'package:flutter/material.dart';
import 'package:monai/core/designsystem/designsystem.dart';
import 'package:monai/core/l10n/l10n.dart';
import 'package:monai/features/shared/domain/entity/category.dart';

/// Every category of the form's type in a grid; "Use Food" sends the pick
/// to [onPick] and closes. Show it with [showMonAIBottomSheet].
class TransactionCategoryPickerSheet extends StatefulWidget {
  const TransactionCategoryPickerSheet({
    required this.categories,
    required this.selectedId,
    required this.onPick,
    super.key,
  });

  final List<Category> categories;
  final String? selectedId;
  final ValueChanged<String> onPick;

  @override
  State<TransactionCategoryPickerSheet> createState() =>
      _TransactionCategoryPickerSheetState();
}

class _TransactionCategoryPickerSheetState
    extends State<TransactionCategoryPickerSheet> {
  late final _selected = ValueNotifier<String?>(widget.selectedId);

  @override
  void dispose() {
    _selected.dispose();
    super.dispose();
  }

  void _pick(String id) => _selected.value = id;

  void _use(String id) {
    widget.onPick(id);
    Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    if (widget.categories.isEmpty) {
      return Padding(
        padding: const .symmetric(vertical: MonAISpacing.x6),
        child: Text(l10n.transactionFormNoCategories, textAlign: .center),
      );
    }
    // TODO(transactions): add the "New" tile once the category form exists.
    return ValueListenableBuilder(
      valueListenable: _selected,
      builder: (context, selected, _) {
        final chosen = widget.categories
            .where((c) => c.id == selected)
            .firstOrNull;
        return Column(
          mainAxisSize: .min,
          crossAxisAlignment: .stretch,
          spacing: MonAISpacing.x4,
          children: [
            Flexible(
              child: GridView.builder(
                shrinkWrap: true,
                itemCount: widget.categories.length,
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 4,
                  mainAxisSpacing: MonAISpacing.x4,
                  crossAxisSpacing: MonAISpacing.x2,
                  mainAxisExtent: 84,
                ),
                itemBuilder: (context, index) {
                  final category = widget.categories[index];
                  return _CategoryTile(
                    category: category,
                    selected: category.id == selected,
                    onTap: () => _pick(category.id),
                  );
                },
              ),
            ),
            MonAIButton(
              label: chosen == null
                  ? l10n.transactionFormDone
                  : l10n.transactionFormUseCategory(chosen.name),
              onPressed: chosen == null ? null : () => _use(chosen.id),
              expand: true,
            ),
          ],
        );
      },
    );
  }
}

class _CategoryTile extends StatelessWidget {
  const _CategoryTile({
    required this.category,
    required this.selected,
    required this.onTap,
  });

  final Category category;
  final bool selected;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final c = context.colors;
    return Semantics(
      inMutuallyExclusiveGroup: true,
      checked: selected,
      button: true,
      child: InkWell(
        onTap: onTap,
        borderRadius: MonAIRadius.mdAll,
        child: Column(
          spacing: MonAISpacing.x1_5,
          children: [
            DecoratedBox(
              decoration: BoxDecoration(
                shape: .circle,
                border: Border.all(
                  color: selected ? c.focus : Colors.transparent,
                  width: MonAISizes.borderFocused,
                ),
              ),
              child: Padding(
                padding: const .all(MonAISpacing.x0_5),
                child: MonAICategoryIcon(
                  icon: categoryIcon(category.icon),
                  color: CategoryColors.parse(category.color),
                  size: MonAISizes.avatarLarge - MonAISpacing.x2,
                ),
              ),
            ),
            Text(
              category.name,
              textAlign: .center,
              maxLines: 2,
              overflow: .ellipsis,
              style: context.textTheme.labelMedium?.copyWith(
                color: c.textSecondary,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
