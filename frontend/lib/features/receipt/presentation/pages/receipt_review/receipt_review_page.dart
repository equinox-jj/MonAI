import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:monai/core/ui/designsystem/designsystem.dart';
import 'package:monai/core/app/injector.dart';
import 'package:monai/core/ui/l10n/l10n.dart';
import 'package:monai/core/model/transaction_type.dart';
import 'package:monai/app_router.dart';
import 'package:monai/core/utils/money_format.dart';
import 'package:monai/core/utils/month_format.dart';
import 'package:monai/features/receipt/domain/entity/receipt_draft.dart';
import 'package:monai/features/receipt/presentation/model/receipt_review_args.dart';
import 'package:monai/features/receipt/presentation/pages/receipt_review/bloc/receipt_review_bloc.dart';
import 'package:monai/features/receipt/presentation/pages/receipt_review/model/receipt_review_text.dart';
import 'package:monai/features/receipt/presentation/pages/receipt_review/widgets/receipt_review_banner.dart';
import 'package:monai/features/receipt/presentation/pages/receipt_review/widgets/receipt_review_fields.dart';
import 'package:monai/features/receipt/presentation/pages/receipt_review/widgets/receipt_review_items.dart';
import 'package:monai/features/receipt/presentation/pages/receipt_review/widgets/receipt_review_photo.dart';

class ReceiptReviewPage extends StatelessWidget {
  const ReceiptReviewPage({required this.args, super.key});

  final ReceiptReviewArgs args;

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) =>
          sl<ReceiptReviewBloc>(param1: args)
            ..add(const ReceiptReviewEvent.started()),
      child: ReceiptReviewUI(args: args),
    );
  }
}

/// A scanned receipt's draft to check and save with its photo. One column
/// on phones; the photo beside the draft on tablet landscape.
class ReceiptReviewUI extends StatefulWidget {
  const ReceiptReviewUI({required this.args, super.key});

  final ReceiptReviewArgs args;

  @override
  State<ReceiptReviewUI> createState() => _ReceiptReviewUIState();
}

class _ReceiptReviewUIState extends State<ReceiptReviewUI> {
  late final _amount = TextEditingController(
    text: switch (widget.args.draft.amount) {
      final amount? => formatRupiahInput(amount),
      null => '',
    },
  );
  late final _merchant = TextEditingController(
    text: widget.args.draft.merchant ?? '',
  );
  late final _note = TextEditingController(text: widget.args.draft.note ?? '');

  @override
  void dispose() {
    _amount.dispose();
    _merchant.dispose();
    _note.dispose();
    super.dispose();
  }

  ReceiptReviewBloc get _bloc => context.read<ReceiptReviewBloc>();

  void _amountEdited(String text) =>
      _bloc.add(ReceiptReviewEvent.amountEdited(text));

  void _merchantEdited(String text) =>
      _bloc.add(ReceiptReviewEvent.merchantEdited(text));

  void _noteEdited(String text) =>
      _bloc.add(ReceiptReviewEvent.noteEdited(text));

  void _save() => _bloc.add(
    ReceiptReviewEvent.saveRequested(
      amount: _amount.text,
      merchant: _merchant.text,
      note: _note.text,
    ),
  );

  void _retryParse() => _bloc.add(const ReceiptReviewEvent.retryRequested());

  /// A new draft from "Try again" fills the text fields too.
  void _refillFields(BuildContext context, ReceiptReviewState state) {
    final draft = state.draft;
    _amount.text = switch (draft.amount) {
      final amount? => formatRupiahInput(amount),
      null => '',
    };
    _merchant.text = draft.merchant ?? '';
    _note.text = draft.note ?? '';
  }

  void _showRetryFailure(BuildContext context, ReceiptReviewState state) {
    if (state.retryFailure case final failure?) {
      showMonAISnackBar(context, message: failure.retryFailed(context.l10n));
    }
  }

  /// Back to the scanner, which opens the camera again.
  void _retake() => context.pop();

  void _openCategoryPicker() {
    final bloc = _bloc;
    final l10n = context.l10n;
    showMonAIBottomSheet<void>(
      context,
      title: l10n.transactionFormChooseCategory,
      builder: (_) => MonAICategoryPickerSheet(
        options: bloc.state.categories.map((c) => c.pickerOption).toList(),
        selectedId: bloc.state.categoryId,
        onPick: (id) => bloc.add(ReceiptReviewEvent.categoryPicked(id)),
        doneLabel: l10n.transactionFormDone,
        useLabel: l10n.transactionFormUseCategory,
        emptyLabel: l10n.transactionFormNoCategories,
      ),
    );
  }

  void _openWalletPicker() {
    final bloc = _bloc;
    final l10n = context.l10n;
    final wallets = bloc.state.wallets;
    showMonAIBottomSheet<void>(
      context,
      title: bloc.state.type == TransactionType.income
          ? l10n.transactionFormReceiveTo
          : l10n.transactionFormPayFrom,
      builder: (_) => MonAIRadioPickerSheet(
        options: wallets.map((w) => w.pickerOption(l10n)).toList(),
        selectedId: bloc.state.walletId,
        onPick: (id) => bloc.add(ReceiptReviewEvent.walletPicked(id)),
        doneLabel: l10n.transactionFormDone,
        note: wallets.isEmpty
            ? l10n.transactionFormNoWallets
            : l10n.transactionFormArchivedNote,
      ),
    );
  }

  void _openDatePicker() {
    final bloc = _bloc;
    final today = bloc.state.today;
    showMonAIBottomSheet<void>(
      context,
      builder: (_) => MonAIDatePickerSheet(
        selected: bloc.state.date,
        today: today,
        onPick: (date) => bloc.add(ReceiptReviewEvent.datePicked(date)),
        labels: receiptDatePickerLabels(
          context.l10n,
          today: today,
          locale: context.localeName,
        ),
      ),
    );
  }

  void _openSaved(BuildContext context, ReceiptReviewState state) {
    if (state.savedId case final id?) {
      context.go(AppRoutes.transactionDetail(id));
    }
  }

  void _showActionFailure(BuildContext context, ReceiptReviewState state) {
    if (state.actionFailure case final failure?) {
      showMonAISnackBar(context, message: failure.message(context.l10n));
    }
  }

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    final wide = context.widthClass == .expanded;
    final form = _DraftForm(
      wide: wide,
      photoPath: widget.args.photoPath,
      onRetry: _retryParse,
      amount: _amount,
      merchant: _merchant,
      note: _note,
      onAmountChanged: _amountEdited,
      onMerchantChanged: _merchantEdited,
      onNoteChanged: _noteEdited,
      onCategoryTap: _openCategoryPicker,
      onWalletTap: _openWalletPicker,
      onDateTap: _openDatePicker,
    );
    return MultiBlocListener(
      listeners: [
        BlocListener<ReceiptReviewBloc, ReceiptReviewState>(
          listenWhen: (previous, current) =>
              current.savedId != null && previous.savedId == null,
          listener: _openSaved,
        ),
        BlocListener<ReceiptReviewBloc, ReceiptReviewState>(
          listenWhen: (previous, current) =>
              previous.draftVersion != current.draftVersion,
          listener: _refillFields,
        ),
        BlocListener<ReceiptReviewBloc, ReceiptReviewState>(
          listenWhen: (previous, current) =>
              current.retryFailure != null &&
              previous.retryFailure != current.retryFailure,
          listener: _showRetryFailure,
        ),
        BlocListener<ReceiptReviewBloc, ReceiptReviewState>(
          listenWhen: (previous, current) =>
              current.actionFailure != null &&
              previous.actionFailure != current.actionFailure,
          listener: _showActionFailure,
        ),
      ],
      child: Scaffold(
        backgroundColor: context.colors.surface,
        appBar: MonAITopBar(
          title: l10n.receiptReviewTitle,
          navigation: wide ? .close : .back,
          navigationTooltip: l10n.receiptReviewBack,
          onNavigationPressed: _retake,
          actions: [
            if (wide) ...[
              MonAIButton(
                label: l10n.receiptReviewRetake,
                leadingIcon: MonAIIcons.photoCamera,
                onPressed: _retake,
                variant: .outlined,
                size: .small,
              ),
              const SizedBox(width: MonAISpacing.x2),
              _SaveButton(onSave: _save, size: .small),
              const SizedBox(width: MonAISpacing.x4),
            ] else
              MonAIButton(
                label: l10n.receiptReviewRetake,
                onPressed: _retake,
                variant: .text,
                size: .small,
              ),
          ],
        ),
        body: wide
            ? Row(
                crossAxisAlignment: .stretch,
                children: [
                  Expanded(
                    flex: 5,
                    child: ReceiptReviewPhoto(photoPath: widget.args.photoPath),
                  ),
                  Expanded(
                    flex: 7,
                    child: SingleChildScrollView(
                      padding: const .symmetric(
                        horizontal: MonAISpacing.x10,
                        vertical: MonAISpacing.x6,
                      ),
                      child: form,
                    ),
                  ),
                ],
              )
            : SafeArea(
                top: false,
                child: Column(
                  children: [
                    Expanded(
                      child: SingleChildScrollView(
                        padding: const .fromLTRB(
                          MonAISpacing.screenHorizontal,
                          MonAISpacing.x1,
                          MonAISpacing.screenHorizontal,
                          MonAISpacing.x4,
                        ),
                        child: form,
                      ),
                    ),
                    Padding(
                      padding: const .fromLTRB(
                        MonAISpacing.screenHorizontal,
                        MonAISpacing.x2,
                        MonAISpacing.screenHorizontal,
                        MonAISpacing.x4,
                      ),
                      child: _SaveButton(onSave: _save),
                    ),
                  ],
                ),
              ),
      ),
    );
  }
}

/// The draft's fields; [wide] pairs them up beside the photo.
class _DraftForm extends StatelessWidget {
  const _DraftForm({
    required this.wide,
    required this.photoPath,
    required this.onRetry,
    required this.amount,
    required this.merchant,
    required this.note,
    required this.onAmountChanged,
    required this.onMerchantChanged,
    required this.onNoteChanged,
    required this.onCategoryTap,
    required this.onWalletTap,
    required this.onDateTap,
  });

  final bool wide;
  final String photoPath;
  final VoidCallback onRetry;
  final TextEditingController amount;
  final TextEditingController merchant;
  final TextEditingController note;
  final ValueChanged<String> onAmountChanged;
  final ValueChanged<String> onMerchantChanged;
  final ValueChanged<String> onNoteChanged;
  final VoidCallback onCategoryTap;
  final VoidCallback onWalletTap;
  final VoidCallback onDateTap;

  @override
  Widget build(BuildContext context) {
    final merchantField = ReceiptReviewMerchant(
      controller: merchant,
      onChanged: onMerchantChanged,
    );
    final category = ReceiptReviewCategory(onTap: onCategoryTap);
    final wallet = ReceiptReviewWallet(onTap: onWalletTap);
    final date = ReceiptReviewDate(onTap: onDateTap);
    return Column(
      crossAxisAlignment: .stretch,
      spacing: MonAISpacing.x3_5,
      children: [
        ReceiptReviewBanner(
          onRetry: onRetry,
          photoPath: wide ? null : photoPath,
        ),
        const ReceiptReviewTypeTabs(),
        ReceiptReviewAmount(controller: amount, onChanged: onAmountChanged),
        if (wide) ...[
          _Pair(start: merchantField, end: category),
          _Pair(start: wallet, end: date),
        ] else ...[
          merchantField,
          _Pair(start: category, end: wallet),
          date,
        ],
        BlocSelector<
          ReceiptReviewBloc,
          ReceiptReviewState,
          (List<ReceiptItem>, int)
        >(
          selector: (state) => (state.items, state.itemsTotal),
          builder: (context, items) => items.$1.isEmpty
              ? const SizedBox.shrink()
              : ReceiptReviewItems(items: items.$1, total: items.$2),
        ),
        ReceiptReviewNote(controller: note, onChanged: onNoteChanged),
      ],
    );
  }
}

class _Pair extends StatelessWidget {
  const _Pair({required this.start, required this.end});

  final Widget start;
  final Widget end;

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: .start,
      spacing: MonAISpacing.x2,
      children: [
        Expanded(child: start),
        Expanded(child: end),
      ],
    );
  }
}

/// "Save expense" or "Save income", spinning while it saves.
class _SaveButton extends StatelessWidget {
  const _SaveButton({required this.onSave, this.size = MonAIButtonSize.large});

  final VoidCallback onSave;
  final MonAIButtonSize size;

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    return BlocSelector<
      ReceiptReviewBloc,
      ReceiptReviewState,
      (TransactionType, bool)
    >(
      selector: (state) => (state.type, state.isSaving),
      builder: (context, selected) {
        final (type, isSaving) = selected;
        return MonAIButton(
          label: type == .income
              ? l10n.transactionFormSaveIncome
              : l10n.transactionFormSaveExpense,
          leadingIcon: MonAIIcons.check,
          onPressed: onSave,
          loading: isSaving,
          size: size,
          expand: size == .large,
        );
      },
    );
  }
}
