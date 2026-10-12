package com.djtech.monai.feature.transactions.presentation.transactions.components

import androidx.compose.foundation.background
import androidx.compose.foundation.layout.Arrangement
import androidx.compose.foundation.layout.Box
import androidx.compose.foundation.layout.Column
import androidx.compose.foundation.layout.PaddingValues
import androidx.compose.foundation.layout.fillMaxSize
import androidx.compose.foundation.layout.fillMaxWidth
import androidx.compose.foundation.layout.height
import androidx.compose.foundation.layout.padding
import androidx.compose.foundation.layout.size
import androidx.compose.foundation.lazy.LazyColumn
import androidx.compose.foundation.lazy.LazyListScope
import androidx.compose.material3.CircularProgressIndicator
import androidx.compose.material3.Text
import androidx.compose.runtime.Composable
import androidx.compose.ui.Alignment
import androidx.compose.ui.Modifier
import androidx.compose.ui.platform.testTag
import androidx.compose.ui.res.stringResource
import androidx.compose.ui.unit.dp
import androidx.paging.LoadState
import androidx.paging.compose.LazyPagingItems
import androidx.paging.compose.itemContentType
import androidx.paging.compose.itemKey
import com.djtech.monai.R
import com.djtech.monai.core.designsystem.component.MonAIButton
import com.djtech.monai.core.designsystem.component.MonAIButtonSize
import com.djtech.monai.core.designsystem.component.MonAIButtonVariant
import com.djtech.monai.core.designsystem.component.MonAIDivider
import com.djtech.monai.core.designsystem.theme.MonAITheme
import com.djtech.monai.feature.transactions.presentation.common.mapper.isOffline
import com.djtech.monai.feature.transactions.presentation.common.model.TransactionListItem
import com.djtech.monai.feature.transactions.presentation.transactions.TransactionsIntent
import com.djtech.monai.feature.transactions.presentation.transactions.TransactionsState

internal object TransactionsTestTags {
    const val LIST = "transactions_list"
}

/**
 * The header, filters and totals, then the month's day groups. [onRowClick] opens a row, or
 * selects it for the detail pane on a wide screen.
 */
@Composable
internal fun TransactionsList(
    state: TransactionsState,
    items: LazyPagingItems<TransactionListItem>,
    onIntent: (TransactionsIntent) -> Unit,
    onRowClick: (String) -> Unit,
    onRetry: () -> Unit,
    showNet: Boolean,
    contentPadding: PaddingValues,
    modifier: Modifier = Modifier,
) {
    val horizontal = Modifier.padding(horizontal = MonAITheme.spacing.screenHorizontal)
    LazyColumn(
        modifier
            .fillMaxSize()
            .testTag(TransactionsTestTags.LIST),
        contentPadding = contentPadding,
    ) {
        item(key = "header", contentType = "header") {
            Column(verticalArrangement = Arrangement.spacedBy(MonAITheme.spacing.x3)) {
                TransactionsHeader(state, onIntent, horizontal)
                TransactionsFilters(
                    state,
                    onIntent,
                    contentPadding = PaddingValues(horizontal = MonAITheme.spacing.screenHorizontal),
                )
                state.totals?.let { TransactionsSummary(it, showNet, horizontal) }
            }
        }
        transactionItems(
            state,
            items,
            onIntent,
            onRowClick,
            onRetry,
        )
    }
}

private fun LazyListScope.transactionItems(
    state: TransactionsState,
    items: LazyPagingItems<TransactionListItem>,
    onIntent: (TransactionsIntent) -> Unit,
    onRowClick: (String) -> Unit,
    onRetry: () -> Unit,
) {
    val refresh = items.loadState.refresh
    if (items.itemCount == 0) {
        item(key = "state", contentType = "state") {
            val padding = Modifier.padding(
                horizontal = MonAITheme.spacing.screenHorizontal,
                vertical = MonAITheme.spacing.x3,
            )
            when (refresh) {
                is LoadState.Loading -> TransactionsSkeleton(Modifier.padding(top = MonAITheme.spacing.x1))
                is LoadState.Error -> TransactionsLoadError(refresh.error.isOffline(), onRetry)
                is LoadState.NotLoading -> TransactionsEmpty(state, onIntent, padding)
            }
        }
        return
    }
    items(
        count = items.itemCount,
        key = items.itemKey { it.key },
        contentType = items.itemContentType { if (it is TransactionListItem.Day) "day" else "entry" },
    ) { index ->
        when (val item = items[index]) {
            is TransactionListItem.Day -> Column {
                TransactionsDayHeader(item.date, state.today, state.dailyNets[item.date])
                MonAIDivider()
            }

            is TransactionListItem.Entry -> TransactionsSwipeRow(
                transaction = item.transaction,
                lookups = state.lookups,
                zone = state.zone,
                selected = item.transaction.id == state.selectedId,
                onClick = { onRowClick(item.transaction.id) },
                onDelete = { onIntent(TransactionsIntent.Delete(item.transaction.id)) },
            )

            // Placeholders are off, so a null item is only a row that is still loading.
            null -> Box(
                Modifier
                    .fillMaxWidth()
                    .height(MonAITheme.sizes.listRowMin)
                    .background(MonAITheme.colors.surface),
            )
        }
    }
    when (items.loadState.append) {
        is LoadState.Loading -> item(key = "append", contentType = "append") {
            Box(
                Modifier
                    .fillMaxWidth()
                    .padding(MonAITheme.spacing.x4),
                contentAlignment = Alignment.Center,
            ) {
                CircularProgressIndicator(Modifier.size(MonAITheme.sizes.icon), strokeWidth = 2.dp)
            }
        }

        is LoadState.Error -> item(key = "append", contentType = "append") {
            Column(
                Modifier
                    .fillMaxWidth()
                    .padding(MonAITheme.spacing.x4),
                horizontalAlignment = Alignment.CenterHorizontally,
                verticalArrangement = Arrangement.spacedBy(MonAITheme.spacing.x2),
            ) {
                Text(
                    stringResource(R.string.transactions_load_more_failed),
                    style = MonAITheme.typography.bodyMedium,
                    color = MonAITheme.colors.textSecondary,
                )
                MonAIButton(
                    stringResource(R.string.transaction_try_again),
                    onClick = { items.retry() },
                    variant = MonAIButtonVariant.Tonal,
                    size = MonAIButtonSize.Small,
                )
            }
        }

        is LoadState.NotLoading -> Unit
    }
}
