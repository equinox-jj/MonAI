package com.djtech.monai.feature.transactions.presentation.transactions.components

import androidx.compose.foundation.layout.PaddingValues
import androidx.compose.runtime.Composable
import androidx.compose.ui.Modifier
import androidx.compose.ui.res.stringResource
import com.djtech.monai.R
import com.djtech.monai.core.designsystem.component.MonAIFilterChip
import com.djtech.monai.feature.transactions.presentation.common.TransactionFilterChips
import com.djtech.monai.feature.transactions.presentation.common.model.FilterIntent
import com.djtech.monai.feature.transactions.presentation.transactions.TransactionsIntent
import com.djtech.monai.feature.transactions.presentation.transactions.TransactionsState

/** "All types" (set when nothing filters the list, and clears every filter), then wallet, category and type. */
@Composable
internal fun TransactionsFilters(
    state: TransactionsState,
    onIntent: (TransactionsIntent) -> Unit,
    contentPadding: PaddingValues,
    modifier: Modifier = Modifier,
) {
    val onFilter = { intent: FilterIntent -> onIntent(TransactionsIntent.Filter(intent)) }
    TransactionFilterChips(
        filter = state.filter,
        lookups = state.lookups,
        onIntent = onFilter,
        modifier = modifier,
        contentPadding = contentPadding,
    ) {
        MonAIFilterChip(
            stringResource(R.string.transactions_filter_all_types),
            selected = state.filter.isEmpty,
            onClick = { onFilter(FilterIntent.RemoveAll) },
        )
    }
}
