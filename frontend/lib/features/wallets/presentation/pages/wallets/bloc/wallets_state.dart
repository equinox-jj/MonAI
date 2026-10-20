part of 'wallets_bloc.dart';

@freezed
abstract class WalletsState with _$WalletsState {
  const factory WalletsState({
    /// [UiStatus.loading] while nothing is cached yet (the skeleton),
    /// [UiStatus.failure] when that first load failed, [UiStatus.empty]
    /// when the user has no wallet, otherwise [UiStatus.success].
    @Default(UiStatus.initial) UiStatus status,

    /// The wallets that aren't archived, default first, then by name.
    @Default([]) List<Wallet> wallets,
    @Default(0) int archivedCount,

    /// The server answered once, so no wallets means there are none.
    @Default(false) bool loaded,
    @Default(false) bool isRefreshing,

    /// The wallet beside the list on a wide screen.
    String? selectedId,

    /// Why the first load failed, with nothing cached.
    WalletFailure? loadFailure,

    /// Why a refresh failed; shown once as a snackbar.
    WalletFailure? actionFailure,
  }) = _WalletsState;
}

extension WalletsStateX on WalletsState {
  /// The money across the wallets and its split by type.
  ({int total, List<WalletTypeShare> shares}) get totals =>
      walletTotalsOf(wallets);

  /// The wallet beside the list: the one picked while it's still listed,
  /// else the first.
  String? get shownId => switch (selectedId) {
    final id? when wallets.any((w) => w.id == id) => id,
    _ => wallets.firstOrNull?.id,
  };
}
