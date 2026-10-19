import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:monai/core/model/wallet_type.dart';

part 'wallet.freezed.dart';

/// A place money is kept: cash, a bank account or an e-wallet. Balances are
/// rupiah; [currentBalance] is calculated by the server.
@freezed
abstract class Wallet with _$Wallet {
  const factory Wallet({
    required String id,
    required String name,
    required WalletType type,
    required int initialBalance,
    required int currentBalance,
    required bool isDefault,
    required bool isArchived,
    required DateTime createdAt,
    required DateTime updatedAt,

    /// The linked payment provider; null for a custom wallet.
    String? providerId,
    String? logoUrl,
    String? icon,

    /// `#RRGGBB`.
    String? color,
  }) = _Wallet;
}
