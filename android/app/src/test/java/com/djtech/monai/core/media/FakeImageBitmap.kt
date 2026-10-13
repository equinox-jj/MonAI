package com.djtech.monai.core.media

import androidx.compose.ui.graphics.ImageBitmap
import androidx.compose.ui.graphics.ImageBitmapConfig
import androidx.compose.ui.graphics.colorspace.ColorSpace
import androidx.compose.ui.graphics.colorspace.ColorSpaces

/** Only a size: JVM tests can't create a real Android bitmap. */
class FakeImageBitmap(override val width: Int, override val height: Int) : ImageBitmap {
    override val colorSpace: ColorSpace get() = ColorSpaces.Srgb
    override val hasAlpha: Boolean get() = false
    override val config: ImageBitmapConfig get() = ImageBitmapConfig.Argb8888

    override fun readPixels(
        buffer: IntArray,
        startX: Int,
        startY: Int,
        width: Int,
        height: Int,
        bufferOffset: Int,
        stride: Int,
    ) = error("Not faked")

    override fun prepareToDraw() = Unit
}
