import 'package:flutter/foundation.dart';

/// Where Settings' rows lead. The screen fills these in; the sections only
/// call them.
@immutable
class SettingsActions {
  const SettingsActions({
    required this.onOpenProfile,
    required this.onOpenBudget,
    required this.onOpenCategories,
    required this.onOpenWallets,
    required this.onExport,
    required this.onPickTheme,
    required this.onPickLanguage,
    required this.onManageProviders,
    required this.onChangePassword,
    required this.onSignOut,
    required this.onSignOutAllDevices,
    required this.onDeleteAccount,
  });

  final VoidCallback onOpenProfile;
  final VoidCallback onOpenBudget;
  final VoidCallback onOpenCategories;
  final VoidCallback onOpenWallets;
  final VoidCallback onExport;
  final VoidCallback onPickTheme;
  final VoidCallback onPickLanguage;
  final VoidCallback onManageProviders;
  final VoidCallback onChangePassword;
  final VoidCallback onSignOut;
  final VoidCallback onSignOutAllDevices;
  final VoidCallback onDeleteAccount;
}
