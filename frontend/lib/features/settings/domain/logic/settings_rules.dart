import 'package:monai/core/error/failure.dart';
import 'package:monai/core/model/app_language.dart';
import 'package:monai/core/utils/monograms.dart';
import 'package:monai/features/settings/domain/entity/settings_overview.dart';
import 'package:monai/features/settings/domain/logic/provider_rules.dart';
import 'package:monai/features/shared/domain/entity/budget.dart';
import 'package:monai/features/shared/domain/entity/category.dart';
import 'package:monai/features/shared/domain/entity/user.dart';
import 'package:monai/features/shared/domain/entity/wallet.dart';

/// The role every account starts with; it gets no badge.
const kDefaultRoleSlug = 'user';

/// Any of these lets a user change the payment provider catalog.
const kProviderManagePermissions = {
  kProviderCreatePermission,
  kProviderUpdatePermission,
  kProviderDeletePermission,
};

/// The Settings hub from the cached [user], [budget], [categories] and
/// [wallets].
SettingsOverview buildSettingsOverview({
  required User? user,
  required Budget? budget,
  required List<Category> categories,
  required List<Wallet> wallets,
}) => SettingsOverview(
  profile: user == null ? null : settingsProfileOf(user),
  budgetLimit: budget?.limitAmount,
  categoryCount: categories.length,
  walletCount: wallets.length,
  canManageProviders: canManageProviders(user),
);

/// The profile card for [user]; a regular user gets no role badge.
SettingsProfile settingsProfileOf(User user) => SettingsProfile(
  name: user.name,
  email: user.email,
  initials: initialsOf(user.name),
  avatarUrl: user.avatarUrl,
  roleBadge: user.role.slug == kDefaultRoleSlug ? null : user.role.name,
);

/// Regular users can view the catalog too (the wallet picker reads it), so
/// the admin section needs a permission to change it.
bool canManageProviders(User? user) =>
    user != null && kProviderManagePermissions.any(user.hasPermission);

/// Being offline explains a failed sign-out best; anything else is
/// unexpected.
SettingsSignOutFailure signOutFailureOf(Failure failure) => switch (failure) {
  NetworkFailure() || TimeoutFailure() => .network,
  _ => .unexpected,
};

/// The language the app is shown in for the active [languageCode]: a phone
/// in any language but Indonesian falls back to English.
AppLanguage shownLanguage(String languageCode) =>
    languageCode == AppLanguage.indonesian.tag ? .indonesian : .english;
