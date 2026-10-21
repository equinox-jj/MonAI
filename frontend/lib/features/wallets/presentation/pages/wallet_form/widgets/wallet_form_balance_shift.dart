import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:monai/core/ui/designsystem/designsystem.dart';
import 'package:monai/core/ui/l10n/l10n.dart';
import 'package:monai/core/utils/money_format.dart';
import 'package:monai/features/wallets/presentation/pages/wallet_form/bloc/wallet_form_bloc.dart';

class WalletFormBalanceShift extends StatelessWidget {
  const WalletFormBalanceShift({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocSelector<WalletFormBloc, WalletFormState, ({int from, int to})?>(
      selector: (state) => state.balanceShift,
      builder: (context, shift) => switch (shift) {
        (:final from, :final to) => Semantics(
          liveRegion: true,
          child: MonAIInlineAlert(
            tone: .warning,
            icon: MonAIIcons.info,
            message: context.l10n.walletFormBalanceShift(
              formatRupiah(from),
              formatRupiah(to),
              formatRupiahSigned(to - from, negative: to < from),
            ),
          ),
        ),
        null => const SizedBox.shrink(),
      },
    );
  }
}
