package com.djtech.monai.core.designsystem.component

import androidx.compose.foundation.Canvas
import androidx.compose.runtime.Composable
import androidx.compose.ui.Modifier
import androidx.compose.ui.geometry.Offset
import androidx.compose.ui.geometry.Size
import androidx.compose.ui.graphics.Color
import androidx.compose.ui.graphics.drawscope.Stroke
import androidx.compose.ui.unit.Dp

/** Gap between donut segments, in degrees. */
private const val SEGMENT_GAP = 1.5f

/** Ring segments clockwise from 12 o'clock; [shares] are percentages, [colors] one per share. */
@Composable
fun MonAIDonut(
    shares: List<Float>,
    colors: List<Color>,
    stroke: Dp,
    modifier: Modifier = Modifier,
) {
    Canvas(modifier) {
        val strokePx = stroke.toPx()
        val diameter = size.minDimension - strokePx
        val topLeft = Offset((size.width - diameter) / 2, (size.height - diameter) / 2)
        val gap = if (shares.size > 1) SEGMENT_GAP else 0f
        var start = -90f
        shares.forEachIndexed { index, share ->
            val sweep = share * 3.6f
            drawArc(
                color = colors[index],
                startAngle = start,
                sweepAngle = (sweep - gap).coerceAtLeast(0f),
                useCenter = false,
                topLeft = topLeft,
                size = Size(diameter, diameter),
                style = Stroke(width = strokePx),
            )
            start += sweep
        }
    }
}
