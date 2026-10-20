import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:monai/core/designsystem/designsystem.dart';
import 'package:monai/core/l10n/l10n.dart';
import 'package:monai/core/utils/money_format.dart';
import 'package:monai/core/utils/month_format.dart';
import 'package:monai/features/home/domain/entity/home_dashboard.dart';
import 'package:monai/features/home/presentation/pages/home/bloc/home_bloc.dart';
import 'package:monai/features/home/presentation/pages/home/model/home_text.dart';
import 'package:monai/features/home/presentation/pages/home/widgets/home_actions.dart';

typedef _Balance = ({
  DateTime? month,
  int totalBalance,
  int walletCount,
  MonthSummary? summary,
  bool isHidden,
  bool promptAddWallets,
});

/// The total-balance hero: total, the month's income and expense, and the
/// change from last month. With at most one wallet it prompts to add more.
///
/// Phones stack everything; tablets put the totals beside the balance.
class HomeBalanceCard extends StatelessWidget {
  const HomeBalanceCard({
    required this.actions,
    required this.widthClass,
    super.key,
  });

  final HomeActions actions;
  final MonAIWidthClass widthClass;

  @override
  Widget build(BuildContext context) {
    return BlocSelector<HomeBloc, HomeState, _Balance>(
      selector: (state) => (
        month: state.dashboard?.month,
        totalBalance: state.dashboard?.totalBalance ?? 0,
        walletCount: state.dashboard?.wallets.length ?? 0,
        summary: state.dashboard?.summary,
        isHidden: state.isBalanceHidden,
        promptAddWallets: state.promptAddWallets,
      ),
      builder: (context, balance) {
        final l10n = context.l10n;
        final locale = context.localeName;
        final isPhone = widthClass == .compact;
        final summary = balance.summary;
        final change = summary?.changeText(l10n, locale);
        final header = _BalanceHeader(
          walletCount: balance.walletCount,
          isHidden: balance.isHidden,
          onToggle: actions.onToggleBalance,
        );
        final amount = Text(
          balance.isHidden
              ? l10n.homeHiddenAmount
              : formatRupiah(balance.totalBalance),
          style: _amountStyle(context)?.tabular.copyWith(color: Colors.white),
        );
        final totals = summary != null && summary.hasTotals
            ? _MonthTotals(
                summary: summary,
                month: balance.month ?? summary.previousMonth,
                isHidden: balance.isHidden,
                stacked: !isPhone,
              )
            : null;
        final pills = [
          if (change != null) MonAIPill(text: change),
          if (balance.promptAddWallets)
            Padding(
              padding: const .only(top: MonAISpacing.x1_5),
              child: _AddWalletsPill(onTap: actions.onAddWallet),
            ),
        ];

        if (isPhone) {
          return MonAIGradientCard(
            padding: const .fromLTRB(
              MonAISpacing.x5,
              MonAISpacing.x5 - _toggleInset,
              MonAISpacing.x5,
              MonAISpacing.x5,
            ),
            child: Column(
              crossAxisAlignment: .start,
              children: [
                header,
                const SizedBox(height: MonAISpacing.x4 - _toggleInset),
                Column(
                  crossAxisAlignment: .start,
                  spacing: MonAISpacing.x4,
                  children: [amount, ?totals, ...pills],
                ),
              ],
            ),
          );
        }
        return MonAIGradientCard(
          padding: const .fromLTRB(
            MonAISpacing.x6,
            MonAISpacing.x6 - _toggleInset,
            MonAISpacing.x6,
            MonAISpacing.x6,
          ),
          child: Row(
            spacing: MonAISpacing.x6,
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: .start,
                  spacing: MonAISpacing.x2,
                  children: [header, amount, ...pills],
                ),
              ),
              if (totals != null)
                SizedBox(width: _tabletTotalsWidth, child: totals),
            ],
          ),
        );
      },
    );
  }

  TextStyle? _amountStyle(BuildContext context) => switch (widthClass) {
    .compact => context.textTheme.displayMedium,
    .medium => context.textTheme.displayLarge,
    .expanded => context.textTheme.displayLarge?.copyWith(
      fontSize: 44,
      height: 52 / 44,
    ),
  };
}

/// The income and expense tiles' column on tablets.
const _tabletTotalsWidth = 240.0;

/// How far the eye button reaches past the label row's line height on each
/// side: (44 − 20) / 2.
const _toggleInset = (MonAISizes.touchTarget - 20) / 2;

/// How far the eye button reaches into the card's right padding.
const _toggleOverhang = MonAISpacing.x2_5;

class _BalanceHeader extends StatelessWidget {
  const _BalanceHeader({
    required this.walletCount,
    required this.isHidden,
    required this.onToggle,
  });

  final int walletCount;
  final bool isHidden;
  final VoidCallback onToggle;

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    return Row(
      children: [
        Expanded(
          child: Text(
            l10n.homeTotalBalance(walletCount),
            style: context.textTheme.bodyMedium
                ?.withWeight(.w500)
                .copyWith(color: context.colors.onGradientMuted),
          ),
        ),
        // A full 44 target. The row is 44 tall, so the card trims its top
        // padding and the gap below by half the difference to keep the
        // label where the design puts it; the button reaches into the right
        // padding.
        Transform.translate(
          offset: const Offset(_toggleOverhang, 0),
          child: MonAIIconButton(
            icon: isHidden ? MonAIIcons.visibilityOff : MonAIIcons.visibility,
            tooltip: isHidden ? l10n.homeShowBalance : l10n.homeHideBalance,
            onPressed: onToggle,
            color: Colors.white,
            iconSize: 22,
          ),
        ),
      ],
    );
  }
}

class _MonthTotals extends StatelessWidget {
  const _MonthTotals({
    required this.summary,
    required this.month,
    required this.isHidden,
    required this.stacked,
  });

  final MonthSummary summary;
  final DateTime month;
  final bool isHidden;

  /// Tablets stack the tiles and show full amounts.
  final bool stacked;

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    final c = context.colors;
    final shortMonth = MonthFormat.shortMonthName(month, context.localeName);
    final income = _MonthTotalTile(
      label: l10n.homeIncomeMonth(shortMonth),
      amount: _amount(l10n, '+', summary.incomeTotal),
      icon: MonAIIcons.southWest,
      iconContainer: c.highlight,
      iconColor: c.onHighlight,
    );
    final expense = _MonthTotalTile(
      label: l10n.homeExpenseMonth(shortMonth),
      amount: _amount(l10n, '−', summary.expenseTotal),
      icon: MonAIIcons.northEast,
      iconContainer: Colors.white,
      iconColor: c.expense,
    );
    if (stacked) {
      return Column(
        crossAxisAlignment: .stretch,
        spacing: MonAISpacing.x2,
        children: [income, expense],
      );
    }
    return Row(
      spacing: MonAISpacing.x2,
      children: [
        Expanded(child: income),
        Expanded(child: expense),
      ],
    );
  }

  String _amount(AppLocalizations l10n, String sign, int amount) {
    if (isHidden) return l10n.homeHiddenAmountShort;
    return sign +
        (stacked ? formatRupiah(amount) : formatRupiahCompact(amount));
  }
}

class _MonthTotalTile extends StatelessWidget {
  const _MonthTotalTile({
    required this.label,
    required this.amount,
    required this.icon,
    required this.iconContainer,
    required this.iconColor,
  });

  final String label;
  final String amount;
  final MonAIIconData icon;
  final Color iconContainer;
  final Color iconColor;

  @override
  Widget build(BuildContext context) {
    final t = context.textTheme;
    return DecoratedBox(
      decoration: BoxDecoration(
        color: Colors.white.withValues(alpha: 0.12),
        borderRadius: MonAIRadius.lgAll,
      ),
      child: Padding(
        padding: const .symmetric(
          horizontal: MonAISpacing.x3,
          vertical: MonAISpacing.x2_5,
        ),
        child: Row(
          spacing: MonAISpacing.x2_5,
          children: [
            Container(
              width: MonAISizes.avatarSmall,
              height: MonAISizes.avatarSmall,
              alignment: .center,
              decoration: BoxDecoration(color: iconContainer, shape: .circle),
              child: MonAIIcon(icon, size: MonAISizes.iconMd, color: iconColor),
            ),
            Expanded(
              child: Column(
                crossAxisAlignment: .start,
                children: [
                  Text(
                    label,
                    maxLines: 1,
                    overflow: .ellipsis,
                    style: t.bodySmall?.copyWith(
                      color: context.colors.onGradientMuted,
                    ),
                  ),
                  Text(
                    amount,
                    maxLines: 1,
                    style: t.titleSmall
                        ?.withWeight(.w600)
                        .tabular
                        .copyWith(color: Colors.white),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _AddWalletsPill extends StatelessWidget {
  const _AddWalletsPill({required this.onTap});

  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return Semantics(
      button: true,
      child: InkWell(
        onTap: onTap,
        borderRadius: MonAIRadius.fullAll,
        child: ConstrainedBox(
          constraints: const BoxConstraints(minHeight: MonAISizes.buttonSmall),
          child: Align(
            widthFactor: 1,
            child: MonAIPill(
              text: context.l10n.homeAddWallets,
              icon: MonAIIcons.add,
            ),
          ),
        ),
      ),
    );
  }
}
