package com.djtech.monai.feature.transactions.presentation.transactiondetail.components

import androidx.compose.foundation.BorderStroke
import androidx.compose.foundation.layout.Arrangement
import androidx.compose.foundation.layout.PaddingValues
import androidx.compose.foundation.layout.Row
import androidx.compose.foundation.layout.fillMaxWidth
import androidx.compose.foundation.layout.height
import androidx.compose.foundation.layout.padding
import androidx.compose.foundation.layout.size
import androidx.compose.foundation.shape.CircleShape
import androidx.compose.material3.ButtonDefaults
import androidx.compose.material3.Icon
import androidx.compose.material3.OutlinedButton
import androidx.compose.material3.Text
import androidx.compose.runtime.Composable
import androidx.compose.ui.Modifier
import androidx.compose.ui.res.stringResource
import androidx.compose.ui.text.style.TextOverflow
import com.djtech.monai.R
import com.djtech.monai.core.designsystem.component.MonAIButton
import com.djtech.monai.core.designsystem.component.MonAIButtonSize
import com.djtech.monai.core.designsystem.icon.MonAIIcons
import com.djtech.monai.core.designsystem.theme.MonAITheme

/** Delete (outlined in red) and Edit, side by side at the foot of the screen. */
@Composable
internal fun TransactionDetailActions(
    isDeleting: Boolean,
    onDelete: () -> Unit,
    onEdit: () -> Unit,
    modifier: Modifier = Modifier,
) {
    val colors = MonAITheme.colors
    Row(modifier.fillMaxWidth(), horizontalArrangement = Arrangement.spacedBy(MonAITheme.spacing.x3)) {
        OutlinedButton(
            onClick = onDelete,
            enabled = !isDeleting,
            modifier = Modifier
                .weight(1f)
                .height(MonAITheme.sizes.buttonMedium),
            shape = CircleShape,
            border = BorderStroke(MonAITheme.sizes.border, colors.errorContainerBorder),
            colors = ButtonDefaults.outlinedButtonColors(contentColor = colors.errorText),
            // Same padding as MonAIButtonSize.Medium (M3's default 24dp is too wide for the tablet pane).
            contentPadding = PaddingValues(horizontal = MonAITheme.spacing.x5),
        ) {
            Icon(MonAIIcons.Delete, null, Modifier.size(MonAITheme.sizes.iconLg))
            Text(
                stringResource(R.string.transaction_detail_delete),
                style = MonAITheme.typography.labelLarge,
                maxLines = 1,
                overflow = TextOverflow.Ellipsis,
                modifier = Modifier.padding(start = MonAITheme.spacing.x1_5),
            )
        }
        MonAIButton(
            stringResource(R.string.transaction_detail_edit),
            onEdit,
            Modifier.weight(1f),
            size = MonAIButtonSize.Medium,
            leadingIcon = MonAIIcons.Edit,
        )
    }
}
