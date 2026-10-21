import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:monai/core/ui/designsystem/designsystem.dart';
import 'package:monai/core/base/error/field_error.dart';
import 'package:monai/core/ui/l10n/l10n.dart';
import 'package:monai/core/model/transaction_type.dart';
import 'package:monai/core/utils/month_format.dart';
import 'package:monai/core/utils/rupiah_input_formatter.dart';
import 'package:monai/features/receipt/presentation/model/receipt_field_error_text.dart';
import 'package:monai/features/receipt/presentation/pages/receipt_review/bloc/receipt_review_bloc.dart';
import 'package:monai/features/receipt/presentation/pages/receipt_review/model/receipt_field.dart';
import 'package:monai/features/receipt/presentation/pages/receipt_review/model/receipt_review_text.dart';
import 'package:monai/features/receipt/presentation/pages/receipt_review/widgets/receipt_review_field_box.dart';
import 'package:monai/features/shared/domain/entity/category.dart';

typedef _FieldLook = (FieldMark?, FieldError?);

_FieldLook _lookOf(ReceiptReviewState state, ReceiptField field) =>
    (state.markOf(field), state.errorOf(field));

class ReceiptReviewTypeTabs extends StatelessWidget {
  const ReceiptReviewTypeTabs({super.key});

  void _select(BuildContext context, TransactionType type) => context
      .read<ReceiptReviewBloc>()
      .add(ReceiptReviewEvent.typeSelected(type));

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    final c = context.colors;
    return BlocSelector<ReceiptReviewBloc, ReceiptReviewState, TransactionType>(
      selector: (state) => state.type,
      builder: (context, type) => MonAISegmentedControl<TransactionType>(
        selected: type,
        onChanged: (type) => _select(context, type),
        segments: [
          MonAISegment(
            value: .expense,
            label: l10n.transactionTypeExpense,
            selectedContainer: c.expenseContainer,
            selectedContent: c.expense,
          ),
          MonAISegment(
            value: .income,
            label: l10n.transactionTypeIncome,
            selectedContainer: c.incomeContainer,
            selectedContent: c.income,
          ),
        ],
      ),
    );
  }
}

class ReceiptReviewAmount extends StatelessWidget {
  const ReceiptReviewAmount({
    required this.controller,
    required this.onChanged,
    super.key,
  });

  static const _height = 64.0;

  final TextEditingController controller;
  final ValueChanged<String> onChanged;

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    final c = context.colors;
    final t = context.textTheme;
    return BlocSelector<
      ReceiptReviewBloc,
      ReceiptReviewState,
      (_FieldLook, TransactionType)
    >(
      selector: (state) => (_lookOf(state, .amount), state.type),
      builder: (context, selected) {
        final ((mark, error), type) = selected;
        final color = type == .income ? c.income : c.expense;
        return ReceiptReviewFieldBox(
          label: l10n.receiptReviewAmount,
          mark: mark,
          error: error?.text(l10n),
          height: _height,
          leading: Text(
            'Rp',
            style: t.titleLarge?.copyWith(color: c.textTertiary),
          ),
          child: TextField(
            controller: controller,
            onChanged: onChanged,
            keyboardType: TextInputType.number,
            textInputAction: TextInputAction.next,
            inputFormatters: const [RupiahInputFormatter()],
            style: t.headlineMedium?.copyWith(
              color: color,
              fontWeight: .w700,
              fontFeatures: const [FontFeature.tabularFigures()],
            ),
            decoration: receiptBareDecoration(
              hint: '0',
              hintStyle: t.headlineMedium?.copyWith(color: c.textDisabled),
            ),
          ),
        );
      },
    );
  }
}

class ReceiptReviewMerchant extends StatelessWidget {
  const ReceiptReviewMerchant({
    required this.controller,
    required this.onChanged,
    super.key,
  });

  static const _maxLength = 100;

  final TextEditingController controller;
  final ValueChanged<String> onChanged;

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    final c = context.colors;
    final t = context.textTheme;
    return BlocSelector<ReceiptReviewBloc, ReceiptReviewState, _FieldLook>(
      selector: (state) => _lookOf(state, .merchant),
      builder: (context, look) => ReceiptReviewFieldBox(
        label: l10n.receiptReviewMerchant,
        mark: look.$1,
        error: look.$2?.text(l10n),
        child: TextField(
          controller: controller,
          onChanged: onChanged,
          maxLength: _maxLength,
          maxLengthEnforcement: MaxLengthEnforcement.enforced,
          textCapitalization: TextCapitalization.words,
          textInputAction: TextInputAction.next,
          style: t.bodyLarge,
          decoration: receiptBareDecoration(
            hint: l10n.receiptReviewMerchantHint,
            hintStyle: t.bodyLarge?.copyWith(color: c.textTertiary),
          ),
        ),
      ),
    );
  }
}

class ReceiptReviewCategory extends StatelessWidget {
  const ReceiptReviewCategory({required this.onTap, super.key});

  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    final c = context.colors;
    final t = context.textTheme;
    return BlocSelector<
      ReceiptReviewBloc,
      ReceiptReviewState,
      (_FieldLook, Category?)
    >(
      selector: (state) => (_lookOf(state, .category), state.category),
      builder: (context, selected) {
        final ((mark, error), category) = selected;
        return ReceiptReviewFieldBox(
          label: l10n.transactionFormCategory,
          mark: mark,
          error: error?.text(l10n),
          onTap: onTap,
          leading: switch (category) {
            final category? => MonAICategoryIcon(
              icon: categoryIcon(category.icon),
              color: CategoryColors.parse(category.color),
              size: MonAISizes.avatarSmall - MonAISpacing.x1,
            ),
            null => null,
          },
          child: Text(
            category?.name ?? l10n.receiptReviewChooseCategory,
            maxLines: 1,
            overflow: .ellipsis,
            style: t.labelLarge?.copyWith(
              color: category == null ? c.textTertiary : c.textPrimary,
            ),
          ),
        );
      },
    );
  }
}

class ReceiptReviewWallet extends StatelessWidget {
  const ReceiptReviewWallet({required this.onTap, super.key});

  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    final c = context.colors;
    return BlocSelector<
      ReceiptReviewBloc,
      ReceiptReviewState,
      (_FieldLook, String?)
    >(
      selector: (state) => (_lookOf(state, .wallet), state.wallet?.name),
      builder: (context, selected) {
        final ((mark, error), name) = selected;
        return ReceiptReviewFieldBox(
          label: l10n.transactionFormWallet,
          mark: mark,
          error: error?.text(l10n),
          onTap: onTap,
          leading: MonAIIcon(
            MonAIIcons.accountBalanceWallet,
            size: MonAISizes.iconLg,
            color: c.accent,
          ),
          child: Text(
            name ?? '–',
            maxLines: 1,
            overflow: .ellipsis,
            style: context.textTheme.labelLarge,
          ),
        );
      },
    );
  }
}

class ReceiptReviewDate extends StatelessWidget {
  const ReceiptReviewDate({required this.onTap, super.key});

  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    final c = context.colors;
    return BlocSelector<
      ReceiptReviewBloc,
      ReceiptReviewState,
      (_FieldLook, DateTime, DateTime)
    >(
      selector: (state) => (_lookOf(state, .date), state.date, state.today),
      builder: (context, selected) {
        final ((mark, error), date, today) = selected;
        return ReceiptReviewFieldBox(
          label: l10n.transactionFormDate,
          mark: mark,
          error: error?.text(l10n),
          onTap: onTap,
          leading: MonAIIcon(
            MonAIIcons.calendarToday,
            size: MonAISizes.iconLg,
            color: mark == FieldMark.check ? c.warning : c.accent,
          ),
          child: Text(
            receiptDateText(date, today, l10n, context.localeName),
            maxLines: 1,
            overflow: .ellipsis,
            style: context.textTheme.labelLarge,
          ),
        );
      },
    );
  }
}

class ReceiptReviewNote extends StatelessWidget {
  const ReceiptReviewNote({
    required this.controller,
    required this.onChanged,
    super.key,
  });

  static const _maxLength = 200;

  final TextEditingController controller;
  final ValueChanged<String> onChanged;

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    return BlocSelector<ReceiptReviewBloc, ReceiptReviewState, String?>(
      selector: (state) => state.errorOf(.note)?.text(l10n),
      builder: (context, error) => MonAITextField(
        controller: controller,
        onChanged: onChanged,
        placeholder: l10n.transactionFormNoteHint,
        leadingIcon: MonAIIcons.editNote,
        compact: true,
        maxLength: _maxLength,
        supportingText: error,
        tone: error == null ? .neutral : .error,
        textInputAction: TextInputAction.done,
      ),
    );
  }
}
