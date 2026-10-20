import 'package:flutter_test/flutter_test.dart';
import 'package:monai/core/model/transaction_type.dart';
import 'package:monai/features/home/domain/entity/home_dashboard.dart';
import 'package:monai/features/home/domain/logic/home_dashboard_rules.dart';

import '../../../../helpers/entity_fixtures.dart';

void main() {
  group('greetingFor', () {
    final cases = {
      4: HomeGreeting.evening,
      5: HomeGreeting.morning,
      11: HomeGreeting.morning,
      12: HomeGreeting.afternoon,
      17: HomeGreeting.afternoon,
      18: HomeGreeting.evening,
    };
    for (final MapEntry(key: hour, value: expected) in cases.entries) {
      test('says ${expected.name} at $hour:00', () {
        // Arrange
        final now = DateTime(2026, 10, 20, hour);

        // Act
        final result = greetingFor(now);

        // Assert
        expect(result, expected);
      });
    }
  });

  group('daysLeftInMonth', () {
    test('counts the days after today', () {
      // Arrange
      final today = DateTime(2026, 10, 10);

      // Act
      final result = daysLeftInMonth(today);

      // Assert
      expect(result, 21);
    });

    test('is 0 on the last day', () {
      // Arrange
      final today = DateTime(2028, 2, 29);

      // Act
      final result = daysLeftInMonth(today);

      // Assert
      expect(result, 0);
    });
  });

  test(
    'totals and lists only wallets that are not archived, default first',
    () {
      // Arrange
      final wallets = [
        wallet(id: 'a', currentBalance: 100),
        wallet(id: 'b', currentBalance: 50, isArchived: true),
        wallet(id: 'c', currentBalance: 25, isDefault: true),
      ];

      // Act
      final total = totalBalance(wallets);
      final visible = visibleWallets(wallets);

      // Assert
      expect(total, 125);
      expect(visible.map((w) => w.id), ['c', 'a']);
    },
  );

  group('toSpendingSlices', () {
    test('keeps up to five categories and leaves out empty ones', () {
      // Arrange
      final categories = [
        categoryBreakdown(id: 'a', amount: 300),
        categoryBreakdown(id: 'b', amount: 0, sharePercent: 0),
      ];

      // Act
      final result = toSpendingSlices(categories);

      // Assert
      expect(result.map((s) => s.categoryId), ['a']);
    });

    test('folds the rest into Others past five', () {
      // Arrange
      final categories = [
        for (var i = 0; i < 7; i++)
          categoryBreakdown(id: 'c$i', amount: 100, sharePercent: 10),
      ];

      // Act
      final result = toSpendingSlices(categories);

      // Assert
      expect(result, hasLength(kMaxSpendingSlices));
      expect(result.last.isOthers, isTrue);
      expect(result.last.amount, 300);
      expect(result.last.sharePercent, 30);
    });
  });

  group('toRecent', () {
    final now = DateTime(2026, 10, 20, 15);
    final categoriesById = {'c1': category()};
    final walletsById = {
      'w1': wallet(id: 'w1', name: 'BCA'),
      'w2': wallet(id: 'w2', name: 'GoPay'),
    };

    RecentTransaction recentOf(
      String? note,
      String? merchant,
      String? categoryId, {
      DateTime? date,
    }) => toRecent(
      transaction(
        note: note,
        merchant: merchant,
        categoryId: categoryId,
        date: date ?? DateTime(2026, 10, 20),
      ),
      categoriesById: categoriesById,
      walletsById: walletsById,
      now: now,
    );

    test('titles it by the note, then the merchant, then the category', () {
      // Arrange
      final withNote = recentOf('Lunch', 'Warung', 'c1');
      final withMerchant = recentOf(' ', 'Warung', 'c1');
      final withCategory = recentOf(null, null, 'c1');

      // Act
      final untitled = recentOf(null, null, null);

      // Assert
      expect(withNote.title, 'Lunch');
      expect(withMerchant.title, 'Warung');
      expect(withCategory.title, 'Food');
      expect(untitled.title, isNull);
    });

    test('dates it today, yesterday or earlier', () {
      // Arrange
      final today = recentOf(null, null, 'c1');
      final yesterday = recentOf(
        null,
        null,
        'c1',
        date: DateTime(2026, 10, 19),
      );

      // Act
      final earlier = recentOf(null, null, 'c1', date: DateTime(2026, 10, 3));

      // Assert
      expect(today.day, isA<RecentToday>());
      expect(yesterday.day, const RecentDay.yesterday());
      expect(earlier.day, RecentDay.earlier(DateTime(2026, 10, 3)));
    });

    test('names both wallets of a transfer', () {
      // Arrange
      final transfer = transaction(
        type: TransactionType.transfer,
        categoryId: null,
        toWalletId: 'w2',
      );

      // Act
      final result = toRecent(
        transfer,
        categoriesById: categoriesById,
        walletsById: walletsById,
        now: now,
      );

      // Assert
      expect(result.walletName, 'BCA');
      expect(result.toWalletName, 'GoPay');
      expect(result.categoryName, isNull);
    });
  });

  test('buildHomeDashboard has a cache once a user or wallet is cached', () {
    // Arrange
    final now = DateTime(2026, 10, 20, 9);

    // Act
    final empty = buildHomeDashboard(
      now: now,
      user: null,
      wallets: const [],
      categories: const [],
      recent: const [],
      budget: null,
      report: null,
    );
    final cached = buildHomeDashboard(
      now: now,
      user: user(name: 'Joshua Putra'),
      wallets: const [],
      categories: const [],
      recent: const [],
      budget: null,
      report: monthlyReport(),
    );

    // Assert
    expect(empty.hasCache, isFalse);
    expect(empty.month, DateTime(2026, 10));
    expect(cached.hasCache, isTrue);
    expect(cached.initials, 'JP');
    expect(cached.greeting, HomeGreeting.morning);
    expect(cached.summary?.expenseTotal, 250000);
  });
}
