package com.djtech.monai.feature.transactions.presentation.transactionform.components

import androidx.compose.foundation.background
import androidx.compose.foundation.border
import androidx.compose.foundation.clickable
import androidx.compose.foundation.layout.Arrangement
import androidx.compose.foundation.layout.Column
import androidx.compose.foundation.layout.Row
import androidx.compose.foundation.layout.fillMaxWidth
import androidx.compose.foundation.layout.heightIn
import androidx.compose.foundation.layout.padding
import androidx.compose.foundation.layout.size
import androidx.compose.foundation.shape.RoundedCornerShape
import androidx.compose.material3.Icon
import androidx.compose.material3.Text
import androidx.compose.runtime.Composable
import androidx.compose.ui.Alignment
import androidx.compose.ui.Modifier
import androidx.compose.ui.draw.clip
import androidx.compose.ui.graphics.vector.ImageVector
import androidx.compose.ui.semantics.Role
import androidx.compose.ui.semantics.error
import androidx.compose.ui.semantics.semantics
import androidx.compose.ui.text.font.FontWeight
import androidx.compose.ui.text.style.TextOverflow
import androidx.compose.ui.unit.dp
import com.djtech.monai.core.designsystem.icon.MonAIIcons
import com.djtech.monai.core.designsystem.theme.MonAITheme

/**
 * A tappable field on the sunken fill that opens a picker: [leading] icon, small [label] above
 * the [value], optional chevron. A red border and message under it when [error] is set.
 */
@Composable
internal fun TransactionFormFieldTile(
    label: String?,
    value: String,
    onClick: () -> Unit,
    modifier: Modifier = Modifier,
    leading: (@Composable () -> Unit)? = null,
    showChevron: Boolean = false,
    error: String? = null,
) {
    val colors = MonAITheme.colors
    val sizes = MonAITheme.sizes
    val shape = RoundedCornerShape(MonAITheme.radius.md)
    Column(modifier, verticalArrangement = Arrangement.spacedBy(MonAITheme.spacing.x1)) {
        Row(
            Modifier
                .fillMaxWidth()
                .heightIn(min = if (label != null) 52.dp else sizes.inputCompact)
                .clip(shape)
                .background(colors.surfaceSunken)
                .border(
                    if (error != null) sizes.borderFocused else sizes.border,
                    if (error != null) colors.error else colors.border,
                    shape,
                )
                .clickable(role = Role.Button, onClick = onClick)
                .semantics { if (error != null) error(error) }
                .padding(horizontal = MonAITheme.spacing.x3),
            verticalAlignment = Alignment.CenterVertically,
            horizontalArrangement = Arrangement.spacedBy(MonAITheme.spacing.x2),
        ) {
            leading?.invoke()
            Column(Modifier.weight(1f)) {
                if (label != null) {
                    Text(
                        label,
                        style = MonAITheme.typography.labelSmall.copy(fontWeight = FontWeight.Normal),
                        color = colors.textTertiary,
                    )
                }
                Text(
                    value,
                    style = MonAITheme.typography.labelLarge,
                    color = colors.textPrimary,
                    maxLines = 1,
                    overflow = TextOverflow.Ellipsis,
                )
            }
            if (showChevron) {
                Icon(
                    MonAIIcons.ExpandMore,
                    null,
                    Modifier.size(MonAITheme.sizes.iconMd),
                    tint = colors.textTertiary,
                )
            }
        }
        if (error != null) {
            Text(error, style = MonAITheme.typography.bodySmall, color = colors.errorText)
        }
    }
}

/** A tile's leading icon in the accent color. */
@Composable
internal fun TileIcon(icon: ImageVector) {
    Icon(
        icon,
        null,
        Modifier.size(MonAITheme.sizes.iconLg),
        tint = MonAITheme.colors.accent,
    )
}
