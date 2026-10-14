package com.djtech.monai.feature.settings.presentation.settings.components

import androidx.compose.foundation.layout.Box
import androidx.compose.foundation.layout.height
import androidx.compose.material3.CircularProgressIndicator
import androidx.compose.runtime.Composable
import androidx.compose.ui.Alignment
import androidx.compose.ui.Modifier
import androidx.compose.ui.res.stringResource
import com.djtech.monai.R
import com.djtech.monai.core.common.format.formatRupiahCompact
import com.djtech.monai.core.designsystem.component.MonAISettingsGroup
import com.djtech.monai.core.designsystem.component.MonAISettingsRow
import com.djtech.monai.core.designsystem.icon.MonAIIcons
import com.djtech.monai.core.designsystem.theme.MonAITheme
import com.djtech.monai.feature.settings.presentation.settings.SettingsDestination
import com.djtech.monai.feature.settings.presentation.settings.SettingsIntent
import com.djtech.monai.feature.settings.presentation.settings.SettingsState
import com.djtech.monai.feature.settings.presentation.settings.model.SettingsSheet

/** Budget, categories and wallets, each with its current value, then the CSV export. */
@Composable
internal fun SettingsMoneyGroup(
    state: SettingsState,
    onIntent: (SettingsIntent) -> Unit,
    modifier: Modifier = Modifier,
) {
    MonAISettingsGroup(stringResource(R.string.settings_group_money), modifier) {
        MonAISettingsRow(
            stringResource(R.string.settings_budget),
            MonAIIcons.Savings,
            onClick = { onIntent(SettingsIntent.Open(SettingsDestination.Budget(state.month))) },
            value = state.budgetLimit?.let(::formatRupiahCompact) ?: stringResource(R.string.settings_budget_not_set),
        )
        MonAISettingsRow(
            stringResource(R.string.settings_categories),
            MonAIIcons.Category,
            onClick = { onIntent(SettingsIntent.Open(SettingsDestination.Categories)) },
            value = state.categoryCount.toString(),
        )
        MonAISettingsRow(
            stringResource(R.string.settings_wallets),
            MonAIIcons.AccountBalanceWallet,
            onClick = { onIntent(SettingsIntent.Open(SettingsDestination.Wallets)) },
            value = state.walletCount.toString(),
        )
        MonAISettingsRow(
            stringResource(R.string.export_row),
            MonAIIcons.Download,
            onClick = { onIntent(SettingsIntent.ShowSheet(SettingsSheet.Export)) },
            showDivider = false,
        )
    }
}

/** Theme and language, each opening its picker. */
@Composable
internal fun SettingsAppGroup(
    state: SettingsState,
    onIntent: (SettingsIntent) -> Unit,
    modifier: Modifier = Modifier,
) {
    MonAISettingsGroup(stringResource(R.string.settings_group_app), modifier) {
        MonAISettingsRow(
            stringResource(R.string.settings_theme),
            MonAIIcons.DarkMode,
            onClick = { onIntent(SettingsIntent.ShowSheet(SettingsSheet.Theme)) },
            value = state.themeMode.label(),
        )
        MonAISettingsRow(
            stringResource(R.string.settings_language),
            MonAIIcons.Translate,
            onClick = { onIntent(SettingsIntent.ShowSheet(SettingsSheet.Language)) },
            value = state.language.label(),
            showDivider = false,
        )
    }
}

/** Shown only to users who may change the provider catalog. */
@Composable
internal fun SettingsAdminGroup(onIntent: (SettingsIntent) -> Unit, modifier: Modifier = Modifier) {
    MonAISettingsGroup(
        stringResource(R.string.settings_group_admin),
        modifier,
        footer = stringResource(R.string.settings_admin_footer),
    ) {
        MonAISettingsRow(
            stringResource(R.string.settings_manage_providers),
            MonAIIcons.AdminPanelSettings,
            onClick = { onIntent(SettingsIntent.Open(SettingsDestination.ManageProviders)) },
            showDivider = false,
        )
    }
}

/** Sign out here or everywhere, and delete the account (on Edit profile, behind the password). */
@Composable
internal fun SettingsAccountGroup(
    isSigningOut: Boolean,
    onIntent: (SettingsIntent) -> Unit,
    modifier: Modifier = Modifier,
) {
    val colors = MonAITheme.colors
    Box(modifier) {
        MonAISettingsGroup(stringResource(R.string.settings_group_account)) {
            MonAISettingsRow(
                stringResource(R.string.settings_sign_out),
                MonAIIcons.Logout,
                onClick = { if (!isSigningOut) onIntent(SettingsIntent.SignOut) },
                showChevron = false,
                iconTint = colors.textSecondary,
            )
            MonAISettingsRow(
                stringResource(R.string.settings_sign_out_all),
                MonAIIcons.Devices,
                onClick = { if (!isSigningOut) onIntent(SettingsIntent.SignOutAllDevices) },
                showChevron = false,
                iconTint = colors.textSecondary,
            )
            MonAISettingsRow(
                stringResource(R.string.settings_delete_account),
                MonAIIcons.PersonRemove,
                onClick = { onIntent(SettingsIntent.Open(SettingsDestination.EditProfile(focusDelete = true))) },
                showChevron = false,
                destructive = true,
                showDivider = false,
            )
        }
        if (isSigningOut) {
            CircularProgressIndicator(
                Modifier
                    .align(Alignment.Center)
                    .height(MonAITheme.sizes.icon),
                color = colors.accent,
                strokeWidth = MonAITheme.sizes.borderFocused,
            )
        }
    }
}
