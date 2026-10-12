package com.djtech.monai.feature.transactions.presentation.transactions.components

import androidx.compose.foundation.layout.PaddingValues
import androidx.compose.foundation.layout.fillMaxWidth
import androidx.compose.runtime.Composable
import androidx.compose.ui.Modifier
import androidx.compose.ui.res.stringResource
import androidx.compose.ui.unit.dp
import com.djtech.monai.R
import com.djtech.monai.core.designsystem.component.MonAICard
import com.djtech.monai.core.designsystem.component.MonAIStateMessage
import com.djtech.monai.core.designsystem.icon.MonAIIcons
import com.djtech.monai.feature.transactions.presentation.common.model.FilterIntent
import com.djtech.monai.feature.transactions.presentation.common.monthText
import com.djtech.monai.feature.transactions.presentation.transactions.TransactionsDestination
import com.djtech.monai.feature.transactions.presentation.transactions.TransactionsIntent
import com.djtech.monai.feature.transactions.presentation.transactions.TransactionsState

/**
 * Nothing to list: a filtered month offers to clear the filters, the current month invites a
 * first transaction, and a past month just says so.
 */
@Composable
internal fun TransactionsEmpty(
    state: TransactionsState,
    onIntent: (TransactionsIntent) -> Unit,
    modifier: Modifier = Modifier,
) {
    val month = monthText(state.month)
    MonAICard(modifier.fillMaxWidth(), contentPadding = PaddingValues(horizontal = 24.dp, vertical = 32.dp)) {
        when {
            !state.filter.isEmpty -> MonAIStateMessage(
                icon = MonAIIcons.FilterAltOff,
                title = stringResource(R.string.transactions_filtered_empty_title),
                message = stringResource(R.string.transactions_filtered_empty_body, month),
                modifier = Modifier.fillMaxWidth(),
                actionLabel = stringResource(R.string.transactions_clear_filters),
                actionIcon = MonAIIcons.FilterAltOff,
                onAction = { onIntent(TransactionsIntent.Filter(FilterIntent.RemoveAll)) },
            )

            state.month == state.currentMonth -> MonAIStateMessage(
                icon = MonAIIcons.ReceiptLong,
                title = stringResource(R.string.transactions_empty_title),
                message = stringResource(R.string.transactions_empty_body),
                modifier = Modifier.fillMaxWidth(),
                actionLabel = stringResource(R.string.transactions_empty_add),
                actionIcon = MonAIIcons.Add,
                onAction = { onIntent(TransactionsIntent.Open(TransactionsDestination.Add)) },
            )

            else -> MonAIStateMessage(
                icon = MonAIIcons.CalendarMonth,
                title = stringResource(R.string.transactions_month_empty_title, month),
                message = stringResource(R.string.transactions_month_empty_body),
                modifier = Modifier.fillMaxWidth(),
            )
        }
    }
}
