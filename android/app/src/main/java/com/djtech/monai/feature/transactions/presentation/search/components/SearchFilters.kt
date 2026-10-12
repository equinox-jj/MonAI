package com.djtech.monai.feature.transactions.presentation.search.components

import androidx.compose.foundation.layout.PaddingValues
import androidx.compose.runtime.Composable
import androidx.compose.ui.Modifier
import androidx.compose.ui.res.stringResource
import com.djtech.monai.R
import com.djtech.monai.core.designsystem.icon.MonAIIcons
import com.djtech.monai.core.designsystem.theme.MonAITheme
import com.djtech.monai.feature.transactions.presentation.common.ActiveFilterChip
import com.djtech.monai.feature.transactions.presentation.common.IconFilterChip
import com.djtech.monai.feature.transactions.presentation.common.TransactionFilterChips
import com.djtech.monai.feature.transactions.presentation.common.currentLocale
import com.djtech.monai.feature.transactions.presentation.common.model.FilterIntent
import com.djtech.monai.feature.transactions.presentation.common.model.FilterSheetKind
import com.djtech.monai.feature.transactions.presentation.search.SearchIntent
import com.djtech.monai.feature.transactions.presentation.search.SearchState
import java.time.format.DateTimeFormatter

/** The searched month (or "All months", which × turns back into the month), then the filters. */
@Composable
internal fun SearchFilters(
    state: SearchState,
    onIntent: (SearchIntent) -> Unit,
    modifier: Modifier = Modifier,
) {
    val month = state.month.format(DateTimeFormatter.ofPattern("MMM yyyy", currentLocale()))
    TransactionFilterChips(
        filter = state.filter,
        lookups = state.lookups,
        onIntent = { onIntent(SearchIntent.Filter(it)) },
        modifier = modifier,
        contentPadding = PaddingValues(horizontal = MonAITheme.spacing.screenHorizontal),
    ) {
        if (state.allMonths) {
            val label = stringResource(R.string.transaction_search_all_months_chip)
            ActiveFilterChip(
                value = label,
                onClick = { onIntent(SearchIntent.Filter(FilterIntent.Open(FilterSheetKind.MONTH))) },
                onRemove = { onIntent(SearchIntent.SearchMonthOnly) },
                removeDescription = stringResource(R.string.transaction_search_only_month, month),
                leadingIcon = MonAIIcons.CalendarMonth,
            )
        } else {
            IconFilterChip(
                label = month,
                icon = MonAIIcons.CalendarMonth,
                onClick = { onIntent(SearchIntent.Filter(FilterIntent.Open(FilterSheetKind.MONTH))) },
            )
        }
    }
}
