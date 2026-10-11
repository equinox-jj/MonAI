package com.djtech.monai.core.designsystem.component

import androidx.compose.animation.core.LinearEasing
import androidx.compose.animation.core.RepeatMode
import androidx.compose.animation.core.animateFloat
import androidx.compose.animation.core.infiniteRepeatable
import androidx.compose.animation.core.rememberInfiniteTransition
import androidx.compose.animation.core.tween
import androidx.compose.foundation.background
import androidx.compose.foundation.layout.Arrangement
import androidx.compose.foundation.layout.Box
import androidx.compose.foundation.layout.Column
import androidx.compose.foundation.layout.Row
import androidx.compose.foundation.layout.fillMaxWidth
import androidx.compose.foundation.layout.height
import androidx.compose.foundation.layout.padding
import androidx.compose.foundation.layout.size
import androidx.compose.foundation.layout.width
import androidx.compose.foundation.shape.CircleShape
import androidx.compose.foundation.shape.RoundedCornerShape
import androidx.compose.material3.Icon
import androidx.compose.material3.Text
import androidx.compose.runtime.Composable
import androidx.compose.runtime.getValue
import androidx.compose.ui.Alignment
import androidx.compose.ui.Modifier
import androidx.compose.ui.composed
import androidx.compose.ui.draw.clip
import androidx.compose.ui.geometry.Offset
import androidx.compose.ui.graphics.Brush
import androidx.compose.ui.graphics.Color
import androidx.compose.ui.graphics.Shape
import androidx.compose.ui.graphics.vector.ImageVector
import androidx.compose.ui.semantics.LiveRegionMode
import androidx.compose.ui.semantics.liveRegion
import androidx.compose.ui.semantics.semantics
import androidx.compose.ui.text.style.TextAlign
import androidx.compose.ui.tooling.preview.PreviewLightDark
import androidx.compose.ui.unit.Dp
import androidx.compose.ui.unit.dp
import com.djtech.monai.core.designsystem.icon.MonAIIcons
import com.djtech.monai.core.designsystem.theme.MonAITheme

/**
 * Centered icon, title, message and actions for empty and error states.
 *
 * @param tone [MonAIAlertTone.Error] gives the red icon circle; anything else is indigo.
 * @param footnote small gray line under the actions, e.g. "Error code: internal_error".
 */
@Composable
fun MonAIStateMessage(
    icon: ImageVector,
    title: String,
    message: String,
    modifier: Modifier = Modifier,
    tone: MonAIAlertTone = MonAIAlertTone.Info,
    actionLabel: String? = null,
    actionIcon: ImageVector? = null,
    onAction: () -> Unit = {},
    actionLoading: Boolean = false,
    secondaryActionLabel: String? = null,
    onSecondaryAction: () -> Unit = {},
    footnote: String? = null,
) {
    val colors = MonAITheme.colors
    val (container, content) = if (tone == MonAIAlertTone.Error) {
        colors.errorContainer to colors.error
    } else {
        colors.primaryContainer to colors.accent
    }
    Column(
        modifier = modifier.semantics { if (tone == MonAIAlertTone.Error) liveRegion = LiveRegionMode.Polite },
        horizontalAlignment = Alignment.CenterHorizontally,
        verticalArrangement = Arrangement.spacedBy(MonAITheme.spacing.x3),
    ) {
        Box(
            Modifier
                .size(MonAITheme.sizes.stateIcon)
                .clip(CircleShape)
                .background(container),
            contentAlignment = Alignment.Center,
        ) {
            Icon(icon, null, Modifier.size(MonAITheme.sizes.iconXxl), tint = content)
        }
        Text(title, style = MonAITheme.typography.titleMedium, color = colors.textPrimary, textAlign = TextAlign.Center)
        Text(message, style = MonAITheme.typography.bodyMedium, color = colors.textSecondary, textAlign = TextAlign.Center)
        if (actionLabel != null) {
            MonAIButton(
                text = actionLabel,
                onClick = onAction,
                modifier = Modifier.padding(top = MonAITheme.spacing.x1),
                size = MonAIButtonSize.Medium,
                leadingIcon = actionIcon,
                loading = actionLoading,
            )
        }
        if (secondaryActionLabel != null) {
            MonAITextLink(secondaryActionLabel, onSecondaryAction, style = MonAITheme.extendedTypography.bodyCompact.copy(fontWeight = MonAITheme.typography.labelLarge.fontWeight))
        }
        if (footnote != null) {
            Text(footnote, style = MonAITheme.typography.bodySmall, color = colors.textDisabled)
        }
    }
}

/**
 * Shimmering placeholder fill. Use [onGradient] for placeholders inside [MonAIGradientCard].
 */
fun Modifier.shimmer(onGradient: Boolean = false): Modifier = composed {
    val colors = MonAITheme.colors
    val base = when {
        onGradient -> Color.White.copy(alpha = 0.14f)
        colors.isDark -> colors.surfaceKey
        else -> colors.surfaceSunken
    }
    val highlight = when {
        onGradient -> Color.White.copy(alpha = 0.28f)
        colors.isDark -> colors.borderStrong
        else -> colors.border
    }
    val transition = rememberInfiniteTransition(label = "shimmer")
    val x by transition.animateFloat(
        initialValue = -400f,
        targetValue = 400f,
        animationSpec = infiniteRepeatable(tween(1200, easing = LinearEasing), RepeatMode.Restart),
        label = "shimmerX",
    )
    background(
        Brush.linearGradient(
            colors = listOf(base, highlight, base),
            start = Offset(x, 0f),
            end = Offset(x + 800f, 0f),
        ),
    )
}

/** A shimmering block. Leave [width] null to fill the available width. */
@Composable
fun MonAISkeleton(
    height: Dp,
    modifier: Modifier = Modifier,
    width: Dp? = null,
    shape: Shape = RoundedCornerShape(MonAITheme.radius.xs),
    onGradient: Boolean = false,
) {
    Box(
        modifier
            .then(if (width != null) Modifier.width(width) else Modifier.fillMaxWidth())
            .height(height)
            .clip(shape)
            .shimmer(onGradient),
    )
}

/** 8dp rounded progress bar, e.g. budget used. [progress] is clamped to 0..1. */
@Composable
fun MonAIProgressBar(
    progress: Float,
    modifier: Modifier = Modifier,
    color: Color = MonAITheme.colors.accent,
    trackColor: Color = MonAITheme.colors.surfaceSunken,
) {
    val shape = RoundedCornerShape(MonAITheme.radius.xs)
    Box(
        modifier
            .fillMaxWidth()
            .height(MonAITheme.sizes.progressTrack)
            .clip(shape)
            .background(trackColor),
    ) {
        Box(
            Modifier
                .fillMaxWidth(progress.coerceIn(0f, 1f))
                .height(MonAITheme.sizes.progressTrack)
                .clip(shape)
                .background(color),
        )
    }
}

/** Onboarding step dots: the current step is a 24dp bar. */
@Composable
fun MonAIPageIndicator(
    pageCount: Int,
    currentPage: Int,
    modifier: Modifier = Modifier,
) {
    Row(modifier, horizontalArrangement = Arrangement.spacedBy(MonAITheme.spacing.x1_5)) {
        repeat(pageCount) { index ->
            Box(
                Modifier
                    .size(width = if (index == currentPage) 24.dp else 6.dp, height = 6.dp)
                    .clip(CircleShape)
                    .background(if (index == currentPage) MonAITheme.colors.primary else MonAITheme.colors.borderStrong),
            )
        }
    }
}

@PreviewLightDark
@Composable
private fun StatesPreview() {
    MonAITheme {
        Column(
            Modifier
                .background(MonAITheme.colors.background)
                .padding(16.dp),
            verticalArrangement = Arrangement.spacedBy(20.dp),
        ) {
            MonAIStateMessage(
                icon = MonAIIcons.ReceiptLong,
                title = "No transactions yet",
                message = "Add your first expense to see where your money goes.",
                actionLabel = "Add transaction",
                actionIcon = MonAIIcons.Add,
                secondaryActionLabel = "or try “kopi 25rb pakai cash”",
                modifier = Modifier.fillMaxWidth(),
            )
            MonAIStateMessage(
                icon = MonAIIcons.Error,
                title = "Couldn't load your wallets",
                message = "Something went wrong on our side. Your data is safe — try again in a moment.",
                tone = MonAIAlertTone.Error,
                actionLabel = "Try again",
                actionIcon = MonAIIcons.Refresh,
                footnote = "Error code: internal_error",
                modifier = Modifier.fillMaxWidth(),
            )
            MonAIProgressBar(0.8f, color = MonAITheme.colors.warning)
            MonAIPageIndicator(pageCount = 3, currentPage = 0)
            Row(horizontalArrangement = Arrangement.spacedBy(12.dp), verticalAlignment = Alignment.CenterVertically) {
                MonAISkeleton(40.dp, width = 40.dp, shape = CircleShape)
                Column(Modifier.weight(1f), verticalArrangement = Arrangement.spacedBy(6.dp)) {
                    MonAISkeleton(14.dp, Modifier.fillMaxWidth(0.6f))
                    MonAISkeleton(10.dp, Modifier.fillMaxWidth(0.4f))
                }
            }
        }
    }
}
