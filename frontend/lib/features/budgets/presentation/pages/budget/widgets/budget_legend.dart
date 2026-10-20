import 'package:flutter/material.dart';
import 'package:monai/core/designsystem/designsystem.dart';
import 'package:monai/core/l10n/l10n.dart';
import 'package:monai/core/model/budget_status.dart';

/// What the preview's colors mean.
class BudgetLegend extends StatelessWidget {
  const BudgetLegend({super.key});

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    return Column(
      crossAxisAlignment: .start,
      spacing: MonAISpacing.x2,
      children: [
        _LegendRow(status: .ok, label: l10n.budgetLegendOk),
        _LegendRow(status: .warning, label: l10n.budgetLegendWarning),
        _LegendRow(status: .exceeded, label: l10n.budgetLegendExceeded),
      ],
    );
  }
}

class _LegendRow extends StatelessWidget {
  const _LegendRow({required this.status, required this.label});

  final BudgetStatus status;
  final String label;

  static const _swatchWidth = 24.0;
  static const _swatchHeight = 6.0;

  @override
  Widget build(BuildContext context) {
    final c = context.colors;
    return Row(
      spacing: MonAISpacing.x2,
      children: [
        Container(
          width: _swatchWidth,
          height: _swatchHeight,
          decoration: BoxDecoration(
            color: status.color(c),
            borderRadius: MonAIRadius.xsAll,
          ),
        ),
        Expanded(
          child: Text(
            label,
            style: context.textTheme.bodySmall?.copyWith(
              color: c.textSecondary,
            ),
          ),
        ),
      ],
    );
  }
}
