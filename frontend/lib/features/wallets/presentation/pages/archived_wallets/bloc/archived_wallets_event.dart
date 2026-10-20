part of 'archived_wallets_bloc.dart';

@freezed
sealed class ArchivedWalletsEvent with _$ArchivedWalletsEvent {
  /// The screen opened.
  const factory ArchivedWalletsEvent.started() = _Started;

  /// "Unarchive" on the wallet [id].
  const factory ArchivedWalletsEvent.unarchiveRequested(String id) =
      _UnarchiveRequested;

  /// Every cached wallet changed. Sent by the bloc itself.
  const factory ArchivedWalletsEvent.walletsChanged(List<Wallet> wallets) =
      _WalletsChanged;
}
