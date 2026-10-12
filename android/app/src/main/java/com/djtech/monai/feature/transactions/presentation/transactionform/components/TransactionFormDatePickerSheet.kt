package com.djtech.monai.feature.transactions.presentation.transactionform.components

import androidx.compose.foundation.background
import androidx.compose.foundation.border
import androidx.compose.foundation.layout.Arrangement
import androidx.compose.foundation.layout.Box
import androidx.compose.foundation.layout.Column
import androidx.compose.foundation.layout.Row
import androidx.compose.foundation.layout.height
import androidx.compose.foundation.layout.size
import androidx.compose.foundation.selection.selectable
import androidx.compose.foundation.shape.CircleShape
import androidx.compose.material3.ExperimentalMaterial3Api
import androidx.compose.material3.Icon
import androidx.compose.material3.Text
import androidx.compose.runtime.Composable
import androidx.compose.runtime.remember
import androidx.compose.ui.Alignment
import androidx.compose.ui.Modifier
import androidx.compose.ui.draw.clip
import androidx.compose.ui.res.stringResource
import androidx.compose.ui.semantics.Role
import androidx.compose.ui.semantics.contentDescription
import androidx.compose.ui.semantics.semantics
import androidx.compose.ui.text.font.FontWeight
import androidx.compose.ui.text.style.TextAlign
import androidx.compose.ui.unit.dp
import com.djtech.monai.R
import com.djtech.monai.core.designsystem.component.MonAIBottomSheet
import com.djtech.monai.core.designsystem.component.MonAIButton
import com.djtech.monai.core.designsystem.component.MonAIButtonSize
import com.djtech.monai.core.designsystem.component.MonAIButtonVariant
import com.djtech.monai.core.designsystem.component.MonAIIconButton
import com.djtech.monai.core.designsystem.icon.MonAIIcons
import com.djtech.monai.core.designsystem.theme.MonAITheme
import com.djtech.monai.core.designsystem.theme.tabular
import com.djtech.monai.feature.transactions.presentation.common.TransactionSheetButtons
import com.djtech.monai.feature.transactions.presentation.common.currentLocale
import com.djtech.monai.feature.transactions.presentation.common.dateText
import com.djtech.monai.feature.transactions.presentation.common.monthText
import com.djtech.monai.feature.transactions.presentation.transactionform.TransactionFormIntent
import com.djtech.monai.feature.transactions.presentation.transactionform.model.FormSheet
import java.time.LocalDate
import java.time.format.DateTimeFormatter
import java.time.format.TextStyle
import java.time.temporal.WeekFields

/** A month calendar for the transaction date. Days after [today] can't be picked. */
@OptIn(ExperimentalMaterial3Api::class)
@Composable
internal fun TransactionFormDatePickerSheet(
    sheet: FormSheet.Date,
    today: LocalDate,
    onIntent: (TransactionFormIntent) -> Unit,
) {
    val colors = MonAITheme.colors
    val spacing = MonAITheme.spacing
    val locale = currentLocale()
    val firstDay = remember(locale) { WeekFields.of(locale).firstDayOfWeek }
    MonAIBottomSheet(onDismissRequest = { onIntent(TransactionFormIntent.DismissSheet) }) {
        Column(verticalArrangement = Arrangement.spacedBy(spacing.x0_5)) {
            Text(
                stringResource(R.string.transaction_picker_date_title),
                style = MonAITheme.typography.labelMedium,
                color = colors.textSecondary,
            )
            Text(
                dateText(sheet.selected, today),
                style = MonAITheme.typography.headlineMedium,
                color = colors.textPrimary,
            )
        }
        Row(horizontalArrangement = Arrangement.spacedBy(spacing.x2)) {
            MonAIButton(
                stringResource(R.string.transaction_picker_today),
                onClick = { onIntent(TransactionFormIntent.SheetPickDate(today)) },
                variant = MonAIButtonVariant.Outlined,
                size = MonAIButtonSize.Small,
            )
            MonAIButton(
                stringResource(R.string.transaction_picker_yesterday),
                onClick = { onIntent(TransactionFormIntent.SheetPickDate(today.minusDays(1))) },
                variant = MonAIButtonVariant.Outlined,
                size = MonAIButtonSize.Small,
            )
        }
        Row(verticalAlignment = Alignment.CenterVertically) {
            MonAIIconButton(
                MonAIIcons.ChevronLeft,
                monthText(sheet.shownMonth.minusMonths(1)),
                onClick = { onIntent(TransactionFormIntent.SheetShowMonth(sheet.shownMonth.minusMonths(1))) },
                tint = colors.textSecondary,
            )
            Text(
                monthText(sheet.shownMonth),
                Modifier.weight(1f),
                style = MonAITheme.typography.titleSmall.copy(fontWeight = FontWeight.SemiBold),
                color = colors.textPrimary,
                textAlign = TextAlign.Center,
            )
            MonAIIconButton(
                MonAIIcons.ChevronRight,
                monthText(sheet.shownMonth.plusMonths(1)),
                onClick = { onIntent(TransactionFormIntent.SheetShowMonth(sheet.shownMonth.plusMonths(1))) },
                tint = colors.textSecondary,
                enabled = sheet.shownMonth.atEndOfMonth() < today,
            )
        }
        Column {
            Row {
                (0 until 7).forEach { offset ->
                    Text(
                        firstDay.plus(offset.toLong()).getDisplayName(TextStyle.NARROW_STANDALONE, locale),
                        Modifier
                            .weight(1f)
                            .height(28.dp),
                        style = MonAITheme.typography.labelMedium,
                        color = colors.textTertiary,
                        textAlign = TextAlign.Center,
                    )
                }
            }
            val first = sheet.shownMonth.atDay(1)
            val leading = (first.dayOfWeek.value - firstDay.value + 7) % 7
            val cells = List(leading) { null } + (1..sheet.shownMonth.lengthOfMonth()).map(sheet.shownMonth::atDay)
            cells.chunked(7).forEach { week ->
                Row {
                    week.forEach { date ->
                        Box(
                            Modifier
                                .weight(1f)
                                .height(MonAITheme.sizes.touchTarget),
                            contentAlignment = Alignment.Center,
                        ) {
                            if (date != null) {
                                DayCell(
                                    date,
                                    selected = date == sheet.selected,
                                    isToday = date == today,
                                    enabled = !date.isAfter(today),
                                    onClick = { onIntent(TransactionFormIntent.SheetPickDate(date)) },
                                )
                            }
                        }
                    }
                    repeat(7 - week.size) { Box(Modifier.weight(1f)) }
                }
            }
        }
        Row(
            verticalAlignment = Alignment.CenterVertically,
            horizontalArrangement = Arrangement.spacedBy(spacing.x1_5),
        ) {
            Icon(
                MonAIIcons.Block,
                null,
                Modifier.size(MonAITheme.sizes.iconSm),
                tint = colors.textTertiary,
            )
            Text(
                stringResource(R.string.transaction_picker_future_note),
                style = MonAITheme.typography.bodySmall,
                color = colors.textTertiary,
            )
        }
        TransactionSheetButtons(
            secondaryLabel = stringResource(R.string.transaction_picker_cancel),
            onSecondary = { onIntent(TransactionFormIntent.DismissSheet) },
            primaryLabel = stringResource(R.string.transaction_picker_set_date),
            onPrimary = { onIntent(TransactionFormIntent.ConfirmSheet) },
        )
    }
}

@Composable
private fun DayCell(
    date: LocalDate,
    selected: Boolean,
    isToday: Boolean,
    enabled: Boolean,
    onClick: () -> Unit,
) {
    val colors = MonAITheme.colors
    val locale = currentLocale()
    val full = date.format(DateTimeFormatter.ofPattern("EEEE, d MMMM yyyy", locale))
    val description = if (enabled) full else stringResource(R.string.transaction_picker_day_unavailable, full)
    Box(
        Modifier
            .size(40.dp)
            .clip(CircleShape)
            .then(if (selected) Modifier.background(colors.primary) else Modifier)
            .then(if (isToday && !selected) Modifier.border(1.dp, colors.accent, CircleShape) else Modifier)
            .selectable(
                selected = selected,
                enabled = enabled,
                role = Role.RadioButton,
                onClick = onClick,
            )
            .semantics { contentDescription = description },
        contentAlignment = Alignment.Center,
    ) {
        Text(
            date.dayOfMonth.toString(),
            style = MonAITheme.typography.bodyMedium.copy(
                fontWeight = if (selected || isToday) FontWeight.Bold else FontWeight.Medium,
            ).tabular(),
            color = when {
                selected -> colors.onPrimary
                enabled -> colors.textPrimary
                else -> colors.textDisabled
            },
        )
    }
}
