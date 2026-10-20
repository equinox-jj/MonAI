import 'package:monai/core/model/category_type.dart';
import 'package:monai/core/model/transaction_type.dart';
import 'package:monai/features/quickadd/domain/parser/amount_parser.dart';
import 'package:monai/features/quickadd/domain/parser/category_keywords.dart';
import 'package:monai/features/quickadd/domain/parser/date_parser.dart';
import 'package:monai/features/quickadd/domain/parser/phrase_splitter.dart';
import 'package:monai/features/quickadd/domain/parser/text_span.dart';
import 'package:monai/features/quickadd/domain/parser/type_hints.dart';
import 'package:monai/features/quickadd/domain/parser/wallet_matcher.dart';
import 'package:monai/features/shared/domain/entity/category.dart';
import 'package:monai/features/shared/domain/entity/draft_confidence.dart';
import 'package:monai/features/shared/domain/entity/payment_provider.dart';
import 'package:monai/features/shared/domain/entity/quick_add_draft.dart';
import 'package:monai/features/shared/domain/entity/wallet.dart';

/// What the parser matches against: the user's active wallets, visible
/// categories and the provider catalog.
class ParseContext {
  const ParseContext({
    required this.wallets,
    required this.categories,
    required this.providers,
    required this.today,
  });

  final List<Wallet> wallets;
  final List<Category> categories;
  final List<PaymentProvider> providers;

  /// Local midnight.
  final DateTime today;

  String? get defaultWalletId =>
      (wallets.where((w) => w.isDefault).firstOrNull ?? wallets.firstOrNull)
          ?.id;
}

class _Segment {
  _Segment(this.text, this.amounts, this.date, this.wallets, this.note);

  final String text;
  final List<AmountMatch> amounts;
  final DateMatch? date;
  final List<WalletMatch> wallets;
  final String? note;

  // "beli 2 kopi 50rb": the clearer amount wins; on a tie, the last one.
  AmountMatch? get amount => amounts.isEmpty
      ? null
      : amounts.reduce((a, b) => b.confidence >= a.confidence ? b : a);
}

/// Layer 1 of quick add: turns a phrase into drafts on the phone, without
/// calling the API. Every field it can't read is null with confidence 0;
/// guesses (the default wallet, "Other") are low.
abstract final class QuickAddParser {
  static const _defaultDate = 0.9;
  static const _fallbackCategory = 0.3;
  static const _notNeeded = 1.0;

  static final _spaces = RegExp(r'\s+');

  static List<QuickAddDraft> parse(String text, ParseContext context) {
    final phrase = text.toLowerCase().replaceAll(_spaces, ' ').trim();
    if (phrase.isEmpty) return const [];
    final matcher = WalletMatcher(context.wallets, context.providers);
    final segments = PhraseSplitter.split(
      phrase,
      (part) => _read(part, context, matcher).amounts,
    );
    final parts = [for (final s in segments) _read(s, context, matcher)];
    // A date or a single wallet said once ("... kmrn", "... pakai gopay")
    // applies to every part.
    final sharedDate = parts.map((p) => p.date).nonNulls.firstOrNull;
    final allWallets = [for (final p in parts) ...p.wallets];
    final sharedWallets = allWallets.length == 1 ? allWallets : <WalletMatch>[];
    return [
      for (final part in parts)
        _toDraft(
          part,
          date: part.date ?? sharedDate,
          wallets: part.wallets.isEmpty ? sharedWallets : part.wallets,
          context: context,
        ),
    ];
  }

  static _Segment _read(
    String text,
    ParseContext context,
    WalletMatcher matcher,
  ) {
    final date = DateParser.find(text, context.today);
    final wallets = matcher.findAll(text);
    final taken = [?date?.span, ...wallets.map((w) => w.span)];
    final amounts = AmountParser.findAll(text)
        .where((a) => !taken.any(a.span.overlaps))
        .toList();
    final note = _noteOf(text, [...taken, ...amounts.map((a) => a.span)]);
    return _Segment(text, amounts, date, wallets, note);
  }

  static QuickAddDraft _toDraft(
    _Segment part, {
    required DateMatch? date,
    required List<WalletMatch> wallets,
    required ParseContext context,
  }) {
    final (type, typeConfidence) = TypeHints.detect(part.text);
    final isTransfer = type == TransactionType.transfer;
    final destination = isTransfer
        ? wallets.where((w) => w.role == WalletRole.destination).firstOrNull ??
              wallets.where((w) => w.role == WalletRole.unspecified).firstOrNull
        : null;
    final source = wallets.where((w) => w != destination).firstOrNull;
    final defaultId = context.defaultWalletId;
    final walletId =
        source?.walletId ??
        (defaultId != destination?.walletId ? defaultId : null);
    final walletConfidence = switch (null) {
      _ when source != null => source.confidence,
      _ when walletId != null => defaultWalletGuess,
      _ => 0.0,
    };
    final category = isTransfer
        ? null
        : _categoryOf(part.text, type, context.categories);
    final amount = part.amount;
    return QuickAddDraft(
      type: type,
      amount: amount?.amount,
      walletId: walletId,
      toWalletId: destination?.walletId,
      categoryId: category?.categoryId,
      date: date?.date ?? context.today,
      note: part.note,
      confidence: DraftConfidence(
        type: typeConfidence,
        amount: amount?.confidence ?? 0,
        wallet: walletConfidence,
        category: isTransfer ? _notNeeded : category?.confidence ?? 0,
        date: date?.confidence ?? _defaultDate,
      ),
    );
  }

  static CategoryMatch? _categoryOf(
    String text,
    TransactionType type,
    List<Category> categories,
  ) {
    final categoryType = type == TransactionType.income
        ? CategoryType.income
        : CategoryType.expense;
    return CategoryKeywords.find(text, categories, categoryType) ??
        categories
            .where((c) => c.type == categoryType && c.isSystem)
            .map((c) => CategoryMatch(c.id, _fallbackCategory))
            .firstOrNull;
  }

  /// [text] without the parsed parts, tidied and capitalized:
  /// "makan siang 35rb pakai gopay" → "Makan siang".
  static String? _noteOf(String text, List<TextSpan> parsed) {
    final kept = StringBuffer();
    for (var i = 0; i < text.length; i++) {
      if (!parsed.any((s) => s.contains(i))) kept.write(text[i]);
    }
    final tidy = kept
        .toString()
        .replaceAll(_spaces, ' ')
        .replaceAll(RegExp(r'^[ ,.\-;+]+|[ ,.\-;+]+$'), '');
    if (tidy.isEmpty) return null;
    return tidy[0].toUpperCase() + tidy.substring(1);
  }
}

/// How sure a wallet is when the default stands in for one the phrase
/// didn't name.
const defaultWalletGuess = 0.5;

/// Whether the phone's drafts are too unsure to use without the AI: none at
/// all, or one without a sure amount or category. An unnamed wallet doesn't
/// count; the default one is used, highlighted.
bool needsAi(List<QuickAddDraft> drafts) =>
    drafts.isEmpty ||
    drafts.any(
      (d) =>
          d.confidence.amount < DraftConfidence.sure ||
          d.confidence.category < DraftConfidence.sure,
    );
