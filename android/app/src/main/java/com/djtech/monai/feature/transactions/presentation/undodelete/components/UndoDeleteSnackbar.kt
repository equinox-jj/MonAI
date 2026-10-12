package com.djtech.monai.feature.transactions.presentation.undodelete.components

import androidx.compose.animation.core.Animatable
import androidx.compose.animation.core.LinearEasing
import androidx.compose.animation.core.tween
import androidx.compose.foundation.Canvas
import androidx.compose.foundation.background
import androidx.compose.foundation.layout.Arrangement
import androidx.compose.foundation.layout.Box
import androidx.compose.foundation.layout.Row
import androidx.compose.foundation.layout.fillMaxWidth
import androidx.compose.foundation.layout.height
import androidx.compose.foundation.layout.padding
import androidx.compose.foundation.layout.size
import androidx.compose.foundation.shape.RoundedCornerShape
import androidx.compose.material3.Text
import androidx.compose.material3.TextButton
import androidx.compose.runtime.Composable
import androidx.compose.runtime.LaunchedEffect
import androidx.compose.runtime.remember
import androidx.compose.ui.Alignment
import androidx.compose.ui.Modifier
import androidx.compose.ui.draw.clip
import androidx.compose.ui.draw.shadow
import androidx.compose.ui.geometry.Offset
import androidx.compose.ui.geometry.Size
import androidx.compose.ui.graphics.drawscope.Stroke
import androidx.compose.ui.res.stringResource
import androidx.compose.ui.semantics.LiveRegionMode
import androidx.compose.ui.semantics.clearAndSetSemantics
import androidx.compose.ui.semantics.liveRegion
import androidx.compose.ui.semantics.semantics
import androidx.compose.ui.text.font.FontWeight
import androidx.compose.ui.text.style.TextOverflow
import androidx.compose.ui.unit.dp
import androidx.compose.ui.unit.sp
import com.djtech.monai.R
import com.djtech.monai.core.designsystem.theme.MonAITheme
import kotlin.math.ceil

/**
 * The dark undo bar: a ring that runs down over [windowMillis] with the seconds left in it,
 * "<title> deleted", and Undo. [key] restarts the countdown for each new delete.
 */
@Composable
internal fun UndoDeleteSnackbar(
    key: String,
    title: String,
    windowMillis: Long,
    enabled: Boolean,
    onUndo: () -> Unit,
    modifier: Modifier = Modifier,
) {
    val colors = MonAITheme.colors
    val shape = RoundedCornerShape(MonAITheme.radius.md)
    val remaining = remember(key) { Animatable(1f) }
    LaunchedEffect(key) {
        remaining.animateTo(0f, tween(windowMillis.toInt(), easing = LinearEasing))
    }
    Row(
        modifier
            .fillMaxWidth()
            .shadow(12.dp, shape)
            .clip(shape)
            .background(colors.inverseSurface)
            .semantics { liveRegion = LiveRegionMode.Polite }
            .padding(start = MonAITheme.spacing.x3_5, end = MonAITheme.spacing.x1_5)
            .padding(vertical = MonAITheme.spacing.x1_5),
        verticalAlignment = Alignment.CenterVertically,
        horizontalArrangement = Arrangement.spacedBy(MonAITheme.spacing.x2_5),
    ) {
        CountdownRing(remaining.value, windowMillis)
        Text(
            stringResource(R.string.transaction_undo_deleted, title),
            Modifier.weight(1f),
            style = MonAITheme.typography.bodyMedium,
            color = colors.onInverseSurface,
            maxLines = 2,
            overflow = TextOverflow.Ellipsis,
        )
        TextButton(
            onClick = onUndo,
            enabled = enabled,
            shape = RoundedCornerShape(MonAITheme.radius.sm),
            modifier = Modifier.height(MonAITheme.sizes.touchTarget),
        ) {
            Text(
                stringResource(R.string.transaction_undo),
                style = MonAITheme.typography.labelLarge.copy(fontWeight = FontWeight.Bold),
                color = colors.inverseAccent,
            )
        }
    }
}

@Composable
private fun CountdownRing(fraction: Float, windowMillis: Long) {
    val colors = MonAITheme.colors
    val seconds = ceil(fraction * windowMillis / 1000f).toInt()
    // Decorative: the message is read out, and a ticking number would be noise.
    Box(
        Modifier
            .size(24.dp)
            .clearAndSetSemantics {},
        contentAlignment = Alignment.Center,
    ) {
        Canvas(Modifier.size(24.dp)) {
            val stroke = 2.5.dp.toPx()
            val topLeft = Offset(stroke / 2, stroke / 2)
            val arcSize = Size(size.width - stroke, size.height - stroke)
            drawArc(
                color = colors.onInverseSurface.copy(alpha = 0.25f),
                startAngle = 0f,
                sweepAngle = 360f,
                useCenter = false,
                topLeft = topLeft,
                size = arcSize,
                style = Stroke(stroke),
            )
            drawArc(
                color = colors.inverseAccent,
                startAngle = -90f,
                sweepAngle = 360f * fraction,
                useCenter = false,
                topLeft = topLeft,
                size = arcSize,
                style = Stroke(stroke),
            )
        }
        Text(
            seconds.toString(),
            style = MonAITheme.typography.labelSmall.copy(fontSize = 10.sp, fontWeight = FontWeight.Bold),
            color = colors.onInverseSurface,
        )
    }
}
