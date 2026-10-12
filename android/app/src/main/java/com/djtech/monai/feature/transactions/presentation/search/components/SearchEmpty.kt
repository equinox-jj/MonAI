package com.djtech.monai.feature.transactions.presentation.search.components

import androidx.compose.foundation.layout.fillMaxWidth
import androidx.compose.foundation.layout.padding
import androidx.compose.runtime.Composable
import androidx.compose.ui.Modifier
import androidx.compose.ui.res.stringResource
import com.djtech.monai.R
import com.djtech.monai.core.designsystem.component.MonAIStateMessage
import com.djtech.monai.core.designsystem.icon.MonAIIcons
import com.djtech.monai.core.designsystem.theme.MonAITheme
import com.djtech.monai.feature.transactions.presentation.common.model.FilterIntent
import com.djtech.monai.feature.transactions.presentation.common.monthNameText
import com.djtech.monai.feature.transactions.presentation.search.SearchIntent
import com.djtech.monai.feature.transactions.presentation.search.SearchState

/** Nothing matched: offers to drop the filters, and to look beyond the month. */
@Composable
internal fun SearchEmpty(
    state: SearchState,
    onIntent: (SearchIntent) -> Unit,
    modifier: Modifier = Modifier,
) {
    val query = state.query.trim()
    val month = monthNameText(state.month)
    val hasFilters = !state.filter.isEmpty
    MonAIStateMessage(
        icon = MonAIIcons.SearchOff,
        title = stringResource(R.string.transaction_search_empty_title, query),
        message = when {
            state.allMonths -> stringResource(R.string.transaction_search_empty_body_all, query)
            hasFilters -> stringResource(R.string.transaction_search_empty_body_filtered, month, query)
            else -> stringResource(R.string.transaction_search_empty_body, month, query)
        },
        modifier = modifier
            .fillMaxWidth()
            .padding(horizontal = MonAITheme.spacing.x6, vertical = MonAITheme.spacing.x10),
        actionLabel = if (hasFilters) stringResource(R.string.transactions_clear_filters) else null,
        actionIcon = MonAIIcons.FilterAltOff,
        onAction = { onIntent(SearchIntent.Filter(FilterIntent.RemoveAll)) },
        secondaryActionLabel = if (state.allMonths) null else stringResource(R.string.transaction_search_all_months),
        onSecondaryAction = { onIntent(SearchIntent.SearchAllMonths) },
    )
}
