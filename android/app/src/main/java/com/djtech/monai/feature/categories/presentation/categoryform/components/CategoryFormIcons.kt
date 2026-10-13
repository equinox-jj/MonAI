package com.djtech.monai.feature.categories.presentation.categoryform.components

import androidx.compose.foundation.background
import androidx.compose.foundation.border
import androidx.compose.foundation.layout.Arrangement
import androidx.compose.foundation.layout.Box
import androidx.compose.foundation.layout.Column
import androidx.compose.foundation.layout.Row
import androidx.compose.foundation.layout.Spacer
import androidx.compose.foundation.layout.height
import androidx.compose.foundation.layout.size
import androidx.compose.foundation.selection.selectable
import androidx.compose.foundation.selection.selectableGroup
import androidx.compose.foundation.shape.RoundedCornerShape
import androidx.compose.material3.Icon
import androidx.compose.material3.Text
import androidx.compose.runtime.Composable
import androidx.compose.ui.Alignment
import androidx.compose.ui.Modifier
import androidx.compose.ui.draw.clip
import androidx.compose.ui.graphics.Color
import androidx.compose.ui.res.stringResource
import androidx.compose.ui.semantics.Role
import androidx.compose.ui.semantics.contentDescription
import androidx.compose.ui.semantics.semantics
import com.djtech.monai.R
import com.djtech.monai.core.designsystem.icon.categoryIcon
import com.djtech.monai.core.designsystem.theme.CategoryColors
import com.djtech.monai.core.designsystem.theme.MonAITheme
import com.djtech.monai.feature.categories.presentation.categoryform.model.CategoryIconChoice

private const val COLUMNS = 6

/** Every icon on offer in a 6-column grid; the selected one takes [color]. */
@Composable
internal fun CategoryFormIcons(
    selected: CategoryIconChoice,
    color: Color,
    onPick: (CategoryIconChoice) -> Unit,
    modifier: Modifier = Modifier,
) {
    val spacing = MonAITheme.spacing
    Column(modifier, verticalArrangement = Arrangement.spacedBy(spacing.x2)) {
        Text(
            stringResource(R.string.category_form_icon),
            style = MonAITheme.typography.labelMedium,
            color = MonAITheme.colors.textSecondary,
        )
        Column(Modifier.selectableGroup(), verticalArrangement = Arrangement.spacedBy(spacing.x2)) {
            CategoryIconChoice.entries.chunked(COLUMNS).forEach { row ->
                Row(horizontalArrangement = Arrangement.spacedBy(spacing.x2)) {
                    row.forEach { icon ->
                        IconCell(
                            icon,
                            selected = icon == selected,
                            color = color,
                            onClick = { onPick(icon) },
                            modifier = Modifier.weight(1f),
                        )
                    }
                    // Keeps a short last row's cells the same width as the others.
                    repeat(COLUMNS - row.size) { Spacer(Modifier.weight(1f)) }
                }
            }
        }
    }
}

@Composable
private fun IconCell(
    icon: CategoryIconChoice,
    selected: Boolean,
    color: Color,
    onClick: () -> Unit,
    modifier: Modifier = Modifier,
) {
    val colors = MonAITheme.colors
    val sizes = MonAITheme.sizes
    val dark = colors.isDark
    val shape = RoundedCornerShape(MonAITheme.radius.md)
    val label = stringResource(icon.label)
    Box(
        modifier
            .height(sizes.buttonMedium)
            .clip(shape)
            .background(if (selected) CategoryColors.tint(color, dark) else colors.background)
            .border(
                if (selected) sizes.borderFocused else sizes.border,
                if (selected) CategoryColors.content(color, dark) else colors.border,
                shape,
            )
            .selectable(selected = selected, role = Role.RadioButton, onClick = onClick)
            .semantics { contentDescription = label },
        contentAlignment = Alignment.Center,
    ) {
        Icon(
            categoryIcon(icon.symbol),
            null,
            Modifier.size(sizes.icon),
            tint = if (selected) CategoryColors.content(color, dark) else colors.textSecondary,
        )
    }
}
