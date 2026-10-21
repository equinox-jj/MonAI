import 'package:flutter/material.dart';
import 'package:monai/core/ui/designsystem/designsystem.dart';
import 'package:monai/core/ui/l10n/l10n.dart';
import 'package:monai/core/utils/month_format.dart';
import 'package:monai/features/shared/domain/entity/transaction.dart';
import 'package:monai/features/transactions/domain/entity/transaction_lookups.dart';
import 'package:monai/features/transactions/presentation/model/transaction_text.dart';

class TransactionListRow extends StatelessWidget {
  const TransactionListRow({
    required this.transaction,
    required this.lookups,
    required this.onTap,
    super.key,
    this.showDivider = true,
    this.selected = false,
    this.showDate = false,
  });

  final Transaction transaction;
  final TransactionLookups lookups;
  final ValueChanged<String> onTap;
  final bool showDivider;
  final bool selected;
  final bool showDate;

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    final c = context.colors;
    return ColoredBox(
      color: selected ? c.primaryContainer : c.surface,
      child: MonAITransactionRow(
        title: transaction.titleText(l10n, lookups),
        meta: showDate
            ? transaction.datedMetaText(l10n, lookups, context.localeName)
            : transaction.metaText(l10n, lookups),
        amount: transaction.amountText,
        direction: transaction.direction,
        categoryIcon: transaction.iconOf(lookups),
        categoryColor: transaction.colorOf(lookups, transferColor: c.accent),
        showDivider: showDivider,
        onTap: () => onTap(transaction.id),
      ),
    );
  }
}
