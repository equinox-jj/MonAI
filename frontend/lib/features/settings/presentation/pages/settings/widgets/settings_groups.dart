import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:monai/core/ui/designsystem/designsystem.dart';
import 'package:monai/core/ui/l10n/l10n.dart';
import 'package:monai/core/model/app_theme_mode.dart';
import 'package:monai/core/utils/money_format.dart';
import 'package:monai/features/settings/domain/logic/settings_rules.dart';
import 'package:monai/features/settings/presentation/app_settings/cubit/app_settings_cubit.dart';
import 'package:monai/features/settings/presentation/pages/settings/bloc/settings_bloc.dart';
import 'package:monai/features/settings/presentation/pages/settings/model/settings_text.dart';
import 'package:monai/features/settings/presentation/pages/settings/widgets/settings_actions.dart';

typedef _MoneyValues = ({int? budgetLimit, int categoryCount, int walletCount});

/// Budget, categories and wallets, each with its current value, then the CSV
/// export.
class SettingsMoneyGroup extends StatelessWidget {
  const SettingsMoneyGroup({required this.actions, super.key});

  final SettingsActions actions;

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    return BlocSelector<SettingsBloc, SettingsState, _MoneyValues>(
      selector: (state) => (
        budgetLimit: state.overview.budgetLimit,
        categoryCount: state.overview.categoryCount,
        walletCount: state.overview.walletCount,
      ),
      builder: (context, values) => MonAISettingsGroup(
        title: l10n.settingsGroupMoney,
        children: [
          MonAISettingsRow(
            label: l10n.settingsBudget,
            icon: MonAIIcons.savings,
            onTap: actions.onOpenBudget,
            value: switch (values.budgetLimit) {
              final limit? => formatRupiahCompact(limit),
              null => l10n.settingsBudgetNotSet,
            },
          ),
          MonAISettingsRow(
            label: l10n.settingsCategories,
            icon: MonAIIcons.category,
            onTap: actions.onOpenCategories,
            value: '${values.categoryCount}',
          ),
          MonAISettingsRow(
            label: l10n.settingsWallets,
            icon: MonAIIcons.accountBalanceWallet,
            onTap: actions.onOpenWallets,
            value: '${values.walletCount}',
          ),
          MonAISettingsRow(
            label: l10n.settingsExport,
            icon: MonAIIcons.download,
            onTap: actions.onExport,
            showDivider: false,
          ),
        ],
      ),
    );
  }
}

/// Theme and language, each opening its picker.
class SettingsAppGroup extends StatelessWidget {
  const SettingsAppGroup({required this.actions, super.key});

  final SettingsActions actions;

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    // The app is already drawn in the picked language, or in the phone's
    // when following it.
    final language = shownLanguage(
      Localizations.localeOf(context).languageCode,
    );
    return MonAISettingsGroup(
      title: l10n.settingsGroupApp,
      children: [
        BlocSelector<AppSettingsCubit, AppSettingsState, AppThemeMode>(
          selector: (state) => state.themeMode,
          builder: (context, themeMode) => MonAISettingsRow(
            label: l10n.settingsTheme,
            icon: MonAIIcons.darkMode,
            onTap: actions.onPickTheme,
            value: themeMode.label(l10n),
          ),
        ),
        MonAISettingsRow(
          label: l10n.settingsLanguage,
          icon: MonAIIcons.translate,
          onTap: actions.onPickLanguage,
          value: language.label(l10n),
          showDivider: false,
        ),
      ],
    );
  }
}

/// Shown only to users who may change the provider catalog.
class SettingsAdminGroup extends StatelessWidget {
  const SettingsAdminGroup({required this.actions, super.key});

  final SettingsActions actions;

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    return MonAISettingsGroup(
      title: l10n.settingsGroupAdmin,
      footer: l10n.settingsAdminFooter,
      children: [
        MonAISettingsRow(
          label: l10n.settingsManageProviders,
          icon: MonAIIcons.adminPanelSettings,
          onTap: actions.onManageProviders,
          showDivider: false,
        ),
      ],
    );
  }
}

/// Change the password, sign out here or everywhere, and delete the account
/// (on Edit profile, behind the password). A spinner covers the group while
/// signing out.
class SettingsAccountGroup extends StatelessWidget {
  const SettingsAccountGroup({required this.actions, super.key});

  final SettingsActions actions;

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    final c = context.colors;
    return BlocSelector<SettingsBloc, SettingsState, bool>(
      selector: (state) => state.isSigningOut,
      builder: (context, isSigningOut) => Stack(
        alignment: .center,
        children: [
          MonAISettingsGroup(
            title: l10n.settingsGroupAccount,
            children: [
              MonAISettingsRow(
                label: l10n.settingsChangePassword,
                icon: MonAIIcons.lock,
                onTap: actions.onChangePassword,
                iconColor: c.textSecondary,
              ),
              MonAISettingsRow(
                label: l10n.settingsSignOut,
                icon: MonAIIcons.logout,
                onTap: isSigningOut ? () {} : actions.onSignOut,
                showChevron: false,
                iconColor: c.textSecondary,
              ),
              MonAISettingsRow(
                label: l10n.settingsSignOutAll,
                icon: MonAIIcons.devices,
                onTap: isSigningOut ? () {} : actions.onSignOutAllDevices,
                showChevron: false,
                iconColor: c.textSecondary,
              ),
              MonAISettingsRow(
                label: l10n.settingsDeleteAccount,
                icon: MonAIIcons.personRemove,
                onTap: actions.onDeleteAccount,
                showChevron: false,
                destructive: true,
                showDivider: false,
              ),
            ],
          ),
          if (isSigningOut)
            SizedBox.square(
              dimension: MonAISizes.icon,
              child: CircularProgressIndicator(
                color: c.accent,
                strokeWidth: MonAISizes.borderFocused,
              ),
            ),
        ],
      ),
    );
  }
}
