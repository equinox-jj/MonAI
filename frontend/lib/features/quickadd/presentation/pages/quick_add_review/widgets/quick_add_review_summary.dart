import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:monai/core/designsystem/designsystem.dart';
import 'package:monai/core/l10n/l10n.dart';
import 'package:monai/core/utils/month_format.dart';
import 'package:monai/features/quickadd/presentation/model/quick_add_text.dart';
import 'package:monai/features/quickadd/presentation/pages/quick_add_review/bloc/quick_add_review_bloc.dart';
import 'package:monai/features/shared/domain/entity/category.dart';

/// One reviewed draft in the summary.
@immutable
class _SummaryRow {
  const _SummaryRow({
    required this.title,
    required this.status,
    required this.amount,
    required this.saved,
    this.category,
  });

  final String title;
  final String status;
  final String amount;
  final bool saved;
  final Category? category;

  @override
  bool operator ==(Object other) =>
      other is _SummaryRow &&
      other.title == title &&
      other.status == status &&
      other.amount == amount &&
      other.saved == saved &&
      other.category == category;

  @override
  int get hashCode => Object.hash(title, status, amount, saved, category);
}

List<_SummaryRow> _rowsOf(
  QuickAddReviewState state,
  AppLocalizations l10n,
  String locale,
) => List.generate(state.results.length, (index) {
  final result = state.results[index];
  final draft = state.drafts[index];
  return switch (result) {
    SavedQuickAddResult(:final transaction) => _SummaryRow(
      title:
          transaction.note ??
          state.categoryOf(transaction.categoryId)?.name ??
          '',
      status: l10n.quickAddReviewStatusSaved(
        state.walletOf(transaction.walletId)?.name ?? '–',
        quickAddDayText(transaction.date, state.today, l10n, locale),
      ),
      amount: quickAddAmountText(
        draft.copyWith(type: transaction.type, amount: transaction.amount),
        l10n,
      ),
      saved: true,
      category: state.categoryOf(transaction.categoryId),
    ),
    SkippedQuickAddResult() => _SummaryRow(
      title: draft.note ?? state.categoryOf(draft.categoryId)?.name ?? '',
      status: l10n.quickAddReviewStatusSkipped,
      amount: quickAddAmountText(draft, l10n),
      saved: false,
      category: state.categoryOf(draft.categoryId),
    ),
  };
});

/// What happened to each draft once all were reviewed.
class QuickAddReviewSummary extends StatelessWidget {
  const QuickAddReviewSummary({super.key});

  static const _skippedOpacity = 0.5;
  static const _iconSize = 64.0;

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    final locale = context.localeName;
    final c = context.colors;
    final t = context.textTheme;
    return BlocSelector<
      QuickAddReviewBloc,
      QuickAddReviewState,
      (int, List<_SummaryRow>)
    >(
      selector: (state) => (state.savedCount, _rowsOf(state, l10n, locale)),
      builder: (context, selected) {
        final (saved, rows) = selected;
        return Semantics(
          liveRegion: true,
          child: Column(
            crossAxisAlignment: .stretch,
            spacing: MonAISpacing.x3,
            children: [
              Center(
                child: SizedBox.square(
                  dimension: _iconSize,
                  child: DecoratedBox(
                    decoration: BoxDecoration(
                      color: c.incomeContainer,
                      shape: BoxShape.circle,
                    ),
                    child: Center(
                      child: MonAIIcon(
                        MonAIIcons.checkCircle,
                        size: MonAISizes.iconXxl,
                        color: c.success,
                      ),
                    ),
                  ),
                ),
              ),
              Text(
                saved == 0
                    ? l10n.quickAddReviewNothingSaved
                    : l10n.quickAddReviewSaved(saved),
                textAlign: .center,
                style: t.titleLarge,
              ),
              MonAICard(
                padding: EdgeInsets.zero,
                child: Column(
                  children: List.generate(
                    rows.length,
                    (index) => Opacity(
                      opacity: rows[index].saved ? 1 : _skippedOpacity,
                      child: _Row(row: rows[index]),
                    ),
                  ),
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}

class _Row extends StatelessWidget {
  const _Row({required this.row});

  final _SummaryRow row;

  @override
  Widget build(BuildContext context) {
    final c = context.colors;
    final t = context.textTheme;
    final category = row.category;
    return Padding(
      padding: const .symmetric(
        horizontal: MonAISpacing.x4,
        vertical: MonAISpacing.x3,
      ),
      child: Row(
        spacing: MonAISpacing.x3,
        children: [
          MonAICategoryIcon(
            icon: category == null
                ? MonAIIcons.category
                : categoryIcon(category.icon),
            color: CategoryColors.parse(category?.color),
            size: MonAISizes.avatarMedium - MonAISpacing.x1,
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
                  row.status,
                  maxLines: 1,
                  overflow: .ellipsis,
                  style: t.bodySmall?.copyWith(color: c.textTertiary),
                ),
              ],
            ),
          ),
          Text(row.amount, style: t.titleSmall),
        ],
      ),
    );
  }
}
