package com.djtech.monai.core.designsystem.component

import androidx.compose.foundation.BorderStroke
import androidx.compose.foundation.background
import androidx.compose.foundation.border
import androidx.compose.foundation.layout.Arrangement
import androidx.compose.foundation.layout.Box
import androidx.compose.foundation.layout.Column
import androidx.compose.foundation.layout.PaddingValues
import androidx.compose.foundation.layout.Row
import androidx.compose.foundation.layout.Spacer
import androidx.compose.foundation.layout.defaultMinSize
import androidx.compose.foundation.layout.fillMaxWidth
import androidx.compose.foundation.layout.height
import androidx.compose.foundation.layout.padding
import androidx.compose.foundation.layout.size
import androidx.compose.foundation.layout.width
import androidx.compose.foundation.shape.CircleShape
import androidx.compose.material3.Button
import androidx.compose.material3.ButtonDefaults
import androidx.compose.material3.CircularProgressIndicator
import androidx.compose.material3.Icon
import androidx.compose.material3.IconButton
import androidx.compose.material3.IconButtonDefaults
import androidx.compose.material3.Text
import androidx.compose.runtime.Composable
import androidx.compose.ui.Alignment
import androidx.compose.ui.Modifier
import androidx.compose.ui.draw.clip
import androidx.compose.ui.graphics.Color
import androidx.compose.ui.graphics.vector.ImageVector
import androidx.compose.ui.text.TextStyle
import androidx.compose.ui.text.style.TextOverflow
import androidx.compose.ui.tooling.preview.PreviewLightDark
import androidx.compose.ui.unit.Dp
import androidx.compose.ui.unit.dp
import com.djtech.monai.core.designsystem.icon.MonAIIcons
import com.djtech.monai.core.designsystem.theme.MonAITheme

enum class MonAIButtonVariant {
    /** Indigo fill. The main action on a screen. */
    Primary,

    /** Light indigo fill, e.g. "Scan", "Add wallet". */
    Tonal,

    /** Gray outline, e.g. "New wallet" next to "Done". */
    Outlined,

    /** No container; looks like a link. */
    Text,

    /** Red fill for confirming a destructive action. */
    Destructive,
}

enum class MonAIButtonSize {
    /** 56dp, 16sp. Full-width screen actions. */
    Large,

    /** 48dp, 14sp. State actions, sheet buttons. */
    Medium,

    /** 44dp, 14sp. Dialog buttons. */
    Compact,

    /** 36dp, 12sp. Header pills like "Scan". */
    Small,
}

/**
 * The design's pill button.
 *
 * @param loading shows a spinner in place of [leadingIcon] and blocks clicks, keeping the
 *   enabled colors (the "Trying…" state on error screens).
 */
@Composable
fun MonAIButton(
    text: String,
    onClick: () -> Unit,
    modifier: Modifier = Modifier,
    variant: MonAIButtonVariant = MonAIButtonVariant.Primary,
    size: MonAIButtonSize = MonAIButtonSize.Large,
    leadingIcon: ImageVector? = null,
    enabled: Boolean = true,
    loading: Boolean = false,
) {
    val colors = MonAITheme.colors
    val sizes = MonAITheme.sizes
    val spec = size.spec()
    val (container, content) = when (variant) {
        MonAIButtonVariant.Primary -> colors.primary to colors.onPrimary
        MonAIButtonVariant.Tonal -> colors.primaryContainer to colors.onPrimaryContainer
        MonAIButtonVariant.Outlined -> Color.Transparent to colors.iconStrong
        MonAIButtonVariant.Text -> Color.Transparent to colors.accent
        MonAIButtonVariant.Destructive -> colors.error to colors.onPrimary
    }
    val filled = variant != MonAIButtonVariant.Outlined && variant != MonAIButtonVariant.Text
    // While loading, keep the enabled look; only a real disable greys the button out.
    val disabledContainer = if (loading) container else if (filled) colors.disabledContainer else Color.Transparent
    val disabledContent = if (loading) content else colors.disabledContent

    Button(
        onClick = onClick,
        modifier = modifier.height(spec.height).defaultMinSize(minWidth = sizes.touchTarget),
        enabled = enabled && !loading,
        shape = CircleShape,
        colors = ButtonDefaults.buttonColors(
            containerColor = container,
            contentColor = content,
            disabledContainerColor = disabledContainer,
            disabledContentColor = disabledContent,
        ),
        border = if (variant == MonAIButtonVariant.Outlined) {
            BorderStroke(sizes.border, colors.borderStrong)
        } else {
            null
        },
        contentPadding = PaddingValues(horizontal = spec.horizontalPadding),
    ) {
        when {
            loading -> {
                CircularProgressIndicator(
                    modifier = Modifier.size(spec.iconSize - 2.dp),
                    color = content,
                    trackColor = content.copy(alpha = 0.35f),
                    strokeWidth = 2.5.dp,
                )
                Spacer(Modifier.width(spec.iconGap))
            }
            leadingIcon != null -> {
                Icon(leadingIcon, contentDescription = null, modifier = Modifier.size(spec.iconSize))
                Spacer(Modifier.width(spec.iconGap))
            }
        }
        Text(text = text, style = spec.textStyle, maxLines = 1, overflow = TextOverflow.Ellipsis)
    }
}

private class ButtonSpec(
    val height: Dp,
    val textStyle: TextStyle,
    val horizontalPadding: Dp,
    val iconSize: Dp,
    val iconGap: Dp,
)

@Composable
private fun MonAIButtonSize.spec(): ButtonSpec {
    val sizes = MonAITheme.sizes
    val type = MonAITheme.typography
    val spacing = MonAITheme.spacing
    return when (this) {
        MonAIButtonSize.Large -> ButtonSpec(sizes.buttonLarge, type.titleMedium, spacing.x6, sizes.iconLg, spacing.x2)
        MonAIButtonSize.Medium -> ButtonSpec(sizes.buttonMedium, type.labelLarge, spacing.x5, sizes.iconLg, spacing.x1_5)
        MonAIButtonSize.Compact -> ButtonSpec(sizes.touchTarget, type.labelLarge, spacing.x4, sizes.iconMd, spacing.x1_5)
        MonAIButtonSize.Small -> ButtonSpec(sizes.buttonSmall, type.labelMedium, spacing.x3_5, sizes.iconSm, spacing.x1_5)
    }
}

enum class MonAIIconButtonStyle {
    /** No container. Top-bar back/close/edit. */
    Plain,

    /** White circle with a gray border. Home search button. */
    Surface,

    /** Light indigo circle. Scan receipt. */
    Tonal,
}

/** 44dp circular icon button (52dp for the quick-add scan button via [size]). */
@Composable
fun MonAIIconButton(
    icon: ImageVector,
    contentDescription: String?,
    onClick: () -> Unit,
    modifier: Modifier = Modifier,
    style: MonAIIconButtonStyle = MonAIIconButtonStyle.Plain,
    tint: Color = Color.Unspecified,
    size: Dp = MonAITheme.sizes.touchTarget,
    iconSize: Dp = MonAITheme.sizes.icon,
    enabled: Boolean = true,
) {
    val colors = MonAITheme.colors
    val (container, defaultTint) = when (style) {
        MonAIIconButtonStyle.Plain -> Color.Transparent to colors.iconStrong
        MonAIIconButtonStyle.Surface -> colors.surface to colors.textSecondary
        MonAIIconButtonStyle.Tonal -> colors.primaryContainer to colors.accent
    }
    val border = if (style == MonAIIconButtonStyle.Surface) {
        Modifier.border(MonAITheme.sizes.border, colors.border, CircleShape)
    } else {
        Modifier
    }
    IconButton(
        onClick = onClick,
        modifier = modifier
            .size(size)
            .clip(CircleShape)
            .background(container)
            .then(border),
        enabled = enabled,
        colors = IconButtonDefaults.iconButtonColors(
            contentColor = if (tint == Color.Unspecified) defaultTint else tint,
            disabledContentColor = colors.textDisabled,
        ),
    ) {
        Icon(icon, contentDescription = contentDescription, modifier = Modifier.size(iconSize))
    }
}

@PreviewLightDark
@Composable
private fun ButtonPreview() {
    MonAITheme {
        Column(
            modifier = Modifier
                .background(MonAITheme.colors.background)
                .padding(16.dp),
            verticalArrangement = Arrangement.spacedBy(12.dp),
        ) {
            MonAIButton("Sign in", onClick = {}, modifier = Modifier.fillMaxWidth())
            MonAIButton("Save expense", onClick = {}, leadingIcon = MonAIIcons.Check, modifier = Modifier.fillMaxWidth())
            MonAIButton("Trying…", onClick = {}, size = MonAIButtonSize.Medium, loading = true)
            Row(horizontalArrangement = Arrangement.spacedBy(8.dp)) {
                MonAIButton("New wallet", onClick = {}, variant = MonAIButtonVariant.Outlined, size = MonAIButtonSize.Medium, leadingIcon = MonAIIcons.Add)
                MonAIButton("Done", onClick = {}, size = MonAIButtonSize.Medium)
            }
            Row(horizontalArrangement = Arrangement.spacedBy(8.dp), verticalAlignment = Alignment.CenterVertically) {
                MonAIButton("Scan", onClick = {}, variant = MonAIButtonVariant.Tonal, size = MonAIButtonSize.Small, leadingIcon = MonAIIcons.DocumentScanner)
                MonAIButton("Cancel", onClick = {}, variant = MonAIButtonVariant.Text, size = MonAIButtonSize.Compact)
                MonAIButton("Delete", onClick = {}, variant = MonAIButtonVariant.Destructive, size = MonAIButtonSize.Compact)
            }
            MonAIButton("Disabled", onClick = {}, enabled = false, modifier = Modifier.fillMaxWidth())
            Row(horizontalArrangement = Arrangement.spacedBy(8.dp)) {
                MonAIIconButton(MonAIIcons.ArrowBack, "Back", onClick = {})
                MonAIIconButton(MonAIIcons.Search, "Search", onClick = {}, style = MonAIIconButtonStyle.Surface)
                MonAIIconButton(MonAIIcons.DocumentScanner, "Scan receipt", onClick = {}, style = MonAIIconButtonStyle.Tonal, size = 52.dp)
                Box {
                    MonAIIconButton(MonAIIcons.Delete, "Delete", onClick = {}, tint = MonAITheme.colors.error)
                }
            }
        }
    }
}
