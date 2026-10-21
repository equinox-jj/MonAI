import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:monai/core/ui/designsystem/designsystem.dart';
import 'package:monai/core/ui/l10n/l10n.dart';
import 'package:monai/core/model/transaction_type.dart';
import 'package:monai/features/transactions/presentation/model/transaction_text.dart';
import 'package:monai/features/transactions/presentation/pages/transaction_form/bloc/transaction_form_bloc.dart';

class TransactionFormTypeTabs extends StatelessWidget {
  const TransactionFormTypeTabs({super.key});

  void _select(BuildContext context, TransactionType type) => context
      .read<TransactionFormBloc>()
      .add(TransactionFormEvent.typeSelected(type));

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    final c = context.colors;
    return BlocSelector<
      TransactionFormBloc,
      TransactionFormState,
      TransactionType
    >(
      selector: (state) => state.draft.type,
      builder: (context, type) => MonAISegmentedControl<TransactionType>(
        selected: type,
        onChanged: (type) => _select(context, type),
        segments: [
          MonAISegment(
            value: .expense,
            label: TransactionType.expense.label(l10n),
            selectedContainer: c.expenseContainer,
            selectedContent: c.expense,
          ),
          MonAISegment(
            value: .income,
            label: TransactionType.income.label(l10n),
            selectedContainer: c.incomeContainer,
            selectedContent: c.income,
          ),
          MonAISegment(
            value: .transfer,
            label: TransactionType.transfer.label(l10n),
          ),
        ],
      ),
    );
  }
}
