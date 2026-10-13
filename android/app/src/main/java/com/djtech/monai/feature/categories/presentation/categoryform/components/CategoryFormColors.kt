package com.djtech.monai.feature.categories.presentation.categoryform.components

import androidx.compose.foundation.background
import androidx.compose.foundation.border
import androidx.compose.foundation.layout.Arrangement
import androidx.compose.foundation.layout.Box
import androidx.compose.foundation.layout.Column
import androidx.compose.foundation.layout.Row
import androidx.compose.foundation.layout.fillMaxWidth
import androidx.compose.foundation.layout.padding
import androidx.compose.foundation.layout.size
import androidx.compose.foundation.selection.selectable
import androidx.compose.foundation.selection.selectableGroup
import androidx.compose.foundation.shape.CircleShape
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
import androidx.compose.ui.unit.dp
import com.djtech.monai.R
import com.djtech.monai.core.designsystem.icon.MonAIIcons
import com.djtech.monai.core.designsystem.theme.CategoryColors
import com.djtech.monai.core.designsystem.theme.MonAITheme
import com.djtech.monai.feature.categories.presentation.categoryform.model.CategoryColorChoice

private const val COLUMNS = 5

/** The color swatches in a 5-column grid; the selected one has a ring and a check. */
@Composable
internal fun CategoryFormColors(
    selected: CategoryColorChoice,
    onPick: (CategoryColorChoice) -> Unit,
    modifier: Modifier = Modifier,
) {
    val spacing = MonAITheme.spacing
    Column(modifier, verticalArrangement = Arrangement.spacedBy(spacing.x2)) {
        Text(
            stringResource(R.string.category_form_color),
            style = MonAITheme.typography.labelMedium,
            color = MonAITheme.colors.textSecondary,
        )
        Column(Modifier.selectableGroup(), verticalArrangement = Arrangement.spacedBy(spacing.x2_5)) {
            CategoryColorChoice.entries.chunked(COLUMNS).forEach { row ->
                Row(Modifier.fillMaxWidth(), horizontalArrangement = Arrangement.SpaceBetween) {
                    row.forEach { color ->
                        Swatch(color, selected = color == selected, onClick = { onPick(color) })
                    }
                }
            }
        }
    }
}

@Composable
private fun Swatch(choice: CategoryColorChoice, selected: Boolean, onClick: () -> Unit) {
    val sizes = MonAITheme.sizes
    val color = CategoryColors.content(CategoryColors.parse(choice.hex), MonAITheme.colors.isDark)
    val label = stringResource(choice.label)
    // The ring sits outside the swatch with a gap, so the box is a little larger than the 44dp target.
    Box(
        Modifier
            .size(sizes.touchTarget + 8.dp)
            .clip(CircleShape)
            .then(if (selected) Modifier.border(sizes.borderFocused, color, CircleShape) else Modifier)
            .selectable(selected = selected, role = Role.RadioButton, onClick = onClick)
            .semantics { contentDescription = label }
            .padding(MonAITheme.spacing.x1),
        contentAlignment = Alignment.Center,
    ) {
        Box(
            Modifier
                .size(sizes.touchTarget)
                .background(color, CircleShape),
            contentAlignment = Alignment.Center,
        ) {
            if (selected) {
                Icon(
                    MonAIIcons.Check,
                    null,
                    Modifier.size(sizes.iconLg),
                    tint = Color.White,
                )
            }
        }
    }
}
