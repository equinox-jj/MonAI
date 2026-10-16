package com.djtech.monai.feature.settings.presentation.settings

import androidx.compose.foundation.background
import androidx.compose.foundation.layout.Arrangement
import androidx.compose.foundation.layout.Box
import androidx.compose.foundation.layout.Column
import androidx.compose.foundation.layout.PaddingValues
import androidx.compose.foundation.layout.Row
import androidx.compose.foundation.layout.WindowInsets
import androidx.compose.foundation.layout.asPaddingValues
import androidx.compose.foundation.layout.fillMaxHeight
import androidx.compose.foundation.layout.fillMaxSize
import androidx.compose.foundation.layout.fillMaxWidth
import androidx.compose.foundation.layout.padding
import androidx.compose.foundation.layout.statusBars
import androidx.compose.foundation.layout.width
import androidx.compose.foundation.layout.widthIn
import androidx.compose.foundation.rememberScrollState
import androidx.compose.foundation.verticalScroll
import androidx.compose.material3.SnackbarHostState
import androidx.compose.material3.VerticalDivider
import androidx.compose.runtime.Composable
import androidx.compose.runtime.getValue
import androidx.compose.runtime.remember
import androidx.compose.ui.Alignment
import androidx.compose.ui.Modifier
import androidx.compose.ui.res.stringResource
import androidx.compose.ui.tooling.preview.PreviewLightDark
import androidx.compose.ui.tooling.preview.PreviewScreenSizes
import androidx.compose.ui.unit.dp
import androidx.hilt.lifecycle.viewmodel.compose.hiltViewModel
import androidx.lifecycle.compose.collectAsStateWithLifecycle
import com.djtech.monai.R
import com.djtech.monai.core.common.ui.CollectEffects
import com.djtech.monai.core.designsystem.component.MonAIScreenTitle
import com.djtech.monai.core.designsystem.component.MonAISnackbarHost
import com.djtech.monai.core.designsystem.component.MonAIWidthClass
import com.djtech.monai.core.designsystem.component.currentWidthClass
import com.djtech.monai.core.designsystem.component.rememberMonAIMessenger
import com.djtech.monai.core.designsystem.icon.MonAIIcons
import com.djtech.monai.core.designsystem.theme.MonAITheme
import com.djtech.monai.feature.export.presentation.exportcsv.ExportCsvPaneRoute
import com.djtech.monai.feature.export.presentation.exportcsv.ExportCsvSheetRoute
import com.djtech.monai.feature.settings.presentation.settings.components.SettingsAccountGroup
import com.djtech.monai.feature.settings.presentation.settings.components.SettingsAdminGroup
import com.djtech.monai.feature.settings.presentation.settings.components.SettingsAppGroup
import com.djtech.monai.feature.settings.presentation.settings.components.SettingsDialogs
import com.djtech.monai.feature.settings.presentation.settings.components.SettingsLanguageOptions
import com.djtech.monai.feature.settings.presentation.settings.components.SettingsLanguageSheet
import com.djtech.monai.feature.settings.presentation.settings.components.SettingsMenu
import com.djtech.monai.feature.settings.presentation.settings.components.SettingsMoneyGroup
import com.djtech.monai.feature.settings.presentation.settings.components.SettingsProfileCard
import com.djtech.monai.feature.settings.presentation.settings.components.SettingsThemeOptions
import com.djtech.monai.feature.settings.presentation.settings.components.SettingsThemeSheet
import com.djtech.monai.feature.settings.presentation.settings.components.SettingsVersion
import com.djtech.monai.feature.settings.presentation.settings.model.SettingsPane
import com.djtech.monai.feature.settings.presentation.settings.model.SettingsSheet
import com.djtech.monai.feature.settings.presentation.settings.preview.SettingsPreviewData
import java.time.YearMonth

/**
 * @param detailPane draws [SettingsPane.Profile], [SettingsPane.Budget] (for the given month),
 *   [SettingsPane.Categories] and [SettingsPane.Providers] next to the menu on a wide screen; Theme,
 *   Language and Export are drawn here.
 */
@Composable
fun SettingsRoute(
    onNavigate: (SettingsDestination) -> Unit,
    detailPane: @Composable (pane: SettingsPane, month: YearMonth, modifier: Modifier) -> Unit,
    modifier: Modifier = Modifier,
    viewModel: SettingsViewModel = hiltViewModel(),
) {
    val state by viewModel.state.collectAsStateWithLifecycle()
    val messenger = rememberMonAIMessenger()
    val offlineIcon = MonAIIcons.CloudOff
    CollectEffects(viewModel.effects) { effect ->
        when (effect) {
            is SettingsEffect.Navigate -> onNavigate(effect.destination)
            is SettingsEffect.ShowMessage ->
                messenger.show(effect.message, icon = if (effect.isOffline) offlineIcon else null)
        }
    }
    SettingsScreen(
        state,
        viewModel::onIntent,
        modifier,
        widthClass = currentWidthClass(),
        snackbarHostState = messenger.hostState,
        detailPane = detailPane,
    )
}

/**
 * The profile card and the Money, App, Admin and Account groups. A wide screen shows a menu with
 * the picked section beside it.
 */
@Composable
fun SettingsScreen(
    state: SettingsState,
    onIntent: (SettingsIntent) -> Unit,
    modifier: Modifier = Modifier,
    widthClass: MonAIWidthClass = MonAIWidthClass.Compact,
    snackbarHostState: SnackbarHostState = remember { SnackbarHostState() },
    detailPane: @Composable (pane: SettingsPane, month: YearMonth, modifier: Modifier) -> Unit = { _, _, _ -> },
) {
    val statusBar = WindowInsets.statusBars.asPaddingValues()
    val contentPadding = PaddingValues(
        top = statusBar.calculateTopPadding() + MonAITheme.spacing.screenTop,
        bottom = MonAITheme.spacing.screenTop,
    )
    Box(
        modifier
            .fillMaxSize()
            .background(MonAITheme.colors.background),
    ) {
        when (widthClass) {
            MonAIWidthClass.Compact -> SettingsList(
                state,
                onIntent,
                contentPadding,
                Modifier.fillMaxSize(),
            )

            MonAIWidthClass.Medium -> Box(Modifier.fillMaxSize(), contentAlignment = Alignment.TopCenter) {
                SettingsList(
                    state,
                    onIntent,
                    contentPadding,
                    Modifier
                        .widthIn(max = 720.dp)
                        .fillMaxSize(),
                )
            }

            MonAIWidthClass.Expanded -> Row(Modifier.fillMaxSize()) {
                SettingsMenu(
                    state,
                    onIntent,
                    contentPadding,
                    Modifier
                        .width(360.dp)
                        .fillMaxHeight(),
                )
                VerticalDivider(color = MonAITheme.colors.border)
                SettingsPaneContent(
                    state,
                    onIntent,
                    detailPane,
                    contentPadding,
                    Modifier
                        .weight(1f)
                        .fillMaxHeight(),
                )
            }
        }
        MonAISnackbarHost(snackbarHostState, Modifier.align(Alignment.BottomCenter))
    }
    // The wide layout shows the pickers in the pane instead.
    if (widthClass != MonAIWidthClass.Expanded) {
        when (state.sheet) {
            SettingsSheet.Theme -> SettingsThemeSheet(
                state.themeMode,
                onPick = { onIntent(SettingsIntent.PickTheme(it)) },
                onDismiss = { onIntent(SettingsIntent.DismissSheet) },
            )

            SettingsSheet.Language -> SettingsLanguageSheet(
                state.language,
                onPick = { onIntent(SettingsIntent.PickLanguage(it)) },
                onDismiss = { onIntent(SettingsIntent.DismissSheet) },
            )

            SettingsSheet.Export -> ExportCsvSheetRoute(
                onDismiss = { onIntent(SettingsIntent.DismissSheet) },
                onExported = { onIntent(SettingsIntent.ExportFinished(it)) },
            )

            null -> Unit
        }
    }
    SettingsDialogs(
        state.dialog,
        onConfirm = { onIntent(SettingsIntent.ConfirmDialog) },
        onDismiss = { onIntent(SettingsIntent.DismissDialog) },
    )
}

@Composable
private fun SettingsList(
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
            .padding(horizontal = spacing.screenHorizontal),
        verticalArrangement = Arrangement.spacedBy(spacing.x4),
    ) {
        MonAIScreenTitle(stringResource(R.string.settings_title))
        SettingsProfileCard(
            state.profile,
            onClick = { onIntent(SettingsIntent.Open(SettingsDestination.EditProfile())) },
        )
        SettingsMoneyGroup(state, onIntent)
        SettingsAppGroup(state, onIntent)
        if (state.showAdmin) SettingsAdminGroup(onIntent)
        SettingsAccountGroup(state.isSigningOut, onIntent)
        SettingsVersion(state.appVersion)
    }
}

/**
 * The wide layout's right side: the theme and language pickers and the CSV export inline, other
 * sections from [detailPane].
 */
@Composable
private fun SettingsPaneContent(
    state: SettingsState,
    onIntent: (SettingsIntent) -> Unit,
    detailPane: @Composable (pane: SettingsPane, month: YearMonth, modifier: Modifier) -> Unit,
    contentPadding: PaddingValues,
    modifier: Modifier = Modifier,
) {
    val spacing = MonAITheme.spacing
    when (state.pane) {
        SettingsPane.Theme, SettingsPane.Language -> Column(
            modifier
                .verticalScroll(rememberScrollState())
                .padding(contentPadding)
                .padding(horizontal = spacing.x10),
            verticalArrangement = Arrangement.spacedBy(spacing.sectionGap),
        ) {
            if (state.pane == SettingsPane.Theme) {
                MonAIScreenTitle(stringResource(R.string.settings_theme))
                SettingsThemeOptions(
                    state.themeMode,
                    onPick = { onIntent(SettingsIntent.PickTheme(it)) },
                    modifier = Modifier.widthIn(max = 640.dp),
                )
            } else {
                MonAIScreenTitle(stringResource(R.string.settings_language))
                SettingsLanguageOptions(
                    state.language,
                    onPick = { onIntent(SettingsIntent.PickLanguage(it)) },
                    modifier = Modifier.widthIn(max = 560.dp),
                )
            }
        }

        SettingsPane.Export -> ExportCsvPaneRoute(
            onExported = { onIntent(SettingsIntent.ExportFinished(it)) },
            modifier = modifier
                .verticalScroll(rememberScrollState())
                .padding(contentPadding)
                .padding(horizontal = spacing.x10),
        )

        else -> detailPane(state.pane, state.month, modifier.fillMaxWidth())
    }
}

@PreviewLightDark
@Composable
private fun SettingsScreenPreview() {
    MonAITheme {
        SettingsScreen(SettingsPreviewData.admin, onIntent = {})
    }
}

@PreviewLightDark
@Composable
private fun SettingsScreenUserPreview() {
    MonAITheme {
        SettingsScreen(SettingsPreviewData.user, onIntent = {})
    }
}

@PreviewScreenSizes
@Composable
private fun SettingsScreenExpandedPreview() {
    MonAITheme {
        SettingsScreen(
            SettingsPreviewData.admin.copy(pane = SettingsPane.Theme),
            onIntent = {},
            widthClass = MonAIWidthClass.Expanded,
        )
    }
}
