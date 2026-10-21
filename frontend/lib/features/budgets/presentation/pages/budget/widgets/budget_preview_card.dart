import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:monai/core/ui/designsystem/designsystem.dart';
import 'package:monai/core/ui/l10n/l10n.dart';
import 'package:monai/core/utils/money_format.dart';
import 'package:monai/features/budgets/domain/logic/budget_preview.dart';
import 'package:monai/features/budgets/presentation/pages/budget/bloc/budget_bloc.dart';

/// The typed limit against this month's spending; hidden while the field is
/// empty.
class BudgetPreviewCard extends StatelessWidget {
  const BudgetPreviewCard({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocSelector<BudgetBloc, BudgetState, BudgetPreview?>(
      selector: (state) => state.preview,
      builder: (context, preview) => switch (preview) {
        final preview? => _PreviewCard(preview: preview),
        null => const SizedBox.shrink(),
      },
    );
  }
}

class _PreviewCard extends StatelessWidget {
  const _PreviewCard({required this.preview});

  final BudgetPreview preview;

  @override
  Widget build(BuildContext context) {
    final c = context.colors;
    final t = context.textTheme;
    final l10n = context.l10n;
    final color = preview.status.color(c);
    final remaining = preview.remaining;
    final (statusText, statusIcon, statusColor) = switch (preview.status) {
      .ok => (
        l10n.budgetPreviewLeft(formatRupiah(remaining)),
        MonAIIcons.checkCircle,
        c.textSecondary,
      ),
      .warning => (
        l10n.budgetPreviewLeft(formatRupiah(remaining)),
        MonAIIcons.warning,
        c.warning,
      ),
      .exceeded => (
        l10n.budgetPreviewOver(formatRupiah(-remaining)),
        MonAIIcons.error,
        c.errorText,
      ),
    };
    return Semantics(
      liveRegion: true,
      child: Container(
        padding: const .all(MonAISpacing.x4),
        decoration: BoxDecoration(
          color: c.background,
          border: Border.all(color: c.border),
          borderRadius: MonAIRadius.lgAll,
        ),
        child: Column(
          crossAxisAlignment: .stretch,
          spacing: MonAISpacing.x3,
          children: [
            Text(
              l10n.budgetPreviewTitle,
              style: t.labelMedium?.copyWith(color: c.textSecondary),
            ),
            Row(
              crossAxisAlignment: .baseline,
              textBaseline: .alphabetic,
              children: [
                Expanded(
                  child: Text(
                    l10n.budgetPreviewSpent(formatRupiah(preview.spent)),
                    style: t.titleMedium?.tabular.copyWith(
                      color: c.textPrimary,
                    ),
                  ),
                ),
                Text(
                  l10n.budgetPercent(preview.percent),
                  style: t.headlineSmall?.tabular
                      .withWeight(.w700)
                      .copyWith(color: color),
                ),
              ],
            ),
            MonAIProgressBar(
              progress: preview.progress,
              color: color,
              trackColor: c.border,
            ),
            Row(
              spacing: MonAISpacing.x1_5,
              children: [
                MonAIIcon(
                  statusIcon,
                  size: MonAISizes.iconSm,
                  color: statusColor,
                ),
                Flexible(
                  child: Text(
                    statusText,
                    style: t.bodyMedium
                        ?.withWeight(.w600)
                        .copyWith(color: statusColor),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
