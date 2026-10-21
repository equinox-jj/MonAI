import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:monai/core/ui/designsystem/designsystem.dart';
import 'package:monai/core/base/error/field_error.dart';
import 'package:monai/core/ui/l10n/l10n.dart';
import 'package:monai/core/model/wallet_type.dart';
import 'package:monai/core/utils/extension/wallet_type_extension.dart';
import 'package:monai/features/wallets/domain/validation/wallet_input_validator.dart';
import 'package:monai/features/wallets/presentation/pages/wallet_form/bloc/wallet_form_bloc.dart';
import 'package:monai/features/wallets/presentation/pages/wallet_form/model/wallet_form_state_extension.dart';
import 'package:monai/features/wallets/presentation/pages/wallet_form/model/wallet_field_error_text.dart';

class WalletFormTypePicker extends StatelessWidget {
  const WalletFormTypePicker({required this.onPicked, super.key});

  final ValueChanged<WalletType> onPicked;

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    final c = context.colors;
    return BlocSelector<
      WalletFormBloc,
      WalletFormState,
      (WalletType?, bool, FieldError?)
    >(
      selector: (state) => (
        state.type,
        state.isTypeLocked,
        state.errorOf(WalletInputValidator.typeField),
      ),
      builder: (context, selected) {
        final (type, locked, error) = selected;
        final note =
            error?.text(l10n) ??
            (locked ? l10n.walletFormTypeFromProvider : null);
        return Column(
          crossAxisAlignment: .stretch,
          spacing: MonAISpacing.fieldLabelGap,
          children: [
            Text(
              l10n.walletFormType,
              style: context.textTheme.labelMedium?.copyWith(
                color: c.textSecondary,
              ),
            ),
            IgnorePointer(
              ignoring: locked,
              child: MonAISegmentedControl<WalletType?>(
                segments: WalletType.values
                    .map(
                      (value) => MonAISegment<WalletType?>(
                        value: value,
                        label: value.label(l10n),
                      ),
                    )
                    .toList(),
                selected: type,
                onChanged: (value) {
                  if (value != null) onPicked(value);
                },
              ),
            ),
            if (note != null)
              Text(
                note,
                style: context.textTheme.bodySmall?.copyWith(
                  color: error == null ? c.textTertiary : c.errorText,
                ),
              ),
          ],
        );
      },
    );
  }
}
