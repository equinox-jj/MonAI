package com.djtech.monai.feature.settings.presentation.manageproviders

import androidx.compose.foundation.background
import androidx.compose.foundation.layout.Arrangement
import androidx.compose.foundation.layout.Box
import androidx.compose.foundation.layout.Column
import androidx.compose.foundation.layout.PaddingValues
import androidx.compose.foundation.layout.WindowInsets
import androidx.compose.foundation.layout.asPaddingValues
import androidx.compose.foundation.layout.fillMaxSize
import androidx.compose.foundation.layout.fillMaxWidth
import androidx.compose.foundation.layout.navigationBars
import androidx.compose.foundation.layout.navigationBarsPadding
import androidx.compose.foundation.layout.padding
import androidx.compose.foundation.layout.statusBars
import androidx.compose.foundation.lazy.LazyColumn
import androidx.compose.foundation.lazy.itemsIndexed
import androidx.compose.foundation.shape.RoundedCornerShape
import androidx.compose.material3.ExperimentalMaterial3Api
import androidx.compose.material3.SnackbarHostState
import androidx.compose.material3.Text
import androidx.compose.material3.pulltorefresh.PullToRefreshBox
import androidx.compose.runtime.Composable
import androidx.compose.runtime.getValue
import androidx.compose.runtime.remember
import androidx.compose.runtime.rememberCoroutineScope
import androidx.compose.ui.Alignment
import androidx.compose.ui.Modifier
import androidx.compose.ui.draw.clip
import androidx.compose.ui.platform.LocalContext
import androidx.compose.ui.res.stringResource
import androidx.compose.ui.tooling.preview.PreviewLightDark
import androidx.compose.ui.unit.dp
import androidx.hilt.lifecycle.viewmodel.compose.hiltViewModel
import androidx.lifecycle.compose.collectAsStateWithLifecycle
import com.djtech.monai.R
import com.djtech.monai.core.common.ui.CollectEffects
import com.djtech.monai.core.designsystem.component.MonAIAlertTone
import com.djtech.monai.core.designsystem.component.MonAIButton
import com.djtech.monai.core.designsystem.component.MonAIDivider
import com.djtech.monai.core.designsystem.component.MonAISearchField
import com.djtech.monai.core.designsystem.component.MonAISkeleton
import com.djtech.monai.core.designsystem.component.MonAISnackbarHost
import com.djtech.monai.core.designsystem.component.MonAISnackbarVisuals
import com.djtech.monai.core.designsystem.component.MonAIStateMessage
import com.djtech.monai.core.designsystem.component.MonAITag
import com.djtech.monai.core.designsystem.component.MonAITopBar
import com.djtech.monai.core.designsystem.component.MonAITopBarNavigation
import com.djtech.monai.core.designsystem.icon.MonAIIcons
import com.djtech.monai.core.designsystem.theme.MonAITheme
import com.djtech.monai.feature.settings.presentation.manageproviders.components.ManageProvidersRow
import com.djtech.monai.feature.settings.presentation.manageproviders.preview.ManageProvidersPreviewData
import kotlinx.coroutines.launch

/**
 * @param onOpenForm opens the provider form; a null id adds one.
 * @param isPane shown beside the Settings menu: no back button, no status-bar inset.
 */
@Composable
fun ManageProvidersRoute(
    onOpenForm: (id: String?) -> Unit,
    onBack: () -> Unit,
    modifier: Modifier = Modifier,
    isPane: Boolean = false,
    viewModel: ManageProvidersViewModel = hiltViewModel(),
) {
    val state by viewModel.state.collectAsStateWithLifecycle()
    val snackbarHostState = remember { SnackbarHostState() }
    val scope = rememberCoroutineScope()
    val context = LocalContext.current
    CollectEffects(viewModel.effects) { effect ->
        when (effect) {
            ManageProvidersEffect.Close -> onBack()
            is ManageProvidersEffect.OpenForm -> onOpenForm(effect.id)
            is ManageProvidersEffect.ShowMessage -> scope.launch {
                snackbarHostState.showSnackbar(MonAISnackbarVisuals(effect.message.asString(context)))
            }
        }
    }
    ManageProvidersScreen(
        state,
        viewModel::onIntent,
        modifier,
        isPane = isPane,
        snackbarHostState = snackbarHostState,
    )
}

/** Every provider with its status, a search over names and aliases, and Add at the bottom. */
@OptIn(ExperimentalMaterial3Api::class)
@Composable
fun ManageProvidersScreen(
    state: ManageProvidersState,
    onIntent: (ManageProvidersIntent) -> Unit,
    modifier: Modifier = Modifier,
    isPane: Boolean = false,
    snackbarHostState: SnackbarHostState = remember { SnackbarHostState() },
) {
    val spacing = MonAITheme.spacing
    Box(
        modifier
            .fillMaxSize()
            .background(MonAITheme.colors.background),
    ) {
        Column(Modifier.fillMaxSize()) {
            MonAITopBar(
                title = stringResource(R.string.providers_title),
                navigation = if (isPane) MonAITopBarNavigation.None else MonAITopBarNavigation.Back,
                onNavigationClick = { onIntent(ManageProvidersIntent.Back) },
                navigationContentDescription = stringResource(R.string.providers_back),
                windowInsets = if (isPane) WindowInsets(0) else WindowInsets.statusBars,
                actions = { MonAITag(stringResource(R.string.providers_admin).uppercase()) },
            )
            MonAISearchField(
                value = state.query,
                onValueChange = { onIntent(ManageProvidersIntent.QueryChanged(it)) },
                placeholder = stringResource(R.string.providers_search),
                modifier = Modifier.padding(horizontal = spacing.screenHorizontal, vertical = spacing.x2),
            )
            Box(Modifier.weight(1f)) {
                when {
                    state.isLoading -> ProvidersSkeleton()
                    state.loadError != null -> MonAIStateMessage(
                        icon = MonAIIcons.CloudOff,
                        title = stringResource(R.string.providers_load_error_title),
                        message = state.loadError.asString(),
                        modifier = Modifier.padding(spacing.screenHorizontal),
                        tone = MonAIAlertTone.Error,
                        actionLabel = stringResource(R.string.providers_retry),
                        actionIcon = MonAIIcons.Refresh,
                        onAction = { onIntent(ManageProvidersIntent.Refresh) },
                    )

                    else -> PullToRefreshBox(
                        isRefreshing = state.isRefreshing,
                        onRefresh = { onIntent(ManageProvidersIntent.Refresh) },
                    ) {
                        ProvidersList(state, onIntent)
                    }
                }
            }
            if (state.canCreate) {
                MonAIButton(
                    stringResource(R.string.providers_add),
                    onClick = { onIntent(ManageProvidersIntent.Add) },
                    modifier = Modifier
                        .fillMaxWidth()
                        .navigationBarsPadding()
                        .padding(horizontal = spacing.screenHorizontal, vertical = spacing.x3),
                    leadingIcon = MonAIIcons.Add,
                )
            }
        }
        MonAISnackbarHost(snackbarHostState, Modifier.align(Alignment.BottomCenter))
    }
}

@Composable
private fun ProvidersList(state: ManageProvidersState, onIntent: (ManageProvidersIntent) -> Unit) {
    val spacing = MonAITheme.spacing
    val colors = MonAITheme.colors
    val radius = MonAITheme.radius.lg
    val lastIndex = state.rows.lastIndex
    val bottomInset = if (state.canCreate) {
        spacing.x2
    } else {
        spacing.x6 + WindowInsets.navigationBars.asPaddingValues().calculateBottomPadding()
    }
    LazyColumn(
        Modifier.fillMaxSize(),
        contentPadding = PaddingValues(
            start = spacing.screenHorizontal,
            end = spacing.screenHorizontal,
            top = spacing.x2,
            bottom = bottomInset,
        ),
    ) {
        if (state.rows.isEmpty()) {
            item(key = "empty") {
                Text(
                    if (state.totalCount == 0) {
                        stringResource(R.string.providers_empty)
                    } else {
                        stringResource(R.string.providers_empty_search, state.query)
                    },
                    Modifier.padding(vertical = spacing.x6),
                    style = MonAITheme.typography.bodyMedium,
                    color = colors.textTertiary,
                )
            }
        }
        // One card drawn row by row: the first and last round its corners.
        itemsIndexed(state.rows, key = { _, row -> row.id }) { index, row ->
            val top = if (index == 0) radius else 0.dp
            val bottom = if (index == lastIndex) radius else 0.dp
            val shape = RoundedCornerShape(
                topStart = top,
                topEnd = top,
                bottomStart = bottom,
                bottomEnd = bottom,
            )
            Column(
                Modifier
                    .clip(shape)
                    .background(colors.surface),
            ) {
                ManageProvidersRow(row, state.canEdit, onOpen = { onIntent(ManageProvidersIntent.Open(row.id)) })
                if (index != lastIndex) MonAIDivider()
            }
        }
    }
}

@Composable
private fun ProvidersSkeleton() {
    val spacing = MonAITheme.spacing
    Column(
        Modifier.padding(horizontal = spacing.screenHorizontal, vertical = spacing.x2),
        verticalArrangement = Arrangement.spacedBy(spacing.x3),
    ) {
        repeat(SKELETON_ROWS) {
            MonAISkeleton(height = MonAITheme.sizes.listRowMin, modifier = Modifier.fillMaxWidth())
        }
    }
}

@PreviewLightDark
@Composable
private fun ManageProvidersScreenPreview() {
    MonAITheme {
        ManageProvidersScreen(ManageProvidersPreviewData.state, onIntent = {})
    }
}

private const val SKELETON_ROWS = 6
