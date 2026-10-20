import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:monai/features/shared/domain/entity/wallet.dart';
import 'package:monai/features/wallets/presentation/pages/wallet_form/bloc/wallet_form_bloc.dart';
import 'package:monai/features/wallets/presentation/widgets/wallet_card.dart';

/// The edited wallet's card in the picked color, with the balance it will
/// have.
class WalletFormPreviewCard extends StatelessWidget {
  const WalletFormPreviewCard({super.key});

  static const _height = 112.0;

  @override
  Widget build(BuildContext context) {
    return BlocSelector<
      WalletFormBloc,
      WalletFormState,
      (Wallet?, String?, int?)
    >(
      selector: (state) =>
          (state.original, state.color, state.balanceShift?.to),
      builder: (context, selected) => switch (selected) {
        (final wallet?, final color, final balance) => SizedBox(
          height: _height,
          child: WalletCard(
            wallet: wallet,
            colorHex: color,
            balance: balance,
            showType: false,
          ),
        ),
        (null, _, _) => const SizedBox.shrink(),
      },
    );
  }
}
