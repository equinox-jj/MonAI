package com.djtech.monai.feature.home.presentation.home.components

import androidx.compose.foundation.Canvas
import androidx.compose.foundation.background
import androidx.compose.foundation.layout.Arrangement
import androidx.compose.foundation.layout.Box
import androidx.compose.foundation.layout.Column
import androidx.compose.foundation.layout.Row
import androidx.compose.foundation.layout.fillMaxSize
import androidx.compose.foundation.layout.fillMaxWidth
import androidx.compose.foundation.layout.size
import androidx.compose.foundation.shape.CircleShape
import androidx.compose.material3.Text
import androidx.compose.runtime.Composable
import androidx.compose.runtime.remember
import androidx.compose.ui.Alignment
import androidx.compose.ui.Modifier
import androidx.compose.ui.draw.clip
import androidx.compose.ui.geometry.Offset
import androidx.compose.ui.geometry.Size
import androidx.compose.ui.graphics.Color
import androidx.compose.ui.graphics.drawscope.Stroke
import androidx.compose.ui.res.stringResource
import androidx.compose.ui.semantics.contentDescription
import androidx.compose.ui.semantics.semantics
import androidx.compose.ui.text.font.FontWeight
import androidx.compose.ui.text.style.TextOverflow
import androidx.compose.ui.unit.dp
import com.djtech.monai.R
import com.djtech.monai.core.common.format.formatRupiahCompact
import com.djtech.monai.core.designsystem.component.MonAICard
import com.djtech.monai.core.designsystem.component.MonAISectionHeader
import com.djtech.monai.core.designsystem.theme.CategoryColors
import com.djtech.monai.core.designsystem.theme.MonAITheme
import com.djtech.monai.core.designsystem.theme.tabular
import com.djtech.monai.feature.home.presentation.home.model.SpendingSlice
import java.time.YearMonth
import kotlin.math.roundToInt

private val DonutSize = 140.dp
private val DonutStroke = 17.dp

/** Gap between donut segments, in degrees. */
private const val SEGMENT_GAP = 1.5f

/** "Where it went": a donut of the month's expense by category with its legend. */
@Composable
internal fun HomeSpendingCard(
    slices: List<SpendingSlice>,
    expenseTotal: Long,
    month: YearMonth,
    onOpenReport: () -> Unit,
    modifier: Modifier = Modifier,
) {
    val dark = MonAITheme.colors.isDark
    val colors = remember(slices, dark) { slices.map { CategoryColors.content(CategoryColors.parse(it.color), dark) } }
    val names = slices.map { it.name.asString() }
    MonAICard(modifier.fillMaxWidth(), verticalArrangement = Arrangement.spacedBy(MonAITheme.spacing.x4)) {
        MonAISectionHeader(
            stringResource(R.string.home_spending_title),
            actionLabel = stringResource(R.string.home_full_report),
            onActionClick = onOpenReport,
            style = MonAITheme.typography.titleMedium,
        )
        Row(
            verticalAlignment = Alignment.CenterVertically,
            horizontalArrangement = Arrangement.spacedBy(MonAITheme.spacing.x5),
        ) {
            val shares = names.zip(slices) { name, slice ->
                stringResource(R.string.home_spending_share_description, name, slice.sharePercent.roundToInt())
            }
            val description = stringResource(
                R.string.home_spending_description,
                month.monthName(),
                shares.joinToString(", "),
            )
            Box(Modifier.size(DonutSize), contentAlignment = Alignment.Center) {
                Donut(
                    slices.map { it.sharePercent.toFloat() },
                    colors,
                    Modifier
                        .fillMaxSize()
                        .semantics { contentDescription = description },
                )
                Column(horizontalAlignment = Alignment.CenterHorizontally) {
                    Text(
                        formatRupiahCompact(expenseTotal),
                        style = MonAITheme.typography.titleMedium.copy(fontWeight = FontWeight.Bold).tabular(),
                    )
                    Text(
                        month.monthName(),
                        style = MonAITheme.typography.bodySmall,
                        color = MonAITheme.colors.textTertiary,
                    )
                }
            }
            Column(Modifier.weight(1f), verticalArrangement = Arrangement.spacedBy(MonAITheme.spacing.x2_5)) {
                slices.forEachIndexed { index, slice ->
                    LegendRow(names[index], slice.sharePercent.roundToInt(), colors[index])
                }
            }
        }
    }
}

@Composable
private fun LegendRow(name: String, percent: Int, color: Color) {
    val style = MonAITheme.extendedTypography.bodyCompact
    Row(
        verticalAlignment = Alignment.CenterVertically,
        horizontalArrangement = Arrangement.spacedBy(MonAITheme.spacing.x2),
    ) {
        Box(
            Modifier
                .size(10.dp)
                .clip(CircleShape)
                .background(color),
        )
        Text(
            name,
            Modifier.weight(1f),
            style = style,
            maxLines = 1,
            overflow = TextOverflow.Ellipsis,
        )
        Text(
            stringResource(R.string.home_budget_percent, percent),
            style = style.copy(fontWeight = FontWeight.SemiBold).tabular(),
        )
    }
}

/** Ring segments clockwise from 12 o'clock; [shares] are percentages. */
@Composable
private fun Donut(shares: List<Float>, colors: List<Color>, modifier: Modifier = Modifier) {
    Canvas(modifier) {
        val stroke = DonutStroke.toPx()
        val diameter = size.minDimension - stroke
        val topLeft = Offset((size.width - diameter) / 2, (size.height - diameter) / 2)
        val gap = if (shares.size > 1) SEGMENT_GAP else 0f
        var start = -90f
        shares.forEachIndexed { index, share ->
            val sweep = share * 3.6f
            drawArc(
                color = colors[index],
                startAngle = start,
                sweepAngle = (sweep - gap).coerceAtLeast(0f),
                useCenter = false,
                topLeft = topLeft,
                size = Size(diameter, diameter),
                style = Stroke(width = stroke),
            )
            start += sweep
        }
    }
}
