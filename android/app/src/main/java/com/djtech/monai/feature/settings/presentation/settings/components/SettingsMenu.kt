package com.djtech.monai.feature.settings.presentation.settings.components

import androidx.compose.foundation.background
import androidx.compose.foundation.layout.Arrangement
import androidx.compose.foundation.layout.Column
import androidx.compose.foundation.layout.PaddingValues
import androidx.compose.foundation.layout.Row
import androidx.compose.foundation.layout.fillMaxWidth
import androidx.compose.foundation.layout.height
import androidx.compose.foundation.layout.padding
import androidx.compose.foundation.rememberScrollState
import androidx.compose.foundation.selection.selectable
import androidx.compose.foundation.selection.selectableGroup
import androidx.compose.foundation.shape.RoundedCornerShape
import androidx.compose.foundation.verticalScroll
import androidx.compose.material3.Icon
import androidx.compose.material3.Text
import androidx.compose.runtime.Composable
import androidx.compose.ui.Alignment
import androidx.compose.ui.Modifier
import androidx.compose.ui.draw.clip
import androidx.compose.ui.graphics.vector.ImageVector
import androidx.compose.ui.res.stringResource
import androidx.compose.ui.semantics.Role
import androidx.compose.ui.text.style.TextAlign
import androidx.compose.ui.text.style.TextOverflow
import com.djtech.monai.R
import com.djtech.monai.core.common.format.formatRupiahCompact
import com.djtech.monai.core.designsystem.component.MonAIAvatar
import com.djtech.monai.core.designsystem.component.MonAITag
import com.djtech.monai.core.designsystem.icon.MonAIIcons
import com.djtech.monai.core.designsystem.theme.MonAITheme
import com.djtech.monai.feature.settings.presentation.settings.SettingsDestination
import com.djtech.monai.feature.settings.presentation.settings.SettingsIntent
import com.djtech.monai.feature.settings.presentation.settings.SettingsState
import com.djtech.monai.feature.settings.presentation.settings.model.SettingsPane

/**
 * The wide-screen menu: the user, then one item per section, which shows it in the detail pane.
 * Wallets switches tab, and signing out sits at the bottom as on the phone.
 */
@Composable
internal fun SettingsMenu(
    state: SettingsState,
    onIntent: (SettingsIntent) -> Unit,
    contentPadding: PaddingValues,
    modifier: Modifier = Modifier,
) {
    val spacing = MonAITheme.spacing
    Column(
        modifier
            .verticalScroll(rememberScrollState())
            .padding(contentPadding)
            .padding(horizontal = spacing.x4),
        verticalArrangement = Arrangement.spacedBy(spacing.x3),
    ) {
        Text(
            stringResource(R.string.settings_title),
            Modifier.padding(horizontal = spacing.x2),
            style = MonAITheme.typography.headlineMedium,
            color = MonAITheme.colors.textPrimary,
        )
        state.profile?.let { profile ->
            Row(
                Modifier.padding(spacing.x2),
                verticalAlignment = Alignment.CenterVertically,
                horizontalArrangement = Arrangement.spacedBy(spacing.x3),
            ) {
                MonAIAvatar(profile.initials, size = MonAITheme.sizes.avatarLarge, imageUrl = profile.avatarUrl)
                Column(Modifier.weight(1f)) {
                    Row(
                        verticalAlignment = Alignment.CenterVertically,
                        horizontalArrangement = Arrangement.spacedBy(spacing.x1_5),
                    ) {
                        Text(
                            profile.name,
                            Modifier.weight(1f, fill = false),
                            style = MonAITheme.typography.titleMedium,
                            maxLines = 1,
                            overflow = TextOverflow.Ellipsis,
                        )
                        profile.roleBadge?.let { MonAITag(it.uppercase()) }
                    }
                    Text(
                        profile.email,
                        style = MonAITheme.typography.bodySmall,
                        color = MonAITheme.colors.textTertiary,
                        maxLines = 1,
                        overflow = TextOverflow.Ellipsis,
                    )
                }
            }
        }
        Column(Modifier.selectableGroup(), verticalArrangement = Arrangement.spacedBy(spacing.x0_5)) {
            MenuHeader(stringResource(R.string.settings_group_account))
            MenuItem(
                SettingsPane.Profile,
                MonAIIcons.Person,
                stringResource(R.string.settings_profile),
                null,
                state,
                onIntent,
            )
            MenuHeader(stringResource(R.string.settings_group_money))
            MenuItem(
                SettingsPane.Budget,
                MonAIIcons.Savings,
                stringResource(R.string.settings_budget),
                state.budgetLimit?.let(::formatRupiahCompact) ?: stringResource(R.string.settings_budget_not_set),
                state,
                onIntent,
            )
            MenuItem(
                SettingsPane.Categories,
                MonAIIcons.Category,
                stringResource(R.string.settings_categories),
                state.categoryCount.toString(),
                state,
                onIntent,
            )
            LinkItem(
                MonAIIcons.AccountBalanceWallet,
                stringResource(R.string.settings_wallets),
                state.walletCount.toString(),
                onClick = { onIntent(SettingsIntent.Open(SettingsDestination.Wallets)) },
            )
            MenuItem(
                SettingsPane.Export,
                MonAIIcons.Download,
                stringResource(R.string.export_row),
                null,
                state,
                onIntent,
            )
            MenuHeader(stringResource(R.string.settings_group_app))
            MenuItem(
                SettingsPane.Theme,
                MonAIIcons.DarkMode,
                stringResource(R.string.settings_theme),
                state.themeMode.label(),
                state,
                onIntent,
            )
            MenuItem(
                SettingsPane.Language,
                MonAIIcons.Translate,
                stringResource(R.string.settings_language),
                state.language.label(),
                state,
                onIntent,
            )
            if (state.showAdmin) {
                MenuHeader(stringResource(R.string.settings_group_admin))
                MenuItem(
                    SettingsPane.Providers,
                    MonAIIcons.AdminPanelSettings,
                    stringResource(R.string.settings_manage_providers),
                    null,
                    state,
                    onIntent,
                )
            }
        }
        SettingsAccountGroup(state.isSigningOut, onIntent)
        SettingsVersion(state.appVersion)
    }
}

@Composable
private fun MenuHeader(title: String) {
    Text(
        title.uppercase(),
        Modifier.padding(
            start = MonAITheme.spacing.x3,
            top = MonAITheme.spacing.x3,
            bottom = MonAITheme.spacing.x1,
        ),
        style = MonAITheme.extendedTypography.overline,
        color = MonAITheme.colors.textTertiary,
    )
}

@Composable
private fun MenuItem(
    pane: SettingsPane,
    icon: ImageVector,
    label: String,
    value: String?,
    state: SettingsState,
    onIntent: (SettingsIntent) -> Unit,
) {
    val selected = state.pane == pane
    val colors = MonAITheme.colors
    Row(
        Modifier
            .fillMaxWidth()
            .height(MonAITheme.sizes.navDrawerItem)
            .clip(RoundedCornerShape(MonAITheme.radius.md))
            .background(if (selected) colors.primaryContainer else colors.background)
            .selectable(selected = selected, role = Role.Tab) { onIntent(SettingsIntent.SelectPane(pane)) }
            .padding(horizontal = MonAITheme.spacing.x3),
        verticalAlignment = Alignment.CenterVertically,
        horizontalArrangement = Arrangement.spacedBy(MonAITheme.spacing.x3),
    ) {
        Icon(icon, null, tint = if (selected) colors.accent else colors.textSecondary)
        Text(
            label,
            Modifier.weight(1f),
            style = MonAITheme.typography.titleSmall,
            color = if (selected) colors.onPrimaryContainer else colors.textPrimary,
            maxLines = 1,
            overflow = TextOverflow.Ellipsis,
        )
        if (value != null) {
            Text(
                value,
                style = MonAITheme.typography.bodySmall,
                color = colors.textTertiary,
                maxLines = 1,
            )
        }
    }
}

/** A menu item that leaves Settings instead of filling the pane. */
@Composable
private fun LinkItem(
    icon: ImageVector,
    label: String,
    value: String,
    onClick: () -> Unit,
) {
    val colors = MonAITheme.colors
    Row(
        Modifier
            .fillMaxWidth()
            .height(MonAITheme.sizes.navDrawerItem)
            .clip(RoundedCornerShape(MonAITheme.radius.md))
            .selectable(selected = false, role = Role.Button, onClick = onClick)
            .padding(horizontal = MonAITheme.spacing.x3),
        verticalAlignment = Alignment.CenterVertically,
        horizontalArrangement = Arrangement.spacedBy(MonAITheme.spacing.x3),
    ) {
        Icon(icon, null, tint = colors.textSecondary)
        Text(
            label,
            Modifier.weight(1f),
            style = MonAITheme.typography.titleSmall,
            color = colors.textPrimary,
        )
        Text(value, style = MonAITheme.typography.bodySmall, color = colors.textTertiary)
        Icon(MonAIIcons.ChevronRight, null, tint = colors.textDisabled)
    }
}

/** The app version under the groups. */
@Composable
internal fun SettingsVersion(version: String, modifier: Modifier = Modifier) {
    Text(
        stringResource(R.string.settings_version, version),
        modifier.fillMaxWidth(),
        style = MonAITheme.typography.bodySmall,
        color = MonAITheme.colors.textDisabled,
        textAlign = TextAlign.Center,
    )
}
