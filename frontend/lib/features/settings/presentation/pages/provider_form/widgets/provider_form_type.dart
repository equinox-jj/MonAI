import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:monai/core/designsystem/designsystem.dart';
import 'package:monai/core/l10n/l10n.dart';
import 'package:monai/core/model/wallet_type.dart';
import 'package:monai/core/utils/extension/wallet_type_extension.dart';
import 'package:monai/features/settings/presentation/pages/provider_form/bloc/provider_form_bloc.dart';

/// Cash, Bank, E-wallet or Other; none is picked on a new provider.
class ProviderFormType extends StatelessWidget {
  const ProviderFormType({required this.onPick, super.key});

  final ValueChanged<WalletType> onPick;

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    return Column(
      crossAxisAlignment: .stretch,
      spacing: MonAISpacing.fieldLabelGap,
      children: [
        Text(l10n.providerFormType, style: context.textTheme.labelMedium),
        BlocSelector<ProviderFormBloc, ProviderFormState, WalletType?>(
          selector: (state) => state.type,
          builder: (context, type) => MonAISegmentedControl<WalletType?>(
            segments: WalletType.values
                .map(
                  (t) =>
                      MonAISegment<WalletType?>(value: t, label: t.label(l10n)),
                )
                .toList(),
            selected: type,
            onChanged: (type) {
              if (type != null) onPick(type);
            },
          ),
        ),
      ],
    );
  }
}
