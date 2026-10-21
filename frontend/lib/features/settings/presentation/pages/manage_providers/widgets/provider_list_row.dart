import 'package:flutter/material.dart';
import 'package:monai/core/designsystem/designsystem.dart';
import 'package:monai/core/l10n/l10n.dart';
import 'package:monai/core/utils/extension/wallet_type_extension.dart';
import 'package:monai/features/settings/domain/entity/admin_payment_provider.dart';
import 'package:monai/features/settings/domain/logic/provider_rules.dart';
import 'package:monai/features/settings/presentation/widgets/provider_logo.dart';
import 'package:monai/features/settings/presentation/widgets/provider_status_tag.dart';

/// One provider in the admin list: logo, name, badge, type and aliases. A
/// system provider shows a lock; others open the form when [onEdit] is set.
class ProviderListRow extends StatelessWidget {
  const ProviderListRow({required this.provider, super.key, this.onEdit});

  static const _height = 68.0;

  final AdminPaymentProvider provider;

  /// Null when the user may not edit providers.
  final VoidCallback? onEdit;

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    final c = context.colors;
    final status = providerStatusOf(provider);
    final details = [
      provider.type.label(l10n),
      if (provider.aliases.isNotEmpty) aliasSummary(provider),
    ].join(' · ');
    return InkWell(
      onTap: status == .system ? null : onEdit,
      child: ConstrainedBox(
        constraints: const BoxConstraints(minHeight: _height),
        child: Padding(
          padding: const .only(left: MonAISpacing.x3_5, right: MonAISpacing.x1),
          child: Row(
            spacing: MonAISpacing.x3,
            children: [
              ProviderLogo(
                name: provider.name,
                logoUrl: provider.logoUrl,
                dimmed: status == .inactive,
              ),
              Expanded(
                child: Column(
                  mainAxisSize: .min,
                  crossAxisAlignment: .start,
                  children: [
                    Row(
                      spacing: MonAISpacing.x1_5,
                      children: [
                        Flexible(
                          child: Text(
                            provider.name,
                            style: context.textTheme.titleSmall,
                            overflow: .ellipsis,
                          ),
                        ),
                        ProviderStatusTag(status: status),
                      ],
                    ),
                    Text(
                      details,
                      maxLines: 1,
                      overflow: .ellipsis,
                      style: context.textTheme.bodySmall?.copyWith(
                        color: c.textTertiary,
                      ),
                    ),
                  ],
                ),
              ),
              _Trailing(status: status, name: provider.name, onEdit: onEdit),
            ],
          ),
        ),
      ),
    );
  }
}

class _Trailing extends StatelessWidget {
  const _Trailing({required this.status, required this.name, this.onEdit});

  final ProviderStatus status;
  final String name;
  final VoidCallback? onEdit;

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    final c = context.colors;
    if (status == .system) {
      return Semantics(
        label: l10n.providersLocked,
        child: SizedBox.square(
          dimension: MonAISizes.buttonMedium,
          child: Center(
            child: MonAIIcon(
              MonAIIcons.lock,
              size: MonAISizes.iconLg,
              color: c.textDisabled,
            ),
          ),
        ),
      );
    }
    final onPressed = onEdit;
    if (onPressed == null) return const SizedBox.shrink();
    return MonAIIconButton(
      icon: MonAIIcons.moreVert,
      tooltip: l10n.providersEdit(name),
      onPressed: onPressed,
    );
  }
}
