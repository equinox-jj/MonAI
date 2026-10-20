import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:monai/core/designsystem/designsystem.dart';
import 'package:monai/core/di/injector.dart';
import 'package:monai/core/l10n/l10n.dart';
import 'package:monai/core/model/app_language.dart';
import 'package:monai/core/model/app_theme_mode.dart';
import 'package:monai/core/router/app_router.dart';
import 'package:monai/features/settings/presentation/app_settings/cubit/app_settings_cubit.dart';
import 'package:monai/features/settings/presentation/pages/settings/bloc/settings_bloc.dart';
import 'package:monai/features/settings/presentation/pages/settings/widgets/settings_actions.dart';
import 'package:monai/features/settings/presentation/pages/settings/widgets/settings_groups.dart';
import 'package:monai/features/settings/presentation/pages/settings/widgets/settings_language_sheet.dart';
import 'package:monai/features/settings/presentation/pages/settings/widgets/settings_profile_card.dart';
import 'package:monai/features/settings/presentation/pages/settings/widgets/settings_sign_out_dialog.dart';
import 'package:monai/features/settings/presentation/pages/settings/widgets/settings_theme_sheet.dart';

class SettingsPage extends StatelessWidget {
  const SettingsPage({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => sl<SettingsBloc>()..add(const SettingsEvent.started()),
      child: const SettingsUI(),
    );
  }
}

/// The profile card and the Money, App, Admin and Account groups.
class SettingsUI extends StatelessWidget {
  const SettingsUI({super.key});

  /// Wide windows keep the list at a readable width.
  static const _maxContentWidth = 720.0;

  // TODO(settings): open Edit profile once it exists.
  void _openProfile() {}

  void _openBudget(BuildContext context) => context.push(AppRoutes.budgetFor());

  void _openCategories(BuildContext context) =>
      context.push(AppRoutes.categories);

  void _openWallets(BuildContext context) => context.go(AppRoutes.wallets);

  // TODO(settings): open the CSV export once it exists.
  void _export() {}

  // TODO(settings): open Manage payment providers once it exists.
  void _manageProviders() {}

  // TODO(settings): open Change password once it exists.
  void _changePassword() {}

  // TODO(settings): open Edit profile at its delete-account card once it
  // exists.
  void _deleteAccount() {}

  void _pickTheme(BuildContext context) {
    final appSettings = context.read<AppSettingsCubit>();
    showMonAIBottomSheet<void>(
      context,
      title: context.l10n.settingsTheme,
      builder: (sheetContext) => SettingsThemeSheet(
        onPick: (mode) => _themePicked(sheetContext, appSettings, mode),
      ),
    );
  }

  void _themePicked(
    BuildContext sheetContext,
    AppSettingsCubit appSettings,
    AppThemeMode mode,
  ) {
    final sheetClosed = ModalRoute.of(sheetContext)!.completed;
    Navigator.pop(sheetContext);
    sheetClosed.then((_) => appSettings.themeModePicked(mode));
  }

  void _pickLanguage(BuildContext context) {
    final appSettings = context.read<AppSettingsCubit>();
    showMonAIBottomSheet<void>(
      context,
      title: context.l10n.settingsLanguage,
      builder: (sheetContext) => SettingsLanguageSheet(
        onPick: (language) =>
            _languagePicked(sheetContext, appSettings, language),
      ),
    );
  }

  void _languagePicked(
    BuildContext sheetContext,
    AppSettingsCubit appSettings,
    AppLanguage language,
  ) {
    Navigator.pop(sheetContext);
    appSettings.languagePicked(language);
  }

  Future<void> _signOut(
    BuildContext context, {
    required bool allDevices,
  }) async {
    final bloc = context.read<SettingsBloc>();
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (_) => SettingsSignOutDialog(allDevices: allDevices),
    );
    if (confirmed ?? false) {
      bloc.add(SettingsEvent.signOutConfirmed(allDevices: allDevices));
    }
  }

  void _showSignOutFailure(BuildContext context, SettingsState state) {
    final l10n = context.l10n;
    switch (state.signOutFailure) {
      case .network:
        showMonAISnackBar(
          context,
          message: l10n.settingsErrorNetwork,
          icon: MonAIIcons.cloudOff,
        );
      case .unexpected:
        showMonAISnackBar(context, message: l10n.settingsErrorSignOut);
      case null:
    }
  }

  @override
  Widget build(BuildContext context) {
    final actions = SettingsActions(
      onOpenProfile: _openProfile,
      onOpenBudget: () => _openBudget(context),
      onOpenCategories: () => _openCategories(context),
      onOpenWallets: () => _openWallets(context),
      onExport: _export,
      onPickTheme: () => _pickTheme(context),
      onPickLanguage: () => _pickLanguage(context),
      onManageProviders: _manageProviders,
      onChangePassword: _changePassword,
      onSignOut: () => _signOut(context, allDevices: false),
      onSignOutAllDevices: () => _signOut(context, allDevices: true),
      onDeleteAccount: _deleteAccount,
    );

    return ColoredBox(
      color: context.colors.background,
      child: SafeArea(
        bottom: false,
        child: BlocListener<SettingsBloc, SettingsState>(
          listenWhen: (previous, current) =>
              current.signOutFailure != null &&
              previous.signOutFailure != current.signOutFailure,
          listener: _showSignOutFailure,
          child: SingleChildScrollView(
            padding: const .symmetric(
              horizontal: MonAISpacing.screenHorizontal,
              vertical: MonAISpacing.screenTop,
            ),
            child: Center(
              child: ConstrainedBox(
                constraints: const BoxConstraints(maxWidth: _maxContentWidth),
                child: _SettingsList(actions: actions),
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class _SettingsList extends StatelessWidget {
  const _SettingsList({required this.actions});

  final SettingsActions actions;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: .stretch,
      spacing: MonAISpacing.x4,
      children: [
        MonAIScreenTitle(title: context.l10n.settingsTitle),
        SettingsProfileCard(onTap: actions.onOpenProfile),
        SettingsMoneyGroup(actions: actions),
        SettingsAppGroup(actions: actions),
        BlocSelector<SettingsBloc, SettingsState, bool>(
          selector: (state) => state.overview.canManageProviders,
          builder: (context, canManage) => canManage
              ? SettingsAdminGroup(actions: actions)
              : const SizedBox.shrink(),
        ),
        SettingsAccountGroup(actions: actions),
        const _Version(),
      ],
    );
  }
}

class _Version extends StatelessWidget {
  const _Version();

  @override
  Widget build(BuildContext context) {
    return BlocSelector<SettingsBloc, SettingsState, String>(
      selector: (state) => state.appVersion,
      builder: (context, version) => version.isEmpty
          ? const SizedBox.shrink()
          : Text(
              context.l10n.settingsVersion(version),
              textAlign: .center,
              style: context.textTheme.bodySmall?.copyWith(
                color: context.colors.textDisabled,
              ),
            ),
    );
  }
}
