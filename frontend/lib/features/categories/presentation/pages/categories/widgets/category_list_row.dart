import 'package:flutter/material.dart';
import 'package:monai/core/ui/designsystem/designsystem.dart';
import 'package:monai/core/ui/l10n/l10n.dart';
import 'package:monai/features/categories/domain/logic/category_rules.dart';
import 'package:monai/features/shared/domain/entity/category.dart';

class CategoryListRow extends StatelessWidget {
  const CategoryListRow({
    required this.category,
    required this.busy,
    required this.onTap,
    required this.onToggleHidden,
    required this.onDelete,
    super.key,
  });

  final Category category;
  final bool busy;
  final VoidCallback onTap;
  final VoidCallback onToggleHidden;
  final VoidCallback onDelete;

  static const _hiddenOpacity = 0.6;

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    final c = context.colors;
    final t = context.textTheme;
    final kind = category.kind;
    final tag = switch ((kind, category.isHidden)) {
      (_, true) => l10n.categoriesTagHidden,
      (.custom, false) => l10n.categoriesTagCustom,
      _ => null,
    };
    final meta = switch ((kind, category.isHidden)) {
      (.system, _) => l10n.categoriesMetaSystem,
      (_, true) => l10n.categoriesMetaHidden,
      (.custom, false) => l10n.categoriesMetaCustom,
      (.standard, false) => l10n.categoriesMetaDefault,
    };
    return InkWell(
      onTap: category.canEdit ? onTap : null,
      child: ConstrainedBox(
        constraints: const BoxConstraints(minHeight: MonAISizes.listRowMin),
        child: Padding(
          padding: const .only(left: MonAISpacing.x4, right: MonAISpacing.x2),
          child: Row(
            spacing: MonAISpacing.x3,
            children: [
              Expanded(
                child: Opacity(
                  opacity: category.isHidden ? _hiddenOpacity : 1,
                  child: Row(
                    spacing: MonAISpacing.x3,
                    children: [
                      MonAICategoryIcon(
                        icon: categoryIcon(category.icon),
                        color: CategoryColors.parse(category.color),
                      ),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: .start,
                          children: [
                            Row(
                              spacing: MonAISpacing.x1_5,
                              children: [
                                Flexible(
                                  child: Text(
                                    category.name,
                                    maxLines: 1,
                                    overflow: .ellipsis,
                                    style: t.titleSmall
                                        ?.withWeight(.w600)
                                        .copyWith(color: c.textPrimary),
                                  ),
                                ),
                                if (tag != null)
                                  MonAITag(text: tag.toUpperCase()),
                              ],
                            ),
                            Text(
                              meta,
                              style: t.bodySmall?.copyWith(
                                color: c.textTertiary,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              _RowAction(
                category: category,
                busy: busy,
                onToggleHidden: onToggleHidden,
                onDelete: onDelete,
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _RowAction extends StatelessWidget {
  const _RowAction({
    required this.category,
    required this.busy,
    required this.onToggleHidden,
    required this.onDelete,
  });

  final Category category;
  final bool busy;
  final VoidCallback onToggleHidden;
  final VoidCallback onDelete;

  static const _spinner = 20.0;

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    final c = context.colors;
    if (busy) {
      return const SizedBox.square(
        dimension: MonAISizes.touchTarget,
        child: Center(
          child: SizedBox.square(
            dimension: _spinner,
            child: CircularProgressIndicator(strokeWidth: 2),
          ),
        ),
      );
    }
    if (category.kind == .system) {
      return SizedBox.square(
        dimension: MonAISizes.touchTarget,
        child: Center(
          child: Semantics(
            label: l10n.categoriesLocked,
            child: MonAIIcon(
              MonAIIcons.lock,
              size: MonAISizes.iconLg,
              color: c.textDisabled,
            ),
          ),
        ),
      );
    }
    if (category.canDelete && !category.isHidden) {
      return MonAIIconButton(
        icon: MonAIIcons.delete,
        tooltip: l10n.categoriesDelete(category.name),
        color: c.errorText,
        onPressed: onDelete,
      );
    }
    if (category.canToggleHidden) {
      return MonAIIconButton(
        icon: category.isHidden
            ? MonAIIcons.visibility
            : MonAIIcons.visibilityOff,
        tooltip: category.isHidden
            ? l10n.categoriesShow(category.name)
            : l10n.categoriesHide(category.name),
        color: c.textSecondary,
        onPressed: onToggleHidden,
      );
    }
    return const SizedBox.square(dimension: MonAISizes.touchTarget);
  }
}
