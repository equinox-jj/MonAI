import 'package:flutter_test/flutter_test.dart';
import 'package:monai/core/model/wallet_type.dart';
import 'package:monai/features/quickadd/domain/parser/wallet_matcher.dart';

import '../../../../helpers/entity_fixtures.dart';

final _gopay = paymentProvider(
  id: 'gopay',
  aliases: ['gopay', 'gpay', 'go-pay'],
);
final _bca = paymentProvider(id: 'bca', name: 'BCA', type: WalletType.bank);
final _wallets = [
  wallet(
    id: 'w-gopay',
    name: 'GoPay',
    providerId: 'gopay',
    type: WalletType.eWallet,
  ),
  wallet(
    id: 'w-bca',
    name: 'BCA Tabungan',
    providerId: 'bca',
    type: WalletType.bank,
    isDefault: true,
  ),
  wallet(id: 'w-cash', name: 'Dompet'),
];

void main() {
  group('WalletMatcher', () {
    late WalletMatcher matcher;

    setUp(() => matcher = WalletMatcher(_wallets, [_gopay, _bca]));

    List<String> ids(String text) =>
        matcher.findAll(text).map((m) => m.walletId).toList();

    test('matches wallet names and provider aliases', () {
      // Act
      final alias = ids('makan pakai gpay');
      final name = ids('bayar via bca tabungan');
      final providerName = ids('bayar via bca');
      final cash = ids('parkir tunai');

      // Assert
      expect(alias, ['w-gopay']);
      expect(name, ['w-bca']);
      expect(providerName, ['w-bca']);
      expect(cash, ['w-cash']);
    });

    test(
      'the word before a wallet gives its role and is part of the match',
      () {
        // Arrange
        const text = 'topup gopay 100rb dari bca';

        // Act
        final matches = matcher.findAll(text);
        final into = matcher.findAll('pindah ke gopay').single;

        // Assert
        expect(matches.map((m) => m.role), [
          WalletRole.unspecified,
          WalletRole.source,
        ]);
        final span = matches[1].span;
        expect(text.substring(span.start, span.end), 'dari bca');
        expect(into.role, WalletRole.destination);
      },
    );

    test('an exact name is more certain than a shared alias', () {
      // Arrange
      final bothBca = WalletMatcher(
        [
          ..._wallets,
          wallet(
            id: 'w-bca2',
            name: 'BCA Bisnis',
            providerId: 'bca',
            type: WalletType.bank,
          ),
        ],
        [_bca],
      );

      // Act
      final exact = matcher.findAll('pakai gopay').single;
      final shared = bothBca.findAll('pakai bca').single;

      // Assert
      expect(exact.confidence, WalletMatcher.named);
      expect(shared.walletId, 'w-bca');
      expect(shared.confidence, lessThan(WalletMatcher.named));
    });

    test('does not match inside other words', () {
      // Act
      final matches = matcher.findAll('abcabc');

      // Assert
      expect(matches, isEmpty);
    });
  });
}
