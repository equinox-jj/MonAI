part of 'archived_wallets_bloc.dart';

@freezed
abstract class ArchivedWalletsState with _$ArchivedWalletsState {
  const factory ArchivedWalletsState({
    /// [UiStatus.initial] until the cache is read, [UiStatus.empty] with
    /// nothing archived, otherwise [UiStatus.success].
    @Default(UiStatus.initial) UiStatus status,

    /// The archived wallets, in the cache's order.
    @Default([]) List<Wallet> wallets,

    /// Being brought back.
    @Default({}) Set<String> restoringIds,

    /// Just brought back; shown once as a snackbar.
    Wallet? restored,

    /// Why an unarchive failed; shown once as a snackbar.
    WalletFailure? actionFailure,
  }) = _ArchivedWalletsState;
}
