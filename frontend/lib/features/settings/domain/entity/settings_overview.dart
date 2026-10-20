import 'package:freezed_annotation/freezed_annotation.dart';

part 'settings_overview.freezed.dart';

/// What the Settings hub shows, from the cache.
@freezed
abstract class SettingsOverview with _$SettingsOverview {
  const factory SettingsOverview({
    /// Null until the user has been cached since sign-in.
    SettingsProfile? profile,

    /// This month's limit in rupiah; null when none is set.
    int? budgetLimit,

    /// Every category, hidden ones included.
    @Default(0) int categoryCount,

    /// Wallets that aren't archived.
    @Default(0) int walletCount,

    /// The user may add, edit or remove payment providers.
    @Default(false) bool canManageProviders,
  }) = _SettingsOverview;
}

/// The profile card.
@freezed
abstract class SettingsProfile with _$SettingsProfile {
  const factory SettingsProfile({
    required String name,
    required String email,

    /// `JP` for "Joshua Pardede".
    required String initials,

    /// Presigned and short-lived.
    String? avatarUrl,

    /// The role's name for anyone above a regular user, e.g. "Admin".
    String? roleBadge,
  }) = _SettingsProfile;
}

/// Why signing out failed.
enum SettingsSignOutFailure {
  /// No connection or a timeout.
  network,

  /// Anything else.
  unexpected,
}
