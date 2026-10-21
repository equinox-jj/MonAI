import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:monai/core/ui/designsystem/designsystem.dart';
import 'package:monai/core/app/injector.dart';
import 'package:monai/core/ui/l10n/l10n.dart';
import 'package:monai/core/utils/money_format.dart';
import 'package:monai/core/utils/month_format.dart';
import 'package:monai/features/budgets/presentation/pages/budget/bloc/budget_bloc.dart';
import 'package:monai/features/budgets/presentation/pages/budget/widgets/budget_actions.dart';
import 'package:monai/features/budgets/presentation/pages/budget/widgets/budget_legend.dart';
import 'package:monai/features/budgets/presentation/pages/budget/widgets/budget_limit_field.dart';
import 'package:monai/features/budgets/presentation/pages/budget/widgets/budget_presets.dart';
import 'package:monai/features/budgets/presentation/pages/budget/widgets/budget_preview_card.dart';

class BudgetPage extends StatelessWidget {
  const BudgetPage({required this.month, super.key});
  final DateTime month;

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) =>
          sl<BudgetBloc>(param1: month)..add(const BudgetEvent.started()),
      child: const BudgetUI(),
    );
  }
}

class BudgetUI extends StatefulWidget {
  const BudgetUI({super.key});

  @override
  State<BudgetUI> createState() => _BudgetUIState();
}

class _BudgetUIState extends State<BudgetUI> {
  final _limit = TextEditingController();

  @override
  void initState() {
    super.initState();
    // The budget may have loaded before this screen listened.
    _fill(context, _bloc.state);
  }

  @override
  void dispose() {
    _limit.dispose();
    super.dispose();
  }

  BudgetBloc get _bloc => context.read<BudgetBloc>();

  void _fill(BuildContext context, BudgetState state) {
    if (state.limitTouched) return;
    _limit.text = state.limit > 0 ? formatRupiahInput(state.limit) : '';
  }

  void _onLimitChanged(String limit) =>
      _bloc.add(BudgetEvent.limitEdited(limit));

  void _pickPreset(int amount) {
    _limit.text = formatRupiahInput(amount);
    _bloc.add(BudgetEvent.limitEdited(_limit.text));
  }

  void _save() {
    FocusScope.of(context).unfocus();
    _bloc.add(BudgetEvent.saveRequested(_limit.text));
  }

  Future<void> _confirmRemove() async {
    final l10n = context.l10n;
    final monthName = MonthFormat.monthName(
      _bloc.state.month,
      context.localeName,
    );
    final remove = await showDialog<bool>(
      context: context,
      builder: (dialogContext) => MonAIAlertDialog(
        title: l10n.budgetRemoveTitle(monthName),
        message: l10n.budgetRemoveMessage,
        icon: MonAIIcons.delete,
        tone: .error,
        confirmLabel: l10n.budgetRemoveConfirm,
        destructive: true,
        onConfirm: () => Navigator.pop(dialogContext, true),
        dismissLabel: l10n.budgetCancel,
        onDismiss: () => Navigator.pop(dialogContext, false),
      ),
    );
    if (remove ?? false) _bloc.add(const BudgetEvent.deleteRequested());
  }

  void _finish(BuildContext context, BudgetState state) =>
      Navigator.pop(context, state.outcome);

  void _showActionFailure(BuildContext context, BudgetState state) {
    if (state.actionFailure case final failure?) {
      showMonAISnackBar(context, message: failure.message(context.l10n));
    }
  }

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    final month = context.select<BudgetBloc, DateTime>(
      (bloc) => bloc.state.month,
    );
    final monthName = MonthFormat.monthName(month, context.localeName);
    return MultiBlocListener(
      listeners: [
        BlocListener<BudgetBloc, BudgetState>(
          listenWhen: (previous, current) =>
              !current.limitTouched &&
              previous.budget?.limitAmount != current.budget?.limitAmount,
          listener: _fill,
        ),
        BlocListener<BudgetBloc, BudgetState>(
          listenWhen: (previous, current) =>
              current.outcome != null && previous.outcome == null,
          listener: _finish,
        ),
        BlocListener<BudgetBloc, BudgetState>(
          listenWhen: (previous, current) =>
              current.actionFailure != null &&
              previous.actionFailure != current.actionFailure,
          listener: _showActionFailure,
        ),
      ],
      child: Scaffold(
        backgroundColor: context.colors.surface,
        appBar: MonAITopBar(
          title: l10n.budgetTitle(monthName),
          navigationTooltip: l10n.budgetBack,
        ),
        body: SafeArea(
          top: false,
          child: Padding(
            padding: const .fromLTRB(
              MonAISpacing.x4,
              0,
              MonAISpacing.x4,
              MonAISpacing.x6,
            ),
            child: Column(
              crossAxisAlignment: .stretch,
              children: [
                Expanded(
                  child: SingleChildScrollView(
                    child: Column(
                      crossAxisAlignment: .stretch,
                      spacing: MonAISpacing.x5,
                      children: [
                        Text(
                          l10n.budgetIntro,
                          style: context.textTheme.bodyMedium?.copyWith(
                            color: context.colors.textSecondary,
                          ),
                        ),
                        BudgetLimitField(
                          controller: _limit,
                          onChanged: _onLimitChanged,
                        ),
                        BudgetPresets(onPick: _pickPreset),
                        const BudgetPreviewCard(),
                        const BudgetLegend(),
                      ],
                    ),
                  ),
                ),
                const SizedBox(height: MonAISpacing.x4),
                BudgetActions(
                  monthName: monthName,
                  onSave: _save,
                  onRemove: _confirmRemove,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
