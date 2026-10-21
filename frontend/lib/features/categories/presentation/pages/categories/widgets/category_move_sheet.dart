import 'package:flutter/material.dart';
import 'package:monai/core/ui/designsystem/designsystem.dart';
import 'package:monai/core/ui/l10n/l10n.dart';
import 'package:monai/features/shared/domain/entity/category.dart';

/// Asks where a deleted category's transactions should go. Pops with the
/// picked category's id, or null on Cancel.
class CategoryMoveSheet extends StatefulWidget {
  const CategoryMoveSheet({
    required this.category,
    required this.targets,
    super.key,
  });

  /// The category being deleted.
  final Category category;

  /// Where its transactions can go; the first is picked to start with.
  final List<Category> targets;

  @override
  State<CategoryMoveSheet> createState() => _CategoryMoveSheetState();
}

class _CategoryMoveSheetState extends State<CategoryMoveSheet> {
  late final _selected = ValueNotifier<String?>(widget.targets.firstOrNull?.id);

  @override
  void dispose() {
    _selected.dispose();
    super.dispose();
  }

  void _pick(String id) => _selected.value = id;

  void _cancel() => Navigator.pop(context);

  void _confirm() => Navigator.pop(context, _selected.value);

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    final c = context.colors;
    final t = context.textTheme;
    return SingleChildScrollView(
      child: Column(
        crossAxisAlignment: .stretch,
        spacing: MonAISpacing.x3_5,
        children: [
          Align(
            alignment: .centerLeft,
            child: Container(
              width: MonAISizes.dialogIcon,
              height: MonAISizes.dialogIcon,
              alignment: .center,
              decoration: BoxDecoration(
                color: c.errorContainer,
                shape: .circle,
              ),
              child: MonAIIcon(MonAIIcons.delete, color: c.error),
            ),
          ),
          Text(
            l10n.categoriesDeleteTitle(widget.category.name),
            style: t.headlineSmall,
          ),
          Text(
            l10n.categoriesMoveMessage(widget.category.name),
            style: t.bodyMedium?.copyWith(color: c.textSecondary),
          ),
          Text(
            l10n.categoriesMoveTo,
            style: t.labelMedium?.copyWith(color: c.textSecondary),
          ),
          ValueListenableBuilder<String?>(
            valueListenable: _selected,
            builder: (context, selected, _) => ListView.separated(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              padding: .zero,
              itemCount: widget.targets.length,
              separatorBuilder: (_, _) =>
                  const SizedBox(height: MonAISpacing.x1_5),
              itemBuilder: (context, index) {
                final target = widget.targets[index];
                return _TargetOption(
                  category: target,
                  selected: target.id == selected,
                  onTap: () => _pick(target.id),
                );
              },
            ),
          ),
          Padding(
            padding: const .only(top: MonAISpacing.x1_5),
            child: Row(
              spacing: MonAISpacing.x3,
              children: [
                Expanded(
                  child: MonAIButton(
                    label: l10n.categoriesCancel,
                    variant: .outlined,
                    size: .medium,
                    expand: true,
                    onPressed: _cancel,
                  ),
                ),
                Expanded(
                  child: ValueListenableBuilder<String?>(
                    valueListenable: _selected,
                    builder: (context, selected, _) => MonAIButton(
                      label: l10n.categoriesMoveConfirm,
                      variant: .destructive,
                      size: .medium,
                      expand: true,
                      onPressed: selected == null ? null : _confirm,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _TargetOption extends StatelessWidget {
  const _TargetOption({
    required this.category,
    required this.selected,
    required this.onTap,
  });

  final Category category;
  final bool selected;
  final VoidCallback onTap;

  static const _height = 52.0;
  static const _iconSize = 32.0;

  @override
  Widget build(BuildContext context) {
    final c = context.colors;
    return Semantics(
      inMutuallyExclusiveGroup: true,
      checked: selected,
      child: Material(
        color: selected ? c.primaryContainer : c.surface,
        shape: RoundedRectangleBorder(
          borderRadius: MonAIRadius.mdAll,
          side: BorderSide(
            color: selected ? c.focus : c.border,
            width: selected ? MonAISizes.borderFocused : MonAISizes.border,
          ),
        ),
        clipBehavior: .antiAlias,
        child: InkWell(
          onTap: onTap,
          child: SizedBox(
            height: _height,
            child: Padding(
              padding: const .symmetric(horizontal: MonAISpacing.x3),
              child: Row(
                spacing: MonAISpacing.x3,
                children: [
                  MonAICategoryIcon(
                    icon: categoryIcon(category.icon),
                    color: CategoryColors.parse(category.color),
                    size: _iconSize,
                  ),
                  Expanded(
                    child: Text(
                      category.name,
                      style: context.textTheme.titleSmall
                          ?.withWeight(.w600)
                          .copyWith(color: c.textPrimary),
                    ),
                  ),
                  MonAIIcon(
                    selected
                        ? MonAIIcons.radioButtonChecked
                        : MonAIIcons.radioButtonUnchecked,
                    color: selected ? c.accent : c.textDisabled,
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
