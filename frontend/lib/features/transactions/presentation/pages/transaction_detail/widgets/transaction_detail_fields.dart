import 'package:flutter/material.dart';
import 'package:monai/core/ui/designsystem/designsystem.dart';
import 'package:monai/core/ui/l10n/l10n.dart';
import 'package:monai/core/utils/month_format.dart';
import 'package:monai/features/shared/domain/entity/transaction.dart';
import 'package:monai/features/transactions/domain/entity/transaction_lookups.dart';
import 'package:monai/features/transactions/presentation/model/transaction_text.dart';

class TransactionDetailFields extends StatelessWidget {
  const TransactionDetailFields({
    required this.transaction,
    required this.lookups,
    super.key,
  });

  final Transaction transaction;
  final TransactionLookups lookups;

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    final isTransfer = transaction.type == .transfer;
    final fields = <_Field>[
      if (!isTransfer)
        _Field(
          l10n.transactionDetailCategory,
          lookups.category(transaction.categoryId)?.name,
        ),
      if (isTransfer) ...[
        _Field(
          l10n.transactionDetailFrom,
          lookups.wallet(transaction.walletId)?.name,
        ),
        _Field(
          l10n.transactionDetailTo,
          lookups.wallet(transaction.toWalletId)?.name,
        ),
      ] else
        _Field(
          l10n.transactionDetailWallet,
          lookups.wallet(transaction.walletId)?.name,
        ),
      _Field(
        l10n.transactionDetailDate,
        TransactionDates.long(transaction.date, context.localeName),
      ),
      if (transaction.merchant case final merchant?)
        _Field(l10n.transactionDetailMerchant, merchant),
      if (transaction.note case final note?)
        _Field(l10n.transactionDetailNote, note),
      _Field(
        l10n.transactionDetailAddedBy,
        transaction.source.label(l10n),
        icon: transaction.source.icon,
      ),
    ];
    return MonAICard(
      padding: const .symmetric(horizontal: MonAISpacing.x4),
      child: ListView.separated(
        shrinkWrap: true,
        physics: const NeverScrollableScrollPhysics(),
        padding: .zero,
        itemCount: fields.length,
        separatorBuilder: (_, _) => const MonAIDivider(),
        itemBuilder: (context, index) => _FieldRow(field: fields[index]),
      ),
    );
  }
}

class _Field {
  const _Field(this.label, this.value, {this.icon});

  final String label;
  final String? value;
  final MonAIIconData? icon;
}

class _FieldRow extends StatelessWidget {
  const _FieldRow({required this.field});

  final _Field field;

  @override
  Widget build(BuildContext context) {
    final c = context.colors;
    final t = context.textTheme;
    final valueColor = field.icon == null ? c.textPrimary : c.accent;
    return Padding(
      padding: const .symmetric(vertical: MonAISpacing.x3),
      child: Row(
        spacing: MonAISpacing.x4,
        children: [
          Text(
            field.label,
            style: t.bodyMedium?.copyWith(color: c.textTertiary),
          ),
          Expanded(
            child: Row(
              mainAxisAlignment: .end,
              spacing: MonAISpacing.x1_5,
              children: [
                if (field.icon case final icon?)
                  MonAIIcon(icon, size: MonAISizes.iconSm, color: valueColor),
                Flexible(
                  child: Text(
                    field.value ?? '–',
                    textAlign: .end,
                    style: t.titleSmall?.copyWith(color: valueColor),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
