import 'package:monai/core/di/injector.dart';
import 'package:monai/features/wallets/domain/usecase/archive_wallet_usecase.dart';
import 'package:monai/features/wallets/domain/usecase/create_wallet_usecase.dart';
import 'package:monai/features/wallets/domain/usecase/delete_wallet_usecase.dart';
import 'package:monai/features/wallets/domain/usecase/refresh_wallet_usecase.dart';
import 'package:monai/features/wallets/domain/usecase/set_default_wallet_usecase.dart';
import 'package:monai/features/wallets/domain/usecase/unarchive_wallet_usecase.dart';
import 'package:monai/features/wallets/domain/usecase/update_wallet_usecase.dart';

/// The wallets feature's use cases; its repository is shared (see
/// `SharedDI`).
class WalletsDI {
  WalletsDI._();

  static Future<void> init() async {
    sl
      ..registerFactory(() => CreateWalletUseCase(sl()))
      ..registerFactory(() => UpdateWalletUseCase(sl()))
      ..registerFactory(() => SetDefaultWalletUseCase(sl()))
      ..registerFactory(() => ArchiveWalletUseCase(sl()))
      ..registerFactory(() => UnarchiveWalletUseCase(sl()))
      ..registerFactory(() => DeleteWalletUseCase(sl()))
      ..registerFactory(() => RefreshWalletUseCase(sl()));
  }
}
