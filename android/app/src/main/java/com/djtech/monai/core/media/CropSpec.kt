package com.djtech.monai.core.media

import kotlin.math.max
import kotlin.math.min
import kotlin.math.roundToInt

/**
 * How a photo is framed in the square crop window.
 *
 * @param zoom 1 fills the window with the photo's short side; 2.5 is the closest.
 * @param offsetX how far the photo is moved right, as a fraction of the window's side.
 * @param offsetY how far the photo is moved down, as a fraction of the window's side.
 * @param quarterTurns counterclockwise 90° turns, 0..3.
 */
data class CropSpec(
    val zoom: Float = MIN_ZOOM,
    val offsetX: Float = 0f,
    val offsetY: Float = 0f,
    val quarterTurns: Int = 0,
) {
    companion object {
        const val MIN_ZOOM = 1f
        const val MAX_ZOOM = 2.5f
    }
}

/** The square of the (rotated) photo to keep, in its pixels. */
data class CropRect(val left: Int, val top: Int, val size: Int)

/** The photo's size once turned [quarterTurns] times. */
fun rotatedSize(width: Int, height: Int, quarterTurns: Int): Pair<Int, Int> =
    if (quarterTurns.mod(4) % 2 == 1) height to width else width to height

/**
 * [spec] with its zoom in range and its offsets limited so the photo always covers the window.
 * [width] and [height] are the photo's size after rotation.
 */
fun CropSpec.clamped(width: Int, height: Int): CropSpec {
    val zoom = zoom.coerceIn(CropSpec.MIN_ZOOM, CropSpec.MAX_ZOOM)
    val (maxX, maxY) = maxOffsets(width, height, zoom)
    return copy(
        zoom = zoom,
        offsetX = offsetX.coerceIn(-maxX, maxX),
        offsetY = offsetY.coerceIn(-maxY, maxY),
        quarterTurns = quarterTurns.mod(4),
    )
}

/** The square of a [width] × [height] photo (after rotation) that the window shows for [spec]. */
fun cropRect(width: Int, height: Int, spec: CropSpec): CropRect {
    val clamped = spec.clamped(width, height)
    // The window shows this many photo pixels per side.
    val side = min(width, height) / clamped.zoom
    // Moving the photo right by a fraction of the window moves the window left by that much photo.
    val centerX = width / 2f - clamped.offsetX * side
    val centerY = height / 2f - clamped.offsetY * side
    val size = side.roundToInt().coerceIn(1, min(width, height))
    val left = (centerX - side / 2).roundToInt().coerceIn(0, width - size)
    val top = (centerY - side / 2).roundToInt().coerceIn(0, height - size)
    return CropRect(left, top, size)
}

// Half of the photo's overflow past the window, in window sides.
private fun maxOffsets(width: Int, height: Int, zoom: Float): Pair<Float, Float> {
    val side = min(width, height) / zoom
    return max(0f, (width - side) / 2 / side) to max(0f, (height - side) / 2 / side)
}
