package com.djtech.monai.feature.receipt.presentation.scanreceipt.components

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
import androidx.compose.foundation.layout.offset
import androidx.compose.foundation.layout.padding
import androidx.compose.foundation.layout.size
import androidx.compose.foundation.shape.RoundedCornerShape
import androidx.compose.material3.CircularProgressIndicator
import androidx.compose.material3.Icon
import androidx.compose.material3.Text
import androidx.compose.runtime.Composable
import androidx.compose.runtime.getValue
import androidx.compose.ui.Alignment
import androidx.compose.ui.Modifier
import androidx.compose.ui.draw.clip
import androidx.compose.ui.graphics.Color
import androidx.compose.ui.layout.ContentScale
import androidx.compose.ui.res.stringResource
import androidx.compose.ui.semantics.LiveRegionMode
import androidx.compose.ui.semantics.liveRegion
import androidx.compose.ui.semantics.semantics
import androidx.compose.ui.unit.IntOffset
import androidx.compose.ui.unit.dp
import coil3.compose.AsyncImage
import com.djtech.monai.R
import com.djtech.monai.core.designsystem.icon.MonAIIcons
import com.djtech.monai.core.designsystem.theme.MonAITheme
import com.djtech.monai.feature.receipt.presentation.scanreceipt.model.ProcessingStep

/** The photo with a sweeping scan line, and the three steps of reading it. */
@Composable
internal fun ScanReceiptProcessing(photoUri: String, step: ProcessingStep, modifier: Modifier = Modifier) {
    val colors = MonAITheme.colors
    val lime = colors.highlight
    Column(
        modifier.fillMaxWidth(),
        horizontalAlignment = Alignment.CenterHorizontally,
        verticalArrangement = Arrangement.spacedBy(MonAITheme.spacing.x6),
    ) {
        val sweep by rememberInfiniteTransition(label = "scan").animateFloat(
            initialValue = 0.06f,
            targetValue = 0.9f,
            animationSpec = infiniteRepeatable(tween(1200, easing = LinearEasing), RepeatMode.Reverse),
            label = "line",
        )
        Box(
            Modifier
                .size(width = 240.dp, height = 340.dp)
                .clip(RoundedCornerShape(MonAITheme.radius.lg)),
        ) {
            AsyncImage(photoUri, null, Modifier.size(width = 240.dp, height = 340.dp), contentScale = ContentScale.Crop)
            Box(
                Modifier
                    .offset { IntOffset(0, (340.dp.toPx() * sweep).toInt()) }
                    .fillMaxWidth()
                    .height(3.dp)
                    .background(lime),
            )
        }
        Column(
            Modifier.semantics { liveRegion = LiveRegionMode.Polite },
            horizontalAlignment = Alignment.CenterHorizontally,
            verticalArrangement = Arrangement.spacedBy(MonAITheme.spacing.x1_5),
        ) {
            Row(verticalAlignment = Alignment.CenterVertically, horizontalArrangement = Arrangement.spacedBy(10.dp)) {
                CircularProgressIndicator(Modifier.size(18.dp), color = lime, strokeWidth = 2.5.dp)
                Text(
                    stringResource(R.string.scan_reading),
                    style = MonAITheme.typography.titleMedium,
                    color = Color.White,
                )
            }
            Text(
                stringResource(R.string.scan_reading_hint),
                style = MonAITheme.typography.bodySmall,
                color = Color.White.copy(alpha = 0.6f),
            )
        }
        Column(
            Modifier
                .fillMaxWidth()
                .background(Color.White.copy(alpha = 0.06f), RoundedCornerShape(MonAITheme.radius.lg))
                .padding(MonAITheme.spacing.x4),
            verticalArrangement = Arrangement.spacedBy(MonAITheme.spacing.x3),
        ) {
            val reading = step == ProcessingStep.READING_TEXT
            Step(
                stringResource(R.string.scan_step_text),
                done = !reading,
                active = reading,
                trailing = stringResource(R.string.scan_step_text_offline),
            )
            Step(stringResource(R.string.scan_step_details), done = false, active = !reading)
            Step(stringResource(R.string.scan_step_draft), done = false, active = false)
        }
    }
}

@Composable
private fun Step(text: String, done: Boolean, active: Boolean, trailing: String? = null) {
    val colors = MonAITheme.colors
    val (icon, tint) = when {
        done -> MonAIIcons.CheckCircle to colors.income
        active -> MonAIIcons.AutoAwesome to colors.highlight
        else -> MonAIIcons.RadioButtonUnchecked to Color.White.copy(alpha = 0.4f)
    }
    Row(verticalAlignment = Alignment.CenterVertically, horizontalArrangement = Arrangement.spacedBy(10.dp)) {
        Icon(icon, null, Modifier.size(MonAITheme.sizes.iconLg), tint = tint)
        Text(
            text,
            Modifier.weight(1f),
            style = if (active) MonAITheme.typography.labelLarge else MonAITheme.typography.bodyMedium,
            color = if (done || active) Color.White else Color.White.copy(alpha = 0.4f),
        )
        trailing?.let {
            Text(it, style = MonAITheme.typography.bodySmall, color = Color.White.copy(alpha = 0.6f))
        }
    }
}
