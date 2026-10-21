import 'package:freezed_annotation/freezed_annotation.dart';

part 'wallet_form_mode.freezed.dart';

@freezed
sealed class WalletFormMode with _$WalletFormMode {
  const factory WalletFormMode.add() = AddWalletMode;
  const factory WalletFormMode.edit(String id) = EditWalletMode;
}

@freezed
sealed class WalletFormOutcome with _$WalletFormOutcome {
  const factory WalletFormOutcome.saved(String id) = SavedWalletOutcome;
  const factory WalletFormOutcome.archived(String name) = ArchivedWalletOutcome;
  const factory WalletFormOutcome.deleted(String name) = DeletedWalletOutcome;
}
