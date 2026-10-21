import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:monai/core/ui/designsystem/designsystem.dart';
import 'package:monai/core/base/error/field_error.dart';
import 'package:monai/core/ui/l10n/l10n.dart';
import 'package:monai/core/model/category_type.dart';
import 'package:monai/features/categories/domain/validation/category_input_validator.dart';
import 'package:monai/features/categories/presentation/pages/category_form/bloc/category_form_bloc.dart';
import 'package:monai/features/categories/presentation/pages/category_form/model/category_field_error_text.dart';

/// The name, with its type and length under it, or its error.
class CategoryFormNameField extends StatelessWidget {
  const CategoryFormNameField({
    required this.controller,
    required this.onChanged,
    super.key,
  });

  final TextEditingController controller;
  final ValueChanged<String> onChanged;

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    return BlocSelector<
      CategoryFormBloc,
      CategoryFormState,
      (FieldError?, CategoryType)
    >(
      selector: (state) => (state.nameError, state.type),
      builder: (context, selected) {
        final (error, type) = selected;
        return ListenableBuilder(
          listenable: controller,
          builder: (context, _) {
            final count = controller.text.characters.length;
            const max = CategoryInputValidator.nameMax;
            return MonAITextField(
              controller: controller,
              onChanged: onChanged,
              label: l10n.categoryFormName,
              placeholder: l10n.categoryFormNamePlaceholder,
              maxLength: max,
              textInputAction: .done,
              tone: error == null ? .neutral : .error,
              supportingText:
                  error?.text(l10n) ??
                  switch (type) {
                    .expense => l10n.categoryFormExpenseCaption(count, max),
                    .income => l10n.categoryFormIncomeCaption(count, max),
                  },
            );
          },
        );
      },
    );
  }
}
