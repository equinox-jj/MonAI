import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:monai/core/ui/designsystem/designsystem.dart';
import 'package:monai/core/ui/l10n/l10n.dart';
import 'package:monai/core/utils/month_format.dart';
import 'package:monai/features/quickadd/presentation/model/quick_add_text.dart';
import 'package:monai/features/quickadd/presentation/pages/quick_add/bloc/quick_add_bloc.dart';

class QuickAddDrafts extends StatelessWidget {
  const QuickAddDrafts({super.key});

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    final locale = context.localeName;
    return BlocSelector<
      QuickAddBloc,
      QuickAddState,
      (List<QuickAddDraftRow>, bool)
    >(
      selector: (state) => (
        switch (state.context) {
          final parseContext? => quickAddRows(
            state.drafts,
            parseContext,
            l10n,
            locale,
          ),
          null => const [],
        },
        state.hasMissingAmount,
      ),
      builder: (context, selected) {
        final (rows, missingAmount) = selected;
        if (rows.isEmpty) return const SizedBox.shrink();
        final c = context.colors;
        return Column(
          crossAxisAlignment: .stretch,
          spacing: MonAISpacing.x2,
          children: [
            Text(
              l10n.quickAddDraftsReady(rows.length),
              style: context.textTheme.titleSmall,
            ),
            ...List.generate(rows.length, (index) => _Row(row: rows[index])),
            if (missingAmount)
              Row(
                spacing: MonAISpacing.x1_5,
                children: [
                  MonAIIcon(
                    MonAIIcons.warning,
                    size: MonAISizes.iconSm,
                    color: c.warning,
                  ),
                  Expanded(
                    child: Text(
                      l10n.quickAddAmountMissing,
                      style: context.textTheme.bodySmall?.copyWith(
                        color: c.onWarningContainer,
                      ),
                    ),
                  ),
                ],
              ),
          ],
        );
      },
    );
  }
}

class _Row extends StatelessWidget {
  const _Row({required this.row});

  final QuickAddDraftRow row;

  @override
  Widget build(BuildContext context) {
    final c = context.colors;
    final t = context.textTheme;
    final amountColor = switch (row.type) {
      _ when row.missingAmount => c.onWarningContainer,
      .expense => c.expense,
      .income => c.income,
      .transfer => c.textPrimary,
    };
    final category = row.category;
    return MonAICard(
      padding: const .symmetric(
        horizontal: MonAISpacing.x3_5,
        vertical: MonAISpacing.x3,
      ),
      child: Row(
        spacing: MonAISpacing.x3,
        children: [
          MonAICategoryIcon(
            icon: switch (category) {
              final category? => categoryIcon(category.icon),
              null when row.type == .transfer => MonAIIcons.swapHoriz,
              null => MonAIIcons.category,
            },
            color: CategoryColors.parse(category?.color),
          ),
          Expanded(
            child: Column(
              crossAxisAlignment: .start,
              children: [
                Text(
                  row.title,
                  maxLines: 1,
                  overflow: .ellipsis,
                  style: t.titleSmall,
                ),
                Text(
                  row.meta,
                  maxLines: 1,
                  overflow: .ellipsis,
                  style: t.bodySmall?.copyWith(color: c.textTertiary),
                ),
              ],
            ),
          ),
          DecoratedBox(
            decoration: BoxDecoration(
              color: row.missingAmount
                  ? c.warningContainer
                  : Colors.transparent,
              borderRadius: MonAIRadius.smAll,
            ),
            child: Padding(
              padding: const .symmetric(
                horizontal: MonAISpacing.x1_5,
                vertical: MonAISpacing.x1,
              ),
              child: Text(
                row.amount,
                style: t.titleSmall?.copyWith(
                  color: amountColor,
                  fontFeatures: const [FontFeature.tabularFigures()],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
