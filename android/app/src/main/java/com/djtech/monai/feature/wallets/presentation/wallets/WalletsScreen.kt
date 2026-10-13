package com.djtech.monai.feature.wallets.presentation.wallets

import androidx.compose.foundation.background
import androidx.compose.foundation.layout.Arrangement
import androidx.compose.foundation.layout.Box
import androidx.compose.foundation.layout.PaddingValues
import androidx.compose.foundation.layout.Row
import androidx.compose.foundation.layout.WindowInsets
import androidx.compose.foundation.layout.asPaddingValues
import androidx.compose.foundation.layout.fillMaxHeight
import androidx.compose.foundation.layout.fillMaxSize
import androidx.compose.foundation.layout.padding
import androidx.compose.foundation.layout.statusBars
import androidx.compose.foundation.layout.width
import androidx.compose.foundation.layout.widthIn
import androidx.compose.foundation.lazy.LazyColumn
import androidx.compose.foundation.lazy.items
import androidx.compose.material3.ExperimentalMaterial3Api
import androidx.compose.material3.SnackbarHostState
import androidx.compose.material3.VerticalDivider
import androidx.compose.material3.pulltorefresh.PullToRefreshBox
import androidx.compose.runtime.Composable
import androidx.compose.runtime.getValue
import androidx.compose.runtime.remember
import androidx.compose.runtime.rememberCoroutineScope
import androidx.compose.ui.Alignment
import androidx.compose.ui.Modifier
import androidx.compose.ui.platform.LocalContext
import androidx.compose.ui.platform.testTag
import androidx.compose.ui.tooling.preview.Preview
import androidx.compose.ui.tooling.preview.PreviewLightDark
import androidx.compose.ui.unit.dp
import androidx.hilt.lifecycle.viewmodel.compose.hiltViewModel
import androidx.lifecycle.compose.collectAsStateWithLifecycle
import com.djtech.monai.R
import com.djtech.monai.core.common.ui.CollectEffects
import com.djtech.monai.core.common.ui.UiText
import com.djtech.monai.core.designsystem.component.MonAISnackbarHost
import com.djtech.monai.core.designsystem.component.MonAISnackbarVisuals
import com.djtech.monai.core.designsystem.component.MonAIWidthClass
import com.djtech.monai.core.designsystem.component.currentWidthClass
import com.djtech.monai.core.designsystem.icon.MonAIIcons
import com.djtech.monai.core.designsystem.theme.MonAITheme
import com.djtech.monai.feature.wallets.presentation.wallets.components.WalletsArchivedLink
import com.djtech.monai.feature.wallets.presentation.wallets.components.WalletsCard
import com.djtech.monai.feature.wallets.presentation.wallets.components.WalletsEmpty
import com.djtech.monai.feature.wallets.presentation.wallets.components.WalletsHeader
import com.djtech.monai.feature.wallets.presentation.wallets.components.WalletsLoadError
import com.djtech.monai.feature.wallets.presentation.wallets.components.WalletsSkeleton
import com.djtech.monai.feature.wallets.presentation.wallets.components.WalletsTotalCard
import com.djtech.monai.feature.wallets.presentation.wallets.preview.WalletsPreviewData
import kotlinx.coroutines.launch

internal object WalletsTestTags {
    const val LIST = "wallets_list"
}

/**
 * The Wallets tab.
 *
 * @param detailPane the detail screen of the wallet picked on a wide screen; the list sits beside it.
 */
@Composable
fun WalletsRoute(
    onNavigate: (WalletsDestination) -> Unit,
    detailPane: @Composable (id: String, modifier: Modifier) -> Unit,
    modifier: Modifier = Modifier,
    viewModel: WalletsViewModel = hiltViewModel(),
) {
    val state by viewModel.state.collectAsStateWithLifecycle()
    val snackbarHostState = remember { SnackbarHostState() }
    val scope = rememberCoroutineScope()
    val context = LocalContext.current
    val offlineIcon = MonAIIcons.CloudOff
    CollectEffects(viewModel.effects) { effect ->
        when (effect) {
            is WalletsEffect.Navigate -> onNavigate(effect.destination)
            is WalletsEffect.ShowMessage -> scope.launch {
                snackbarHostState.showSnackbar(
                    MonAISnackbarVisuals(
                        effect.message.asString(context),
                        icon = if (effect.isOffline) offlineIcon else null,
                    ),
                )
            }
        }
    }
    WalletsScreen(
        state,
        viewModel::onIntent,
        modifier,
        widthClass = currentWidthClass(),
        snackbarHostState = snackbarHostState,
        detailPane = detailPane,
    )
}

/**
 * One pane on phones and tablet portrait (centered), the list beside the picked wallet's detail on
 * tablet landscape. The skeleton while the first load runs, or the error when it failed.
 */
@OptIn(ExperimentalMaterial3Api::class)
@Composable
fun WalletsScreen(
    state: WalletsState,
    onIntent: (WalletsIntent) -> Unit,
    modifier: Modifier = Modifier,
    widthClass: MonAIWidthClass = MonAIWidthClass.Compact,
    snackbarHostState: SnackbarHostState = remember { SnackbarHostState() },
    detailPane: @Composable (id: String, modifier: Modifier) -> Unit = { _, _ -> },
) {
    val statusBar = WindowInsets.statusBars.asPaddingValues()
    val contentPadding = PaddingValues(
        top = statusBar.calculateTopPadding() + MonAITheme.spacing.screenTop,
        bottom = MonAITheme.spacing.screenTop,
    )
    val isWide = widthClass == MonAIWidthClass.Expanded
    val list = @Composable { listModifier: Modifier ->
        when {
            state.isLoading -> WalletsSkeleton(contentPadding, listModifier)
            state.loadError != null -> WalletsLoadError(
                state.loadError,
                onRetry = { onIntent(WalletsIntent.Refresh) },
                contentPadding = contentPadding,
                modifier = listModifier,
            )

            else -> PullToRefreshBox(
                isRefreshing = state.isRefreshing,
                onRefresh = { onIntent(WalletsIntent.Refresh) },
                modifier = listModifier,
            ) {
                WalletsList(state, onIntent, isWide, contentPadding)
            }
        }
    }
    Box(
        modifier
            .fillMaxSize()
            .background(MonAITheme.colors.background),
    ) {
        when (widthClass) {
            MonAIWidthClass.Compact -> list(Modifier.fillMaxSize())
            MonAIWidthClass.Medium -> Box(Modifier.fillMaxSize(), contentAlignment = Alignment.TopCenter) {
                list(
                    Modifier
                        .widthIn(max = 720.dp)
                        .fillMaxSize(),
                )
            }

            MonAIWidthClass.Expanded -> Row(Modifier.fillMaxSize()) {
                list(
                    Modifier
                        .width(400.dp)
                        .fillMaxHeight(),
                )
                VerticalDivider(color = MonAITheme.colors.border)
                Box(
                    Modifier
                        .weight(1f)
                        .fillMaxHeight(),
                ) {
                    state.selectedId?.let { detailPane(it, Modifier.fillMaxSize()) }
                }
            }
        }
        MonAISnackbarHost(snackbarHostState, Modifier.align(Alignment.BottomCenter))
    }
}

/** Header, total card, one card per wallet and the archived link. */
@Composable
private fun WalletsList(
    state: WalletsState,
    onIntent: (WalletsIntent) -> Unit,
    isWide: Boolean,
    contentPadding: PaddingValues,
) {
    val horizontal = Modifier.padding(horizontal = MonAITheme.spacing.screenHorizontal)
    val onAdd = { onIntent(WalletsIntent.Open(WalletsDestination.Add)) }
    LazyColumn(
        Modifier
            .fillMaxSize()
            .testTag(WalletsTestTags.LIST),
        contentPadding = contentPadding,
        verticalArrangement = Arrangement.spacedBy(MonAITheme.spacing.x4),
    ) {
        item(key = "header") { WalletsHeader(onAdd, horizontal) }
        if (state.wallets.isEmpty()) {
            item(key = "empty") { WalletsEmpty(onAdd, horizontal) }
        } else {
            item(key = "total") {
                WalletsTotalCard(
                    state.totalBalance,
                    state.wallets.size,
                    state.shares,
                    horizontal,
                )
            }
            items(state.wallets, key = { it.id }) { wallet ->
                WalletsCard(
                    wallet,
                    selected = isWide && wallet.id == state.selectedId,
                    onClick = {
                        onIntent(
                            if (isWide) {
                                WalletsIntent.Select(wallet.id)
                            } else {
                                WalletsIntent.Open(WalletsDestination.Detail(wallet.id))
                            },
                        )
                    },
                    modifier = horizontal,
                )
            }
        }
        if (state.archivedCount > 0) {
            item(key = "archived") {
                WalletsArchivedLink(
                    state.archivedCount,
                    onClick = { onIntent(WalletsIntent.Open(WalletsDestination.Archived)) },
                    modifier = horizontal,
                )
            }
        }
    }
}

@PreviewLightDark
@Composable
private fun WalletsScreenPreview() {
    MonAITheme { WalletsScreen(WalletsPreviewData.list, onIntent = {}) }
}

@Preview
@Composable
private fun WalletsLoadingPreview() {
    MonAITheme { WalletsScreen(WalletsState(), onIntent = {}) }
}

@Preview
@Composable
private fun WalletsErrorPreview() {
    MonAITheme {
        WalletsScreen(
            WalletsState(isLoading = false, loadError = UiText.Resource(R.string.wallets_load_failed_network)),
            onIntent = {},
        )
    }
}

@Preview(widthDp = 1280, heightDp = 800)
@Composable
private fun WalletsExpandedPreview() {
    MonAITheme {
        WalletsScreen(
            WalletsPreviewData.list,
            onIntent = {},
            widthClass = MonAIWidthClass.Expanded,
        )
    }
}
