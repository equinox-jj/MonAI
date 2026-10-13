package com.djtech.monai.feature.transactions.presentation.common

import androidx.compose.foundation.layout.Arrangement
import androidx.compose.foundation.layout.Column
import androidx.compose.foundation.layout.FlowRow
import androidx.compose.foundation.layout.heightIn
import androidx.compose.foundation.rememberScrollState
import androidx.compose.foundation.selection.selectableGroup
import androidx.compose.foundation.verticalScroll
import androidx.compose.material3.ExperimentalMaterial3Api
import androidx.compose.material3.Text
import androidx.compose.runtime.Composable
import androidx.compose.ui.Modifier
import androidx.compose.ui.res.stringResource
import androidx.compose.ui.unit.dp
import com.djtech.monai.R
import com.djtech.monai.core.designsystem.component.MonAIBottomSheet
import com.djtech.monai.core.designsystem.component.MonAICategoryChip
import com.djtech.monai.core.designsystem.component.MonAISheetButtons
import com.djtech.monai.core.designsystem.theme.MonAITheme
import com.djtech.monai.core.model.Category
import com.djtech.monai.core.model.CategoryType
import com.djtech.monai.feature.transactions.presentation.common.model.FilterIntent
import com.djtech.monai.feature.transactions.presentation.common.model.FilterSheet

/** One category to filter by, expense categories first, then income. */
@OptIn(ExperimentalMaterial3Api::class)
@Composable
internal fun TransactionCategoryFilterSheet(
    sheet: FilterSheet.Category,
    categories: List<Category>,
    onIntent: (FilterIntent) -> Unit,
) {
    MonAIBottomSheet(
        onDismissRequest = { onIntent(FilterIntent.Dismiss) },
        title = stringResource(R.string.transactions_sheet_categories),
    ) {
        Column(
            Modifier
                .heightIn(max = 440.dp)
                .verticalScroll(rememberScrollState())
                .selectableGroup(),
            verticalArrangement = Arrangement.spacedBy(MonAITheme.spacing.x3_5),
        ) {
            listOf(
                CategoryType.EXPENSE to R.string.transactions_category_group_expense,
                CategoryType.INCOME to R.string.transactions_category_group_income,
            ).forEach { (type, label) ->
                val group = categories.filter { it.type == type }
                if (group.isEmpty()) return@forEach
                Column(verticalArrangement = Arrangement.spacedBy(MonAITheme.spacing.x2)) {
                    Text(
                        stringResource(label).uppercase(),
                        style = MonAITheme.extendedTypography.overline,
                        color = MonAITheme.colors.textTertiary,
                    )
                    FlowRow(
                        horizontalArrangement = Arrangement.spacedBy(MonAITheme.spacing.x2),
                        verticalArrangement = Arrangement.spacedBy(MonAITheme.spacing.x2),
                    ) {
                        group.forEach { category ->
                            val (icon, color) = category.iconAndColor()
                            MonAICategoryChip(
                                category.name,
                                icon,
                                color,
                                selected = category.id == sheet.selectedId,
                                onClick = { onIntent(FilterIntent.PickCategory(category.id)) },
                            )
                        }
                    }
                }
            }
        }
        MonAISheetButtons(
            secondaryLabel = stringResource(R.string.transactions_sheet_clear),
            onSecondary = { onIntent(FilterIntent.ClearSheet) },
            primaryLabel = stringResource(
                if (sheet.selectedId == null) {
                    R.string.transactions_sheet_show_all
                } else {
                    R.string.transactions_sheet_apply
                },
            ),
            onPrimary = { onIntent(FilterIntent.Apply) },
        )
    }
}
