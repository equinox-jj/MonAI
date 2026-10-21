import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:monai/core/ui/designsystem/designsystem.dart';
import 'package:monai/core/base/error/field_error.dart';
import 'package:monai/core/ui/l10n/l10n.dart';
import 'package:monai/core/model/transaction_type.dart';
import 'package:monai/core/utils/month_format.dart';
import 'package:monai/core/utils/rupiah_input_formatter.dart';
import 'package:monai/features/quickadd/domain/parser/quick_add_parser.dart';
import 'package:monai/features/quickadd/presentation/model/quick_add_field.dart';
import 'package:monai/features/quickadd/presentation/model/quick_add_field_error_text.dart';
import 'package:monai/features/quickadd/presentation/model/quick_add_text.dart';
import 'package:monai/features/quickadd/presentation/pages/quick_add_review/bloc/quick_add_review_bloc.dart';
import 'package:monai/features/shared/domain/entity/category.dart';

typedef _FieldLook = (MonAIFieldMark?, FieldError?);

_FieldLook _lookOf(QuickAddReviewState state, QuickAddField field) =>
    (state.markOf(field), state.errorOf(field));

class QuickAddReviewHero extends StatelessWidget {
  const QuickAddReviewHero({
    required this.controller,
    required this.onChanged,
    super.key,
  });

  static const _height = 64.0;
  static const _iconSize = 56.0;

  final TextEditingController controller;
  final ValueChanged<String> onChanged;

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    final c = context.colors;
    final t = context.textTheme;
    return BlocSelector<
      QuickAddReviewBloc,
      QuickAddReviewState,
      (_FieldLook, TransactionType, Category?)
    >(
      selector: (state) => (
        _lookOf(state, .amount),
        state.current.type,
        state.categoryOf(state.current.categoryId),
      ),
      builder: (context, selected) {
        final ((mark, error), type, category) = selected;
        final color = switch (type) {
          .expense => c.expense,
          .income => c.income,
          .transfer => c.textPrimary,
        };
        return Column(
          crossAxisAlignment: .stretch,
          spacing: MonAISpacing.x2,
          children: [
            Center(
              child: MonAICategoryIcon(
                icon: switch ((category, type)) {
                  (final category?, _) => categoryIcon(category.icon),
                  (null, .transfer) => MonAIIcons.swapHoriz,
                  (null, _) => MonAIIcons.category,
                },
                color: CategoryColors.parse(category?.color),
                size: _iconSize,
              ),
            ),
            Text(
              switch (type) {
                .expense => l10n.quickAddReviewExpense,
                .income => l10n.quickAddReviewIncome,
                .transfer => l10n.quickAddReviewTransfer,
              },
              textAlign: .center,
              style: t.bodySmall?.copyWith(color: c.textTertiary),
            ),
            MonAIMarkedField(
              label: l10n.quickAddReviewAmount,
              mark: mark,
              error: error?.text(l10n),
              checkCaption: l10n.transactionFormCheckField,
              aiLabel: l10n.quickAddReviewFilledByAi,
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
                decoration: MonAIMarkedField.bareDecoration(
                  hint: '0',
                  hintStyle: t.headlineMedium?.copyWith(color: c.textDisabled),
                ),
              ),
            ),
          ],
        );
      },
    );
  }
}

class QuickAddReviewCategory extends StatelessWidget {
  const QuickAddReviewCategory({required this.onTap, super.key});

  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    final c = context.colors;
    final t = context.textTheme;
    return BlocSelector<
      QuickAddReviewBloc,
      QuickAddReviewState,
      (_FieldLook, Category?)
    >(
      selector: (state) => (
        _lookOf(state, .category),
        state.categoryOf(state.current.categoryId),
      ),
      builder: (context, selected) {
        final ((mark, error), category) = selected;
        return MonAIMarkedField(
          label: l10n.transactionFormCategory,
          mark: mark,
          error: error?.text(l10n),
          checkCaption: l10n.transactionFormCheckField,
          aiLabel: l10n.quickAddReviewFilledByAi,
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
            category?.name ?? l10n.transactionFormChooseCategory,
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

class QuickAddReviewWallet extends StatelessWidget {
  const QuickAddReviewWallet({
    required this.field,
    required this.onTap,
    super.key,
  });

  final QuickAddField field;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    final c = context.colors;
    return BlocSelector<
      QuickAddReviewBloc,
      QuickAddReviewState,
      (_FieldLook, String?, TransactionType, bool)
    >(
      selector: (state) {
        final id = field == .toWallet
            ? state.current.toWalletId
            : state.current.walletId;
        final original = state.original;
        return (
          _lookOf(state, field),
          state.walletOf(id)?.name,
          state.current.type,
          // The default stood in for a wallet the phrase didn't name: it is
          // the default wallet, guessed (not read) and not changed since.
          field == .wallet &&
              state.markOf(.wallet) == .check &&
              original != null &&
              original.walletId != null &&
              original.confidence.wallet <= defaultWalletGuess &&
              state.walletOf(original.walletId)?.isDefault == true,
        );
      },
      builder: (context, selected) {
        final ((mark, error), name, type, defaultUsed) = selected;
        return MonAIMarkedField(
          label: switch ((type, field)) {
            (.transfer, .toWallet) => l10n.transactionFormTo,
            (.transfer, _) => l10n.transactionFormFrom,
            _ => l10n.transactionFormWallet,
          },
          mark: mark,
          error: error?.text(l10n),
          checkCaption: defaultUsed
              ? l10n.quickAddReviewDefaultWalletNote
              : l10n.transactionFormCheckField,
          aiLabel: l10n.quickAddReviewFilledByAi,
          onTap: onTap,
          leading: MonAIIcon(
            MonAIIcons.accountBalanceWallet,
            size: MonAISizes.iconLg,
            color: mark == .check ? c.warning : c.accent,
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

class QuickAddReviewDate extends StatelessWidget {
  const QuickAddReviewDate({required this.onTap, super.key});

  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    final c = context.colors;
    return BlocSelector<
      QuickAddReviewBloc,
      QuickAddReviewState,
      (_FieldLook, DateTime, DateTime)
    >(
      selector: (state) =>
          (_lookOf(state, .date), state.current.date, state.today),
      builder: (context, selected) {
        final ((mark, error), date, today) = selected;
        return MonAIMarkedField(
          label: l10n.transactionFormDate,
          mark: mark,
          error: error?.text(l10n),
          checkCaption: l10n.transactionFormCheckField,
          aiLabel: l10n.quickAddReviewFilledByAi,
          onTap: onTap,
          leading: MonAIIcon(
            MonAIIcons.calendarToday,
            size: MonAISizes.iconLg,
            color: mark == .check ? c.warning : c.accent,
          ),
          child: Text(
            quickAddDateText(date, today, l10n, context.localeName),
            maxLines: 1,
            overflow: .ellipsis,
            style: context.textTheme.labelLarge,
          ),
        );
      },
    );
  }
}

class QuickAddReviewNote extends StatelessWidget {
  const QuickAddReviewNote({
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
    return BlocSelector<QuickAddReviewBloc, QuickAddReviewState, String?>(
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
