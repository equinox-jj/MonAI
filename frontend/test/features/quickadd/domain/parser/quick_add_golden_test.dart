import 'dart:convert';
import 'dart:io';

import 'package:flutter_test/flutter_test.dart';
import 'package:monai/core/model/category_type.dart';
import 'package:monai/core/model/transaction_type.dart';
import 'package:monai/core/model/wallet_type.dart';
import 'package:monai/features/quickadd/domain/parser/quick_add_parser.dart';
import 'package:monai/features/shared/domain/entity/draft_confidence.dart';
import 'package:monai/features/shared/domain/entity/quick_add_draft.dart';

import '../../../../helpers/entity_fixtures.dart';

// The PRD's golden test set for layer 1, shared with the Android client:
// every phrase in `golden/quick_add_phrases.json` is parsed on the "phone"
// and scored per field. A phrase is handled locally when quick add would not
// call the AI for it and every field came out right; the PRD asks for 80% or
// more. "Sure but wrong" counts fields the parser got wrong without flagging
// them, which the user would not be asked to check.

const _handledTarget = 0.8;
const _sureButWrongLimit = 0.05;
const _fields = ['type', 'amount', 'wallet', 'category', 'date'];

const _walletTypes = {
  'CASH': WalletType.cash,
  'BANK': WalletType.bank,
  'E_WALLET': WalletType.eWallet,
  'OTHER': WalletType.other,
};

const _transactionTypes = {
  'EXPENSE': TransactionType.expense,
  'INCOME': TransactionType.income,
  'TRANSFER': TransactionType.transfer,
};

class _Check {
  const _Check(this.field, {required this.correct, required this.sure});

  final String field;
  final bool correct;
  final bool sure;
}

class _Result {
  const _Result(
    this.text,
    this.checks, {
    required this.countRight,
    required this.needsAi,
  });

  final String text;
  final List<_Check> checks;
  final bool countRight;
  final bool needsAi;

  bool get handledLocally =>
      countRight && !needsAi && checks.every((c) => c.correct);
}

/// Wallets and categories get their names as ids; each wallet with
/// aliases gets a provider.
ParseContext _contextOf(Map<String, dynamic> golden) {
  final wallets = (golden['wallets'] as List).cast<Map<String, dynamic>>();
  final providers = [
    for (final w in wallets)
      if ((w['aliases'] as List?)?.isNotEmpty ?? false)
        paymentProvider(
          id: (w['name'] as String).toLowerCase(),
          name: w['name'] as String,
          type: _walletTypes[w['type']]!,
          aliases: (w['aliases'] as List).cast<String>(),
        ),
  ];
  return ParseContext(
    wallets: [
      for (final w in wallets)
        wallet(
          id: w['name'] as String,
          name: w['name'] as String,
          type: _walletTypes[w['type']]!,
          isDefault: w['isDefault'] as bool? ?? false,
          providerId: providers
              .where((p) => p.name == w['name'])
              .firstOrNull
              ?.id,
        ),
    ],
    categories: [
      for (final c
          in (golden['categories'] as List).cast<Map<String, dynamic>>())
        category(
          id: c['name'] as String,
          name: c['name'] as String,
          type: c['type'] == 'INCOME'
              ? CategoryType.income
              : CategoryType.expense,
          isSystem: c['isSystem'] as bool? ?? false,
        ),
    ],
    providers: providers,
    today: DateTime.parse(golden['today'] as String),
  );
}

List<_Check> _checkFields(Map<String, dynamic> expected, QuickAddDraft actual) {
  const sure = DraftConfidence.sure;
  final confidence = actual.confidence;
  final type = _transactionTypes[expected['type']];
  final isTransfer = type == TransactionType.transfer;
  return [
    _Check('type', correct: actual.type == type, sure: confidence.type >= sure),
    _Check(
      'amount',
      correct: actual.amount == expected['amount'],
      sure: confidence.amount >= sure,
    ),
    // Ids are the wallet and category names.
    _Check(
      'wallet',
      correct: actual.walletId == expected['wallet'],
      sure: confidence.wallet >= sure,
    ),
    // Transfers score their destination wallet under "category".
    if (isTransfer)
      _Check(
        'category',
        correct: actual.toWalletId == expected['toWallet'],
        sure: confidence.wallet >= sure,
      )
    else
      _Check(
        'category',
        correct: actual.categoryId == expected['category'],
        sure: confidence.category >= sure,
      ),
    _Check(
      'date',
      correct: actual.date == DateTime.parse(expected['date'] as String),
      sure: confidence.date >= sure,
    ),
  ];
}

_Result _score(Map<String, dynamic> phrase, ParseContext context) {
  final text = phrase['text'] as String;
  final expected = (phrase['drafts'] as List).cast<Map<String, dynamic>>();
  final drafts = QuickAddParser.parse(text, context);
  final countRight = drafts.length == expected.length;
  final checks = countRight
      ? [
          for (var i = 0; i < drafts.length; i++)
            ..._checkFields(expected[i], drafts[i]),
        ]
      // A wrong number of drafts fails every expected field.
      : [
          for (final _ in expected)
            for (final field in _fields)
              _Check(field, correct: false, sure: false),
        ];
  return _Result(
    text,
    checks,
    countRight: countRight,
    needsAi: needsAi(drafts),
  );
}

String _report(List<_Result> results) {
  final buffer = StringBuffer()
    ..writeln('Quick-add golden set, layer 1 (${results.length} phrases)')
    ..writeln(
      '  handled locally: '
      '${results.where((r) => r.handledLocally).length}/${results.length}',
    );
  for (final result in results.where((r) => !r.handledLocally)) {
    final wrong = result.checks
        .where((c) => !c.correct)
        .map((c) => c.field + (c.sure ? ' (sure)' : ''))
        .join(', ');
    final why = !result.countRight
        ? 'wrong number of drafts'
        : wrong.isNotEmpty
        ? 'wrong: $wrong'
        : 'right, but unsure, so the AI is asked';
    buffer.writeln('  - "${result.text}": $why');
  }
  return buffer.toString();
}

void main() {
  test('layer 1 handles at least 80% of the golden phrases on its own', () {
    // Arrange
    final golden = jsonDecode(
      File(
        'test/features/quickadd/domain/parser/golden/'
        'quick_add_phrases.json',
      ).readAsStringSync(),
    ) as Map<String, dynamic>;
    final context = _contextOf(golden);
    final phrases = (golden['phrases'] as List).cast<Map<String, dynamic>>();

    // Act
    final results = [for (final p in phrases) _score(p, context)];

    // Assert
    final checks = [for (final r in results) ...r.checks];
    final handledRate =
        results.where((r) => r.handledLocally).length / results.length;
    final sureButWrongRate =
        checks.where((c) => !c.correct && c.sure).length / checks.length;
    printOnFailure(_report(results));
    expect(handledRate, greaterThanOrEqualTo(_handledTarget));
    expect(sureButWrongRate, lessThanOrEqualTo(_sureButWrongLimit));
  });
}
