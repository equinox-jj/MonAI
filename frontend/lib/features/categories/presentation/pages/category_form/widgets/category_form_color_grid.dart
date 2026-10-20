import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:monai/core/designsystem/designsystem.dart';
import 'package:monai/core/l10n/l10n.dart';
import 'package:monai/features/categories/domain/logic/category_choices.dart';
import 'package:monai/features/categories/presentation/model/category_choice_text.dart';
import 'package:monai/features/categories/presentation/pages/category_form/bloc/category_form_bloc.dart';

/// The colors to pick from, five to a row; the picked one ringed and
/// checked.
class CategoryFormColorGrid extends StatelessWidget {
  const CategoryFormColorGrid({required this.onPick, super.key});

  final ValueChanged<String> onPick;

  static const _columns = 5;

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    return Column(
      crossAxisAlignment: .stretch,
      spacing: MonAISpacing.x2,
      children: [
        Text(
          l10n.categoryFormColor,
          style: context.textTheme.labelMedium?.copyWith(
            color: context.colors.textSecondary,
          ),
        ),
        BlocSelector<CategoryFormBloc, CategoryFormState, String>(
          selector: (state) => state.color,
          builder: (context, picked) => GridView.builder(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            padding: .zero,
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: _columns,
              mainAxisSpacing: MonAISpacing.x2_5,
              crossAxisSpacing: MonAISpacing.x2_5,
              mainAxisExtent: MonAISizes.touchTarget,
            ),
            itemCount: categoryColorChoices.length,
            itemBuilder: (context, index) {
              final hex = categoryColorChoices[index];
              return _Swatch(
                color: CategoryColors.parse(hex),
                label: l10n.categoryColorName(hex),
                selected: hex == picked,
                onTap: () => onPick(hex),
              );
            },
          ),
        ),
      ],
    );
  }
}

class _Swatch extends StatelessWidget {
  const _Swatch({
    required this.color,
    required this.label,
    required this.selected,
    required this.onTap,
  });

  final Color color;
  final String label;
  final bool selected;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final c = context.colors;
    final fill = CategoryColors.content(color, dark: c.isDark);
    return Semantics(
      label: label,
      inMutuallyExclusiveGroup: true,
      checked: selected,
      button: true,
      child: Center(
        child: InkWell(
          onTap: onTap,
          customBorder: const CircleBorder(),
          child: Container(
            width: MonAISizes.touchTarget,
            height: MonAISizes.touchTarget,
            alignment: .center,
            decoration: BoxDecoration(
              color: fill,
              shape: .circle,
              border: selected
                  ? Border.all(
                      color: c.surface,
                      width: MonAISizes.borderFocused,
                      strokeAlign: BorderSide.strokeAlignInside,
                    )
                  : null,
              boxShadow: selected
                  ? [BoxShadow(color: fill, spreadRadius: 2)]
                  : null,
            ),
            child: selected
                ? const MonAIIcon(
                    MonAIIcons.check,
                    size: MonAISizes.iconLg,
                    color: Colors.white,
                  )
                : null,
          ),
        ),
      ),
    );
  }
}
