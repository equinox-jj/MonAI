import 'package:monai/core/model/wallet_type.dart';
import 'package:monai/features/shared/domain/entity/payment_provider.dart';
import 'package:monai/features/shared/domain/entity/wallet.dart';
import 'package:monai/features/shared/domain/entity/wallet_input.dart';

/// [wallet]'s current balance once its starting balance becomes
/// [initialBalance]: both move by the same amount.
int shiftedBalance(Wallet wallet, int initialBalance) =>
    wallet.currentBalance + initialBalance - wallet.initialBalance;

/// The new wallet the add form describes.
///
/// A wallet from a [provider] leaves a blank name and the type to the
/// server. A bundled provider's id isn't one the server knows, so that
/// wallet goes as a custom one with the provider's name and type.
WalletInput newWalletInput({
  required PaymentProvider? provider,
  required String name,
  required WalletType? type,
  required int initialBalance,
  required bool isDefault,
}) => switch (provider) {
  null => WalletInput(
    name: name,
    type: type,
    initialBalance: initialBalance,
    isDefault: isDefault,
  ),
  PaymentProvider(isBundled: true) => WalletInput(
    name: name.trim().isEmpty ? provider.name : name,
    type: provider.type,
    initialBalance: initialBalance,
    isDefault: isDefault,
  ),
  _ => WalletInput(
    name: name,
    providerId: provider.id,
    initialBalance: initialBalance,
    isDefault: isDefault,
  ),
};

/// The edited [wallet] as the edit form describes it. The form can't change
/// the type.
WalletInput editedWalletInput(
  Wallet wallet, {
  required String name,
  required int initialBalance,
  required String? color,
  required bool isDefault,
}) => WalletInput(
  name: name,
  providerId: wallet.providerId,
  type: wallet.type,
  initialBalance: initialBalance,
  color: color,
  isDefault: isDefault,
);

/// Each day's money out of a wallet from the 1st of [month] to [lastDay],
/// for its chart; days with nothing are 0.
List<int> dailyOutflowSeries(
  Map<DateTime, int> outflows,
  DateTime month,
  int lastDay,
) => List.generate(
  lastDay,
  (index) => outflows[DateTime(month.year, month.month, index + 1)] ?? 0,
);
