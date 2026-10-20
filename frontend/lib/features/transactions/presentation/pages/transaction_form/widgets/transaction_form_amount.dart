import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';
import 'package:monai/core/designsystem/designsystem.dart';
import 'package:monai/core/l10n/l10n.dart';
import 'package:monai/core/model/transaction_type.dart';
import 'package:monai/core/utils/money_format.dart';
import 'package:monai/features/shared/domain/validation/transaction_input_validator.dart';
import 'package:monai/features/transactions/presentation/pages/transaction_form/bloc/transaction_form_bloc.dart';
import 'package:monai/features/transactions/presentation/pages/transaction_form/widgets/transaction_form_field_error.dart';

final _digits = NumberFormat.decimalPattern('id');

/// The amount typed on the keypad, signed and colored by type, with the
/// saved amount under it while editing.
class TransactionFormAmount extends StatelessWidget {
  const TransactionFormAmount({super.key});

  @override
  Widget build(BuildContext context) {
    final c = context.colors;
    final t = context.textTheme;
    return BlocSelector<
      TransactionFormBloc,
      TransactionFormState,
      (int, TransactionType, int?)
    >(
      selector: (state) =>
          (state.draft.amount, state.draft.type, state.changedFromAmount),
      builder: (context, selected) {
        final (amount, type, was) = selected;
        final (sign, color) = switch (type) {
          .expense => ('−', c.expense),
          .income => ('+', c.income),
          .transfer => ('', c.textPrimary),
        };
        return Semantics(
          liveRegion: true,
          child: Column(
            children: [
              Row(
                mainAxisAlignment: .center,
                crossAxisAlignment: .baseline,
                textBaseline: .alphabetic,
                spacing: MonAISpacing.x2,
                children: [
                  Text(
                    '${sign}Rp',
                    style: t.titleLarge?.copyWith(color: c.textTertiary),
                  ),
                  Flexible(
                    child: FittedBox(
                      fit: .scaleDown,
                      child: Text(
                        _digits.format(amount),
                        style: t.displayMedium?.copyWith(color: color),
                      ),
                    ),
                  ),
                ],
              ),
              if (was case final was?)
                Text(
                  context.l10n.transactionFormWas(formatRupiah(was)),
                  style: t.bodySmall?.copyWith(color: c.textTertiary),
                ),
              const TransactionFormFieldError(
                fields: [TransactionInputValidator.amountField],
              ),
            ],
          ),
        );
      },
    );
  }
}
