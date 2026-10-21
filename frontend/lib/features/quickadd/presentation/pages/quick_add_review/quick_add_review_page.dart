import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:monai/core/ui/designsystem/designsystem.dart';
import 'package:monai/core/app/injector.dart';
import 'package:monai/core/ui/l10n/l10n.dart';
import 'package:monai/core/model/transaction_type.dart';
import 'package:monai/core/utils/money_format.dart';
import 'package:monai/core/utils/month_format.dart';
import 'package:monai/features/quickadd/presentation/model/quick_add_field.dart';
import 'package:monai/features/quickadd/presentation/model/quick_add_review_args.dart';
import 'package:monai/features/quickadd/presentation/model/quick_add_text.dart';
import 'package:monai/features/quickadd/presentation/pages/quick_add_review/bloc/quick_add_review_bloc.dart';
import 'package:monai/features/quickadd/presentation/pages/quick_add_review/widgets/quick_add_review_fields.dart';
import 'package:monai/features/quickadd/presentation/pages/quick_add_review/widgets/quick_add_review_summary.dart';
import 'package:monai/features/quickadd/presentation/widgets/quick_add_pickers.dart';

class QuickAddReviewPage extends StatelessWidget {
  const QuickAddReviewPage({required this.args, super.key});

  final QuickAddReviewArgs args;

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) =>
          sl<QuickAddReviewBloc>(param1: args)
            ..add(const QuickAddReviewEvent.started()),
      child: const QuickAddReviewUI(),
    );
  }
}

/// Leaving after a save goes home, so nothing is saved twice.
class QuickAddReviewUI extends StatefulWidget {
  const QuickAddReviewUI({super.key});

  @override
  State<QuickAddReviewUI> createState() => _QuickAddReviewUIState();
}

class _QuickAddReviewUIState extends State<QuickAddReviewUI> {
  final _amount = TextEditingController();
  final _note = TextEditingController();

  @override
  void initState() {
    super.initState();
    _fill(context, _bloc.state);
  }

  @override
  void dispose() {
    _amount.dispose();
    _note.dispose();
    super.dispose();
  }

  QuickAddReviewBloc get _bloc => context.read<QuickAddReviewBloc>();

  void _fill(BuildContext context, QuickAddReviewState state) {
    final draft = state.original;
    if (draft == null) return;
    _amount.text = switch (draft.amount) {
      final amount? => formatRupiahInput(amount),
      null => '',
    };
    _note.text = draft.note ?? '';
  }

  void _amountEdited(String text) =>
      _bloc.add(QuickAddReviewEvent.amountEdited(text));

  void _noteEdited(String text) =>
      _bloc.add(QuickAddReviewEvent.noteEdited(text));

  void _save() => _bloc.add(
    QuickAddReviewEvent.saveRequested(amount: _amount.text, note: _note.text),
  );

  void _skip() => _bloc.add(const QuickAddReviewEvent.skipRequested());

  void _back() => Navigator.pop(
    context,
    _bloc.state.savedCount > 0 ? QuickAddReviewExit.home : null,
  );

  void _onPopInvoked(bool didPop, Object? result) {
    if (!didPop) _back();
  }

  void _startOver() => Navigator.pop(context, QuickAddReviewExit.startOver);

  void _home() => Navigator.pop(context, QuickAddReviewExit.home);

  void _openCategory() {
    final bloc = _bloc;
    showMonAIBottomSheet<void>(
      context,
      title: context.l10n.transactionFormChooseCategory,
      builder: (sheetContext) => MonAICategoryPickerSheet(
        options: bloc.state.categories.map((c) => c.pickerOption).toList(),
        selectedId: bloc.state.current.categoryId,
        onPick: (id) => bloc.add(QuickAddReviewEvent.categoryPicked(id)),
        doneLabel: sheetContext.l10n.transactionFormDone,
        useLabel: sheetContext.l10n.transactionFormUseCategory,
        emptyLabel: sheetContext.l10n.transactionFormNoCategories,
      ),
    );
  }

  void _openWallet(QuickAddField field) {
    final bloc = _bloc;
    final l10n = context.l10n;
    final state = bloc.state;
    final isDestination = field == QuickAddField.toWallet;
    showMonAIBottomSheet<void>(
      context,
      title: switch ((state.current.type, isDestination)) {
        (.transfer, false) => l10n.transactionFormFrom,
        (.transfer, true) => l10n.transactionFormTo,
        (.income, _) => l10n.transactionFormReceiveTo,
        (.expense, _) => l10n.transactionFormPayFrom,
      },
      builder: (_) => MonAIRadioPickerSheet(
        options: state.wallets.map((w) => w.pickerOption(l10n)).toList(),
        selectedId: isDestination
            ? state.current.toWalletId
            : state.current.walletId,
        onPick: (id) => bloc.add(
          isDestination
              ? QuickAddReviewEvent.toWalletPicked(id)
              : QuickAddReviewEvent.walletPicked(id),
        ),
        doneLabel: l10n.transactionFormDone,
        note: state.wallets.isEmpty
            ? l10n.transactionFormNoWallets
            : l10n.transactionFormArchivedNote,
      ),
    );
  }

  void _openDate() {
    final bloc = _bloc;
    showMonAIBottomSheet<void>(
      context,
      builder: (_) => MonAIDatePickerSheet(
        selected: bloc.state.current.date,
        today: bloc.state.today,
        onPick: (date) => bloc.add(QuickAddReviewEvent.datePicked(date)),
        labels: quickAddDatePickerLabels(
          context.l10n,
          today: bloc.state.today,
          locale: context.localeName,
        ),
      ),
    );
  }

  void _showFailure(BuildContext context, QuickAddReviewState state) {
    if (state.actionFailure case final failure?) {
      showMonAISnackBar(context, message: failure.message(context.l10n));
    }
  }

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    final c = context.colors;
    return MultiBlocListener(
      listeners: [
        BlocListener<QuickAddReviewBloc, QuickAddReviewState>(
          listenWhen: (previous, current) => previous.index != current.index,
          listener: _fill,
        ),
        BlocListener<QuickAddReviewBloc, QuickAddReviewState>(
          listenWhen: (previous, current) =>
              current.actionFailure != null &&
              previous.actionFailure != current.actionFailure,
          listener: _showFailure,
        ),
      ],
      child: PopScope(
        canPop: false,
        onPopInvokedWithResult: _onPopInvoked,
        child: Scaffold(
          backgroundColor: c.surface,
          appBar: MonAITopBar(
            title: l10n.quickAddReviewTitle,
            navigationTooltip: l10n.quickAddReviewBack,
            onNavigationPressed: _back,
            actions: const [_Counter()],
          ),
          body: SafeArea(
            top: false,
            child: Padding(
              padding: const .fromLTRB(
                MonAISpacing.screenHorizontal,
                MonAISpacing.x2,
                MonAISpacing.screenHorizontal,
                MonAISpacing.x4,
              ),
              child: Column(
                crossAxisAlignment: .stretch,
                spacing: MonAISpacing.x4,
                children: [
                  const _Progress(),
                  const _Phrase(),
                  Expanded(
                    child: SingleChildScrollView(
                      child:
                          BlocSelector<
                            QuickAddReviewBloc,
                            QuickAddReviewState,
                            (bool, bool)
                          >(
                            selector: (state) => (
                              state.isDone,
                              state.current.type == TransactionType.transfer,
                            ),
                            builder: (context, selected) => switch (selected) {
                              (true, _) => const QuickAddReviewSummary(),
                              (false, final isTransfer) => _Draft(
                                amount: _amount,
                                note: _note,
                                isTransfer: isTransfer,
                                onAmountChanged: _amountEdited,
                                onNoteChanged: _noteEdited,
                                onCategory: _openCategory,
                                onWallet: _openWallet,
                                onDate: _openDate,
                              ),
                            },
                          ),
                    ),
                  ),
                  _Actions(
                    onSkip: _skip,
                    onSave: _save,
                    onStartOver: _startOver,
                    onHome: _home,
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class _Counter extends StatelessWidget {
  const _Counter();

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    return Padding(
      padding: const .only(right: MonAISpacing.x4),
      child: Center(
        child: BlocSelector<QuickAddReviewBloc, QuickAddReviewState, String>(
          selector: (state) => state.isDone
              ? l10n.quickAddReviewDone
              : l10n.quickAddReviewCounter(
                  state.index + 1,
                  state.drafts.length,
                ),
          builder: (context, text) => Text(
            text,
            style: context.textTheme.labelLarge?.copyWith(
              color: context.colors.textSecondary,
            ),
          ),
        ),
      ),
    );
  }
}

class _Progress extends StatelessWidget {
  const _Progress();

  static const _height = 4.0;

  @override
  Widget build(BuildContext context) {
    final c = context.colors;
    return ExcludeSemantics(
      child: BlocSelector<QuickAddReviewBloc, QuickAddReviewState, (int, int)>(
        selector: (state) => (state.index, state.drafts.length),
        builder: (context, selected) {
          final (index, count) = selected;
          return Row(
            spacing: MonAISpacing.x1_5,
            children: List.generate(
              count,
              (i) => Expanded(
                child: Container(
                  height: _height,
                  decoration: BoxDecoration(
                    color: switch (i) {
                      _ when i < index => c.accent,
                      _ when i == index => c.primaryContainerBorder,
                      _ => c.border,
                    },
                    borderRadius: MonAIRadius.xsAll,
                  ),
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}

class _Phrase extends StatelessWidget {
  const _Phrase();

  @override
  Widget build(BuildContext context) {
    final c = context.colors;
    final phrase = context.select<QuickAddReviewBloc, String>(
      (bloc) => bloc.state.args.phrase,
    );
    return DecoratedBox(
      decoration: BoxDecoration(
        color: c.surfaceSunken,
        borderRadius: MonAIRadius.mdAll,
      ),
      child: Padding(
        padding: const .symmetric(
          horizontal: MonAISpacing.x3,
          vertical: MonAISpacing.x2_5,
        ),
        child: Row(
          spacing: MonAISpacing.x2,
          children: [
            MonAIIcon(
              MonAIIcons.autoAwesome,
              size: MonAISizes.iconMd,
              color: c.accent,
            ),
            Expanded(
              child: Text(
                context.l10n.quickAddReviewFrom(phrase),
                style: context.textTheme.bodySmall?.copyWith(
                  color: c.textSecondary,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _Draft extends StatelessWidget {
  const _Draft({
    required this.amount,
    required this.note,
    required this.isTransfer,
    required this.onAmountChanged,
    required this.onNoteChanged,
    required this.onCategory,
    required this.onWallet,
    required this.onDate,
  });

  final TextEditingController amount;
  final TextEditingController note;
  final bool isTransfer;
  final ValueChanged<String> onAmountChanged;
  final ValueChanged<String> onNoteChanged;
  final VoidCallback onCategory;
  final ValueChanged<QuickAddField> onWallet;
  final VoidCallback onDate;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: .stretch,
      spacing: MonAISpacing.x3,
      children: [
        QuickAddReviewHero(controller: amount, onChanged: onAmountChanged),
        if (!isTransfer) QuickAddReviewCategory(onTap: onCategory),
        QuickAddReviewWallet(
          field: QuickAddField.wallet,
          onTap: () => onWallet(QuickAddField.wallet),
        ),
        if (isTransfer)
          QuickAddReviewWallet(
            field: QuickAddField.toWallet,
            onTap: () => onWallet(QuickAddField.toWallet),
          ),
        QuickAddReviewDate(onTap: onDate),
        QuickAddReviewNote(controller: note, onChanged: onNoteChanged),
      ],
    );
  }
}

class _Actions extends StatelessWidget {
  const _Actions({
    required this.onSkip,
    required this.onSave,
    required this.onStartOver,
    required this.onHome,
  });

  final VoidCallback onSkip;
  final VoidCallback onSave;
  final VoidCallback onStartOver;
  final VoidCallback onHome;

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    return BlocSelector<
      QuickAddReviewBloc,
      QuickAddReviewState,
      (bool, bool, bool)
    >(
      selector: (state) => (state.isDone, state.isLast, state.isSaving),
      builder: (context, selected) {
        final (isDone, isLast, isSaving) = selected;
        return Row(
          spacing: MonAISpacing.x3,
          children: [
            Expanded(
              child: MonAIButton(
                label: isDone
                    ? l10n.quickAddReviewStartOver
                    : l10n.quickAddReviewSkip,
                variant: .outlined,
                expand: true,
                onPressed: isDone ? onStartOver : (isSaving ? null : onSkip),
              ),
            ),
            Expanded(
              flex: 2,
              child: MonAIButton(
                label: switch ((isDone, isLast)) {
                  (true, _) => l10n.quickAddReviewHome,
                  (false, true) => l10n.quickAddReviewSave,
                  (false, false) => l10n.quickAddReviewSaveNext,
                },
                leadingIcon: isDone ? null : MonAIIcons.check,
                loading: isSaving,
                expand: true,
                onPressed: isDone ? onHome : onSave,
              ),
            ),
          ],
        );
      },
    );
  }
}
