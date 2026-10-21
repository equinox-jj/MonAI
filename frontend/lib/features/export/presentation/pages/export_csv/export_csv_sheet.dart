import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:monai/core/ui/designsystem/designsystem.dart';
import 'package:monai/core/app/injector.dart';
import 'package:monai/core/ui/l10n/l10n.dart';
import 'package:monai/core/utils/month_format.dart';
import 'package:monai/features/export/domain/entity/csv_export.dart';
import 'package:monai/features/export/presentation/model/export_failure.dart';
import 'package:monai/features/export/presentation/pages/export_csv/bloc/export_csv_bloc.dart';

Future<void> showExportCsvSheet(BuildContext context) async {
  final exported = await showMonAIBottomSheet<ExportedCsv>(
    context,
    title: context.l10n.exportTitle,
    builder: (_) => BlocProvider(
      create: (_) => sl<ExportCsvBloc>()..add(const ExportCsvEvent.started()),
      child: const ExportCsvSheet(),
    ),
  );
  if (exported != null && !exported.isComplete && context.mounted) {
    showMonAISnackBar(context, message: context.l10n.exportPartialOffline);
  }
}

class ExportCsvSheet extends StatelessWidget {
  const ExportCsvSheet({super.key});

  void _moveFrom(BuildContext context, int months) =>
      context.read<ExportCsvBloc>().add(ExportCsvEvent.fromMoved(months));

  void _moveTo(BuildContext context, int months) =>
      context.read<ExportCsvBloc>().add(ExportCsvEvent.toMoved(months));

  void _pickDelimiter(BuildContext context, CsvDelimiter delimiter) => context
      .read<ExportCsvBloc>()
      .add(ExportCsvEvent.delimiterPicked(delimiter));

  void _export(BuildContext context) => context.read<ExportCsvBloc>().add(
    ExportCsvEvent.exportRequested(shareTitle: context.l10n.exportShareTitle),
  );

  void _close(BuildContext context, ExportCsvState state) =>
      Navigator.pop(context, state.exported);

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    return BlocListener<ExportCsvBloc, ExportCsvState>(
      listenWhen: (previous, current) =>
          current.exported != null && previous.exported == null,
      listener: _close,
      child: Column(
        mainAxisSize: .min,
        crossAxisAlignment: .stretch,
        spacing: MonAISpacing.x4,
        children: [
          _MonthRow(
            label: l10n.exportFrom,
            month: (state) => state.range.from,
            canMoveForward: (state) => state.canMoveFromForward,
            onPrevious: () => _moveFrom(context, -1),
            onNext: () => _moveFrom(context, 1),
          ),
          _MonthRow(
            label: l10n.exportTo,
            month: (state) => state.range.to,
            canMoveForward: (state) => state.canMoveToForward,
            onPrevious: () => _moveTo(context, -1),
            onNext: () => _moveTo(context, 1),
          ),
          _Note(text: l10n.exportRangeNote),
          _DelimiterPicker(onPick: (d) => _pickDelimiter(context, d)),
          _Note(text: l10n.exportDelimiterNote),
          const _Failure(),
          BlocSelector<ExportCsvBloc, ExportCsvState, bool>(
            selector: (state) => state.isExporting,
            builder: (context, isExporting) => MonAISheetButtons(
              secondaryLabel: l10n.exportCancel,
              onSecondary: () => Navigator.pop(context),
              primaryLabel: l10n.exportAction,
              onPrimary: isExporting ? null : () => _export(context),
              primaryLoading: isExporting,
            ),
          ),
        ],
      ),
    );
  }
}

class _MonthRow extends StatelessWidget {
  const _MonthRow({
    required this.label,
    required this.month,
    required this.canMoveForward,
    required this.onPrevious,
    required this.onNext,
  });

  final String label;
  final DateTime Function(ExportCsvState) month;
  final bool Function(ExportCsvState) canMoveForward;
  final VoidCallback onPrevious;
  final VoidCallback onNext;

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    final locale = context.localeName;
    return Column(
      crossAxisAlignment: .stretch,
      spacing: MonAISpacing.fieldLabelGap,
      children: [
        Text(
          label,
          style: context.textTheme.labelMedium?.copyWith(
            color: context.colors.textSecondary,
          ),
        ),
        BlocSelector<ExportCsvBloc, ExportCsvState, (DateTime, bool)>(
          selector: (state) => (month(state), canMoveForward(state)),
          builder: (context, selected) {
            final (shown, canNext) = selected;
            return MonAIMonthSwitcher(
              label: MonthFormat.monthYear(shown, locale),
              previousTooltip: l10n.exportPreviousMonth,
              nextTooltip: l10n.exportNextMonth,
              onPrevious: onPrevious,
              onNext: canNext ? onNext : null,
            );
          },
        ),
      ],
    );
  }
}

class _DelimiterPicker extends StatelessWidget {
  const _DelimiterPicker({required this.onPick});

  final ValueChanged<CsvDelimiter> onPick;

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    return Column(
      crossAxisAlignment: .stretch,
      spacing: MonAISpacing.fieldLabelGap,
      children: [
        Text(
          l10n.exportDelimiter,
          style: context.textTheme.labelMedium?.copyWith(
            color: context.colors.textSecondary,
          ),
        ),
        BlocSelector<ExportCsvBloc, ExportCsvState, CsvDelimiter>(
          selector: (state) => state.delimiter,
          builder: (context, delimiter) => MonAISegmentedControl<CsvDelimiter>(
            selected: delimiter,
            onChanged: onPick,
            segments: [
              MonAISegment(
                value: CsvDelimiter.comma,
                label: l10n.exportDelimiterComma,
              ),
              MonAISegment(
                value: CsvDelimiter.semicolon,
                label: l10n.exportDelimiterSemicolon,
              ),
            ],
          ),
        ),
      ],
    );
  }
}

class _Note extends StatelessWidget {
  const _Note({required this.text});

  final String text;

  @override
  Widget build(BuildContext context) => Text(
    text,
    style: context.textTheme.bodySmall?.copyWith(
      color: context.colors.textTertiary,
    ),
  );
}

class _Failure extends StatelessWidget {
  const _Failure();

  @override
  Widget build(BuildContext context) {
    return BlocSelector<ExportCsvBloc, ExportCsvState, ExportFailure?>(
      selector: (state) => state.failure,
      builder: (context, failure) => switch (failure) {
        final failure? => MonAIInlineAlert(
          message: failure.message(context.l10n),
          tone: .error,
        ),
        null => const SizedBox.shrink(),
      },
    );
  }
}
