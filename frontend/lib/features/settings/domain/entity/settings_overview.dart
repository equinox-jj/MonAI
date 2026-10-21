import 'package:freezed_annotation/freezed_annotation.dart';

part 'settings_overview.freezed.dart';

@freezed
abstract class SettingsOverview with _$SettingsOverview {
  const factory SettingsOverview({
    SettingsProfile? profile,
    int? budgetLimit,
    @Default(0) int categoryCount,
    @Default(0) int walletCount,
    @Default(false) bool canManageProviders,
  }) = _SettingsOverview;
}

@freezed
abstract class SettingsProfile with _$SettingsProfile {
  const factory SettingsProfile({
    required String name,
    required String email,
    required String initials,
    String? avatarUrl,

    /// The role's name for anyone above a regular user, e.g. "Admin".
    String? roleBadge,
  }) = _SettingsProfile;
}

enum SettingsSignOutFailure { network, unexpected }
