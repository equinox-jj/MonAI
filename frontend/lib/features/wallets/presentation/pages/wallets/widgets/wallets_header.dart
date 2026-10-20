import 'package:flutter/material.dart';
import 'package:monai/core/designsystem/designsystem.dart';
import 'package:monai/core/l10n/l10n.dart';
import 'package:monai/features/wallets/presentation/pages/wallets/widgets/wallets_actions.dart';

/// "Wallets" with the "Add wallet" button.
class WalletsHeader extends StatelessWidget {
  const WalletsHeader({required this.actions, super.key});

  final WalletsActions actions;

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    return MonAIScreenTitle(
      title: l10n.walletsTitle,
      action: MonAIButton(
        label: l10n.walletsAdd,
        leadingIcon: MonAIIcons.add,
        variant: .tonal,
        size: .compact,
        onPressed: actions.onAddWallet,
      ),
    );
  }
}
