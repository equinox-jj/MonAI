part of 'archived_wallets_bloc.dart';

@freezed
sealed class ArchivedWalletsEvent with _$ArchivedWalletsEvent {
  const factory ArchivedWalletsEvent.started() = _Started;

  const factory ArchivedWalletsEvent.unarchiveRequested(String id) =
      _UnarchiveRequested;

  const factory ArchivedWalletsEvent.walletsChanged(List<Wallet> wallets) =
      _WalletsChanged;
}
