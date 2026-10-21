import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:monai/core/ui/designsystem/designsystem.dart';
import 'package:monai/core/ui/l10n/l10n.dart';
import 'package:monai/core/model/wallet_type.dart';
import 'package:monai/core/utils/extension/wallet_type_extension.dart';
import 'package:monai/core/utils/money_format.dart';
import 'package:monai/features/wallets/domain/logic/wallet_totals.dart';
import 'package:monai/features/wallets/presentation/pages/wallets/bloc/wallets_bloc.dart';

class WalletsTotalCard extends StatelessWidget {
  const WalletsTotalCard({super.key});

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    final c = context.colors;
    return BlocSelector<
      WalletsBloc,
      WalletsState,
      (int, int, List<WalletTypeShare>)
    >(
      selector: (state) {
        final totals = state.totals;
        return (state.wallets.length, totals.total, totals.shares);
      },
      builder: (context, selected) {
        final (count, total, shares) = selected;
        return MonAICard(
          child: Column(
            crossAxisAlignment: .stretch,
            spacing: MonAISpacing.x1,
            children: [
              Text(
                l10n.walletsTotalAcross(count),
                style: context.textTheme.bodySmall?.copyWith(
                  color: c.textTertiary,
                ),
              ),
              Text(
                formatRupiah(total),
                style: context.textStyles.amountLarge.copyWith(
                  color: c.textPrimary,
                ),
              ),
              if (shares.isNotEmpty) ...[
                const SizedBox(height: MonAISpacing.x1),
                _ShareBar(shares: shares),
                const SizedBox(height: MonAISpacing.x0_5),
                _Legend(shares: shares),
              ],
            ],
          ),
        );
      },
    );
  }
}

Color _typeColor(BuildContext context, WalletType type) =>
    WalletGradients.forType(type, dark: context.colors.isDark).end;

class _ShareBar extends StatelessWidget {
  const _ShareBar({required this.shares});

  final List<WalletTypeShare> shares;

  @override
  Widget build(BuildContext context) {
    return ExcludeSemantics(
      child: ClipRRect(
        borderRadius: MonAIRadius.xsAll,
        child: SizedBox(
          height: MonAISizes.progressTrack,
          child: Row(
            spacing: MonAISpacing.x0_5,
            children: List.generate(
              shares.length,
              (index) => Expanded(
                // At least a sliver, so a 0% share still shows.
                flex: shares[index].percent.clamp(1, 100),
                child: ColoredBox(
                  color: _typeColor(context, shares[index].type),
                  child: const SizedBox.expand(),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class _Legend extends StatelessWidget {
  const _Legend({required this.shares});

  final List<WalletTypeShare> shares;

  @override
  Widget build(BuildContext context) {
    return Wrap(
      spacing: MonAISpacing.x3,
      runSpacing: MonAISpacing.x1,
      children: List.generate(
        shares.length,
        (index) => _LegendItem(share: shares[index]),
      ),
    );
  }
}

class _LegendItem extends StatelessWidget {
  const _LegendItem({required this.share});

  final WalletTypeShare share;

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    return Row(
      mainAxisSize: .min,
      spacing: MonAISpacing.x1,
      children: [
        Container(
          width: MonAISpacing.x2,
          height: MonAISpacing.x2,
          decoration: BoxDecoration(
            color: _typeColor(context, share.type),
            shape: .circle,
          ),
        ),
        Text(
          l10n.walletsShare(share.type.label(l10n), share.percent),
          style: context.textTheme.bodySmall?.copyWith(
            color: context.colors.textSecondary,
          ),
        ),
      ],
    );
  }
}
