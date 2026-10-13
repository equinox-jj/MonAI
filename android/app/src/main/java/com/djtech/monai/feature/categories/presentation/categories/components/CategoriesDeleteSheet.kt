package com.djtech.monai.feature.categories.presentation.categories.components

import androidx.compose.foundation.layout.Arrangement
import androidx.compose.foundation.layout.Column
import androidx.compose.foundation.layout.Row
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
import com.djtech.monai.core.designsystem.component.MonAIAlertDialog
import com.djtech.monai.core.designsystem.component.MonAIAlertTone
import com.djtech.monai.core.designsystem.component.MonAIBottomSheet
import com.djtech.monai.core.designsystem.component.MonAIButton
import com.djtech.monai.core.designsystem.component.MonAIButtonVariant
import com.djtech.monai.core.designsystem.component.MonAICategoryIcon
import com.djtech.monai.core.designsystem.component.MonAIRadioOption
import com.djtech.monai.core.designsystem.icon.MonAIIcons
import com.djtech.monai.core.designsystem.icon.categoryIcon
import com.djtech.monai.core.designsystem.theme.CategoryColors
import com.djtech.monai.core.designsystem.theme.MonAITheme
import com.djtech.monai.feature.categories.presentation.categories.model.CategoryDeletion

/** A plain confirmation first; once the category turns out to be in use, where to move its transactions. */
@OptIn(ExperimentalMaterial3Api::class)
@Composable
internal fun CategoriesDeleteSheet(
    deletion: CategoryDeletion,
    onPickTarget: (String) -> Unit,
    onConfirm: () -> Unit,
    onDismiss: () -> Unit,
) {
    val name = deletion.category.name
    if (!deletion.needsTarget) {
        MonAIAlertDialog(
            title = stringResource(R.string.categories_delete_title, name),
            message = stringResource(R.string.categories_delete_message),
            confirmLabel = stringResource(R.string.categories_delete_confirm),
            onConfirm = onConfirm,
            onDismissRequest = onDismiss,
            dismissLabel = stringResource(R.string.categories_cancel),
            icon = MonAIIcons.Delete,
            tone = MonAIAlertTone.Error,
            destructive = true,
        )
        return
    }
    MonAIBottomSheet(onDismissRequest = onDismiss, title = stringResource(R.string.categories_delete_title, name)) {
        Text(
            stringResource(R.string.categories_move_message, name),
            style = MonAITheme.typography.bodyMedium,
            color = MonAITheme.colors.textSecondary,
        )
        Text(
            stringResource(R.string.categories_move_to),
            style = MonAITheme.typography.labelLarge,
            color = MonAITheme.colors.textSecondary,
        )
        Column(
            Modifier
                .heightIn(max = TargetsMaxHeight)
                .verticalScroll(rememberScrollState())
                .selectableGroup(),
            verticalArrangement = Arrangement.spacedBy(MonAITheme.spacing.x1_5),
        ) {
            deletion.targets.forEach { target ->
                MonAIRadioOption(
                    title = target.name,
                    selected = target.id == deletion.targetId,
                    onClick = { onPickTarget(target.id) },
                    leading = {
                        MonAICategoryIcon(
                            categoryIcon(target.icon),
                            CategoryColors.parse(target.color),
                            size = MonAITheme.sizes.avatarSmall,
                            iconSize = MonAITheme.sizes.iconMd,
                        )
                    },
                )
            }
        }
        Row(horizontalArrangement = Arrangement.spacedBy(MonAITheme.spacing.x3)) {
            MonAIButton(
                stringResource(R.string.categories_cancel),
                onClick = onDismiss,
                modifier = Modifier.weight(1f),
                variant = MonAIButtonVariant.Outlined,
                enabled = !deletion.isDeleting,
            )
            MonAIButton(
                stringResource(R.string.categories_move_confirm),
                onClick = onConfirm,
                modifier = Modifier.weight(1f),
                variant = MonAIButtonVariant.Destructive,
                enabled = deletion.targetId != null,
                loading = deletion.isDeleting,
            )
        }
    }
}

private val TargetsMaxHeight = 320.dp
