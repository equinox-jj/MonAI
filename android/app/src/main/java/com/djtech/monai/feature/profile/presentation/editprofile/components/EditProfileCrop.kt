package com.djtech.monai.feature.profile.presentation.editprofile.components

import androidx.compose.foundation.Canvas
import androidx.compose.foundation.background
import androidx.compose.foundation.gestures.detectTransformGestures
import androidx.compose.foundation.layout.Arrangement
import androidx.compose.foundation.layout.Box
import androidx.compose.foundation.layout.Column
import androidx.compose.foundation.layout.Row
import androidx.compose.foundation.layout.fillMaxSize
import androidx.compose.foundation.layout.fillMaxWidth
import androidx.compose.foundation.layout.padding
import androidx.compose.foundation.layout.safeDrawingPadding
import androidx.compose.material3.CircularProgressIndicator
import androidx.compose.material3.Icon
import androidx.compose.material3.Slider
import androidx.compose.material3.SliderDefaults
import androidx.compose.material3.Text
import androidx.compose.runtime.Composable
import androidx.compose.runtime.getValue
import androidx.compose.runtime.rememberUpdatedState
import androidx.compose.ui.Alignment
import androidx.compose.ui.Modifier
import androidx.compose.ui.draw.clipToBounds
import androidx.compose.ui.geometry.Offset
import androidx.compose.ui.geometry.Rect
import androidx.compose.ui.geometry.Size
import androidx.compose.ui.graphics.ImageBitmap
import androidx.compose.ui.graphics.Path
import androidx.compose.ui.graphics.PathFillType
import androidx.compose.ui.graphics.drawscope.Stroke
import androidx.compose.ui.graphics.drawscope.rotate
import androidx.compose.ui.graphics.drawscope.scale
import androidx.compose.ui.graphics.drawscope.translate
import androidx.compose.ui.input.pointer.pointerInput
import androidx.compose.ui.res.stringResource
import androidx.compose.ui.semantics.contentDescription
import androidx.compose.ui.semantics.semantics
import androidx.compose.ui.text.style.TextAlign
import androidx.compose.ui.unit.dp
import androidx.compose.ui.window.Dialog
import androidx.compose.ui.window.DialogProperties
import com.djtech.monai.R
import com.djtech.monai.core.designsystem.component.MonAIButton
import com.djtech.monai.core.designsystem.component.MonAIButtonSize
import com.djtech.monai.core.designsystem.component.MonAIButtonVariant
import com.djtech.monai.core.designsystem.icon.MonAIIcons
import com.djtech.monai.core.designsystem.theme.MonAITheme
import com.djtech.monai.core.media.CropSpec
import com.djtech.monai.core.media.rotatedSize
import com.djtech.monai.feature.profile.presentation.editprofile.model.CropState
import kotlin.math.min

/**
 * Frames the picked photo in a round window, over the whole screen and always dark: drag to move,
 * pinch or the slider to zoom, rotate a quarter turn, reset. Back cancels.
 */
@Composable
internal fun EditProfileCrop(
    crop: CropState,
    onSpecChange: (CropSpec) -> Unit,
    onRotate: () -> Unit,
    onReset: () -> Unit,
    onCancel: () -> Unit,
    onDone: () -> Unit,
) {
    Dialog(
        onDismissRequest = onCancel,
        properties = DialogProperties(usePlatformDefaultWidth = false, decorFitsSystemWindows = false),
    ) {
        MonAITheme(darkTheme = true) {
            val colors = MonAITheme.colors
            val spacing = MonAITheme.spacing
            Column(
                Modifier
                    .fillMaxSize()
                    .background(colors.background)
                    .safeDrawingPadding()
                    .padding(horizontal = spacing.screenHorizontal, vertical = spacing.x2),
                verticalArrangement = Arrangement.spacedBy(spacing.x4),
            ) {
                Row(verticalAlignment = Alignment.CenterVertically) {
                    MonAIButton(
                        stringResource(R.string.profile_crop_cancel),
                        onClick = onCancel,
                        variant = MonAIButtonVariant.Text,
                        size = MonAIButtonSize.Small,
                    )
                    Text(
                        stringResource(R.string.profile_crop_title),
                        Modifier.weight(1f),
                        style = MonAITheme.typography.titleMedium,
                        color = colors.textPrimary,
                        textAlign = TextAlign.Center,
                    )
                    MonAIButton(
                        stringResource(R.string.profile_crop_done),
                        onClick = onDone,
                        size = MonAIButtonSize.Small,
                        enabled = crop.preview != null,
                    )
                }
                Box(
                    Modifier
                        .weight(1f)
                        .fillMaxWidth(),
                    contentAlignment = Alignment.Center,
                ) {
                    val preview = crop.preview
                    if (preview == null) {
                        CircularProgressIndicator(color = colors.accent)
                    } else {
                        CropWindow(preview, crop.spec, onSpecChange)
                    }
                }
                Text(
                    stringResource(R.string.profile_crop_hint),
                    Modifier.fillMaxWidth(),
                    style = MonAITheme.typography.bodySmall,
                    color = colors.textSecondary,
                    textAlign = TextAlign.Center,
                )
                ZoomSlider(crop.spec, onSpecChange)
                Row(
                    Modifier.fillMaxWidth(),
                    horizontalArrangement = Arrangement.spacedBy(spacing.x3, Alignment.CenterHorizontally),
                ) {
                    MonAIButton(
                        stringResource(R.string.profile_crop_rotate),
                        onClick = onRotate,
                        variant = MonAIButtonVariant.Outlined,
                        size = MonAIButtonSize.Small,
                        leadingIcon = MonAIIcons.Rotate90DegreesCcw,
                        enabled = crop.preview != null,
                    )
                    MonAIButton(
                        stringResource(R.string.profile_crop_reset),
                        onClick = onReset,
                        variant = MonAIButtonVariant.Outlined,
                        size = MonAIButtonSize.Small,
                        leadingIcon = MonAIIcons.RestartAlt,
                        enabled = crop.preview != null,
                    )
                }
                Text(
                    stringResource(R.string.profile_crop_note),
                    Modifier.fillMaxWidth(),
                    style = MonAITheme.typography.bodySmall,
                    color = colors.textTertiary,
                    textAlign = TextAlign.Center,
                )
            }
        }
    }
}

@Composable
private fun ZoomSlider(spec: CropSpec, onSpecChange: (CropSpec) -> Unit) {
    val colors = MonAITheme.colors
    val zoomLabel = stringResource(R.string.profile_crop_zoom)
    Row(
        verticalAlignment = Alignment.CenterVertically,
        horizontalArrangement = Arrangement.spacedBy(MonAITheme.spacing.x2),
    ) {
        Icon(MonAIIcons.ZoomOut, null, tint = colors.textSecondary)
        Slider(
            value = spec.zoom,
            onValueChange = { onSpecChange(spec.copy(zoom = it)) },
            modifier = Modifier
                .weight(1f)
                .semantics { contentDescription = zoomLabel },
            valueRange = CropSpec.MIN_ZOOM..CropSpec.MAX_ZOOM,
            colors = SliderDefaults.colors(
                thumbColor = colors.accent,
                activeTrackColor = colors.accent,
                inactiveTrackColor = colors.border,
            ),
        )
        Icon(MonAIIcons.ZoomIn, null, tint = colors.textSecondary)
    }
}

/**
 * The photo drawn as [spec] frames it: scaled so its short side fills the window at zoom 1, moved
 * by the offsets (fractions of the window) and turned. The canvas fills the space between the
 * header and the controls and clips to it, so a zoomed photo never draws over them; everything
 * outside the round window is dimmed.
 */
@Composable
private fun CropWindow(
    image: ImageBitmap,
    spec: CropSpec,
    onSpecChange: (CropSpec) -> Unit,
) {
    val current by rememberUpdatedState(spec)
    val colors = MonAITheme.colors
    Canvas(
        Modifier
            .fillMaxSize()
            .clipToBounds()
            .pointerInput(image) {
                detectTransformGestures { _, pan, zoom, _ ->
                    val window = min(size.width, size.height).toFloat()
                    onSpecChange(
                        current.copy(
                            zoom = current.zoom * zoom,
                            offsetX = current.offsetX + pan.x / window,
                            offsetY = current.offsetY + pan.y / window,
                        ),
                    )
                }
            },
    ) {
        val window = size.minDimension
        val frame = Rect(center - Offset(window / 2, window / 2), Size(window, window))
        val (width, height) = rotatedSize(image.width, image.height, spec.quarterTurns)
        val scale = window / min(width, height) * spec.zoom
        translate(center.x + spec.offsetX * window, center.y + spec.offsetY * window) {
            rotate(-90f * spec.quarterTurns, pivot = Offset.Zero) {
                scale(scale, pivot = Offset.Zero) {
                    drawImage(image, topLeft = Offset(-image.width / 2f, -image.height / 2f))
                }
            }
        }
        val mask = Path().apply {
            fillType = PathFillType.EvenOdd
            addRect(Rect(Offset.Zero, size))
            addOval(frame)
        }
        drawPath(mask, colors.scrim)
        drawCircle(colors.highlight, radius = window / 2 - 1.dp.toPx(), style = Stroke(2.dp.toPx()))
        // Rule-of-thirds guides across the window.
        val third = window / 3
        for (i in 1..2) {
            drawLine(
                colors.onGradientMuted,
                Offset(frame.left + third * i, frame.top),
                Offset(frame.left + third * i, frame.bottom),
                1.dp.toPx(),
            )
            drawLine(
                colors.onGradientMuted,
                Offset(frame.left, frame.top + third * i),
                Offset(frame.right, frame.top + third * i),
                1.dp.toPx(),
            )
        }
    }
}
