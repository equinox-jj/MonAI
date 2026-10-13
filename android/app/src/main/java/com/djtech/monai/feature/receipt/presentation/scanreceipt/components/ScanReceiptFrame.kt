package com.djtech.monai.feature.receipt.presentation.scanreceipt.components

import androidx.compose.foundation.Canvas
import androidx.compose.foundation.layout.Box
import androidx.compose.foundation.layout.size
import androidx.compose.runtime.Composable
import androidx.compose.ui.Modifier
import androidx.compose.ui.geometry.Offset
import androidx.compose.ui.geometry.Size
import androidx.compose.ui.graphics.StrokeCap
import androidx.compose.ui.graphics.drawscope.Stroke
import androidx.compose.ui.unit.dp
import com.djtech.monai.core.designsystem.theme.MonAITheme

/** Lime corner brackets marking where the receipt should go. Decorative. */
@Composable
internal fun ScanReceiptFrame(modifier: Modifier = Modifier) {
    val color = MonAITheme.colors.highlight
    Box(modifier.size(width = 296.dp, height = 370.dp)) {
        Canvas(Modifier.size(width = 296.dp, height = 370.dp)) {
            val stroke = 4.dp.toPx()
            val arm = 40.dp.toPx()
            val radius = 16.dp.toPx()
            val style = Stroke(width = stroke, cap = StrokeCap.Round)
            val corners = listOf(
                Offset(0f, 0f) to 180f,
                Offset(size.width - radius * 2, 0f) to 270f,
                Offset(size.width - radius * 2, size.height - radius * 2) to 0f,
                Offset(0f, size.height - radius * 2) to 90f,
            )
            corners.forEach { (topLeft, start) ->
                drawArc(color, start, 90f, false, topLeft, Size(radius * 2, radius * 2), style = style)
            }
            // Straight arms beside each rounded corner.
            val w = size.width
            val h = size.height
            listOf(
                Offset(radius, 0f) to Offset(arm, 0f),
                Offset(0f, radius) to Offset(0f, arm),
                Offset(w - arm, 0f) to Offset(w - radius, 0f),
                Offset(w, radius) to Offset(w, arm),
                Offset(w, h - arm) to Offset(w, h - radius),
                Offset(w - arm, h) to Offset(w - radius, h),
                Offset(radius, h) to Offset(arm, h),
                Offset(0f, h - arm) to Offset(0f, h - radius),
            ).forEach { (from, to) -> drawLine(color, from, to, stroke, StrokeCap.Round) }
        }
    }
}
