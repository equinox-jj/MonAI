package com.djtech.monai.feature.transactions.presentation.search.components

import androidx.compose.foundation.layout.Row
import androidx.compose.foundation.layout.fillMaxWidth
import androidx.compose.material3.Text
import androidx.compose.runtime.Composable
import androidx.compose.ui.Alignment
import androidx.compose.ui.Modifier
import androidx.compose.ui.res.pluralStringResource
import androidx.compose.ui.res.stringResource
import com.djtech.monai.R
import com.djtech.monai.core.designsystem.component.MoneyDirection
import com.djtech.monai.core.designsystem.component.color
import com.djtech.monai.core.designsystem.theme.MonAITheme
import com.djtech.monai.core.designsystem.theme.tabular
import com.djtech.monai.feature.transactions.presentation.common.netText

/**
 * "4 results" and their net. While more pages remain ([isComplete] false) the count reads
 * "20+ results" and the net covers what has loaded.
 */
@Composable
internal fun SearchResultsHeader(
    count: Int,
    isComplete: Boolean,
    net: Long,
    modifier: Modifier = Modifier,
) {
    Row(modifier.fillMaxWidth(), verticalAlignment = Alignment.CenterVertically) {
        Text(
            if (isComplete) {
                pluralStringResource(R.plurals.transaction_search_results, count, count)
            } else {
                stringResource(R.string.transaction_search_results_more, count)
            },
            Modifier.weight(1f),
            style = MonAITheme.typography.labelLarge,
            color = MonAITheme.colors.textPrimary,
        )
        Text(
            netText(net),
            style = MonAITheme.extendedTypography.bodyCompact.copy(
                fontWeight = MonAITheme.typography.labelLarge.fontWeight,
            ).tabular(),
            color = when {
                net < 0 -> MoneyDirection.Expense.color()
                net > 0 -> MoneyDirection.Income.color()
                else -> MonAITheme.colors.textSecondary
            },
        )
    }
}
