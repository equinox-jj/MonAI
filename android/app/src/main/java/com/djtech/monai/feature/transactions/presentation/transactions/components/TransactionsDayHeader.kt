package com.djtech.monai.feature.transactions.presentation.transactions.components

import androidx.compose.foundation.layout.Row
import androidx.compose.foundation.layout.fillMaxWidth
import androidx.compose.foundation.layout.padding
import androidx.compose.material3.Text
import androidx.compose.runtime.Composable
import androidx.compose.ui.Alignment
import androidx.compose.ui.Modifier
import androidx.compose.ui.semantics.heading
import androidx.compose.ui.semantics.semantics
import com.djtech.monai.core.designsystem.theme.MonAITheme
import com.djtech.monai.core.designsystem.theme.tabular
import com.djtech.monai.feature.transactions.presentation.common.dayHeaderText
import com.djtech.monai.feature.transactions.presentation.common.netText
import java.time.LocalDate

/** "Today · Sat, 10 Oct" with the day's net, above that day's rows. */
@Composable
internal fun TransactionsDayHeader(
    date: LocalDate,
    today: LocalDate,
    net: Long?,
    modifier: Modifier = Modifier,
) {
    val colors = MonAITheme.colors
    Row(
        modifier
            .fillMaxWidth()
            .padding(horizontal = MonAITheme.spacing.x4)
            .padding(top = MonAITheme.spacing.x4, bottom = MonAITheme.spacing.x2),
        verticalAlignment = Alignment.CenterVertically,
    ) {
        Text(
            dayHeaderText(date, today),
            Modifier
                .weight(1f)
                .semantics { heading() },
            style = MonAITheme.typography.labelLarge,
            color = colors.textSecondary,
        )
        if (net != null) {
            Text(
                netText(net),
                style = MonAITheme.extendedTypography.bodyCompact.copy(
                    fontWeight = MonAITheme.typography.labelLarge.fontWeight,
                ).tabular(),
                color = colors.textSecondary,
            )
        }
    }
}
