import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:monai/core/ui/designsystem/designsystem.dart';
import 'package:monai/core/ui/l10n/l10n.dart';
import 'package:monai/features/shared/domain/entity/payment_provider.dart';
import 'package:monai/features/wallets/presentation/pages/wallet_form/bloc/wallet_form_bloc.dart';
import 'package:monai/features/wallets/presentation/widgets/wallet_logo.dart';

class WalletFormProviderGrid extends StatelessWidget {
  const WalletFormProviderGrid({required this.onPicked, super.key});
  final ValueChanged<String?> onPicked;

  static const _columns = 5;
  static const _tileHeight = 80.0;

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    return Column(
      crossAxisAlignment: .stretch,
      spacing: MonAISpacing.x2_5,
      children: [
        Text(
          l10n.walletFormPickProvider,
          style: context.textTheme.labelLarge?.copyWith(
            color: context.colors.textSecondary,
          ),
        ),
        BlocSelector<
          WalletFormBloc,
          WalletFormState,
          (List<PaymentProvider>, String?)
        >(
          selector: (state) => (state.providers, state.providerSlug),
          builder: (context, selected) {
            final (providers, slug) = selected;
            return GridView.builder(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              padding: .zero,
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: _columns,
                mainAxisExtent: _tileHeight,
                mainAxisSpacing: MonAISpacing.x2,
                crossAxisSpacing: MonAISpacing.x1,
              ),
              itemCount: providers.length + 1,
              itemBuilder: (context, index) {
                if (index == providers.length) {
                  return _Tile(
                    name: l10n.walletFormCustom,
                    selected: slug == null,
                    onTap: () => onPicked(null),
                    custom: true,
                  );
                }
                final provider = providers[index];
                return _Tile(
                  name: provider.name,
                  logoUrl: provider.logoUrl,
                  selected: provider.slug == slug,
                  onTap: () => onPicked(provider.slug),
                );
              },
            );
          },
        ),
      ],
    );
  }
}

class _Tile extends StatelessWidget {
  const _Tile({
    required this.name,
    required this.selected,
    required this.onTap,
    this.logoUrl,
    this.custom = false,
  });

  static const _logoSize = 48.0;
  static const _badgeSize = 20.0;

  final String name;
  final String? logoUrl;
  final bool selected;
  final VoidCallback onTap;
  final bool custom;

  @override
  Widget build(BuildContext context) {
    final c = context.colors;
    return Semantics(
      button: true,
      selected: selected,
      child: InkWell(
        onTap: onTap,
        borderRadius: MonAIRadius.mdAll,
        child: Column(
          spacing: MonAISpacing.x1_5,
          children: [
            const SizedBox(height: MonAISpacing.x1),
            SizedBox.square(
              dimension: _logoSize,
              child: Stack(
                clipBehavior: .none,
                children: [
                  DecoratedBox(
                    position: .foreground,
                    decoration: BoxDecoration(
                      shape: .circle,
                      border: Border.all(
                        color: selected ? c.focus : c.border,
                        width: selected
                            ? MonAISizes.borderFocused
                            : MonAISizes.border,
                      ),
                    ),
                    child: custom
                        ? Container(
                            width: _logoSize,
                            height: _logoSize,
                            alignment: .center,
                            decoration: BoxDecoration(
                              color: c.surfaceSunken,
                              shape: .circle,
                            ),
                            child: MonAIIcon(
                              MonAIIcons.add,
                              color: c.textSecondary,
                            ),
                          )
                        : WalletLogo(
                            name: name,
                            logoUrl: logoUrl,
                            size: _logoSize,
                            containerColor: selected
                                ? c.primaryContainer
                                : c.background,
                            contentColor: c.accent,
                          ),
                  ),
                  if (selected)
                    Positioned(
                      right: -MonAISpacing.x1,
                      bottom: -MonAISpacing.x1,
                      child: Container(
                        width: _badgeSize,
                        height: _badgeSize,
                        alignment: .center,
                        decoration: BoxDecoration(
                          color: c.primary,
                          shape: .circle,
                          border: Border.all(
                            color: c.surface,
                            width: MonAISizes.borderFocused,
                          ),
                        ),
                        child: MonAIIcon(
                          MonAIIcons.check,
                          size: MonAISizes.iconXs,
                          color: c.onPrimary,
                        ),
                      ),
                    ),
                ],
              ),
            ),
            Text(
              name,
              maxLines: 1,
              overflow: .ellipsis,
              style: context.textTheme.labelMedium?.copyWith(
                color: c.iconStrong,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
