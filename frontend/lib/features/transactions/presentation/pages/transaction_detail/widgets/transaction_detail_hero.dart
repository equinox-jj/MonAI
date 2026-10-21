import 'package:flutter/material.dart';
import 'package:monai/core/ui/designsystem/designsystem.dart';
import 'package:monai/core/ui/l10n/l10n.dart';
import 'package:monai/features/shared/domain/entity/transaction.dart';
import 'package:monai/features/transactions/domain/entity/transaction_lookups.dart';
import 'package:monai/features/transactions/presentation/model/transaction_text.dart';

/// The category icon, the title, the signed amount and the type.
class TransactionDetailHero extends StatelessWidget {
  const TransactionDetailHero({
    required this.transaction,
    required this.lookups,
    super.key,
  });

  final Transaction transaction;
  final TransactionLookups lookups;

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    final c = context.colors;
    final t = context.textTheme;
    final (
      amountColor,
      pillColor,
      pillContent,
      arrow,
    ) = switch (transaction.type) {
      .expense => (
        c.expense,
        c.expenseContainer,
        c.expense,
        MonAIIcons.northEast,
      ),
      .income => (c.income, c.incomeContainer, c.income, MonAIIcons.southWest),
      .transfer => (
        c.textPrimary,
        c.primaryContainer,
        c.onPrimaryContainer,
        MonAIIcons.syncAlt,
      ),
    };
    return Padding(
      padding: const .symmetric(vertical: MonAISpacing.x2),
      child: Column(
        spacing: MonAISpacing.x2,
        children: [
          MonAICategoryIcon(
            icon: transaction.iconOf(lookups),
            color: transaction.colorOf(lookups, transferColor: c.accent),
            size: MonAISizes.avatarLarge,
          ),
          Text(
            transaction.titleText(l10n, lookups),
            textAlign: .center,
            style: t.titleMedium,
          ),
          Text(
            transaction.amountText,
            style: t.displaySmall?.copyWith(color: amountColor),
          ),
          MonAIPill(
            text: transaction.type.label(l10n),
            icon: arrow,
            containerColor: pillColor,
            contentColor: pillContent,
          ),
        ],
      ),
    );
  }
}
