import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:monai/core/ui/designsystem/designsystem.dart';
import 'package:monai/core/ui/l10n/l10n.dart';
import 'package:monai/features/wallets/presentation/pages/wallet_form/bloc/wallet_form_bloc.dart';
import 'package:monai/features/wallets/presentation/pages/wallet_form/model/wallet_form_state_extension.dart';

class WalletFormDefaultRow extends StatelessWidget {
  const WalletFormDefaultRow({required this.onToggled, super.key});

  final ValueChanged<bool> onToggled;

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    final c = context.colors;
    return BlocSelector<
      WalletFormBloc,
      WalletFormState,
      (bool, bool, bool, String?)
    >(
      selector: (state) => (
        state.isEdit,
        state.isDefault,
        state.original?.isDefault ?? false,
        state.defaultWalletName,
      ),
      builder: (context, selected) {
        final (isEdit, isDefault, isAlreadyDefault, defaultName) = selected;
        final title = isEdit
            ? l10n.walletFormDefault
            : l10n.walletFormMakeDefault;
        final subtitle = switch ((isEdit, isAlreadyDefault, defaultName)) {
          (false, _, _) => l10n.walletFormMakeDefaultHint,
          (true, true, _) => l10n.walletFormDefaultIsThis,
          (true, false, final name?) => l10n.walletFormDefaultIsOther(name),
          (true, false, null) => l10n.walletFormMakeDefaultHint,
        };
        final enabled = !isAlreadyDefault;
        return MergeSemantics(
          child: InkWell(
            onTap: enabled ? () => onToggled(!isDefault) : null,
            borderRadius: MonAIRadius.mdAll,
            child: ConstrainedBox(
              constraints: const BoxConstraints(
                minHeight: MonAISizes.buttonMedium,
              ),
              child: Row(
                spacing: MonAISpacing.x3,
                children: [
                  Expanded(
                    child: Column(
                      crossAxisAlignment: .start,
                      children: [
                        Text(title, style: context.textTheme.titleSmall),
                        Text(
                          subtitle,
                          style: context.textTheme.bodySmall?.copyWith(
                            color: c.textTertiary,
                          ),
                        ),
                      ],
                    ),
                  ),
                  Checkbox(
                    value: isDefault,
                    activeColor: c.primary,
                    onChanged: enabled
                        ? (value) => onToggled(value ?? false)
                        : null,
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }
}
