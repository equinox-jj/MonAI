part of 'wallets_bloc.dart';

@freezed
sealed class WalletsEvent with _$WalletsEvent {
  const factory WalletsEvent.started() = _Started;
  const factory WalletsEvent.refreshed() = _Refreshed;
  const factory WalletsEvent.selected(String id) = _Selected;

  const factory WalletsEvent.walletsChanged(List<Wallet> wallets) =
      _WalletsChanged;

  const factory WalletsEvent.allWalletsChanged(List<Wallet> wallets) =
      _AllWalletsChanged;
}
