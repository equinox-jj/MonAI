import 'package:flutter/material.dart';
import 'package:monai/core/ui/designsystem/designsystem.dart';
import 'package:monai/core/ui/l10n/l10n.dart';
import 'package:monai/core/utils/month_format.dart';
import 'package:monai/features/shared/domain/entity/transaction.dart';
import 'package:monai/features/transactions/domain/entity/transaction_lookups.dart';
import 'package:monai/features/transactions/presentation/model/search_highlight.dart';
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
    this.highlight,
  });

  final Transaction transaction;
  final TransactionLookups lookups;
  final ValueChanged<String> onTap;
  final bool showDivider;
  final bool selected;
  final bool showDate;

  /// A search query whose words are marked in the title and meta.
  final String? highlight;

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    final c = context.colors;
    final title = transaction.titleText(l10n, lookups);
    final meta = showDate
        ? transaction.datedMetaText(l10n, lookups, context.localeName)
        : transaction.metaText(l10n, lookups);
    final query = highlight;
    final merchant = transaction.merchant;
    // A match only in the merchant would be invisible under a note title, so
    // the merchant leads the meta.
    final searchMeta =
        query != null &&
            merchant != null &&
            merchant != title &&
            merchant.matchesSearch(query)
        ? '${l10n.searchMerchant(merchant)} · $meta'
        : meta;
    final mark = TextStyle(
      backgroundColor: c.primaryContainer,
      fontWeight: .w600,
    );
    return ColoredBox(
      color: selected ? c.primaryContainer : c.surface,
      child: MonAITransactionRow(
        title: title,
        meta: searchMeta,
        titleSpan: query == null ? null : title.highlighted(query, mark),
        metaSpan: query == null ? null : searchMeta.highlighted(query, mark),
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
