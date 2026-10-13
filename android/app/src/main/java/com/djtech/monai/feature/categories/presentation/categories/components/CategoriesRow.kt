package com.djtech.monai.feature.categories.presentation.categories.components

import androidx.compose.foundation.clickable
import androidx.compose.foundation.layout.Arrangement
import androidx.compose.foundation.layout.Box
import androidx.compose.foundation.layout.Column
import androidx.compose.foundation.layout.Row
import androidx.compose.foundation.layout.fillMaxWidth
import androidx.compose.foundation.layout.height
import androidx.compose.foundation.layout.padding
import androidx.compose.foundation.layout.size
import androidx.compose.material3.CircularProgressIndicator
import androidx.compose.material3.Icon
import androidx.compose.material3.Text
import androidx.compose.runtime.Composable
import androidx.compose.ui.Alignment
import androidx.compose.ui.Modifier
import androidx.compose.ui.draw.alpha
import androidx.compose.ui.res.stringResource
import androidx.compose.ui.semantics.Role
import androidx.compose.ui.semantics.contentDescription
import androidx.compose.ui.semantics.semantics
import androidx.compose.ui.text.style.TextOverflow
import com.djtech.monai.R
import com.djtech.monai.core.designsystem.component.MonAICategoryIcon
import com.djtech.monai.core.designsystem.component.MonAIIconButton
import com.djtech.monai.core.designsystem.component.MonAITag
import com.djtech.monai.core.designsystem.icon.MonAIIcons
import com.djtech.monai.core.designsystem.icon.categoryIcon
import com.djtech.monai.core.designsystem.theme.CategoryColors
import com.djtech.monai.core.designsystem.theme.MonAITheme
import com.djtech.monai.feature.categories.presentation.categories.model.CategoryKind
import com.djtech.monai.feature.categories.presentation.categories.model.CategoryRow

/** Icon, name with its tag and note, then the row's one action: lock, delete, or hide/show. */
@Composable
internal fun CategoriesRow(
    row: CategoryRow,
    onEdit: () -> Unit,
    onSetHidden: (Boolean) -> Unit,
    onDelete: () -> Unit,
    modifier: Modifier = Modifier,
) {
    val colors = MonAITheme.colors
    Row(
        modifier
            .fillMaxWidth()
            .height(MonAITheme.sizes.listRowMin)
            .clickable(enabled = row.canEdit, role = Role.Button, onClick = onEdit)
            .padding(start = MonAITheme.spacing.x4, end = MonAITheme.spacing.x2),
        verticalAlignment = Alignment.CenterVertically,
        horizontalArrangement = Arrangement.spacedBy(MonAITheme.spacing.x3),
    ) {
        Row(
            Modifier
                .weight(1f)
                .alpha(if (row.isHidden) HIDDEN_ALPHA else 1f),
            verticalAlignment = Alignment.CenterVertically,
            horizontalArrangement = Arrangement.spacedBy(MonAITheme.spacing.x3),
        ) {
            MonAICategoryIcon(categoryIcon(row.icon), CategoryColors.parse(row.color))
            Column(Modifier.weight(1f)) {
                Row(
                    verticalAlignment = Alignment.CenterVertically,
                    horizontalArrangement = Arrangement.spacedBy(MonAITheme.spacing.x1_5),
                ) {
                    Text(
                        row.name,
                        Modifier.weight(1f, fill = false),
                        style = MonAITheme.typography.titleSmall,
                        color = colors.textPrimary,
                        maxLines = 1,
                        overflow = TextOverflow.Ellipsis,
                    )
                    when {
                        row.isHidden -> Tag(stringResource(R.string.categories_tag_hidden))
                        row.kind == CategoryKind.CUSTOM -> Tag(stringResource(R.string.categories_tag_custom))
                    }
                }
                Text(row.note(), style = MonAITheme.typography.bodySmall, color = colors.textTertiary)
            }
        }
        RowAction(row, onSetHidden, onDelete)
    }
}

@Composable
private fun RowAction(row: CategoryRow, onSetHidden: (Boolean) -> Unit, onDelete: () -> Unit) {
    val colors = MonAITheme.colors
    val touch = MonAITheme.sizes.touchTarget
    when {
        row.isBusy -> Box(Modifier.size(touch), contentAlignment = Alignment.Center) {
            CircularProgressIndicator(
                Modifier.size(MonAITheme.sizes.iconLg),
                color = colors.accent,
                strokeWidth = MonAITheme.sizes.borderFocused,
            )
        }

        row.kind == CategoryKind.SYSTEM -> {
            val locked = stringResource(R.string.categories_locked)
            Box(
                Modifier
                    .size(touch)
                    .semantics { contentDescription = locked },
                contentAlignment = Alignment.Center,
            ) {
                Icon(
                    MonAIIcons.Lock,
                    null,
                    Modifier.size(MonAITheme.sizes.iconLg),
                    tint = colors.textDisabled,
                )
            }
        }

        row.canHide -> MonAIIconButton(
            if (row.isHidden) MonAIIcons.Visibility else MonAIIcons.VisibilityOff,
            stringResource(if (row.isHidden) R.string.categories_show else R.string.categories_hide, row.name),
            onClick = { onSetHidden(!row.isHidden) },
            tint = colors.textSecondary,
        )

        row.canDelete -> MonAIIconButton(
            MonAIIcons.Delete,
            stringResource(R.string.categories_delete, row.name),
            onClick = onDelete,
            tint = colors.errorText,
        )
    }
}

@Composable
private fun Tag(text: String) {
    MonAITag(
        text.uppercase(),
        containerColor = MonAITheme.colors.surfaceSunken,
        contentColor = MonAITheme.colors.textSecondary,
    )
}

@Composable
private fun CategoryRow.note(): String = stringResource(
    when {
        isHidden -> R.string.categories_meta_hidden
        kind == CategoryKind.SYSTEM -> R.string.categories_meta_system
        kind == CategoryKind.CUSTOM -> R.string.categories_meta_custom
        else -> R.string.categories_meta_default
    },
)

private const val HIDDEN_ALPHA = 0.6f
