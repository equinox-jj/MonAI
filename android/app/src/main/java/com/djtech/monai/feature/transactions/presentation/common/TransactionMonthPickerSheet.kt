package com.djtech.monai.feature.transactions.presentation.common

import androidx.compose.foundation.background
import androidx.compose.foundation.border
import androidx.compose.foundation.layout.Arrangement
import androidx.compose.foundation.layout.Column
import androidx.compose.foundation.layout.Row
import androidx.compose.foundation.layout.fillMaxWidth
import androidx.compose.foundation.layout.height
import androidx.compose.foundation.layout.padding
import androidx.compose.foundation.selection.selectable
import androidx.compose.foundation.selection.selectableGroup
import androidx.compose.foundation.shape.CircleShape
import androidx.compose.foundation.shape.RoundedCornerShape
import androidx.compose.material3.ExperimentalMaterial3Api
import androidx.compose.material3.Text
import androidx.compose.runtime.Composable
import androidx.compose.ui.Alignment
import androidx.compose.ui.Modifier
import androidx.compose.ui.draw.clip
import androidx.compose.ui.res.stringResource
import androidx.compose.ui.semantics.Role
import androidx.compose.ui.text.font.FontWeight
import androidx.compose.ui.text.style.TextAlign
import androidx.compose.ui.unit.dp
import com.djtech.monai.R
import com.djtech.monai.core.common.format.formatRupiahCompact
import com.djtech.monai.core.designsystem.component.MonAIBottomSheet
import com.djtech.monai.core.designsystem.component.MonAIButton
import com.djtech.monai.core.designsystem.component.MonAIIconButton
import com.djtech.monai.core.designsystem.icon.MonAIIcons
import com.djtech.monai.core.designsystem.theme.MonAITheme
import com.djtech.monai.core.designsystem.theme.tabular
import com.djtech.monai.feature.transactions.presentation.common.model.FilterIntent
import com.djtech.monai.feature.transactions.presentation.common.model.FilterSheet
import java.time.YearMonth
import java.time.format.TextStyle

/**
 * Year stepper over a 3×4 month grid. Months after [currentMonth] are disabled; each month shows
 * what was spent when its report is cached ([expenseTotals]).
 */
@OptIn(ExperimentalMaterial3Api::class)
@Composable
internal fun TransactionMonthPickerSheet(
    sheet: FilterSheet.Month,
    currentMonth: YearMonth,
    expenseTotals: Map<YearMonth, Long>,
    onIntent: (FilterIntent) -> Unit,
) {
    val colors = MonAITheme.colors
    val spacing = MonAITheme.spacing
    MonAIBottomSheet(
        onDismissRequest = { onIntent(FilterIntent.Dismiss) },
        title = stringResource(R.string.transactions_month_title),
    ) {
        Row(
            Modifier
                .fillMaxWidth()
                .clip(CircleShape)
                .background(colors.surfaceSunken)
                .padding(2.dp),
            verticalAlignment = Alignment.CenterVertically,
        ) {
            MonAIIconButton(
                MonAIIcons.ChevronLeft,
                stringResource(R.string.transactions_month_previous_year),
                onClick = { onIntent(FilterIntent.ShowYear(sheet.year - 1)) },
            )
            Text(
                sheet.year.toString(),
                Modifier.weight(1f),
                style = MonAITheme.typography.titleMedium.copy(fontWeight = FontWeight.Bold).tabular(),
                color = colors.textPrimary,
                textAlign = TextAlign.Center,
            )
            MonAIIconButton(
                MonAIIcons.ChevronRight,
                stringResource(R.string.transactions_month_next_year),
                onClick = { onIntent(FilterIntent.ShowYear(sheet.year + 1)) },
                enabled = sheet.year < currentMonth.year,
            )
        }
        Column(Modifier.selectableGroup(), verticalArrangement = Arrangement.spacedBy(spacing.x2)) {
            (1..12).chunked(3).forEach { row ->
                Row(horizontalArrangement = Arrangement.spacedBy(spacing.x2)) {
                    row.forEach { number ->
                        val month = YearMonth.of(sheet.year, number)
                        MonthCell(
                            month = month,
                            selected = month == sheet.selected,
                            enabled = month <= currentMonth,
                            spent = expenseTotals[month],
                            onClick = { onIntent(FilterIntent.PickMonth(month)) },
                            modifier = Modifier.weight(1f),
                        )
                    }
                }
            }
        }
        MonAIButton(
            stringResource(R.string.transactions_month_show, monthText(sheet.selected)),
            onClick = { onIntent(FilterIntent.Apply) },
            modifier = Modifier.fillMaxWidth(),
        )
    }
}

@Composable
private fun MonthCell(
    month: YearMonth,
    selected: Boolean,
    enabled: Boolean,
    spent: Long?,
    onClick: () -> Unit,
    modifier: Modifier = Modifier,
) {
    val colors = MonAITheme.colors
    val shape = RoundedCornerShape(MonAITheme.radius.mdl)
    val (container, content, sub) = when {
        selected -> Triple(colors.primary, colors.onPrimary, colors.onPrimary.copy(alpha = 0.8f))
        enabled -> Triple(colors.surface, colors.textPrimary, colors.textTertiary)
        else -> Triple(colors.surface, colors.textDisabled, colors.textDisabled)
    }
    Column(
        modifier = modifier
            .height(56.dp)
            .clip(shape)
            .background(container)
            .then(if (selected) Modifier else Modifier.border(MonAITheme.sizes.border, colors.border, shape))
            .selectable(
                selected = selected,
                enabled = enabled,
                role = Role.RadioButton,
                onClick = onClick,
            ),
        horizontalAlignment = Alignment.CenterHorizontally,
        verticalArrangement = Arrangement.Center,
    ) {
        Text(
            month.month.getDisplayName(TextStyle.SHORT_STANDALONE, currentLocale()),
            style = MonAITheme.typography.labelLarge,
            color = content,
        )
        if (spent != null && enabled) {
            Text(
                formatRupiahCompact(spent).removePrefix("Rp "),
                style = MonAITheme.typography.labelSmall.copy(fontWeight = FontWeight.Normal).tabular(),
                color = sub,
            )
        }
    }
}
