import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:monai/core/ui/designsystem/designsystem.dart';
import 'package:monai/core/ui/l10n/l10n.dart';
import 'package:monai/features/wallets/presentation/pages/wallet_detail/bloc/wallet_detail_bloc.dart';
import 'package:monai/features/wallets/presentation/pages/wallet_detail/model/wallet_detail_state_extension.dart';
import 'package:monai/features/wallets/presentation/pages/wallet_detail/widgets/wallet_detail_actions.dart';

class WalletDetailButtons extends StatelessWidget {
  const WalletDetailButtons({required this.actions, super.key});

  final WalletDetailActions actions;

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    return BlocSelector<
      WalletDetailBloc,
      WalletDetailState,
      (bool, bool, bool)
    >(
      selector: (state) =>
          (state.wallet != null, state.canArchive, state.isArchiving),
      builder: (context, selected) {
        final (loaded, canArchive, isArchiving) = selected;
        return Column(
          crossAxisAlignment: .stretch,
          spacing: MonAISpacing.x2,
          children: [
            Row(
              spacing: MonAISpacing.x2,
              children: [
                _Tile(
                  icon: MonAIIcons.edit,
                  label: l10n.walletDetailEdit,
                  onTap: loaded ? actions.onEdit : null,
                ),
                _Tile(
                  icon: MonAIIcons.swapHoriz,
                  label: l10n.walletDetailTransferAction,
                  onTap: loaded ? actions.onTransfer : null,
                ),
                _Tile(
                  icon: MonAIIcons.inventory2,
                  label: l10n.walletDetailArchive,
                  onTap: canArchive && !isArchiving ? actions.onArchive : null,
                  tooltip: loaded && !canArchive
                      ? l10n.walletDetailDefaultNote
                      : null,
                ),
              ],
            ),
            if (loaded && !canArchive)
              Text(
                l10n.walletDetailDefaultNote,
                style: context.textTheme.bodySmall?.copyWith(
                  color: context.colors.textTertiary,
                ),
              ),
          ],
        );
      },
    );
  }
}

class _Tile extends StatelessWidget {
  const _Tile({
    required this.icon,
    required this.label,
    required this.onTap,
    this.tooltip,
  });

  static const _height = 64.0;

  final MonAIIconData icon;
  final String label;
  final VoidCallback? onTap;
  final String? tooltip;

  @override
  Widget build(BuildContext context) {
    final c = context.colors;
    final enabled = onTap != null;
    final tile = SizedBox(
      height: _height,
      child: Material(
        color: enabled ? c.surface : c.background,
        shape: RoundedRectangleBorder(
          borderRadius: MonAIRadius.mdAll,
          side: BorderSide(color: c.border),
        ),
        clipBehavior: .antiAlias,
        child: InkWell(
          onTap: onTap,
          child: Column(
            mainAxisAlignment: .center,
            spacing: MonAISpacing.x1,
            children: [
              MonAIIcon(
                icon,
                size: MonAISizes.iconLg,
                color: enabled ? c.accent : c.textDisabled,
              ),
              Text(
                label,
                style: context.textTheme.labelMedium?.copyWith(
                  color: enabled ? c.iconStrong : c.textDisabled,
                ),
              ),
            ],
          ),
        ),
      ),
    );
    return Expanded(
      child: Semantics(
        button: true,
        enabled: enabled,
        child: switch (tooltip) {
          final message? => Tooltip(message: message, child: tile),
          null => tile,
        },
      ),
    );
  }
}
