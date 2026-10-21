import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:monai/core/ui/designsystem/designsystem.dart';
import 'package:monai/core/ui/l10n/l10n.dart';
import 'package:monai/core/model/transaction_type.dart';
import 'package:monai/core/utils/month_format.dart';
import 'package:monai/features/shared/domain/validation/transaction_input_validator.dart';
import 'package:monai/features/transactions/presentation/model/transaction_picker_options.dart';
import 'package:monai/features/transactions/presentation/model/transaction_text.dart';
import 'package:monai/features/transactions/presentation/pages/transaction_form/bloc/transaction_form_bloc.dart';
import 'package:monai/features/transactions/presentation/pages/transaction_form/widgets/transaction_form_field_error.dart';

enum _WalletTarget { source, destination }

class TransactionFormFields extends StatelessWidget {
  const TransactionFormFields({super.key});

  void _openWalletPicker(BuildContext context, _WalletTarget target) {
    final bloc = context.read<TransactionFormBloc>();
    final state = bloc.state;
    final l10n = context.l10n;
    final isDestination = target == .destination;
    showMonAIBottomSheet<void>(
      context,
      title: switch ((state.draft.type, target)) {
        (.transfer, .source) => l10n.transactionFormFrom,
        (.transfer, .destination) => l10n.transactionFormTo,
        (.income, _) => l10n.transactionFormReceiveTo,
        (.expense, _) => l10n.transactionFormPayFrom,
      },
      builder: (_) => MonAIRadioPickerSheet(
        options: state.wallets.map((w) => w.pickerOption(l10n)).toList(),
        selectedId: isDestination
            ? state.draft.toWalletId
            : state.draft.walletId,
        onPick: (id) => bloc.add(
          isDestination
              ? TransactionFormEvent.toWalletPicked(id)
              : TransactionFormEvent.walletPicked(id),
        ),
        doneLabel: l10n.transactionFormDone,
        note: state.wallets.isEmpty
            ? l10n.transactionFormNoWallets
            : l10n.transactionFormArchivedNote,
      ),
    );
  }

  void _openDatePicker(BuildContext context) {
    final bloc = context.read<TransactionFormBloc>();
    showMonAIBottomSheet<void>(
      context,
      builder: (_) => MonAIDatePickerSheet(
        selected: bloc.state.draft.date,
        today: bloc.state.today,
        onPick: (date) => bloc.add(TransactionFormEvent.datePicked(date)),
        labels: transactionDatePickerLabels(
          context.l10n,
          today: bloc.state.today,
          locale: context.localeName,
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    return BlocBuilder<TransactionFormBloc, TransactionFormState>(
      buildWhen: (previous, current) =>
          previous.draft != current.draft ||
          previous.lookups != current.lookups ||
          previous.unsure != current.unsure,
      builder: (context, state) {
        final draft = state.draft;
        final wallet = state.lookups.wallet(draft.walletId)?.name ?? '–';
        final walletUnsure = state.isUnsure(
          TransactionInputValidator.walletField,
        );
        final date = _SelectBox(
          icon: MonAIIcons.calendarToday,
          label: l10n.transactionFormDate,
          check: state.isUnsure(TransactionInputValidator.dateField),
          value: TransactionDates.field(
            draft.date,
            state.today,
            l10n,
            context.localeName,
          ),
          onTap: () => _openDatePicker(context),
        );
        const walletErrors = TransactionFormFieldError(
          fields: [
            TransactionInputValidator.walletField,
            TransactionInputValidator.toWalletField,
          ],
        );
        if (draft.type == TransactionType.transfer) {
          return Column(
            crossAxisAlignment: .stretch,
            spacing: MonAISpacing.x2,
            children: [
              Row(
                spacing: MonAISpacing.x1,
                children: [
                  Expanded(
                    child: _SelectBox(
                      label: l10n.transactionFormFrom,
                      value: wallet,
                      check: walletUnsure,
                      onTap: () => _openWalletPicker(context, .source),
                    ),
                  ),
                  MonAIIcon(
                    MonAIIcons.arrowForward,
                    color: context.colors.accent,
                  ),
                  Expanded(
                    child: _SelectBox(
                      label: l10n.transactionFormTo,
                      value:
                          state.lookups.wallet(draft.toWalletId)?.name ?? '–',
                      onTap: () => _openWalletPicker(context, .destination),
                    ),
                  ),
                ],
              ),
              walletErrors,
              date,
              const TransactionFormFieldError(
                fields: [TransactionInputValidator.dateField],
              ),
            ],
          );
        }
        return Column(
          crossAxisAlignment: .stretch,
          children: [
            Row(
              spacing: MonAISpacing.x2,
              children: [
                Expanded(
                  child: _SelectBox(
                    icon: MonAIIcons.accountBalanceWallet,
                    label: l10n.transactionFormWallet,
                    value: wallet,
                    check: walletUnsure,
                    onTap: () => _openWalletPicker(context, .source),
                  ),
                ),
                Expanded(child: date),
              ],
            ),
            walletErrors,
            const TransactionFormFieldError(
              fields: [TransactionInputValidator.dateField],
            ),
          ],
        );
      },
    );
  }
}

class _SelectBox extends StatelessWidget {
  const _SelectBox({
    required this.label,
    required this.value,
    required this.onTap,
    this.icon,
    this.check = false,
  });

  final String label;
  final String value;
  final VoidCallback onTap;
  final MonAIIconData? icon;
  final bool check;

  @override
  Widget build(BuildContext context) {
    final c = context.colors;
    final t = context.textTheme;
    return Semantics(
      button: true,
      label: label,
      value: value,
      excludeSemantics: true,
      hint: check ? context.l10n.transactionFormCheckField : null,
      child: Material(
        color: check ? c.warningContainer : c.surfaceSunken,
        shape: RoundedRectangleBorder(
          borderRadius: MonAIRadius.mdAll,
          side: check
              ? BorderSide(color: c.warning, width: 2)
              : BorderSide(color: c.border),
        ),
        clipBehavior: .antiAlias,
        child: InkWell(
          onTap: onTap,
          child: SizedBox(
            height: 52,
            child: Padding(
              padding: const .symmetric(horizontal: MonAISpacing.x3),
              child: Row(
                spacing: MonAISpacing.x2,
                children: [
                  if (icon case final icon?)
                    MonAIIcon(icon, size: MonAISizes.iconMd, color: c.accent),
                  Expanded(
                    child: Column(
                      mainAxisAlignment: .center,
                      crossAxisAlignment: .start,
                      children: [
                        Text(
                          label,
                          style: t.labelSmall?.copyWith(color: c.textTertiary),
                        ),
                        Text(
                          value,
                          maxLines: 1,
                          overflow: .ellipsis,
                          style: t.titleSmall?.copyWith(color: c.textPrimary),
                        ),
                      ],
                    ),
                  ),
                  if (check)
                    MonAIIcon(
                      MonAIIcons.warning,
                      size: MonAISizes.iconMd,
                      color: c.warning,
                    ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
