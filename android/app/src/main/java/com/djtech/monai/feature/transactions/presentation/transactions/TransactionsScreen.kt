package com.djtech.monai.feature.transactions.presentation.transactions

import androidx.compose.foundation.background
import androidx.compose.foundation.layout.Box
import androidx.compose.foundation.layout.PaddingValues
import androidx.compose.foundation.layout.Row
import androidx.compose.foundation.layout.WindowInsets
import androidx.compose.foundation.layout.asPaddingValues
import androidx.compose.foundation.layout.fillMaxHeight
import androidx.compose.foundation.layout.fillMaxSize
import androidx.compose.foundation.layout.statusBars
import androidx.compose.foundation.layout.width
import androidx.compose.foundation.layout.widthIn
import androidx.compose.material3.ExperimentalMaterial3Api
import androidx.compose.material3.SnackbarHostState
import androidx.compose.material3.VerticalDivider
import androidx.compose.material3.pulltorefresh.PullToRefreshBox
import androidx.compose.runtime.Composable
import androidx.compose.runtime.LaunchedEffect
import androidx.compose.runtime.getValue
import androidx.compose.runtime.mutableStateOf
import androidx.compose.runtime.remember
import androidx.compose.runtime.rememberCoroutineScope
import androidx.compose.runtime.setValue
import androidx.compose.ui.Alignment
import androidx.compose.ui.Modifier
import androidx.compose.ui.platform.LocalContext
import androidx.compose.ui.res.stringResource
import androidx.compose.ui.tooling.preview.Preview
import androidx.compose.ui.tooling.preview.PreviewLightDark
import androidx.compose.ui.unit.dp
import androidx.hilt.lifecycle.viewmodel.compose.hiltViewModel
import androidx.lifecycle.compose.collectAsStateWithLifecycle
import androidx.paging.LoadState
import androidx.paging.PagingData
import androidx.paging.compose.LazyPagingItems
import androidx.paging.compose.collectAsLazyPagingItems
import com.djtech.monai.R
import com.djtech.monai.core.common.ui.CollectEffects
import com.djtech.monai.core.designsystem.component.MonAISnackbarHost
import com.djtech.monai.core.designsystem.component.MonAISnackbarVisuals
import com.djtech.monai.core.designsystem.component.MonAIWidthClass
import com.djtech.monai.core.designsystem.component.currentWidthClass
import com.djtech.monai.core.designsystem.icon.MonAIIcons
import com.djtech.monai.core.designsystem.theme.MonAITheme
import com.djtech.monai.feature.transactions.presentation.common.TransactionFilterSheetHost
import com.djtech.monai.feature.transactions.presentation.common.mapper.isOffline
import com.djtech.monai.feature.transactions.presentation.common.model.TransactionListItem
import com.djtech.monai.feature.transactions.presentation.transactions.components.TransactionsDetailPlaceholder
import com.djtech.monai.feature.transactions.presentation.transactions.components.TransactionsList
import com.djtech.monai.feature.transactions.presentation.transactions.preview.TransactionsPreviewData
import kotlinx.coroutines.flow.flowOf
import kotlinx.coroutines.launch

/**
 * @param detailPane the detail screen for the transaction picked on a wide screen; the list sits
 *   beside it instead of opening it.
 */
@Composable
fun TransactionsRoute(
    onNavigate: (TransactionsDestination) -> Unit,
    detailPane: @Composable (id: String, modifier: Modifier) -> Unit,
    modifier: Modifier = Modifier,
    viewModel: TransactionsViewModel = hiltViewModel(),
) {
    val state by viewModel.state.collectAsStateWithLifecycle()
    val items = viewModel.transactions.collectAsLazyPagingItems()
    val snackbarHostState = remember { SnackbarHostState() }
    val scope = rememberCoroutineScope()
    val context = LocalContext.current
    val offlineIcon = MonAIIcons.CloudOff
    CollectEffects(viewModel.effects) { effect ->
        when (effect) {
            is TransactionsEffect.Navigate -> onNavigate(effect.destination)
            is TransactionsEffect.ShowMessage -> scope.launch {
                snackbarHostState.showSnackbar(
                    MonAISnackbarVisuals(
                        effect.message.asString(context),
                        icon = if (effect.isOffline) offlineIcon else null,
                    ),
                )
            }
        }
    }
    // A failed refresh over cached rows keeps them and says so; with nothing cached the list shows the error.
    val refresh = items.loadState.refresh
    val offlineMessage = stringResource(R.string.transactions_refresh_failed_network)
    val failedMessage = stringResource(R.string.transactions_refresh_failed_unexpected)
    LaunchedEffect(refresh) {
        if (refresh is LoadState.Error && items.itemCount > 0) {
            val offline = refresh.error.isOffline()
            snackbarHostState.showSnackbar(
                MonAISnackbarVisuals(
                    if (offline) offlineMessage else failedMessage,
                    icon = if (offline) offlineIcon else null,
                ),
            )
        }
    }
    TransactionsScreen(
        state,
        items,
        viewModel::onIntent,
        modifier,
        widthClass = currentWidthClass(),
        snackbarHostState = snackbarHostState,
        detailPane = detailPane,
    )
}

/**
 * One pane on phones and tablet portrait (centered, with the net total), list and detail side by
 * side on tablet landscape.
 */
@OptIn(ExperimentalMaterial3Api::class)
@Composable
fun TransactionsScreen(
    state: TransactionsState,
    items: LazyPagingItems<TransactionListItem>,
    onIntent: (TransactionsIntent) -> Unit,
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
    val retry = {
        items.retry()
        onIntent(TransactionsIntent.Refresh)
    }
    val isWide = widthClass == MonAIWidthClass.Expanded
    // The indicator is only for a pull; first loads and reloads after a save refresh quietly.
    var isPulled by remember { mutableStateOf(false) }
    val refresh = items.loadState.refresh
    LaunchedEffect(refresh) {
        if (refresh !is LoadState.Loading) isPulled = false
    }
    val list = @Composable { listModifier: Modifier ->
        PullToRefreshBox(
            isRefreshing = isPulled && items.itemCount > 0,
            onRefresh = {
                isPulled = true
                items.refresh()
                onIntent(TransactionsIntent.Refresh)
            },
            modifier = listModifier,
        ) {
            TransactionsList(
                state = state,
                items = items,
                onIntent = onIntent,
                onRowClick = { id ->
                    onIntent(
                        if (isWide) {
                            TransactionsIntent.Select(id)
                        } else {
                            TransactionsIntent.Open(TransactionsDestination.Detail(id))
                        },
                    )
                },
                onRetry = retry,
                showNet = widthClass != MonAIWidthClass.Compact && !isWide,
                contentPadding = contentPadding,
            )
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
                        .width(440.dp)
                        .fillMaxHeight(),
                )
                VerticalDivider(color = MonAITheme.colors.border)
                Box(
                    Modifier
                        .weight(1f)
                        .fillMaxHeight(),
                ) {
                    val selected = state.selectedId
                    if (selected == null) {
                        TransactionsDetailPlaceholder()
                    } else {
                        detailPane(selected, Modifier.fillMaxSize())
                    }
                }
            }
        }
        MonAISnackbarHost(snackbarHostState, Modifier.align(Alignment.BottomCenter))
    }
    TransactionFilterSheetHost(
        sheet = state.sheet,
        month = state.month,
        currentMonth = state.currentMonth,
        wallets = state.wallets,
        categories = state.categories,
        totals = state.totals,
        monthPickerTotals = state.monthPickerTotals,
        onIntent = { onIntent(TransactionsIntent.Filter(it)) },
    )
}

@Composable
private fun previewItems(items: List<TransactionListItem>) =
    remember(items) { flowOf(PagingData.from(items)) }.collectAsLazyPagingItems()

@PreviewLightDark
@Composable
private fun TransactionsScreenPreview() {
    MonAITheme {
        TransactionsScreen(TransactionsPreviewData.state, previewItems(TransactionsPreviewData.items), onIntent = {})
    }
}

@Preview
@Composable
private fun TransactionsEmptyPreview() {
    MonAITheme {
        TransactionsScreen(TransactionsPreviewData.state, previewItems(emptyList()), onIntent = {})
    }
}

@Preview(widthDp = 1040, heightDp = 800)
@Composable
private fun TransactionsExpandedPreview() {
    MonAITheme {
        TransactionsScreen(
            TransactionsPreviewData.state,
            previewItems(TransactionsPreviewData.items),
            onIntent = {},
            widthClass = MonAIWidthClass.Expanded,
        )
    }
}
