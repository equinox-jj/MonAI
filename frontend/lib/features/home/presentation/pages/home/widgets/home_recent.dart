import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:monai/core/ui/designsystem/designsystem.dart';
import 'package:monai/core/ui/l10n/l10n.dart';
import 'package:monai/core/utils/month_format.dart';
import 'package:monai/features/home/domain/entity/home_dashboard.dart';
import 'package:monai/features/home/presentation/pages/home/bloc/home_bloc.dart';
import 'package:monai/features/home/presentation/pages/home/model/home_text.dart';
import 'package:monai/features/home/presentation/pages/home/widgets/home_actions.dart';

/// "Recent" with the month's newest transactions, or the first-run prompt
/// when there are none.
///
/// Tablet landscape puts the header inside the card, beside the spending
/// card.
class HomeRecent extends StatelessWidget {
  const HomeRecent({
    required this.actions,
    required this.widthClass,
    super.key,
  });

  final HomeActions actions;
  final MonAIWidthClass widthClass;

  @override
  Widget build(BuildContext context) {
    return BlocSelector<HomeBloc, HomeState, List<RecentTransaction>>(
      selector: (state) => state.dashboard?.recent ?? const [],
      builder: (context, recent) {
        if (recent.isEmpty) return _EmptyRecent(actions: actions);
        final l10n = context.l10n;
        final header = MonAISectionHeader(
          title: l10n.homeRecent,
          actionLabel: l10n.homeSeeAll,
          onActionPressed: actions.onSeeAllTransactions,
          style: widthClass == .expanded ? context.textTheme.titleMedium : null,
        );
        final rows = _RecentRows(
          recent: recent,
          onOpen: actions.onOpenTransaction,
        );
        if (widthClass == .expanded) {
          return MonAICard(
            padding: .zero,
            child: Column(
              crossAxisAlignment: .stretch,
              children: [
                Padding(
                  padding: const .fromLTRB(
                    MonAISpacing.x5,
                    MonAISpacing.x1,
                    MonAISpacing.x4,
                    0,
                  ),
                  child: header,
                ),
                const MonAIDivider(),
                rows,
              ],
            ),
          );
        }
        return Column(
          crossAxisAlignment: .stretch,
          spacing: MonAISpacing.x2,
          children: [
            header,
            MonAICard(padding: .zero, child: rows),
          ],
        );
      },
    );
  }
}

class _RecentRows extends StatelessWidget {
  const _RecentRows({required this.recent, required this.onOpen});

  final List<RecentTransaction> recent;
  final ValueChanged<String> onOpen;

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    final locale = context.localeName;
    final transferColor = context.colors.accent;
    return ListView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      padding: .zero,
      itemCount: recent.length,
      itemBuilder: (context, index) {
        final transaction = recent[index];
        final isTransfer = transaction.type == .transfer;
        return MonAITransactionRow(
          title: transaction.titleText(l10n),
          meta: transaction.metaText(l10n, locale),
          amount: transaction.amountText,
          direction: transaction.direction,
          categoryIcon: isTransfer
              ? MonAIIcons.swapHoriz
              : categoryIcon(transaction.icon),
          categoryColor: isTransfer
              ? transferColor
              : CategoryColors.parse(transaction.color),
          showDivider: index < recent.length - 1,
          onTap: () => onOpen(transaction.id),
        );
      },
    );
  }
}

class _EmptyRecent extends StatelessWidget {
  const _EmptyRecent({required this.actions});

  final HomeActions actions;

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    return MonAICard(
      padding: const .symmetric(
        horizontal: MonAISpacing.x6,
        vertical: MonAISpacing.x8,
      ),
      child: Center(
        child: MonAIStateMessage(
          icon: MonAIIcons.receiptLong,
          title: l10n.homeEmptyTitle,
          message: l10n.homeEmptyBody,
          actionLabel: l10n.homeEmptyAdd,
          actionIcon: MonAIIcons.add,
          onAction: actions.onAddTransaction,
          secondaryActionLabel: l10n.homeEmptyQuickAdd,
          onSecondaryAction: actions.onQuickAdd,
        ),
      ),
    );
  }
}
