import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:monai/core/ui/designsystem/designsystem.dart';
import 'package:monai/core/ui/l10n/l10n.dart';
import 'package:monai/features/budgets/presentation/pages/budget/bloc/budget_bloc.dart';
import 'package:monai/features/budgets/presentation/pages/budget/model/budget_state_extension.dart';

typedef _Actions = ({bool canSave, bool isSaving, bool hasBudget, bool isBusy});

class BudgetActions extends StatelessWidget {
  const BudgetActions({
    required this.monthName,
    required this.onSave,
    required this.onRemove,
    super.key,
  });

  final String monthName;
  final VoidCallback onSave;
  final VoidCallback onRemove;

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    return BlocSelector<BudgetBloc, BudgetState, _Actions>(
      selector: (state) => (
        canSave: state.canSave,
        isSaving: state.isSaving,
        hasBudget: state.hasBudget,
        isBusy: state.isBusy,
      ),
      builder: (context, actions) => Column(
        crossAxisAlignment: .stretch,
        spacing: MonAISpacing.x2,
        children: [
          MonAIButton(
            label: l10n.budgetSave,
            expand: true,
            loading: actions.isSaving,
            onPressed: actions.canSave ? onSave : null,
          ),
          if (actions.hasBudget)
            _RemoveButton(
              label: l10n.budgetRemove(monthName),
              onPressed: actions.isBusy ? null : onRemove,
            ),
        ],
      ),
    );
  }
}

class _RemoveButton extends StatelessWidget {
  const _RemoveButton({required this.label, required this.onPressed});

  final String label;
  final VoidCallback? onPressed;

  @override
  Widget build(BuildContext context) {
    final c = context.colors;
    return SizedBox(
      height: MonAISizes.buttonMedium,
      child: TextButton(
        onPressed: onPressed,
        style: TextButton.styleFrom(
          foregroundColor: c.errorText,
          disabledForegroundColor: c.disabledContent,
          shape: const StadiumBorder(),
          textStyle: context.textTheme.labelLarge,
        ),
        child: Text(label),
      ),
    );
  }
}
