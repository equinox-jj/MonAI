import 'package:flutter_test/flutter_test.dart';
import 'package:monai/core/model/category_type.dart';
import 'package:monai/core/model/transaction_type.dart';
import 'package:monai/core/model/wallet_type.dart';
import 'package:monai/features/quickadd/domain/parser/quick_add_parser.dart';
import 'package:monai/features/shared/domain/entity/draft_confidence.dart';
import 'package:monai/features/shared/domain/entity/quick_add_draft.dart';

import '../../../../helpers/entity_fixtures.dart';

final _today = DateTime(2026, 10, 10);
final _gopay = paymentProvider(id: 'gopay', aliases: ['gopay', 'gpay']);
final _context = ParseContext(
  wallets: [
    wallet(
      id: 'w-bca',
      name: 'BCA Tabungan',
      type: WalletType.bank,
      isDefault: true,
    ),
    wallet(
      id: 'w-gopay',
      name: 'GoPay',
      providerId: 'gopay',
      type: WalletType.eWallet,
    ),
    wallet(id: 'w-mandiri', name: 'Mandiri', type: WalletType.bank),
  ],
  categories: [
    category(id: 'food'),
    category(id: 'transport', name: 'Transport'),
    category(id: 'other', name: 'Other', isSystem: true),
    category(id: 'salary', name: 'Salary', type: CategoryType.income),
    category(
      id: 'other-income',
      name: 'Other Income',
      type: CategoryType.income,
      isSystem: true,
    ),
  ],
  providers: [_gopay],
  today: _today,
);

List<QuickAddDraft> _parse(String text) => QuickAddParser.parse(text, _context);

void main() {
  group('QuickAddParser', () {
    test('makan siang with gopay is a confident food expense today', () {
      // Act
      final draft = _parse('makan siang 35rb pakai gopay').single;

      // Assert
      expect(draft.type, TransactionType.expense);
      expect(draft.amount, 35000);
      expect(draft.categoryId, 'food');
      expect(draft.walletId, 'w-gopay');
      expect(draft.date, _today);
      expect(draft.note, 'Makan siang');
      expect(draft.isAmountUnsure, isFalse);
      expect(draft.isCategoryUnsure, isFalse);
      expect(draft.isWalletUnsure, isFalse);
      expect(needsAi([draft]), isFalse);
    });

    test('two amounts make two drafts sharing the date and default wallet', () {
      // Act
      final drafts = _parse('kopi 25rb sama parkir 5rb kmrn');

      // Assert
      expect(drafts.map((d) => d.amount), [25000, 5000]);
      expect(drafts.map((d) => d.categoryId), ['food', 'transport']);
      expect(drafts.map((d) => d.note), ['Kopi', 'Parkir']);
      expect(drafts.every((d) => d.date == DateTime(2026, 10, 9)), isTrue);
      expect(
        drafts.every((d) => d.walletId == 'w-bca' && d.isWalletUnsure),
        isTrue,
      );
    });

    test('amounts without a separator make one draft each', () {
      // Act
      final drafts = _parse('makan siang 35rb pakai gopay 15rb 20rb 40 rb');

      // Assert
      expect(drafts.map((d) => d.amount), [35000, 15000, 20000, 40000]);
      expect(drafts.first.note, 'Makan siang');
      expect(drafts.first.categoryId, 'food');
      expect(drafts.every((d) => d.walletId == 'w-gopay'), isTrue);
    });

    test('without an amount the draft has none and falls back to Other', () {
      // Act
      final draft = _parse('bayar arisan ke tante via mandiri').single;

      // Assert
      expect(draft.amount, isNull);
      expect(draft.confidence.amount, 0);
      expect(draft.categoryId, 'other');
      expect(draft.isCategoryUnsure, isTrue);
      expect(draft.walletId, 'w-mandiri');
      expect(draft.note, 'Bayar arisan ke tante');
      expect(needsAi([draft]), isTrue);
    });

    test('gajian is income', () {
      // Act
      final draft = _parse('gajian 8jt ke bca tabungan').single;

      // Assert
      expect(draft.type, TransactionType.income);
      expect(draft.amount, 8000000);
      expect(draft.categoryId, 'salary');
      expect(draft.walletId, 'w-bca');
    });

    test('topup moves money from the source into the named wallet', () {
      // Act
      final draft = _parse('topup gopay 100rb dari mandiri').single;

      // Assert
      expect(draft.type, TransactionType.transfer);
      expect(draft.walletId, 'w-mandiri');
      expect(draft.toWalletId, 'w-gopay');
      expect(draft.categoryId, isNull);
      expect(draft.isCategoryUnsure, isFalse);
    });

    test('a topup without a source uses the default wallet', () {
      // Act
      final draft = _parse('topup gopay 50rb').single;

      // Assert
      expect(draft.walletId, 'w-bca');
      expect(draft.toWalletId, 'w-gopay');
    });

    test('a day number is a date, not an amount', () {
      // Act
      final draft = _parse('listrik 300rb tgl 5').single;

      // Assert
      expect(draft.amount, 300000);
      expect(draft.date, DateTime(2026, 10, 5));
    });

    test('blank text has no drafts, which needs the AI', () {
      // Act
      final drafts = _parse('   ');

      // Assert
      expect(drafts, isEmpty);
      expect(needsAi(drafts), isTrue);
    });

    test('an amount below the sure threshold needs the AI', () {
      // Arrange
      final draft = QuickAddDraft(
        type: TransactionType.expense,
        date: _today,
        amount: 25,
        categoryId: 'food',
        confidence: const DraftConfidence(amount: 0.4, category: 0.85),
      );

      // Act
      final result = needsAi([draft]);

      // Assert
      expect(result, isTrue);
    });
  });
}
