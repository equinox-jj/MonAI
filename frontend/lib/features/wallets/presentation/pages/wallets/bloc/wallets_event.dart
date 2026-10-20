part of 'wallets_bloc.dart';

@freezed
sealed class WalletsEvent with _$WalletsEvent {
  /// The tab opened.
  const factory WalletsEvent.started() = _Started;

  /// Pull-to-refresh, or "Try again" on the error.
  const factory WalletsEvent.refreshed() = _Refreshed;

  /// A wallet was tapped on a wide screen: shows it beside the list.
  const factory WalletsEvent.selected(String id) = _Selected;

  /// The cached wallets that aren't archived changed. Sent by the bloc
  /// itself.
  const factory WalletsEvent.walletsChanged(List<Wallet> wallets) =
      _WalletsChanged;

  /// Every cached wallet, archived ones too, changed. Sent by the bloc
  /// itself.
  const factory WalletsEvent.allWalletsChanged(List<Wallet> wallets) =
      _AllWalletsChanged;
}
