import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:monai/core/ui/designsystem/designsystem.dart';
import 'package:monai/core/ui/l10n/l10n.dart';
import 'package:monai/features/wallets/presentation/pages/wallet_form/bloc/wallet_form_bloc.dart';

/// "Card color": a swatch per [WalletColor]; none is picked while the card
/// uses its type's color.
class WalletFormColorPicker extends StatelessWidget {
  const WalletFormColorPicker({required this.onPicked, super.key});

  /// The color as `#RRGGBB`.
  final ValueChanged<String> onPicked;

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    return Column(
      crossAxisAlignment: .stretch,
      spacing: MonAISpacing.x2,
      children: [
        Text(
          l10n.walletFormCardColor,
          style: context.textTheme.labelMedium?.copyWith(
            color: context.colors.textSecondary,
          ),
        ),
        BlocSelector<WalletFormBloc, WalletFormState, WalletColor?>(
          selector: (state) => WalletColor.fromHex(state.color),
          builder: (context, picked) => Semantics(
            label: l10n.walletFormCardColor,
            child: Wrap(
              spacing: MonAISpacing.x2_5,
              runSpacing: MonAISpacing.x2_5,
              children: List.generate(WalletColor.values.length, (index) {
                final color = WalletColor.values[index];
                return _Swatch(
                  color: color,
                  selected: color == picked,
                  onTap: () => onPicked(color.hex),
                );
              }),
            ),
          ),
        ),
      ],
    );
  }
}

class _Swatch extends StatelessWidget {
  const _Swatch({
    required this.color,
    required this.selected,
    required this.onTap,
  });

  final WalletColor color;
  final bool selected;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final c = context.colors;
    final gradient = color.gradient(dark: c.isDark);
    return Semantics(
      inMutuallyExclusiveGroup: true,
      checked: selected,
      button: true,
      label: color.label(context.l10n),
      child: GestureDetector(
        onTap: onTap,
        child: Container(
          width: MonAISizes.touchTarget,
          height: MonAISizes.touchTarget,
          alignment: .center,
          decoration: BoxDecoration(
            gradient: gradient.gradient,
            shape: .circle,
            boxShadow: selected
                ? [
                    BoxShadow(color: c.surface, spreadRadius: 2),
                    BoxShadow(color: c.focus, spreadRadius: 4),
                  ]
                : null,
          ),
          child: selected
              ? const MonAIIcon(
                  MonAIIcons.check,
                  size: MonAISizes.iconLg,
                  color: Colors.white,
                )
              : null,
        ),
      ),
    );
  }
}

extension on WalletColor {
  /// "Indigo", "Teal"…, for screen readers.
  String label(AppLocalizations l10n) => switch (this) {
    .indigo => l10n.walletColorIndigo,
    .teal => l10n.walletColorTeal,
    .green => l10n.walletColorGreen,
    .violet => l10n.walletColorViolet,
    .rose => l10n.walletColorRose,
    .slate => l10n.walletColorSlate,
  };
}
