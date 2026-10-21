import 'package:monai/features/wallets/domain/logic/wallet_totals.dart';
import 'package:monai/features/wallets/presentation/pages/wallets/bloc/wallets_bloc.dart';

extension WalletsStateX on WalletsState {
  ({int total, List<WalletTypeShare> shares}) get totals =>
      walletTotalsOf(wallets);

  String? get shownId => switch (selectedId) {
    final id? when wallets.any((w) => w.id == id) => id,
    _ => wallets.firstOrNull?.id,
  };
}
