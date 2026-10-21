import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:monai/core/ui/designsystem/designsystem.dart';
import 'package:monai/core/ui/l10n/l10n.dart';
import 'package:monai/features/settings/presentation/pages/provider_form/bloc/provider_form_bloc.dart';
import 'package:monai/features/settings/presentation/widgets/provider_logo.dart';

/// The logo card: Upload while there is none, Replace once there is. A
/// picked image shows at once and uploads on Save.
class ProviderFormLogo extends StatelessWidget {
  const ProviderFormLogo({required this.name, required this.onPick, super.key});

  static const _logoSize = 56.0;

  /// The name field, for the monogram.
  final TextEditingController name;
  final VoidCallback onPick;

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    final c = context.colors;
    return BlocSelector<
      ProviderFormBloc,
      ProviderFormState,
      (String?, String?, bool)
    >(
      selector: (state) =>
          (state.original?.logoUrl, state.newLogoPath, state.isWorking),
      builder: (context, logo) {
        final (logoUrl, newLogoPath, working) = logo;
        final hasLogo = logoUrl != null || newLogoPath != null;
        return InkWell(
          onTap: working || hasLogo ? null : onPick,
          borderRadius: MonAIRadius.lgAll,
          child: DecoratedBox(
            decoration: BoxDecoration(
              color: hasLogo ? null : c.background,
              borderRadius: MonAIRadius.lgAll,
              border: Border.all(color: c.borderStrong),
            ),
            child: Padding(
              padding: const .all(MonAISpacing.x3_5),
              child: Row(
                spacing: MonAISpacing.x3_5,
                children: [
                  if (hasLogo)
                    ValueListenableBuilder(
                      valueListenable: name,
                      builder: (_, name, _) => ProviderLogo(
                        name: name.text,
                        logoUrl: logoUrl,
                        localPath: newLogoPath,
                        size: _logoSize,
                      ),
                    )
                  else
                    Container(
                      width: _logoSize,
                      height: _logoSize,
                      decoration: BoxDecoration(
                        color: c.surface,
                        shape: BoxShape.circle,
                        border: Border.all(color: c.border),
                      ),
                      child: Center(
                        child: MonAIIcon(
                          MonAIIcons.addPhotoAlternate,
                          color: c.textTertiary,
                        ),
                      ),
                    ),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: .start,
                      spacing: MonAISpacing.x0_5,
                      children: [
                        Text(
                          hasLogo
                              ? l10n.providerFormLogo
                              : l10n.providerFormUploadLogo,
                          style: context.textTheme.titleSmall,
                        ),
                        Text(
                          l10n.providerFormLogoNote,
                          style: context.textTheme.bodySmall?.copyWith(
                            color: c.textTertiary,
                          ),
                        ),
                      ],
                    ),
                  ),
                  if (hasLogo)
                    MonAIButton(
                      label: l10n.providerFormReplaceLogo,
                      variant: .tonal,
                      size: .small,
                      onPressed: working ? null : onPick,
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
