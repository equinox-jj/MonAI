import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:monai/core/designsystem/designsystem.dart';
import 'package:monai/core/l10n/l10n.dart';
import 'package:monai/features/categories/presentation/pages/category_form/bloc/category_form_bloc.dart';

/// The category as it will look: its icon large, then a chip with its name.
class CategoryFormPreview extends StatelessWidget {
  const CategoryFormPreview({required this.name, super.key});

  /// The name field, so the chip follows typing.
  final TextEditingController name;

  static const _iconSize = 72.0;
  static const _chipIcon = 24.0;
  static const _chipHeight = 32.0;

  @override
  Widget build(BuildContext context) {
    final c = context.colors;
    return ExcludeSemantics(
      child:
          BlocSelector<CategoryFormBloc, CategoryFormState, (String, String)>(
            selector: (state) => (state.icon, state.color),
            builder: (context, selected) {
              final (icon, colorHex) = selected;
              final color = CategoryColors.parse(colorHex);
              final dark = c.isDark;
              return Column(
                spacing: MonAISpacing.x2,
                children: [
                  Container(
                    width: _iconSize,
                    height: _iconSize,
                    alignment: .center,
                    decoration: BoxDecoration(
                      color: CategoryColors.tint(color, dark: dark),
                      shape: .circle,
                    ),
                    child: MonAIIcon(
                      categoryIcon(icon),
                      size: MonAISizes.iconXxl + MonAISpacing.x1,
                      color: CategoryColors.content(color, dark: dark),
                    ),
                  ),
                  Container(
                    height: _chipHeight,
                    padding: const .only(
                      left: MonAISpacing.x1,
                      right: MonAISpacing.x3,
                    ),
                    decoration: BoxDecoration(
                      border: Border.all(color: c.border),
                      borderRadius: MonAIRadius.fullAll,
                    ),
                    child: Row(
                      mainAxisSize: .min,
                      spacing: MonAISpacing.x1_5,
                      children: [
                        MonAICategoryIcon(
                          icon: categoryIcon(icon),
                          color: color,
                          size: _chipIcon,
                        ),
                        ListenableBuilder(
                          listenable: name,
                          builder: (context, _) => Text(
                            name.text.trim().isEmpty
                                ? context.l10n.categoryFormNewTitle
                                : name.text.trim(),
                            style: context.textTheme.labelLarge?.copyWith(
                              color: c.textPrimary,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              );
            },
          ),
    );
  }
}
