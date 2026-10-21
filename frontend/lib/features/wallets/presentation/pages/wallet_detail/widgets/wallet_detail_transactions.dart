import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:monai/core/ui/designsystem/designsystem.dart';
import 'package:monai/core/ui/l10n/l10n.dart';
import 'package:monai/core/utils/month_format.dart';
import 'package:monai/features/shared/domain/entity/category.dart';
import 'package:monai/features/shared/domain/entity/transaction.dart';
import 'package:monai/features/shared/domain/entity/wallet.dart';
import 'package:monai/features/wallets/presentation/model/wallet_text.dart';
import 'package:monai/features/wallets/presentation/pages/wallet_detail/bloc/wallet_detail_bloc.dart';
import 'package:monai/features/wallets/presentation/pages/wallet_detail/widgets/wallet_detail_actions.dart';

class WalletDetailTransactions extends StatelessWidget {
  const WalletDetailTransactions({required this.actions, super.key});

  final WalletDetailActions actions;

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    final c = context.colors;
    return Column(
      crossAxisAlignment: .stretch,
      spacing: MonAISpacing.x2,
      children: [
        Text(l10n.walletDetailThisMonth, style: context.textTheme.titleMedium),
        BlocSelector<
          WalletDetailBloc,
          WalletDetailState,
          (
            String,
            List<Transaction>,
            Map<String, Category>,
            Map<String, Wallet>,
          )
        >(
          selector: (state) =>
              (state.id, state.transactions, state.categories, state.wallets),
          builder: (context, selected) {
            final (walletId, transactions, categories, wallets) = selected;
            if (transactions.isEmpty) {
              return MonAICard(
                child: Text(
                  l10n.walletDetailNoTransactions,
                  textAlign: .center,
                  style: context.textTheme.bodyMedium?.copyWith(
                    color: c.textTertiary,
                  ),
                ),
              );
            }
            return MonAICard(
              padding: .zero,
              child: ListView.builder(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                padding: .zero,
                itemCount: transactions.length,
                itemBuilder: (context, index) => _Row(
                  transaction: transactions[index],
                  walletId: walletId,
                  categories: categories,
                  wallets: wallets,
                  showDivider: index < transactions.length - 1,
                  onTap: actions.onOpenTransaction,
                ),
              ),
            );
          },
        ),
      ],
    );
  }
}

class _Row extends StatelessWidget {
  const _Row({
    required this.transaction,
    required this.walletId,
    required this.categories,
    required this.wallets,
    required this.showDivider,
    required this.onTap,
  });

  final Transaction transaction;
  final String walletId;
  final Map<String, Category> categories;
  final Map<String, Wallet> wallets;
  final bool showDivider;
  final ValueChanged<String> onTap;

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    return MonAITransactionRow(
      title: transaction.titleIn(l10n, categories),
      meta: transaction.metaIn(
        l10n,
        walletId: walletId,
        categories: categories,
        wallets: wallets,
        locale: context.localeName,
      ),
      amount: transaction.amountIn(walletId),
      direction: transaction.direction,
      categoryIcon: transaction.iconIn(categories),
      categoryColor: transaction.colorIn(
        categories,
        transferColor: context.colors.accent,
      ),
      showDivider: showDivider,
      onTap: () => onTap(transaction.id),
    );
  }
}
