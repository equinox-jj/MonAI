import 'package:monai/core/model/wallet_type.dart';
import 'package:monai/features/shared/domain/entity/wallet.dart';

/// One wallet type's part of the money across wallets; [percent] is whole.
typedef WalletTypeShare = ({WalletType type, int amount, int percent});

/// The money across [wallets] and how it splits by type, biggest share
/// first.
///
/// Only positive balances make up the shares, which add up to 100; a type
/// with nothing in it is left out.
({int total, List<WalletTypeShare> shares}) walletTotalsOf(
  List<Wallet> wallets,
) {
  final total = wallets.fold<int>(0, (sum, w) => sum + w.currentBalance);
  final byType = <WalletType, int>{};
  for (final wallet in wallets) {
    if (wallet.currentBalance <= 0) continue;
    byType.update(
      wallet.type,
      (amount) => amount + wallet.currentBalance,
      ifAbsent: () => wallet.currentBalance,
    );
  }
  final positive = byType.values.fold<int>(0, (sum, amount) => sum + amount);
  if (positive == 0) return (total: total, shares: const []);
  final types = byType.keys.toList()
    ..sort((a, b) => byType[b]!.compareTo(byType[a]!));
  return (total: total, shares: _percents(types, byType, positive));
}

/// Whole percents by largest remainder, so the shown shares add up to 100.
List<WalletTypeShare> _percents(
  List<WalletType> types,
  Map<WalletType, int> amounts,
  int whole,
) {
  final floors = {
    for (final type in types) type: amounts[type]! * 100 ~/ whole,
  };
  final left = 100 - floors.values.fold<int>(0, (sum, p) => sum + p);
  final byRemainder = [...types]
    ..sort(
      (a, b) =>
          (amounts[b]! * 100 % whole).compareTo(amounts[a]! * 100 % whole),
    );
  final bumped = byRemainder.take(left).toSet();
  return [
    for (final type in types)
      (
        type: type,
        amount: amounts[type]!,
        percent: floors[type]! + (bumped.contains(type) ? 1 : 0),
      ),
  ];
}
