part of 'archived_wallets_bloc.dart';

@freezed
abstract class ArchivedWalletsState with _$ArchivedWalletsState {
  const factory ArchivedWalletsState({
    @Default(UiStatus.initial) UiStatus status,
    @Default([]) List<Wallet> wallets,
    @Default({}) Set<String> restoringIds,
    Wallet? restored,
    WalletFailure? actionFailure,
  }) = _ArchivedWalletsState;
}
