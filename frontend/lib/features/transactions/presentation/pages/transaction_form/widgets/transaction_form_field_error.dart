import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:monai/core/ui/designsystem/designsystem.dart';
import 'package:monai/core/base/error/field_error.dart';
import 'package:monai/core/ui/l10n/l10n.dart';
import 'package:monai/features/transactions/presentation/pages/transaction_form/bloc/transaction_form_bloc.dart';
import 'package:monai/features/transactions/presentation/pages/transaction_form/model/transaction_field_error_text.dart';

class TransactionFormFieldError extends StatelessWidget {
  const TransactionFormFieldError({required this.fields, super.key});
  final List<String> fields;

  @override
  Widget build(BuildContext context) {
    return BlocSelector<TransactionFormBloc, TransactionFormState, FieldError?>(
      selector: (state) => fields.map(state.errorOf).nonNulls.firstOrNull,
      builder: (context, error) => switch (error) {
        final error? => Padding(
          padding: const .only(top: MonAISpacing.x1),
          child: Text(
            error.text(context.l10n),
            style: context.textTheme.bodySmall?.copyWith(
              color: context.colors.errorText,
            ),
          ),
        ),
        null => const SizedBox.shrink(),
      },
    );
  }
}
