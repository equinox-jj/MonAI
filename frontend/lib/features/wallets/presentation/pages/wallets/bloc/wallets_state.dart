part of 'wallets_bloc.dart';

@freezed
abstract class WalletsState with _$WalletsState {
  const factory WalletsState({
    @Default(UiStatus.initial) UiStatus status,
    @Default([]) List<Wallet> wallets,
    @Default(0) int archivedCount,

    /// The server answered once, so no wallets means there are none.
    @Default(false) bool loaded,
    @Default(false) bool isRefreshing,
    String? selectedId,
    WalletFailure? loadFailure,
    WalletFailure? actionFailure,
  }) = _WalletsState;
}
