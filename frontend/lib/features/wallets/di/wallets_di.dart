import 'package:monai/core/app/injector.dart';
import 'package:monai/features/wallets/domain/usecase/archive_wallet_usecase.dart';
import 'package:monai/features/wallets/domain/usecase/create_wallet_usecase.dart';
import 'package:monai/features/wallets/domain/usecase/delete_wallet_usecase.dart';
import 'package:monai/features/wallets/domain/usecase/refresh_wallet_usecase.dart';
import 'package:monai/features/wallets/domain/usecase/set_default_wallet_usecase.dart';
import 'package:monai/features/wallets/domain/usecase/unarchive_wallet_usecase.dart';
import 'package:monai/features/wallets/domain/usecase/update_wallet_usecase.dart';
import 'package:monai/features/wallets/presentation/pages/archived_wallets/bloc/archived_wallets_bloc.dart';
import 'package:monai/features/wallets/presentation/pages/wallet_detail/bloc/wallet_detail_bloc.dart';
import 'package:monai/features/wallets/presentation/pages/wallet_form/bloc/wallet_form_bloc.dart';
import 'package:monai/features/wallets/presentation/pages/wallet_form/model/wallet_form_mode.dart';
import 'package:monai/features/wallets/presentation/pages/wallets/bloc/wallets_bloc.dart';

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
      ..registerFactory(() => RefreshWalletUseCase(sl()))
      ..registerFactory(
        () => WalletsBloc(
          watchWallets: sl(),
          watchAllWallets: sl(),
          refreshWallets: sl(),
        ),
      )
      ..registerFactoryParam<WalletDetailBloc, String, void>(
        (id, _) => WalletDetailBloc(
          id: id,
          watchWallet: sl(),
          refreshWallet: sl(),
          watchOutflows: sl(),
          watchTransactions: sl(),
          refreshTransactions: sl(),
          watchCategories: sl(),
          watchAllWallets: sl(),
          archive: sl(),
          setDefault: sl(),
        ),
      )
      ..registerFactoryParam<WalletFormBloc, WalletFormMode, void>(
        (mode, _) => WalletFormBloc(
          mode: mode,
          watchProviders: sl(),
          refreshProviders: sl(),
          watchWallet: sl(),
          watchWallets: sl(),
          create: sl(),
          update: sl(),
          archive: sl(),
          delete: sl(),
        ),
      )
      ..registerFactory(
        () => ArchivedWalletsBloc(
          watchAllWallets: sl(),
          refreshWallets: sl(),
          unarchive: sl(),
        ),
      );
  }
}
