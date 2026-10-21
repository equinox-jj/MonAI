import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:monai/core/ui/designsystem/designsystem.dart';
import 'package:monai/core/ui/l10n/l10n.dart';
import 'package:monai/core/utils/money_format.dart';
import 'package:monai/core/utils/month_format.dart';
import 'package:monai/features/home/domain/entity/home_dashboard.dart';
import 'package:monai/features/home/presentation/pages/home/bloc/home_bloc.dart';
import 'package:monai/features/home/presentation/pages/home/model/home_text.dart';

typedef _Spending = ({
  List<SpendingSlice> slices,
  int expenseTotal,
  DateTime? month,
});

class HomeSpendingCard extends StatelessWidget {
  const HomeSpendingCard({
    required this.onOpenReport,
    required this.widthClass,
    super.key,
  });

  final VoidCallback onOpenReport;
  final MonAIWidthClass widthClass;

  @override
  Widget build(BuildContext context) {
    return BlocSelector<HomeBloc, HomeState, _Spending>(
      selector: (state) {
        final dashboard = state.dashboard;
        final slices = dashboard?.spending ?? const <SpendingSlice>[];
        return (
          slices: slices,
          expenseTotal:
              dashboard?.summary?.expenseTotal ??
              slices.fold(0, (sum, s) => sum + s.amount),
          month: dashboard?.month,
        );
      },
      builder: (context, spending) {
        final l10n = context.l10n;
        final month = spending.month;
        final monthName = month == null
            ? ''
            : MonthFormat.monthName(month, context.localeName);
        final isExpanded = widthClass == .expanded;
        final isPhone = widthClass == .compact;
        final dark = context.colors.isDark;
        final colors = spending.slices
            .map(
              (s) => CategoryColors.content(
                CategoryColors.parse(s.color),
                dark: dark,
              ),
            )
            .toList();
        final shares = spending.slices
            .map(
              (s) =>
                  l10n.homeSpendingShareDescription(s.label(l10n), s.percent),
            )
            .join(', ');
        return MonAICard(
          padding: isPhone
              ? const .all(MonAISpacing.cardPadding)
              : const .all(MonAISpacing.x5),
          child: Column(
            crossAxisAlignment: .stretch,
            spacing: MonAISpacing.x4,
            children: [
              MonAISectionHeader(
                title: isExpanded
                    ? l10n.homeSpendingTitleMonth(monthName)
                    : l10n.homeSpendingTitle,
                actionLabel: l10n.homeFullReport,
                onActionPressed: onOpenReport,
                style: context.textTheme.titleMedium,
              ),
              Row(
                spacing: isExpanded ? MonAISpacing.x8 : MonAISpacing.x5,
                children: [
                  SizedBox.square(
                    dimension: switch (widthClass) {
                      .compact => 140,
                      .medium => 132,
                      .expanded => 220,
                    },
                    child: Stack(
                      alignment: .center,
                      children: [
                        MonAIDonut(
                          shares: spending.slices
                              .map((s) => s.sharePercent)
                              .toList(),
                          colors: colors,
                          stroke: switch (widthClass) {
                            .compact => 17,
                            .medium => 20,
                            .expanded => 27,
                          },
                          semanticsLabel: l10n.homeSpendingDescription(
                            monthName,
                            shares,
                          ),
                        ),
                        ExcludeSemantics(
                          child: _DonutCenter(
                            total: formatRupiahCompact(spending.expenseTotal),
                            caption: switch (widthClass) {
                              .compact => monthName,
                              .medium => null,
                              .expanded => l10n.homeSpendingSpent,
                            },
                            large: isExpanded,
                          ),
                        ),
                      ],
                    ),
                  ),
                  Expanded(
                    child: _Legend(
                      slices: spending.slices,
                      colors: colors,
                      large: isExpanded,
                    ),
                  ),
                ],
              ),
            ],
          ),
        );
      },
    );
  }
}

class _DonutCenter extends StatelessWidget {
  const _DonutCenter({
    required this.total,
    required this.caption,
    required this.large,
  });

  final String total;
  final String? caption;
  final bool large;

  @override
  Widget build(BuildContext context) {
    final t = context.textTheme;
    return Column(
      mainAxisSize: .min,
      children: [
        Text(
          total,
          style: (large ? t.headlineSmall : t.titleMedium)
              ?.withWeight(.w700)
              .tabular
              .copyWith(color: context.colors.textPrimary),
        ),
        if (caption case final caption?)
          Text(
            caption,
            style: t.bodySmall?.copyWith(color: context.colors.textTertiary),
          ),
      ],
    );
  }
}

class _Legend extends StatelessWidget {
  const _Legend({
    required this.slices,
    required this.colors,
    required this.large,
  });

  final List<SpendingSlice> slices;
  final List<Color> colors;
  final bool large;

  @override
  Widget build(BuildContext context) {
    return ExcludeSemantics(
      child: ListView.separated(
        shrinkWrap: true,
        physics: const NeverScrollableScrollPhysics(),
        padding: .zero,
        itemCount: slices.length,
        separatorBuilder: (_, _) =>
            SizedBox(height: large ? MonAISpacing.x3 : MonAISpacing.x2_5),
        itemBuilder: (context, index) => _LegendRow(
          name: slices[index].label(context.l10n),
          percent: slices[index].percent,
          color: colors[index],
          large: large,
        ),
      ),
    );
  }
}

class _LegendRow extends StatelessWidget {
  const _LegendRow({
    required this.name,
    required this.percent,
    required this.color,
    required this.large,
  });

  final String name;
  final int percent;
  final Color color;
  final bool large;

  @override
  Widget build(BuildContext context) {
    final style =
        (large ? context.textTheme.bodyMedium! : context.textStyles.bodyCompact)
            .copyWith(color: context.colors.textPrimary);
    return Row(
      spacing: MonAISpacing.x2,
      children: [
        Container(
          width: 10,
          height: 10,
          decoration: BoxDecoration(color: color, shape: .circle),
        ),
        Expanded(
          child: Text(name, maxLines: 1, overflow: .ellipsis, style: style),
        ),
        Text(
          context.l10n.homePercent(percent),
          style: style.withWeight(.w600).tabular,
        ),
      ],
    );
  }
}
