import 'package:flutter_test/flutter_test.dart';
import 'package:intl/date_symbol_data_local.dart';
import 'package:monai/core/ui/l10n/gen/app_localizations_en.dart';
import 'package:monai/core/model/transaction_type.dart';
import 'package:monai/features/transactions/domain/entity/transaction_lookups.dart';
import 'package:monai/features/transactions/presentation/model/transaction_text.dart';

import '../../../../helpers/entity_fixtures.dart';

void main() {
  final l10n = AppLocalizationsEn();
  final lookups = TransactionLookups.of(
    categories: [category()],
    wallets: [
      wallet(id: 'w1', name: 'BCA'),
      wallet(id: 'w2', name: 'GoPay'),
    ],
  );

  setUpAll(() => initializeDateFormatting());

  test('a title falls back from the note to the merchant to the category', () {
    // Arrange
    final noted = transaction(note: 'Makan siang', merchant: 'Warteg');
    final merchant = transaction(merchant: 'Warteg');
    final bare = transaction();
    final unknown = transaction(categoryId: 'gone');

    // Act
    final titles = [
      noted,
      merchant,
      bare,
      unknown,
    ].map((t) => t.titleText(l10n, lookups));

    // Assert
    expect(titles, ['Makan siang', 'Warteg', 'Food', 'Transaction']);
  });

  test('a transfer reads its wallets and no category', () {
    // Arrange
    final transfer = transaction(
      type: TransactionType.transfer,
      categoryId: null,
      toWalletId: 'w2',
      amount: 500000,
      createdAt: DateTime(2026, 10, 9, 19, 20),
    );

    // Act
    final meta = transfer.metaText(l10n, lookups);

    // Assert
    expect(meta, 'Transfer · BCA → GoPay · 19:20');
    expect(transfer.titleText(l10n, lookups), 'Transfer');
    expect(transfer.amountText, 'Rp 500.000');
  });

  test('day headers name today and yesterday', () {
    // Arrange
    final today = DateTime(2026, 10, 10, 15);

    // Act
    final headers = [
      DateTime(2026, 10, 10),
      DateTime(2026, 10, 9),
      DateTime(2026, 10, 8),
      DateTime(2025, 12, 31),
    ].map((day) => TransactionDates.dayHeader(day, today, l10n, 'en')).toList();

    // Assert
    expect(headers, [
      'Today · Sat, 10 Oct',
      'Yesterday · Fri, 9 Oct',
      'Thu, 8 Oct',
      'Wed, 31 Dec 2025',
    ]);
  });
}
