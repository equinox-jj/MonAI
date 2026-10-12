package com.djtech.monai.feature.transactions.presentation.transactions.components

import androidx.compose.foundation.background
import androidx.compose.foundation.border
import androidx.compose.foundation.layout.Arrangement
import androidx.compose.foundation.layout.Column
import androidx.compose.foundation.layout.Row
import androidx.compose.foundation.layout.fillMaxWidth
import androidx.compose.foundation.layout.padding
import androidx.compose.foundation.shape.RoundedCornerShape
import androidx.compose.material3.Text
import androidx.compose.runtime.Composable
import androidx.compose.ui.Modifier
import androidx.compose.ui.draw.clip
import androidx.compose.ui.graphics.Color
import androidx.compose.ui.res.stringResource
import com.djtech.monai.R
import com.djtech.monai.core.common.format.MoneySign
import com.djtech.monai.core.common.format.formatRupiahSigned
import com.djtech.monai.core.designsystem.theme.MonAITheme
import com.djtech.monai.core.designsystem.theme.tabular
import com.djtech.monai.feature.transactions.presentation.common.model.MonthTotals
import com.djtech.monai.feature.transactions.presentation.common.netText

/** The month's income and expense, plus the net on wider screens. */
@Composable
internal fun TransactionsSummary(
    totals: MonthTotals,
    showNet: Boolean,
    modifier: Modifier = Modifier,
) {
    val colors = MonAITheme.colors
    Row(modifier.fillMaxWidth(), horizontalArrangement = Arrangement.spacedBy(MonAITheme.spacing.x2)) {
        SummaryCard(
            stringResource(R.string.transactions_income),
            formatRupiahSigned(totals.income, MoneySign.Positive),
            colors.income,
            Modifier.weight(1f),
        )
        SummaryCard(
            stringResource(R.string.transactions_expense),
            formatRupiahSigned(totals.expense, MoneySign.Negative),
            colors.expense,
            Modifier.weight(1f),
        )
        if (showNet) {
            SummaryCard(
                stringResource(R.string.transactions_net),
                netText(totals.income - totals.expense),
                colors.textPrimary,
                Modifier.weight(1f),
            )
        }
    }
}

@Composable
private fun SummaryCard(
    label: String,
    amount: String,
    color: Color,
    modifier: Modifier = Modifier,
) {
    val colors = MonAITheme.colors
    val shape = RoundedCornerShape(MonAITheme.radius.md)
    Column(
        modifier
            .clip(shape)
            .background(colors.surface)
            .border(MonAITheme.sizes.border, colors.border, shape)
            .padding(horizontal = MonAITheme.spacing.x3, vertical = MonAITheme.spacing.x2_5),
    ) {
        Text(label, style = MonAITheme.typography.bodySmall, color = colors.textTertiary)
        Text(
            amount,
            style = MonAITheme.typography.titleMedium.tabular(),
            color = color,
            maxLines = 1,
        )
    }
}
