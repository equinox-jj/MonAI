import 'package:flutter_test/flutter_test.dart';
import 'package:monai/core/model/transaction_source.dart';
import 'package:monai/core/model/transaction_type.dart';
import 'package:monai/features/export/domain/csv/transaction_csv_writer.dart';
import 'package:monai/features/export/domain/entity/csv_export.dart';

import '../../../../helpers/entity_fixtures.dart';

const _header =
    'Date,Type,Amount,Wallet,To wallet,Category,Merchant,Note,Source';

void main() {
  group('TransactionCsvWriter', () {
    test('starts with a BOM and a header, with CRLF line ends', () {
      // Act
      final csv = TransactionCsvWriter.write(
        const [],
        walletNames: const {},
        categoryNames: const {},
      );

      // Assert
      expect(csv, '﻿$_header\r\n');
    });

    test('writes a row per transaction, oldest first, with names', () {
      // Arrange
      final newer = transaction(
        id: 't2',
        amount: 5000,
        date: DateTime(2026, 10, 9),
        note: 'Parkir',
      );
      final older = transaction(
        id: 't1',
        amount: 35000,
        date: DateTime(2026, 10, 1),
        merchant: 'Warteg',
        source: TransactionSource.quickAdd,
      );

      // Act
      final csv = TransactionCsvWriter.write(
        [newer, older],
        walletNames: const {'w1': 'Cash'},
        categoryNames: const {'c1': 'Food'},
      );

      // Assert
      expect(csv.split('\r\n'), [
        '﻿$_header',
        '2026-10-01,EXPENSE,35000,Cash,,Food,Warteg,,QUICK_ADD',
        '2026-10-09,EXPENSE,5000,Cash,,Food,,Parkir,MANUAL',
        '',
      ]);
    });

    test('a transfer names both wallets and no category', () {
      // Arrange
      final transfer = transaction(
        type: TransactionType.transfer,
        amount: 100000,
        walletId: 'w1',
        toWalletId: 'w2',
        categoryId: null,
      );

      // Act
      final csv = TransactionCsvWriter.write(
        [transfer],
        walletNames: const {'w1': 'BCA', 'w2': 'GoPay'},
        categoryNames: const {},
      );

      // Assert
      expect(csv, contains('TRANSFER,100000,BCA,GoPay,,,,MANUAL'));
    });

    test('quotes cells with the delimiter, quotes or line breaks', () {
      // Arrange
      final quoted = transaction(note: 'Kopi, "susu"\ndan roti');

      // Act
      final csv = TransactionCsvWriter.write(
        [quoted],
        walletNames: const {},
        categoryNames: const {},
      );

      // Assert
      expect(csv, contains('"Kopi, ""susu""\ndan roti"'));
    });

    test('with semicolons, a comma needs no quotes', () {
      // Arrange
      final row = transaction(note: 'Kopi, susu');

      // Act
      final csv = TransactionCsvWriter.write(
        [row],
        walletNames: const {},
        categoryNames: const {},
        delimiter: CsvDelimiter.semicolon,
      );

      // Assert
      expect(csv, contains(';Kopi, susu;MANUAL'));
      expect(csv, contains('Date;Type;Amount'));
    });

    test('user text that would run as a formula is defused', () {
      // Arrange
      final formula = transaction(note: '=HYPERLINK("x")', merchant: '+62');

      // Act
      final csv = TransactionCsvWriter.write(
        [formula],
        walletNames: const {},
        categoryNames: const {},
      );

      // Assert
      expect(csv, contains(",'+62,\"'=HYPERLINK(\"\"x\"\")\","));
    });

    test('an unknown wallet or category is left blank', () {
      // Act
      final csv = TransactionCsvWriter.write(
        [transaction()],
        walletNames: const {},
        categoryNames: const {},
      );

      // Assert
      expect(csv, contains('EXPENSE,10000,,,,,,MANUAL'));
    });
  });
}
