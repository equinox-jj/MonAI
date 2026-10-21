import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:monai/core/ui/designsystem/designsystem.dart';
import 'package:monai/core/base/error/field_error.dart';
import 'package:monai/core/ui/l10n/l10n.dart';
import 'package:monai/core/utils/rupiah_input_formatter.dart';
import 'package:monai/features/budgets/presentation/pages/budget/bloc/budget_bloc.dart';
import 'package:monai/features/budgets/presentation/pages/budget/model/budget_field_error_text.dart';

/// The monthly limit, typed large in the middle with an underline that turns
/// red on an error.
class BudgetLimitField extends StatelessWidget {
  const BudgetLimitField({
    required this.controller,
    required this.onChanged,
    super.key,
  });

  final TextEditingController controller;
  final ValueChanged<String> onChanged;

  static const _underlineWidth = 220.0;

  @override
  Widget build(BuildContext context) {
    final c = context.colors;
    final t = context.textTheme;
    final l10n = context.l10n;
    return BlocSelector<BudgetBloc, BudgetState, FieldError?>(
      selector: (state) => state.limitError,
      builder: (context, error) => Padding(
        padding: const .symmetric(vertical: MonAISpacing.x2),
        child: Column(
          spacing: MonAISpacing.x2,
          children: [
            Text(
              l10n.budgetLimitLabel,
              style: t.labelMedium?.copyWith(color: c.textSecondary),
            ),
            Row(
              mainAxisAlignment: .center,
              crossAxisAlignment: .baseline,
              textBaseline: .alphabetic,
              spacing: MonAISpacing.x2,
              children: [
                Text(
                  l10n.budgetCurrency,
                  style: t.headlineSmall?.copyWith(color: c.textTertiary),
                ),
                Flexible(
                  child: IntrinsicWidth(
                    child: TextField(
                      controller: controller,
                      onChanged: onChanged,
                      keyboardType: TextInputType.number,
                      textAlign: .center,
                      inputFormatters: const [
                        RupiahInputFormatter(maxDigits: 12),
                      ],
                      style: t.displayLarge?.tabular.copyWith(
                        color: c.textPrimary,
                      ),
                      cursorColor: c.accent,
                      decoration: InputDecoration(
                        isCollapsed: true,
                        border: InputBorder.none,
                        hintText: '0',
                        hintStyle: t.displayLarge?.tabular.copyWith(
                          color: c.textDisabled,
                        ),
                        semanticCounterText: l10n.budgetLimitDescription,
                      ),
                    ),
                  ),
                ),
              ],
            ),
            Container(
              width: _underlineWidth,
              height: MonAISizes.borderFocused,
              decoration: BoxDecoration(
                color: error == null ? c.focus : c.error,
                borderRadius: MonAIRadius.xsAll,
              ),
            ),
            if (error != null)
              Text(
                error.text(l10n),
                textAlign: .center,
                style: t.bodySmall?.copyWith(color: c.errorText),
              ),
          ],
        ),
      ),
    );
  }
}
