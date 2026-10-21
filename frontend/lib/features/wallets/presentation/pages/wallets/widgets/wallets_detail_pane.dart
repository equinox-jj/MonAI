import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:monai/core/ui/designsystem/designsystem.dart';
import 'package:monai/core/ui/l10n/l10n.dart';
import 'package:monai/features/wallets/presentation/pages/wallet_detail/wallet_detail_page.dart';
import 'package:monai/features/wallets/presentation/pages/wallets/bloc/wallets_bloc.dart';

/// Tablet landscape: the picked wallet beside the list, else the first.
class WalletsDetailPane extends StatelessWidget {
  const WalletsDetailPane({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocSelector<WalletsBloc, WalletsState, String?>(
      selector: (state) => state.shownId,
      builder: (context, id) => switch (id) {
        final id? => WalletDetailPage(
          key: ValueKey(id),
          id: id,
          placement: .pane,
        ),
        null => Center(
          child: Padding(
            padding: const .all(MonAISpacing.x8),
            child: MonAIStateMessage(
              icon: MonAIIcons.accountBalanceWallet,
              title: context.l10n.walletsSelectPrompt,
              message: '',
            ),
          ),
        ),
      },
    );
  }
}
