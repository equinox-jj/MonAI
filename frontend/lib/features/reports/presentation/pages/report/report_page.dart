import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:monai/core/designsystem/designsystem.dart';
import 'package:monai/core/di/injector.dart';
import 'package:monai/core/l10n/l10n.dart';
import 'package:monai/core/model/ui_status.dart';
import 'package:monai/core/router/app_router.dart';
import 'package:monai/core/utils/month_format.dart';
import 'package:monai/features/reports/presentation/model/report_failure.dart';
import 'package:monai/features/reports/presentation/pages/report/bloc/report_bloc.dart';
import 'package:monai/features/reports/presentation/pages/report/widgets/report_breakdown_card.dart';
import 'package:monai/features/reports/presentation/pages/report/widgets/report_budget_card.dart';
import 'package:monai/features/reports/presentation/pages/report/widgets/report_skeleton.dart';
import 'package:monai/features/reports/presentation/pages/report/widgets/report_totals.dart';

class ReportPage extends StatelessWidget {
  const ReportPage({required this.month, super.key});

  /// The month to open on; a future one opens the current month.
  final DateTime month;

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) =>
          sl<ReportBloc>(param1: month)..add(const ReportEvent.started()),
      child: const ReportUI(),
    );
  }
}

/// A month's report: totals, spending by category and the budget, with
/// arrows to step through months.
class ReportUI extends StatelessWidget {
  const ReportUI({super.key});

  void _previousMonth(BuildContext context) =>
      context.read<ReportBloc>().add(const ReportEvent.previousMonth());

  void _nextMonth(BuildContext context) =>
      context.read<ReportBloc>().add(const ReportEvent.nextMonth());

  void _retry(BuildContext context) =>
      context.read<ReportBloc>().add(const ReportEvent.retried());

  void _openBudget(BuildContext context) =>
      context.push(AppRoutes.budgetFor(context.read<ReportBloc>().state.month));

  void _showRefreshFailure(BuildContext context, ReportState state) {
    if (state.refreshFailure case final failure?) {
      showMonAISnackBar(
        context,
        message: failure.refreshMessage(context.l10n),
        icon: MonAIIcons.cloudOff,
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    return BlocListener<ReportBloc, ReportState>(
      listenWhen: (previous, current) =>
          current.refreshFailure != null &&
          previous.refreshFailure != current.refreshFailure,
      listener: _showRefreshFailure,
      child: Scaffold(
        backgroundColor: context.colors.background,
        appBar: MonAITopBar(
          title: l10n.reportTitle,
          navigationTooltip: l10n.reportBack,
        ),
        body: SafeArea(
          top: false,
          child: ListView(
            padding: const .fromLTRB(
              MonAISpacing.x4,
              0,
              MonAISpacing.x4,
              MonAISpacing.x6,
            ),
            children: [
              _MonthSwitcher(
                onPrevious: () => _previousMonth(context),
                onNext: () => _nextMonth(context),
              ),
              const SizedBox(height: MonAISpacing.x4),
              _Body(
                onRetry: () => _retry(context),
                onOpenBudget: () => _openBudget(context),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _MonthSwitcher extends StatelessWidget {
  const _MonthSwitcher({required this.onPrevious, required this.onNext});

  final VoidCallback onPrevious;
  final VoidCallback onNext;

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    final locale = context.localeName;
    return BlocSelector<ReportBloc, ReportState, (DateTime, bool)>(
      selector: (state) => (state.month, state.canShowNextMonth),
      builder: (context, selected) {
        final (month, canShowNext) = selected;
        return MonAIMonthSwitcher(
          label: MonthFormat.monthYear(month, locale),
          previousTooltip: l10n.reportPreviousMonth(
            MonthFormat.monthYear(
              DateTime(month.year, month.month - 1),
              locale,
            ),
          ),
          nextTooltip: l10n.reportNextMonth(
            MonthFormat.monthYear(
              DateTime(month.year, month.month + 1),
              locale,
            ),
          ),
          onPrevious: onPrevious,
          onNext: canShowNext ? onNext : null,
        );
      },
    );
  }
}

/// The report, its skeleton while loading, or the error when it couldn't
/// be loaded.
class _Body extends StatelessWidget {
  const _Body({required this.onRetry, required this.onOpenBudget});

  final VoidCallback onRetry;
  final VoidCallback onOpenBudget;

  @override
  Widget build(BuildContext context) {
    return BlocSelector<ReportBloc, ReportState, (bool, UiStatus)>(
      selector: (state) => (state.report != null, state.status),
      builder: (context, selected) => switch (selected) {
        (true, _) => Column(
          crossAxisAlignment: .stretch,
          spacing: MonAISpacing.x4,
          children: [
            const ReportTotals(),
            const ReportBreakdownCard(),
            ReportBudgetCard(onOpenBudget: onOpenBudget),
          ],
        ),
        (false, .failure) => _LoadError(onRetry: onRetry),
        (false, _) => const ReportSkeleton(),
      },
    );
  }
}

class _LoadError extends StatelessWidget {
  const _LoadError({required this.onRetry});

  final VoidCallback onRetry;

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    return Padding(
      padding: const .symmetric(
        horizontal: MonAISpacing.x6,
        vertical: MonAISpacing.x10,
      ),
      child: BlocSelector<ReportBloc, ReportState, ReportFailure?>(
        selector: (state) => state.loadFailure,
        builder: (context, failure) => MonAIStateMessage(
          icon: failure == .network ? MonAIIcons.cloudOff : MonAIIcons.error,
          tone: .error,
          title: l10n.reportErrorTitle,
          message: (failure ?? .unexpected).loadMessage(l10n),
          actionLabel: l10n.reportTryAgain,
          actionIcon: MonAIIcons.refresh,
          onAction: onRetry,
        ),
      ),
    );
  }
}
