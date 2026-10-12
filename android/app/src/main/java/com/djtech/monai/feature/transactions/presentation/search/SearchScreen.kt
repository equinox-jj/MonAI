package com.djtech.monai.feature.transactions.presentation.search

import androidx.compose.foundation.background
import androidx.compose.foundation.layout.Arrangement
import androidx.compose.foundation.layout.Box
import androidx.compose.foundation.layout.Column
import androidx.compose.foundation.layout.PaddingValues
import androidx.compose.foundation.layout.fillMaxSize
import androidx.compose.foundation.layout.fillMaxWidth
import androidx.compose.foundation.layout.imePadding
import androidx.compose.foundation.layout.navigationBarsPadding
import androidx.compose.foundation.layout.padding
import androidx.compose.foundation.layout.statusBarsPadding
import androidx.compose.foundation.layout.widthIn
import androidx.compose.foundation.lazy.LazyColumn
import androidx.compose.foundation.shape.RoundedCornerShape
import androidx.compose.material3.CircularProgressIndicator
import androidx.compose.material3.Text
import androidx.compose.runtime.Composable
import androidx.compose.runtime.derivedStateOf
import androidx.compose.runtime.getValue
import androidx.compose.runtime.remember
import androidx.compose.ui.Alignment
import androidx.compose.ui.Modifier
import androidx.compose.ui.draw.clip
import androidx.compose.ui.platform.testTag
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
import androidx.paging.compose.itemKey
import com.djtech.monai.R
import com.djtech.monai.core.common.ui.CollectEffects
import com.djtech.monai.core.designsystem.component.MonAITextLink
import com.djtech.monai.core.designsystem.theme.MonAITheme
import com.djtech.monai.core.model.Transaction
import com.djtech.monai.core.model.TransactionType
import com.djtech.monai.feature.transactions.presentation.common.RowWhen
import com.djtech.monai.feature.transactions.presentation.common.TransactionFilterSheetHost
import com.djtech.monai.feature.transactions.presentation.common.TransactionRow
import com.djtech.monai.feature.transactions.presentation.common.mapper.isOffline
import com.djtech.monai.feature.transactions.presentation.common.monthNameText
import com.djtech.monai.feature.transactions.presentation.search.components.SearchEmpty
import com.djtech.monai.feature.transactions.presentation.search.components.SearchError
import com.djtech.monai.feature.transactions.presentation.search.components.SearchFilters
import com.djtech.monai.feature.transactions.presentation.search.components.SearchPrompt
import com.djtech.monai.feature.transactions.presentation.search.components.SearchRecent
import com.djtech.monai.feature.transactions.presentation.search.components.SearchResultsHeader
import com.djtech.monai.feature.transactions.presentation.search.components.SearchTopBar
import com.djtech.monai.feature.transactions.presentation.search.preview.SearchPreviewData
import kotlinx.coroutines.flow.flowOf

internal object SearchTestTags {
    const val RESULTS = "search_results"
}

/** @param initialMonth `YYYY-MM`, the month the list was showing; null for the current month. */
@Composable
fun SearchRoute(
    initialMonth: String?,
    onBack: () -> Unit,
    onOpenTransaction: (String) -> Unit,
    modifier: Modifier = Modifier,
    viewModel: SearchViewModel =
        hiltViewModel<SearchViewModel, SearchViewModel.Factory>(key = initialMonth ?: "current") {
            it.create(initialMonth)
        },
) {
    val state by viewModel.state.collectAsStateWithLifecycle()
    val results = viewModel.results.collectAsLazyPagingItems()
    CollectEffects(viewModel.effects) { effect ->
        when (effect) {
            SearchEffect.NavigateBack -> onBack()
            is SearchEffect.OpenTransaction -> onOpenTransaction(effect.id)
        }
    }
    SearchScreen(state, results, viewModel::onIntent, modifier)
}

@Composable
fun SearchScreen(
    state: SearchState,
    results: LazyPagingItems<Transaction>,
    onIntent: (SearchIntent) -> Unit,
    modifier: Modifier = Modifier,
) {
    val spacing = MonAITheme.spacing
    Box(
        modifier
            .fillMaxSize()
            .background(MonAITheme.colors.background),
        contentAlignment = Alignment.TopCenter,
    ) {
        Column(
            Modifier
                .widthIn(max = 720.dp)
                .fillMaxSize()
                .statusBarsPadding()
                .navigationBarsPadding()
                .imePadding()
                .padding(top = spacing.x2),
            verticalArrangement = Arrangement.spacedBy(spacing.x3),
        ) {
            SearchTopBar(state.query, onIntent)
            SearchFilters(state, onIntent)
            SearchBody(state, results, onIntent, Modifier.weight(1f))
        }
    }
    TransactionFilterSheetHost(
        sheet = state.sheet,
        month = state.month,
        currentMonth = state.currentMonth,
        wallets = state.wallets,
        categories = state.categories,
        totals = null,
        monthPickerTotals = state.monthPickerTotals,
        onIntent = { onIntent(SearchIntent.Filter(it)) },
    )
}

@Composable
private fun SearchBody(
    state: SearchState,
    results: LazyPagingItems<Transaction>,
    onIntent: (SearchIntent) -> Unit,
    modifier: Modifier = Modifier,
) {
    val spacing = MonAITheme.spacing
    val horizontal = Modifier.padding(horizontal = spacing.screenHorizontal)
    val refresh = results.loadState.refresh
    // The count and net cover the rows loaded so far.
    val loaded by remember(results) { derivedStateOf { results.itemSnapshotList.items } }
    LazyColumn(
        modifier
            .fillMaxWidth()
            .testTag(SearchTestTags.RESULTS),
        contentPadding = PaddingValues(bottom = spacing.x6),
    ) {
        when {
            !state.hasQuery -> item(key = "idle") {
                if (state.recentSearches.isEmpty()) {
                    SearchPrompt()
                } else {
                    SearchRecent(
                        state.recentSearches,
                        onUse = { onIntent(SearchIntent.UseRecent(it)) },
                        modifier = horizontal.padding(top = spacing.x2),
                    )
                }
            }

            results.itemCount == 0 -> item(key = "state") {
                when (refresh) {
                    is LoadState.Loading -> Box(
                        Modifier
                            .fillMaxWidth()
                            .padding(spacing.x10),
                        contentAlignment = Alignment.Center,
                    ) { CircularProgressIndicator() }

                    is LoadState.Error -> SearchError(
                        isOffline = refresh.error.isOffline(),
                        onRetry = results::retry,
                        onSearchAllMonths = { onIntent(SearchIntent.SearchAllMonths) },
                    )

                    is LoadState.NotLoading -> SearchEmpty(state, onIntent)
                }
            }

            else -> {
                item(key = "header") {
                    SearchResultsHeader(
                        count = loaded.size,
                        isComplete = results.loadState.append.endOfPaginationReached,
                        net = loaded.sumOf { it.signedAmount() },
                        modifier = horizontal.padding(top = spacing.x1, bottom = spacing.x3),
                    )
                }
                items(results.itemCount, key = results.itemKey(Transaction::id)) { index ->
                    val transaction = results[index] ?: return@items
                    val last = index == results.itemCount - 1
                    val corner = MonAITheme.radius.lg
                    val shape = RoundedCornerShape(
                        topStart = if (index == 0) corner else 0.dp,
                        topEnd = if (index == 0) corner else 0.dp,
                        bottomStart = if (last) corner else 0.dp,
                        bottomEnd = if (last) corner else 0.dp,
                    )
                    TransactionRow(
                        transaction = transaction,
                        lookups = state.lookups,
                        rowWhen = RowWhen.DATE,
                        zone = state.zone,
                        onClick = { onIntent(SearchIntent.OpenResult(transaction.id)) },
                        modifier = horizontal.clip(shape),
                        highlight = state.query,
                        showDivider = !last,
                    )
                }
                item(key = "scope") {
                    Column(
                        Modifier
                            .fillMaxWidth()
                            .padding(top = spacing.x2),
                        horizontalAlignment = Alignment.CenterHorizontally,
                    ) {
                        if (state.allMonths) {
                            Text(
                                stringResource(R.string.transaction_search_cached_note),
                                style = MonAITheme.typography.bodySmall,
                                color = MonAITheme.colors.textTertiary,
                            )
                            MonAITextLink(
                                stringResource(R.string.transaction_search_only_month, monthNameText(state.month)),
                                onClick = { onIntent(SearchIntent.SearchMonthOnly) },
                            )
                        } else {
                            MonAITextLink(
                                stringResource(R.string.transaction_search_all_months),
                                onClick = { onIntent(SearchIntent.SearchAllMonths) },
                            )
                        }
                    }
                }
            }
        }
    }
}

private fun Transaction.signedAmount(): Long = when (type) {
    TransactionType.EXPENSE -> -amount
    TransactionType.INCOME -> amount
    TransactionType.TRANSFER -> 0
}

@PreviewLightDark
@Composable
private fun SearchResultsPreview() {
    val results = remember { flowOf(PagingData.from(SearchPreviewData.results)) }.collectAsLazyPagingItems()
    MonAITheme { SearchScreen(SearchPreviewData.state, results, onIntent = {}) }
}

@Preview
@Composable
private fun SearchRecentPreview() {
    val results = remember { flowOf(PagingData.empty<Transaction>()) }.collectAsLazyPagingItems()
    MonAITheme { SearchScreen(SearchPreviewData.state.copy(query = ""), results, onIntent = {}) }
}
