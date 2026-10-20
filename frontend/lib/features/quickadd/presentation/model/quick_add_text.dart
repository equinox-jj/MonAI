import 'package:flutter/widgets.dart';
import 'package:intl/intl.dart';
import 'package:monai/core/designsystem/designsystem.dart';
import 'package:monai/core/l10n/l10n.dart';
import 'package:monai/core/model/transaction_type.dart';
import 'package:monai/core/utils/money_format.dart';
import 'package:monai/features/quickadd/domain/entity/quick_add_reading.dart';
import 'package:monai/features/quickadd/domain/parser/quick_add_parser.dart';
import 'package:monai/features/shared/domain/entity/category.dart';
import 'package:monai/features/shared/domain/entity/quick_add_draft.dart';

/// `Today`, `Yesterday`, else `Thu, 8 Oct`.
String quickAddDayText(
  DateTime day,
  DateTime today,
  AppLocalizations l10n,
  String locale,
) {
  if (day == today) return l10n.transactionFormToday;
  if (day == DateTime(today.year, today.month, today.day - 1)) {
    return l10n.transactionFormYesterday;
  }
  return DateFormat('EEE, d MMM', locale).format(day);
}

/// `Today, 10 Oct`, `Yesterday, 9 Oct`, else `Thu, 8 Oct 2026`.
String quickAddDateText(
  DateTime day,
  DateTime today,
  AppLocalizations l10n,
  String locale,
) {
  final short = DateFormat('d MMM', locale).format(day);
  if (day == today) return l10n.transactionFormTodayDate(short);
  if (day == DateTime(today.year, today.month, today.day - 1)) {
    return l10n.transactionFormYesterdayDate(short);
  }
  return DateFormat('EEE, d MMM y', locale).format(day);
}

/// The text of the review's [MonAIDatePickerSheet], up to [today].
MonAIDatePickerLabels quickAddDatePickerLabels(
  AppLocalizations l10n, {
  required DateTime today,
  required String locale,
}) => MonAIDatePickerLabels(
  title: l10n.transactionFormDateTitle,
  dateText: (date) => quickAddDateText(date, today, l10n, locale),
  today: l10n.transactionFormToday,
  yesterday: l10n.transactionFormYesterday,
  dayUnavailable: l10n.transactionFormDayUnavailable,
  futureNote: l10n.transactionFormFutureNote,
  cancel: l10n.transactionFormCancel,
  set: l10n.transactionFormSetDate,
);

/// A draft's amount as a signed rupiah: `−Rp 35.000`, `+Rp 8.000.000`, or
/// `Rp —` without one.
String quickAddAmountText(QuickAddDraft draft, AppLocalizations l10n) =>
    switch ((draft.amount, draft.type)) {
      (null, _) => l10n.quickAddNoAmount,
      (final amount?, .transfer) => formatRupiah(amount),
      (final amount?, final type) => formatRupiahSigned(
        amount,
        negative: type == .expense,
      ),
    };

/// One "understood" chip under the phrase.
@immutable
class QuickAddChip {
  const QuickAddChip({
    required this.icon,
    required this.text,
    required this.unsure,
  });

  final MonAIIconData icon;
  final String text;

  /// Shown amber: missing, guessed or unsure.
  final bool unsure;

  @override
  bool operator ==(Object other) =>
      other is QuickAddChip &&
      other.icon == icon &&
      other.text == text &&
      other.unsure == unsure;

  @override
  int get hashCode => Object.hash(icon, text, unsure);
}

/// Chips for every draft's amount and category, then the wallets and dates
/// they share, without repeats.
List<QuickAddChip> quickAddChips(
  List<QuickAddDraft> drafts,
  ParseContext context,
  AppLocalizations l10n,
  String locale,
) {
  final chips = [
    for (final d in drafts)
      QuickAddChip(
        icon: MonAIIcons.payments,
        text: d.amount == null
            ? l10n.quickAddChipAmount
            : formatRupiah(d.amount!),
        unsure: d.amount == null || d.isAmountUnsure,
      ),
    for (final d in drafts.where((d) => d.type != TransactionType.transfer))
      switch (_category(context, d.categoryId)) {
        final category? => QuickAddChip(
          icon: categoryIcon(category.icon),
          text: category.name,
          unsure: d.isCategoryUnsure,
        ),
        null => QuickAddChip(
          icon: MonAIIcons.help,
          text: l10n.quickAddChipCategory,
          unsure: true,
        ),
      },
    for (final d in drafts)
      // An unsure wallet shows as "Wallet?"; the engine note names the
      // default in use.
      if (d.walletId == null || d.isWalletUnsure)
        QuickAddChip(
          icon: MonAIIcons.help,
          text: l10n.quickAddChipWallet,
          unsure: true,
        )
      else
        QuickAddChip(
          icon: MonAIIcons.accountBalanceWallet,
          text: _walletName(context, d.walletId) ?? '–',
          unsure: false,
        ),
    for (final d in drafts)
      QuickAddChip(
        icon: MonAIIcons.calendarToday,
        text: quickAddDayText(d.date, context.today, l10n, locale),
        unsure: d.isDateUnsure,
      ),
  ];
  return chips.toSet().toList();
}

/// One draft in the list under the phrase.
@immutable
class QuickAddDraftRow {
  const QuickAddDraftRow({
    required this.type,
    required this.title,
    required this.meta,
    required this.amount,
    required this.missingAmount,
    this.category,
  });

  final TransactionType type;
  final String title;

  /// `Food · GoPay · Today`.
  final String meta;
  final String amount;
  final bool missingAmount;

  /// Drawn as the row's icon; null for a transfer or no category.
  final Category? category;

  @override
  bool operator ==(Object other) =>
      other is QuickAddDraftRow &&
      other.type == type &&
      other.title == title &&
      other.meta == meta &&
      other.amount == amount &&
      other.missingAmount == missingAmount &&
      other.category == category;

  @override
  int get hashCode =>
      Object.hash(type, title, meta, amount, missingAmount, category);
}

List<QuickAddDraftRow> quickAddRows(
  List<QuickAddDraft> drafts,
  ParseContext context,
  AppLocalizations l10n,
  String locale,
) => [for (final d in drafts) _row(d, context, l10n, locale)];

QuickAddDraftRow _row(
  QuickAddDraft draft,
  ParseContext context,
  AppLocalizations l10n,
  String locale,
) {
  final category = _category(context, draft.categoryId);
  final walletName = _walletName(context, draft.walletId) ?? '–';
  final isDefault =
      draft.isWalletUnsure && draft.walletId == context.defaultWalletId;
  final wallet = switch (draft.type) {
    .transfer =>
      '$walletName → ${_walletName(context, draft.toWalletId) ?? '–'}',
    _ when isDefault => l10n.quickAddDefaultWallet(walletName),
    _ => walletName,
  };
  final day = quickAddDayText(draft.date, context.today, l10n, locale);
  return QuickAddDraftRow(
    type: draft.type,
    title:
        draft.note ??
        category?.name ??
        switch (draft.type) {
          .expense => l10n.quickAddReviewExpense,
          .income => l10n.quickAddReviewIncome,
          .transfer => l10n.quickAddReviewTransfer,
        },
    meta: [?category?.name, wallet, day].join(' · '),
    amount: quickAddAmountText(draft, l10n),
    missingAmount: draft.amount == null,
    category: category,
  );
}

/// Who read the phrase, or which guess the user should know about.
enum QuickAddEngineNoteKind { onPhone, defaultWallet, willAskAi, askedAi }

@immutable
class QuickAddEngineNote {
  const QuickAddEngineNote(this.kind, [this.walletName]);

  final QuickAddEngineNoteKind kind;

  /// The default wallet in use, for [QuickAddEngineNoteKind.defaultWallet].
  final String? walletName;

  String text(AppLocalizations l10n) => switch (kind) {
    .onPhone => l10n.quickAddEnginePhone,
    .defaultWallet => l10n.quickAddEngineDefaultWallet(walletName ?? ''),
    .willAskAi => l10n.quickAddEngineWillAsk,
    .askedAi => l10n.quickAddEngineAsked,
  };

  MonAIIconData get icon => switch (kind) {
    .onPhone => MonAIIcons.offlineBolt,
    .defaultWallet => MonAIIcons.info,
    .willAskAi || .askedAi => MonAIIcons.autoAwesome,
  };

  @override
  bool operator ==(Object other) =>
      other is QuickAddEngineNote &&
      other.kind == kind &&
      other.walletName == walletName;

  @override
  int get hashCode => Object.hash(kind, walletName);
}

/// Null with no drafts, or when the AI couldn't help (the fallback banner
/// says so instead).
QuickAddEngineNote? quickAddEngineNote(
  List<QuickAddDraft> drafts,
  DraftEngine engine,
  ParseContext context,
) {
  if (drafts.isEmpty) return null;
  return switch (engine) {
    .fallback => null,
    .ai => const QuickAddEngineNote(.askedAi),
    .local when needsAi(drafts) => const QuickAddEngineNote(.willAskAi),
    .local => switch (drafts.where((d) => d.isWalletUnsure).firstOrNull) {
      final unsure? => QuickAddEngineNote(
        .defaultWallet,
        _walletName(context, unsure.walletId),
      ),
      null => const QuickAddEngineNote(.onPhone),
    },
  };
}

/// The fallback banner's title for [failure].
String quickAddFallbackTitle(
  QuickAddAiFailure? failure,
  AppLocalizations l10n,
) => switch (failure) {
  QuickAddAiFailure.offline => l10n.quickAddFallbackOfflineTitle,
  QuickAddAiFailure.rateLimited => l10n.quickAddFallbackRateLimitedTitle,
  QuickAddAiFailure.unavailable || null => l10n.quickAddFallbackTitle,
};

Category? _category(ParseContext context, String? id) =>
    context.categories.where((c) => c.id == id).firstOrNull;

String? _walletName(ParseContext context, String? id) =>
    context.wallets.where((w) => w.id == id).firstOrNull?.name;
