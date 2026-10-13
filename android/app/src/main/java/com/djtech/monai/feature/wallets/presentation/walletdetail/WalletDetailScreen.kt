package com.djtech.monai.feature.wallets.presentation.walletdetail

import androidx.compose.foundation.background
import androidx.compose.foundation.layout.Box
import androidx.compose.foundation.layout.Column
import androidx.compose.foundation.layout.PaddingValues
import androidx.compose.foundation.layout.WindowInsets
import androidx.compose.foundation.layout.asPaddingValues
import androidx.compose.foundation.layout.fillMaxSize
import androidx.compose.foundation.layout.fillMaxWidth
import androidx.compose.foundation.layout.navigationBars
import androidx.compose.foundation.layout.padding
import androidx.compose.foundation.layout.statusBars
import androidx.compose.foundation.lazy.LazyColumn
import androidx.compose.foundation.shape.RoundedCornerShape
import androidx.compose.material3.SnackbarHostState
import androidx.compose.material3.Text
import androidx.compose.runtime.Composable
import androidx.compose.runtime.getValue
import androidx.compose.runtime.remember
import androidx.compose.runtime.rememberCoroutineScope
import androidx.compose.ui.Alignment
import androidx.compose.ui.Modifier
import androidx.compose.ui.draw.clip
import androidx.compose.ui.graphics.RectangleShape
import androidx.compose.ui.platform.LocalContext
import androidx.compose.ui.platform.testTag
import androidx.compose.ui.res.stringResource
import androidx.compose.ui.tooling.preview.Preview
import androidx.compose.ui.tooling.preview.PreviewLightDark
import androidx.hilt.lifecycle.viewmodel.compose.hiltViewModel
import androidx.lifecycle.compose.collectAsStateWithLifecycle
import androidx.paging.LoadState
import androidx.paging.PagingData
import androidx.paging.compose.LazyPagingItems
import androidx.paging.compose.collectAsLazyPagingItems
import androidx.paging.compose.itemKey
import com.djtech.monai.R
import com.djtech.monai.core.common.ui.CollectEffects
import com.djtech.monai.core.common.ui.UiText
import com.djtech.monai.core.designsystem.component.MonAICard
import com.djtech.monai.core.designsystem.component.MonAISectionHeader
import com.djtech.monai.core.designsystem.component.MonAISnackbarHost
import com.djtech.monai.core.designsystem.component.MonAISnackbarVisuals
import com.djtech.monai.core.designsystem.component.MonAITopBar
import com.djtech.monai.core.designsystem.component.MonAITopBarNavigation
import com.djtech.monai.core.designsystem.theme.MonAITheme
import com.djtech.monai.core.model.Transaction
import com.djtech.monai.feature.wallets.presentation.walletdetail.components.WalletDetailActions
import com.djtech.monai.feature.wallets.presentation.walletdetail.components.WalletDetailChart
import com.djtech.monai.feature.wallets.presentation.walletdetail.components.WalletDetailDialogs
import com.djtech.monai.feature.wallets.presentation.walletdetail.components.WalletDetailHero
import com.djtech.monai.feature.wallets.presentation.walletdetail.components.WalletDetailLoadError
import com.djtech.monai.feature.wallets.presentation.walletdetail.components.WalletDetailMenu
import com.djtech.monai.feature.wallets.presentation.walletdetail.components.WalletDetailSkeleton
import com.djtech.monai.feature.wallets.presentation.walletdetail.components.WalletDetailTransactionRow
import com.djtech.monai.feature.wallets.presentation.walletdetail.mapper.toWalletRow
import com.djtech.monai.feature.wallets.presentation.walletdetail.preview.WalletDetailPreviewData
import kotlinx.coroutines.flow.flowOf
import kotlinx.coroutines.launch

internal object WalletDetailTestTags {
    const val LIST = "wallet_detail_list"
}

/**
 * @param onDeleted the wallet was deleted from here; close its screens.
 * @param isPane shown beside the wallet list on a wide screen: no back button, no status-bar inset.
 */
@Composable
fun WalletDetailRoute(
    walletId: String,
    onNavigate: (WalletDetailDestination) -> Unit,
    onBack: () -> Unit,
    onDeleted: (String) -> Unit,
    modifier: Modifier = Modifier,
    isPane: Boolean = false,
    viewModel: WalletDetailViewModel =
        hiltViewModel<WalletDetailViewModel, WalletDetailViewModel.Factory>(key = walletId) { it.create(walletId) },
) {
    val state by viewModel.state.collectAsStateWithLifecycle()
    val items = viewModel.transactions.collectAsLazyPagingItems()
    val snackbarHostState = remember { SnackbarHostState() }
    val scope = rememberCoroutineScope()
    val context = LocalContext.current
    CollectEffects(viewModel.effects) { effect ->
        when (effect) {
            WalletDetailEffect.NavigateBack -> onBack()
            is WalletDetailEffect.Navigate -> onNavigate(effect.destination)
            is WalletDetailEffect.Deleted -> onDeleted(effect.id)
            is WalletDetailEffect.ShowMessage -> scope.launch {
                snackbarHostState.showSnackbar(MonAISnackbarVisuals(effect.message.asString(context)))
            }
        }
    }
    WalletDetailScreen(
        state,
        items,
        viewModel::onIntent,
        modifier,
        isPane = isPane,
        snackbarHostState = snackbarHostState,
    )
}

/** The wallet card, its actions, this month's money out and its transactions. */
@Composable
fun WalletDetailScreen(
    state: WalletDetailState,
    items: LazyPagingItems<Transaction>,
    onIntent: (WalletDetailIntent) -> Unit,
    modifier: Modifier = Modifier,
    isPane: Boolean = false,
    snackbarHostState: SnackbarHostState = remember { SnackbarHostState() },
) {
    Box(
        modifier
            .fillMaxSize()
            .background(MonAITheme.colors.background),
    ) {
        Column(Modifier.fillMaxSize()) {
            MonAITopBar(
                title = stringResource(R.string.wallet_detail_title),
                navigation = if (isPane) MonAITopBarNavigation.None else MonAITopBarNavigation.Back,
                onNavigationClick = { onIntent(WalletDetailIntent.Back) },
                windowInsets = if (isPane) WindowInsets(0) else WindowInsets.statusBars,
                actions = { WalletDetailMenu(state, onIntent) },
            )
            val wallet = state.wallet
            when {
                wallet != null -> WalletDetailContent(state, items, onIntent)
                state.loadError != null -> WalletDetailLoadError(
                    state.loadError,
                    onRetry = { onIntent(WalletDetailIntent.Retry) },
                )

                else -> WalletDetailSkeleton()
            }
        }
        MonAISnackbarHost(snackbarHostState, Modifier.align(Alignment.BottomCenter))
    }
    state.wallet?.let { WalletDetailDialogs(state.dialog, it.name, onIntent) }
}

@Composable
private fun WalletDetailContent(
    state: WalletDetailState,
    items: LazyPagingItems<Transaction>,
    onIntent: (WalletDetailIntent) -> Unit,
) {
    val wallet = state.wallet ?: return
    val spacing = MonAITheme.spacing
    val horizontal = Modifier.padding(horizontal = spacing.screenHorizontal)
    val radius = MonAITheme.radius.lg
    // Rows sit flush as one card, so the sections space themselves instead of the list.
    val section = horizontal.padding(bottom = spacing.x4)
    LazyColumn(
        Modifier
            .fillMaxSize()
            .testTag(WalletDetailTestTags.LIST),
        contentPadding = PaddingValues(
            top = spacing.x2,
            bottom = spacing.screenTop + WindowInsets.navigationBars.asPaddingValues().calculateBottomPadding(),
        ),
    ) {
        item(key = "hero") { WalletDetailHero(wallet, section) }
        item(key = "actions") { WalletDetailActions(state, onIntent, section) }
        item(key = "chart") {
            WalletDetailChart(
                wallet.name,
                state.month,
                state.today,
                state.outflows,
                state.outflowTotal,
                section,
            )
        }
        item(key = "monthHeader") {
            MonAISectionHeader(
                stringResource(R.string.wallet_detail_this_month),
                horizontal.padding(bottom = spacing.x2),
                style = MonAITheme.typography.titleMedium,
            )
        }
        if (items.itemCount == 0 && items.loadState.refresh !is LoadState.Loading) {
            item(key = "noTransactions") {
                MonAICard(horizontal.fillMaxWidth()) {
                    Text(
                        stringResource(R.string.wallet_detail_no_transactions),
                        style = MonAITheme.typography.bodyMedium,
                        color = MonAITheme.colors.textSecondary,
                    )
                }
            }
        }
        // The rows read as one card: each is a slice of it, rounded only at the ends.
        items(items.itemCount, key = items.itemKey(Transaction::id)) { index ->
            val transaction = items[index] ?: return@items
            val isFirst = index == 0
            val isLast = index == items.itemCount - 1
            val shape = when {
                isFirst && isLast -> RoundedCornerShape(radius)
                isFirst -> RoundedCornerShape(topStart = radius, topEnd = radius)
                isLast -> RoundedCornerShape(bottomStart = radius, bottomEnd = radius)
                else -> RectangleShape
            }
            val row = remember(transaction, state.lookups) { transaction.toWalletRow(wallet.id, state.lookups) }
            WalletDetailTransactionRow(
                row,
                onClick = { onIntent(WalletDetailIntent.OpenTransaction(transaction.id)) },
                showDivider = !isLast,
                modifier = horizontal.clip(shape),
            )
        }
    }
}

@Composable
private fun previewItems(items: List<Transaction>) =
    remember(items) { flowOf(PagingData.from(items)) }.collectAsLazyPagingItems()

@PreviewLightDark
@Composable
private fun WalletDetailScreenPreview() {
    MonAITheme {
        WalletDetailScreen(
            WalletDetailPreviewData.state,
            previewItems(WalletDetailPreviewData.transactions),
            onIntent = {},
        )
    }
}

@Preview
@Composable
private fun WalletDetailErrorPreview() {
    MonAITheme {
        WalletDetailScreen(
            WalletDetailPreviewData.state.copy(
                wallet = null,
                isLoading = false,
                loadError = UiText.Resource(R.string.wallets_error_not_found),
            ),
            previewItems(emptyList()),
            onIntent = {},
        )
    }
}
