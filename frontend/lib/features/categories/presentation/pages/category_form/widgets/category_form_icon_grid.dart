import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:monai/core/designsystem/designsystem.dart';
import 'package:monai/core/l10n/l10n.dart';
import 'package:monai/features/categories/domain/logic/category_choices.dart';
import 'package:monai/features/categories/presentation/model/category_choice_text.dart';
import 'package:monai/features/categories/presentation/pages/category_form/bloc/category_form_bloc.dart';

/// The icons to pick from, six to a row; the picked one in the category's
/// color.
class CategoryFormIconGrid extends StatelessWidget {
  const CategoryFormIconGrid({required this.onPick, super.key});

  final ValueChanged<String> onPick;

  static const _columns = 6;
  static const _cellHeight = 48.0;

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    return Column(
      crossAxisAlignment: .stretch,
      spacing: MonAISpacing.x2,
      children: [
        Text(
          l10n.categoryFormIcon,
          style: context.textTheme.labelMedium?.copyWith(
            color: context.colors.textSecondary,
          ),
        ),
        BlocSelector<CategoryFormBloc, CategoryFormState, (String, String)>(
          selector: (state) => (state.icon, state.color),
          builder: (context, selected) {
            final (picked, colorHex) = selected;
            return GridView.builder(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              padding: .zero,
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: _columns,
                mainAxisSpacing: MonAISpacing.x2,
                crossAxisSpacing: MonAISpacing.x2,
                mainAxisExtent: _cellHeight,
              ),
              itemCount: categoryIconChoices.length,
              itemBuilder: (context, index) {
                final icon = categoryIconChoices[index];
                return _IconCell(
                  icon: icon,
                  label: l10n.categoryIconName(icon),
                  color: CategoryColors.parse(colorHex),
                  selected: icon == picked,
                  onTap: () => onPick(icon),
                );
              },
            );
          },
        ),
      ],
    );
  }
}

class _IconCell extends StatelessWidget {
  const _IconCell({
    required this.icon,
    required this.label,
    required this.color,
    required this.selected,
    required this.onTap,
  });

  final String icon;
  final String label;
  final Color color;
  final bool selected;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final c = context.colors;
    final content = CategoryColors.content(color, dark: c.isDark);
    return Semantics(
      label: label,
      inMutuallyExclusiveGroup: true,
      checked: selected,
      button: true,
      child: Material(
        color: selected
            ? CategoryColors.tint(color, dark: c.isDark)
            : c.background,
        shape: RoundedRectangleBorder(
          borderRadius: MonAIRadius.mdAll,
          side: selected
              ? BorderSide(color: content, width: MonAISizes.borderFocused)
              : BorderSide(color: c.border),
        ),
        clipBehavior: .antiAlias,
        child: InkWell(
          onTap: onTap,
          child: Center(
            child: MonAIIcon(
              categoryIcon(icon),
              color: selected ? content : c.textSecondary,
            ),
          ),
        ),
      ),
    );
  }
}
