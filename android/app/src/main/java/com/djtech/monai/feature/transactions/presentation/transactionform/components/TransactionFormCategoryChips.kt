package com.djtech.monai.feature.transactions.presentation.transactionform.components

import androidx.compose.foundation.layout.Arrangement
import androidx.compose.foundation.layout.Column
import androidx.compose.foundation.layout.PaddingValues
import androidx.compose.foundation.layout.Row
import androidx.compose.foundation.layout.fillMaxWidth
import androidx.compose.foundation.layout.padding
import androidx.compose.foundation.lazy.LazyRow
import androidx.compose.foundation.lazy.items
import androidx.compose.foundation.lazy.rememberLazyListState
import androidx.compose.foundation.selection.selectableGroup
import androidx.compose.material3.Text
import androidx.compose.runtime.Composable
import androidx.compose.runtime.remember
import androidx.compose.ui.Alignment
import androidx.compose.ui.Modifier
import androidx.compose.ui.res.stringResource
import com.djtech.monai.R
import com.djtech.monai.core.designsystem.component.FieldHighlight
import com.djtech.monai.core.designsystem.component.HighlightIcon
import com.djtech.monai.core.designsystem.component.MonAICategoryChip
import com.djtech.monai.core.designsystem.component.MonAITextLink
import com.djtech.monai.core.designsystem.theme.MonAITheme
import com.djtech.monai.core.model.Category
import com.djtech.monai.feature.transactions.presentation.common.iconAndColor

/**
 * The add form's category row: the type's categories as chips that pick at once, and "All
 * categories" for the grid picker. The chosen one moves to the front so it is always visible.
 * A drafted or suggested category says so underneath ([highlight]).
 */
@Composable
internal fun TransactionFormCategoryChips(
    categories: List<Category>,
    selectedId: String?,
    error: String?,
    onPick: (String) -> Unit,
    onShowAll: () -> Unit,
    modifier: Modifier = Modifier,
    highlight: FieldHighlight = FieldHighlight.None,
) {
    val colors = MonAITheme.colors
    val ordered = categories.sortedByDescending { it.id == selectedId }
    val listState = rememberLazyListState()
    // The keyed row would keep its old first chip in view after the reorder. Requesting the start
    // during composition applies in the same remeasure as the new order, so the row never jumps.
    remember(selectedId) { listState.requestScrollToItem(0) }
    Column(modifier, verticalArrangement = Arrangement.spacedBy(MonAITheme.spacing.x1_5)) {
        Row(
            Modifier
                .fillMaxWidth()
                .padding(horizontal = MonAITheme.spacing.screenHorizontal),
            verticalAlignment = Alignment.CenterVertically,
        ) {
            Text(
                stringResource(R.string.transaction_form_category),
                Modifier.weight(1f),
                style = MonAITheme.typography.labelMedium,
                color = colors.textSecondary,
            )
            MonAITextLink(
                stringResource(R.string.transaction_form_all_categories),
                onShowAll,
                style = MonAITheme.typography.labelMedium,
            )
        }
        if (categories.isEmpty()) {
            Text(
                stringResource(R.string.transaction_form_no_categories),
                Modifier.padding(horizontal = MonAITheme.spacing.screenHorizontal),
                style = MonAITheme.typography.bodySmall,
                color = colors.textTertiary,
            )
        } else {
            LazyRow(
                Modifier.selectableGroup(),
                state = listState,
                contentPadding = PaddingValues(horizontal = MonAITheme.spacing.screenHorizontal),
                horizontalArrangement = Arrangement.spacedBy(MonAITheme.spacing.x2),
            ) {
                items(ordered, key = Category::id) { category ->
                    val (icon, color) = category.iconAndColor()
                    MonAICategoryChip(
                        category.name,
                        icon,
                        color,
                        selected = category.id == selectedId,
                        onClick = { onPick(category.id) },
                    )
                }
            }
        }
        if (error == null && highlight != FieldHighlight.None) {
            Row(
                Modifier.padding(horizontal = MonAITheme.spacing.screenHorizontal),
                verticalAlignment = Alignment.CenterVertically,
                horizontalArrangement = Arrangement.spacedBy(MonAITheme.spacing.x1_5),
            ) {
                HighlightIcon(highlight)
                Text(
                    stringResource(
                        if (highlight == FieldHighlight.Low) R.string.ai_hint_check else R.string.ai_category_suggested,
                    ),
                    style = MonAITheme.typography.bodySmall,
                    color = if (highlight == FieldHighlight.Low) colors.onWarningContainer else colors.textSecondary,
                )
            }
        }
        if (error != null) {
            Text(
                error,
                Modifier.padding(horizontal = MonAITheme.spacing.screenHorizontal),
                style = MonAITheme.typography.bodySmall,
                color = colors.errorText,
            )
        }
    }
}
