import 'package:freezed_annotation/freezed_annotation.dart';

part 'wallet_form_mode.freezed.dart';

/// Whether the form adds a wallet or edits one.
@freezed
sealed class WalletFormMode with _$WalletFormMode {
  /// A new wallet, from a provider or custom.
  const factory WalletFormMode.add() = AddWalletMode;

  /// The wallet with [id].
  const factory WalletFormMode.edit(String id) = EditWalletMode;
}

/// How the form closed.
@freezed
sealed class WalletFormOutcome with _$WalletFormOutcome {
  /// Saved as wallet [id].
  const factory WalletFormOutcome.saved(String id) = SavedWalletOutcome;

  /// The edited wallet [name] was archived.
  const factory WalletFormOutcome.archived(String name) = ArchivedWalletOutcome;

  /// The edited wallet [name] was deleted.
  const factory WalletFormOutcome.deleted(String name) = DeletedWalletOutcome;
}
