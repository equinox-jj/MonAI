import 'package:fpdart/fpdart.dart';
import 'package:mocktail/mocktail.dart';
import 'package:monai/core/di/injector.dart';
import 'package:monai/core/usecase/usecase.dart';
import 'package:monai/features/shared/domain/usecase/refresh_wallets_usecase.dart';
import 'package:monai/features/shared/domain/usecase/watch_all_wallets_usecase.dart';
import 'package:monai/features/shared/domain/usecase/watch_wallets_usecase.dart';
import 'package:monai/features/wallets/presentation/pages/wallets/bloc/wallets_bloc.dart';

class _MockWatchWallets extends Mock implements WatchWalletsUseCase {}

class _MockWatchAllWallets extends Mock implements WatchAllWalletsUseCase {}

class _MockRefreshWallets extends Mock implements RefreshWalletsUseCase {}

/// Registers the Wallets tab, backed by an empty cache that never changes.
/// For widget tests that reach the signed-in shell.
void registerQuietWalletScreens() {
  registerFallbackValue(const NoParams());
  final watchWallets = _MockWatchWallets();
  when(() => watchWallets(any()))
      .thenAnswer((_) => Stream.value(const Right([])));
  final watchAllWallets = _MockWatchAllWallets();
  when(() => watchAllWallets(any()))
      .thenAnswer((_) => Stream.value(const Right([])));
  final refreshWallets = _MockRefreshWallets();
  when(() => refreshWallets(any())).thenAnswer((_) async => const Right([]));
  sl.registerFactory(
    () => WalletsBloc(
      watchWallets: watchWallets,
      watchAllWallets: watchAllWallets,
      refreshWallets: refreshWallets,
    ),
  );
}
