package com.djtech.monai.feature.transactions.presentation.common

import androidx.compose.foundation.layout.Arrangement
import androidx.compose.foundation.layout.Column
import androidx.compose.foundation.selection.selectableGroup
import androidx.compose.material3.ExperimentalMaterial3Api
import androidx.compose.material3.Text
import androidx.compose.runtime.Composable
import androidx.compose.ui.Modifier
import androidx.compose.ui.graphics.Color
import androidx.compose.ui.graphics.vector.ImageVector
import androidx.compose.ui.res.stringResource
import com.djtech.monai.R
import com.djtech.monai.core.common.format.MoneySign
import com.djtech.monai.core.common.format.formatRupiahSigned
import com.djtech.monai.core.designsystem.component.MonAIBottomSheet
import com.djtech.monai.core.designsystem.component.MonAICategoryIcon
import com.djtech.monai.core.designsystem.component.MonAIRadioOption
import com.djtech.monai.core.designsystem.component.arrowIcon
import com.djtech.monai.core.designsystem.icon.MonAIIcons
import com.djtech.monai.core.designsystem.theme.MonAITheme
import com.djtech.monai.core.model.TransactionType
import com.djtech.monai.feature.transactions.presentation.common.model.FilterIntent
import com.djtech.monai.feature.transactions.presentation.common.model.FilterSheet
import com.djtech.monai.feature.transactions.presentation.common.model.MonthTotals
import java.time.YearMonth

/** All types, or one. Expense and income show the month's totals when its report is cached. */
@OptIn(ExperimentalMaterial3Api::class)
@Composable
internal fun TransactionTypeFilterSheet(
    sheet: FilterSheet.Type,
    month: YearMonth,
    totals: MonthTotals?,
    onIntent: (FilterIntent) -> Unit,
) {
    val colors = MonAITheme.colors
    MonAIBottomSheet(
        onDismissRequest = { onIntent(FilterIntent.Dismiss) },
        title = stringResource(R.string.transactions_sheet_type),
    ) {
        Column(Modifier.selectableGroup(), verticalArrangement = Arrangement.spacedBy(MonAITheme.spacing.x2)) {
            TypeOption(
                label = stringResource(R.string.transactions_filter_all_types),
                meta = stringResource(R.string.transactions_type_all_meta, monthNameText(month)),
                icon = MonAIIcons.Apps,
                color = colors.textSecondary,
                selected = sheet.selected == null,
                onClick = { onIntent(FilterIntent.PickType(null)) },
            )
            TransactionType.entries.forEach { type ->
                val direction = type.direction()
                TypeOption(
                    label = type.label(),
                    meta = when (type) {
                        TransactionType.EXPENSE -> totals?.let { formatRupiahSigned(it.expense, MoneySign.Negative) }
                        TransactionType.INCOME -> totals?.let { formatRupiahSigned(it.income, MoneySign.Positive) }
                        TransactionType.TRANSFER -> stringResource(R.string.transactions_type_transfer_meta)
                    },
                    icon = if (type == TransactionType.TRANSFER) MonAIIcons.SwapHoriz else direction.arrowIcon(),
                    color = when (type) {
                        TransactionType.EXPENSE -> colors.expense
                        TransactionType.INCOME -> colors.income
                        TransactionType.TRANSFER -> colors.primary
                    },
                    selected = sheet.selected == type,
                    onClick = { onIntent(FilterIntent.PickType(type)) },
                )
            }
        }
        Text(
            stringResource(R.string.transactions_type_note),
            style = MonAITheme.typography.bodySmall,
            color = colors.textTertiary,
        )
        TransactionSheetButtons(
            secondaryLabel = stringResource(R.string.transactions_sheet_reset),
            onSecondary = { onIntent(FilterIntent.ClearSheet) },
            primaryLabel = stringResource(R.string.transactions_sheet_apply),
            onPrimary = { onIntent(FilterIntent.Apply) },
        )
    }
}

@Composable
private fun TypeOption(
    label: String,
    meta: String?,
    icon: ImageVector,
    color: Color,
    selected: Boolean,
    onClick: () -> Unit,
) {
    MonAIRadioOption(
        title = label,
        selected = selected,
        onClick = onClick,
        subtitle = meta,
        leading = { MonAICategoryIcon(icon, color) },
    )
}
