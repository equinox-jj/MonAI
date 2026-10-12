package com.djtech.monai.feature.home.presentation.home.components

import androidx.compose.foundation.layout.Arrangement
import androidx.compose.foundation.layout.Column
import androidx.compose.foundation.layout.PaddingValues
import androidx.compose.foundation.layout.fillMaxWidth
import androidx.compose.runtime.Composable
import androidx.compose.ui.Modifier
import androidx.compose.ui.res.stringResource
import androidx.compose.ui.unit.dp
import com.djtech.monai.R
import com.djtech.monai.core.designsystem.component.MonAICard
import com.djtech.monai.core.designsystem.component.MonAISectionHeader
import com.djtech.monai.core.designsystem.component.MonAIStateMessage
import com.djtech.monai.core.designsystem.component.MonAITransactionRow
import com.djtech.monai.core.designsystem.component.MoneyDirection
import com.djtech.monai.core.designsystem.icon.MonAIIcons
import com.djtech.monai.core.designsystem.icon.categoryIcon
import com.djtech.monai.core.designsystem.theme.CategoryColors
import com.djtech.monai.core.designsystem.theme.MonAITheme
import com.djtech.monai.core.model.TransactionType
import com.djtech.monai.feature.home.presentation.home.HomeDestination
import com.djtech.monai.feature.home.presentation.home.HomeIntent
import com.djtech.monai.feature.home.presentation.home.model.RecentTransaction

/** "Recent" with the month's newest transactions, or the first-run prompt when there are none. */
@Composable
internal fun HomeRecent(
    recent: List<RecentTransaction>,
    onIntent: (HomeIntent) -> Unit,
    modifier: Modifier = Modifier,
) {
    if (recent.isEmpty()) {
        MonAICard(modifier.fillMaxWidth(), contentPadding = PaddingValues(horizontal = 24.dp, vertical = 32.dp)) {
            MonAIStateMessage(
                icon = MonAIIcons.ReceiptLong,
                title = stringResource(R.string.home_empty_title),
                message = stringResource(R.string.home_empty_body),
                modifier = Modifier.fillMaxWidth(),
                actionLabel = stringResource(R.string.home_empty_add),
                actionIcon = MonAIIcons.Add,
                onAction = { onIntent(HomeIntent.Open(HomeDestination.AddTransaction)) },
                secondaryActionLabel = stringResource(R.string.home_empty_quick_add),
                onSecondaryAction = { onIntent(HomeIntent.Open(HomeDestination.QuickAdd)) },
            )
        }
        return
    }
    Column(modifier, verticalArrangement = Arrangement.spacedBy(MonAITheme.spacing.x2)) {
        MonAISectionHeader(
            stringResource(R.string.home_recent),
            actionLabel = stringResource(R.string.home_see_all),
            onActionClick = { onIntent(HomeIntent.Open(HomeDestination.Transactions)) },
        )
        MonAICard(
            Modifier.fillMaxWidth(),
            contentPadding = PaddingValues(0.dp),
            verticalArrangement = Arrangement.Top,
        ) {
            recent.forEachIndexed { index, transaction ->
                RecentRow(
                    transaction,
                    showDivider = index < recent.lastIndex,
                    onClick = { onIntent(HomeIntent.Open(HomeDestination.TransactionDetail(transaction.id))) },
                )
            }
        }
    }
}

@Composable
private fun RecentRow(transaction: RecentTransaction, showDivider: Boolean, onClick: () -> Unit) {
    val isTransfer = transaction.type == TransactionType.TRANSFER
    MonAITransactionRow(
        title = transaction.title.asString(),
        meta = transaction.metaText(),
        amount = transaction.amountText(),
        direction = when (transaction.type) {
            TransactionType.EXPENSE -> MoneyDirection.Expense
            TransactionType.INCOME -> MoneyDirection.Income
            TransactionType.TRANSFER -> MoneyDirection.Transfer
        },
        categoryIcon = if (isTransfer) MonAIIcons.SwapHoriz else categoryIcon(transaction.icon),
        categoryColor = if (isTransfer) MonAITheme.colors.primary else CategoryColors.parse(transaction.color),
        onClick = onClick,
        showDivider = showDivider,
    )
}
