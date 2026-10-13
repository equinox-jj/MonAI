package com.djtech.monai.core.designsystem.component

import androidx.compose.foundation.background
import androidx.compose.foundation.border
import androidx.compose.foundation.clickable
import androidx.compose.foundation.layout.Arrangement
import androidx.compose.foundation.layout.Box
import androidx.compose.foundation.layout.Column
import androidx.compose.foundation.layout.Row
import androidx.compose.foundation.layout.Spacer
import androidx.compose.foundation.layout.fillMaxWidth
import androidx.compose.foundation.layout.heightIn
import androidx.compose.foundation.layout.offset
import androidx.compose.foundation.layout.padding
import androidx.compose.foundation.layout.size
import androidx.compose.foundation.rememberScrollState
import androidx.compose.foundation.selection.selectable
import androidx.compose.foundation.selection.selectableGroup
import androidx.compose.foundation.shape.CircleShape
import androidx.compose.foundation.shape.RoundedCornerShape
import androidx.compose.foundation.verticalScroll
import androidx.compose.material3.ExperimentalMaterial3Api
import androidx.compose.material3.Icon
import androidx.compose.material3.Text
import androidx.compose.runtime.Composable
import androidx.compose.ui.Alignment
import androidx.compose.ui.Modifier
import androidx.compose.ui.draw.clip
import androidx.compose.ui.draw.drawBehind
import androidx.compose.ui.graphics.PathEffect
import androidx.compose.ui.graphics.drawscope.Stroke
import androidx.compose.ui.res.stringResource
import androidx.compose.ui.semantics.Role
import androidx.compose.ui.text.style.TextAlign
import androidx.compose.ui.unit.dp
import com.djtech.monai.R
import com.djtech.monai.core.designsystem.icon.MonAIIcons
import com.djtech.monai.core.designsystem.icon.categoryIcon
import com.djtech.monai.core.designsystem.theme.CategoryColors
import com.djtech.monai.core.designsystem.theme.MonAITheme
import com.djtech.monai.core.model.Category

private const val COLUMNS = 4

/**
 * Every visible category of one type in a 4-column grid; "Use <name>" confirms. The pill names
 * the type ([typeLabel] in its [direction]'s colors). [onNewCategory] adds a "New" tile when set.
 */
@OptIn(ExperimentalMaterial3Api::class)
@Composable
fun MonAICategoryPickerSheet(
    categories: List<Category>,
    selectedId: String?,
    typeLabel: String,
    direction: MoneyDirection,
    onSelect: (String) -> Unit,
    onConfirm: () -> Unit,
    onDismiss: () -> Unit,
    onNewCategory: (() -> Unit)? = null,
) {
    val selected = categories.find { it.id == selectedId }
    MonAIBottomSheet(onDismissRequest = onDismiss) {
        Row(verticalAlignment = Alignment.CenterVertically) {
            Text(
                stringResource(R.string.transaction_picker_category_title),
                Modifier.weight(1f),
                style = MonAITheme.typography.headlineSmall,
                color = MonAITheme.colors.textPrimary,
            )
            MonAIDirectionPill(typeLabel, direction)
        }
        if (categories.isEmpty()) {
            Text(
                stringResource(R.string.transaction_form_no_categories),
                style = MonAITheme.typography.bodyMedium,
                color = MonAITheme.colors.textTertiary,
            )
        }
        Column(
            Modifier
                .heightIn(max = 400.dp)
                .verticalScroll(rememberScrollState())
                .selectableGroup(),
            verticalArrangement = Arrangement.spacedBy(MonAITheme.spacing.x4),
        ) {
            // The "New" tile (null) follows the last category.
            val cells = if (onNewCategory != null) categories + null else categories
            cells.chunked(COLUMNS).forEach { row ->
                Row(horizontalArrangement = Arrangement.spacedBy(MonAITheme.spacing.x2)) {
                    row.forEach { category ->
                        if (category == null) {
                            NewCategoryCell(
                                onClick = { onNewCategory?.invoke() },
                                modifier = Modifier.weight(1f),
                            )
                        } else {
                            CategoryCell(
                                category,
                                selected = category.id == selectedId,
                                onClick = { onSelect(category.id) },
                                modifier = Modifier.weight(1f),
                            )
                        }
                    }
                    repeat(COLUMNS - row.size) { Spacer(Modifier.weight(1f)) }
                }
            }
        }
        MonAIButton(
            selected?.let { stringResource(R.string.transaction_picker_use, it.name) }
                ?: stringResource(R.string.transaction_picker_category_title),
            onClick = onConfirm,
            modifier = Modifier.fillMaxWidth(),
            enabled = selected != null,
        )
    }
}

@Composable
private fun CategoryCell(
    category: Category,
    selected: Boolean,
    onClick: () -> Unit,
    modifier: Modifier = Modifier,
) {
    val colors = MonAITheme.colors
    val icon = categoryIcon(category.icon)
    val color = CategoryColors.parse(category.color)
    Column(
        modifier
            .heightIn(min = 80.dp)
            .clip(RoundedCornerShape(MonAITheme.radius.md))
            .selectable(selected = selected, role = Role.RadioButton, onClick = onClick)
            .padding(vertical = MonAITheme.spacing.x1),
        horizontalAlignment = Alignment.CenterHorizontally,
        verticalArrangement = Arrangement.spacedBy(MonAITheme.spacing.x1_5),
    ) {
        Box {
            MonAICategoryIcon(
                icon,
                color,
                modifier = if (selected) {
                    Modifier
                        .border(2.dp, colors.surface, CircleShape)
                        .padding(2.dp)
                        .border(2.dp, colors.focus, CircleShape)
                        .padding(2.dp)
                } else {
                    Modifier.padding(4.dp)
                },
                size = 48.dp,
                iconSize = MonAITheme.sizes.icon,
            )
            if (selected) {
                Icon(
                    MonAIIcons.Check,
                    null,
                    Modifier
                        .align(Alignment.TopEnd)
                        .offset(x = 4.dp, y = (-4).dp)
                        .size(20.dp)
                        .clip(CircleShape)
                        .background(colors.primary)
                        .padding(3.dp),
                    tint = colors.onPrimary,
                )
            }
        }
        Text(
            category.name,
            style = MonAITheme.typography.labelMedium,
            color = colors.iconStrong,
            textAlign = TextAlign.Center,
            maxLines = 2,
        )
    }
}

/** A dashed circle with a plus: opens the category form. */
@Composable
private fun NewCategoryCell(onClick: () -> Unit, modifier: Modifier = Modifier) {
    val colors = MonAITheme.colors
    val dash = colors.textTertiary
    Column(
        modifier
            .heightIn(min = 80.dp)
            .clip(RoundedCornerShape(MonAITheme.radius.md))
            .clickable(role = Role.Button, onClick = onClick)
            .padding(vertical = MonAITheme.spacing.x1),
        horizontalAlignment = Alignment.CenterHorizontally,
        verticalArrangement = Arrangement.spacedBy(MonAITheme.spacing.x1_5),
    ) {
        Box(
            Modifier
                .padding(4.dp)
                .size(48.dp)
                .drawBehind {
                    val stroke = 1.dp.toPx()
                    drawCircle(
                        color = dash,
                        radius = (size.minDimension - stroke) / 2,
                        style = Stroke(
                            width = stroke,
                            pathEffect = PathEffect.dashPathEffect(floatArrayOf(4.dp.toPx(), 3.dp.toPx())),
                        ),
                    )
                },
            contentAlignment = Alignment.Center,
        ) {
            Icon(
                MonAIIcons.Add,
                null,
                Modifier.size(MonAITheme.sizes.icon),
                tint = colors.textSecondary,
            )
        }
        Text(
            stringResource(R.string.transaction_picker_new_category),
            style = MonAITheme.typography.labelMedium,
            color = colors.accent,
            textAlign = TextAlign.Center,
        )
    }
}
