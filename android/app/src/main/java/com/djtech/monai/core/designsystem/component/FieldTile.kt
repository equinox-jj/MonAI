package com.djtech.monai.core.designsystem.component

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
import androidx.compose.ui.graphics.Color
import androidx.compose.ui.graphics.vector.ImageVector
import androidx.compose.ui.res.stringResource
import androidx.compose.ui.semantics.Role
import androidx.compose.ui.semantics.error
import androidx.compose.ui.semantics.semantics
import androidx.compose.ui.text.font.FontWeight
import androidx.compose.ui.text.style.TextOverflow
import androidx.compose.ui.unit.Dp
import androidx.compose.ui.unit.dp
import com.djtech.monai.R
import com.djtech.monai.core.designsystem.icon.MonAIIcons
import com.djtech.monai.core.designsystem.theme.MonAITheme

/**
 * How a field drafted by the AI or the quick-add parser is marked: [Ai] filled it surely (tinted,
 * with a sparkle), [Low] is unsure and needs a look (amber, with a warning).
 */
enum class FieldHighlight { None, Ai, Low }

/**
 * A tappable field on the sunken fill that opens a picker: [leading] icon, small [label] above
 * the [value], optional chevron. A red border and message under it when [error] is set; otherwise
 * [highlight] marks a drafted value, with [hint] under a [FieldHighlight.Low] one.
 */
@Composable
fun MonAIFieldTile(
    label: String?,
    value: String,
    onClick: () -> Unit,
    modifier: Modifier = Modifier,
    leading: (@Composable () -> Unit)? = null,
    showChevron: Boolean = false,
    error: String? = null,
    highlight: FieldHighlight = FieldHighlight.None,
    hint: String? = null,
) {
    val colors = MonAITheme.colors
    val sizes = MonAITheme.sizes
    val shape = RoundedCornerShape(MonAITheme.radius.md)
    val look = tileLook(highlight, isError = error != null)
    Column(modifier, verticalArrangement = Arrangement.spacedBy(MonAITheme.spacing.x1)) {
        Row(
            Modifier
                .fillMaxWidth()
                .heightIn(min = if (label != null) 52.dp else sizes.inputCompact)
                .clip(shape)
                .background(look.container)
                .border(look.borderWidth, look.border, shape)
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
            when {
                error == null && highlight != FieldHighlight.None -> HighlightIcon(highlight)
                showChevron -> Icon(
                    MonAIIcons.ExpandMore,
                    null,
                    Modifier.size(sizes.iconMd),
                    tint = colors.textTertiary,
                )
            }
        }
        when {
            error != null -> Text(error, style = MonAITheme.typography.bodySmall, color = colors.errorText)
            highlight == FieldHighlight.Low && hint != null -> Text(
                hint,
                style = MonAITheme.typography.bodySmall,
                color = colors.onWarningContainer,
            )
        }
    }
}

/** The sparkle of an AI-filled field or the warning of an unsure one, announced to screen readers. */
@Composable
fun HighlightIcon(highlight: FieldHighlight, modifier: Modifier = Modifier) {
    val colors = MonAITheme.colors
    when (highlight) {
        FieldHighlight.Ai -> Icon(
            MonAIIcons.AutoAwesome,
            stringResource(R.string.ai_filled_description),
            modifier.size(MonAITheme.sizes.iconMd),
            tint = colors.accent,
        )

        FieldHighlight.Low -> Icon(
            MonAIIcons.Warning,
            stringResource(R.string.ai_check_description),
            modifier.size(MonAITheme.sizes.iconMd),
            tint = colors.warning,
        )

        FieldHighlight.None -> Unit
    }
}

/** A tile's leading icon in the accent color. */
@Composable
fun MonAITileIcon(icon: ImageVector, modifier: Modifier = Modifier) {
    Icon(
        icon,
        null,
        modifier.size(MonAITheme.sizes.iconLg),
        tint = MonAITheme.colors.accent,
    )
}

private class TileLook(val container: Color, val border: Color, val borderWidth: Dp)

@Composable
private fun tileLook(highlight: FieldHighlight, isError: Boolean): TileLook {
    val colors = MonAITheme.colors
    val sizes = MonAITheme.sizes
    return when {
        isError -> TileLook(colors.surfaceSunken, colors.error, sizes.borderFocused)
        highlight == FieldHighlight.Low -> TileLook(colors.warningContainer, colors.warning, sizes.borderFocused)
        highlight == FieldHighlight.Ai -> TileLook(colors.primaryContainer, colors.primaryContainerBorder, sizes.border)
        else -> TileLook(colors.surfaceSunken, colors.border, sizes.border)
    }
}
