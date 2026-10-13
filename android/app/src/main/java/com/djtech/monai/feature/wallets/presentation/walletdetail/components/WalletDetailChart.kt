package com.djtech.monai.feature.wallets.presentation.walletdetail.components

import androidx.compose.foundation.Canvas
import androidx.compose.foundation.layout.Arrangement
import androidx.compose.foundation.layout.Row
import androidx.compose.foundation.layout.fillMaxWidth
import androidx.compose.foundation.layout.height
import androidx.compose.material3.Text
import androidx.compose.runtime.Composable
import androidx.compose.ui.Alignment
import androidx.compose.ui.Modifier
import androidx.compose.ui.geometry.CornerRadius
import androidx.compose.ui.geometry.Offset
import androidx.compose.ui.geometry.Size
import androidx.compose.ui.graphics.Color
import androidx.compose.ui.graphics.drawscope.DrawScope
import androidx.compose.ui.res.stringResource
import androidx.compose.ui.semantics.contentDescription
import androidx.compose.ui.semantics.semantics
import androidx.compose.ui.unit.dp
import com.djtech.monai.R
import com.djtech.monai.core.common.format.MoneySign
import com.djtech.monai.core.common.format.formatRupiah
import com.djtech.monai.core.common.format.formatRupiahSigned
import com.djtech.monai.core.designsystem.component.MonAICard
import com.djtech.monai.core.designsystem.theme.MonAITheme
import com.djtech.monai.feature.wallets.presentation.common.monthName
import com.djtech.monai.feature.wallets.presentation.common.shortDate
import com.djtech.monai.feature.wallets.presentation.walletdetail.model.OutflowDay
import java.time.LocalDate
import java.time.YearMonth

/** "Money out · October": the month's total and one bar per day, today's in the accent color. */
@Composable
internal fun WalletDetailChart(
    walletName: String,
    month: YearMonth,
    today: LocalDate,
    days: List<OutflowDay>,
    total: Long,
    modifier: Modifier = Modifier,
) {
    val colors = MonAITheme.colors
    MonAICard(modifier.fillMaxWidth()) {
        Row(verticalAlignment = Alignment.CenterVertically) {
            Text(
                stringResource(R.string.wallet_detail_money_out, month.monthName()),
                Modifier.weight(1f),
                style = MonAITheme.typography.titleMedium,
                color = colors.textPrimary,
            )
            Text(
                formatRupiahSigned(total, if (total > 0) MoneySign.Negative else MoneySign.None),
                style = MonAITheme.extendedTypography.amount.copy(fontSize = MonAITheme.typography.labelLarge.fontSize),
                color = if (total > 0) colors.expense else colors.textTertiary,
            )
        }
        val biggest = days.maxByOrNull(OutflowDay::amount)?.takeIf { it.amount > 0 }
        val description = if (biggest == null || days.isEmpty()) {
            stringResource(R.string.wallet_detail_chart_empty, walletName)
        } else {
            stringResource(
                R.string.wallet_detail_chart_description,
                walletName,
                days.first().date.shortDate(),
                days.last().date.shortDate(),
                biggest.date.shortDate(),
                formatRupiah(biggest.amount),
            )
        }
        val bar = colors.primaryContainerBorder
        val todayBar = colors.accent
        val empty = colors.border
        Canvas(
            Modifier
                .fillMaxWidth()
                .height(110.dp)
                .semantics { contentDescription = description },
        ) {
            drawBars(days, today, bar = bar, todayBar = todayBar, empty = empty)
        }
        if (days.isNotEmpty()) {
            Row(horizontalArrangement = Arrangement.SpaceBetween, modifier = Modifier.fillMaxWidth()) {
                listOf(days.first(), days[days.size / 2], days.last()).distinct().forEach {
                    Text(
                        it.date.shortDate(),
                        style = MonAITheme.typography.labelSmall,
                        color = colors.textTertiary,
                    )
                }
            }
        }
    }
}

private fun DrawScope.drawBars(
    days: List<OutflowDay>,
    today: LocalDate,
    bar: Color,
    todayBar: Color,
    empty: Color,
) {
    if (days.isEmpty()) return
    val gap = 6.dp.toPx()
    val width = ((size.width - gap * (days.size - 1)) / days.size).coerceAtLeast(1f)
    val max = days.maxOf(OutflowDay::amount).coerceAtLeast(1)
    // A day with nothing out still gets a sliver, so the month's days read as a baseline.
    val sliver = 3.dp.toPx()
    val radius = CornerRadius(4.dp.toPx())
    days.forEachIndexed { index, day ->
        val height = if (day.amount == 0L) {
            sliver
        } else {
            (day.amount.toFloat() / max * size.height).coerceAtLeast(sliver)
        }
        drawRoundRect(
            color = when {
                day.amount == 0L -> empty
                day.date == today -> todayBar
                else -> bar
            },
            topLeft = Offset(index * (width + gap), size.height - height),
            size = Size(width, height),
            cornerRadius = radius,
        )
    }
}
