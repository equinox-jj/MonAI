import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:monai/core/designsystem/designsystem.dart';
import 'package:monai/core/utils/money_format.dart';
import 'package:monai/features/budgets/domain/logic/budget_presets.dart';
import 'package:monai/features/budgets/presentation/pages/budget/bloc/budget_bloc.dart';

/// Quick limits in one row; the one matching the field is selected.
class BudgetPresets extends StatelessWidget {
  const BudgetPresets({required this.onPick, super.key});

  final ValueChanged<int> onPick;

  @override
  Widget build(BuildContext context) {
    return BlocSelector<BudgetBloc, BudgetState, int>(
      selector: (state) => state.limit,
      builder: (context, limit) => GridView.builder(
        shrinkWrap: true,
        physics: const NeverScrollableScrollPhysics(),
        padding: EdgeInsets.zero,
        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 4,
          crossAxisSpacing: MonAISpacing.x2,
          mainAxisExtent: MonAISizes.choiceChip,
        ),
        itemCount: budgetPresets.length,
        itemBuilder: (context, index) {
          final amount = budgetPresets[index];
          return _PresetPill(
            label: formatRupiahCompact(amount, symbol: false),
            selected: amount == limit,
            onTap: () => onPick(amount),
          );
        },
      ),
    );
  }
}

class _PresetPill extends StatelessWidget {
  const _PresetPill({
    required this.label,
    required this.selected,
    required this.onTap,
  });

  final String label;
  final bool selected;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final c = context.colors;
    return Semantics(
      button: true,
      selected: selected,
      child: Material(
        color: selected ? c.primaryContainer : c.surface,
        shape: StadiumBorder(
          side: BorderSide(
            color: selected ? c.primaryContainerBorder : c.borderStrong,
          ),
        ),
        clipBehavior: .antiAlias,
        child: InkWell(
          onTap: onTap,
          child: Center(
            child: Text(
              label,
              style: context.textTheme.labelLarge?.copyWith(
                color: selected ? c.onPrimaryContainer : c.textSecondary,
              ),
            ),
          ),
        ),
      ),
    );
  }
}
