package com.djtech.monai.core.media

import androidx.compose.ui.graphics.ImageBitmap

/** Returns [image] for every request (null when unset), recording what was asked. */
class FakeImageProcessor(
    var image: EncodedImage? = EncodedImage(byteArrayOf(1, 2, 3), "image/webp"),
) : ImageProcessor {
    val crops = mutableListOf<Crop>()
    val fits = mutableListOf<Fit>()
    var preview: ImageBitmap? = null
    var cameraUriCount = 0

    data class Crop(
        val uri: String,
        val spec: CropSpec,
        val side: Int,
        val encoding: ImageEncoding,
        val maxBytes: Int,
    )

    data class Fit(
        val uri: String,
        val maxSide: Int,
        val encoding: ImageEncoding,
        val maxBytes: Int,
    )

    override suspend fun loadPreview(uri: String, maxSide: Int): ImageBitmap? = preview

    override suspend fun cropSquare(
        uri: String,
        spec: CropSpec,
        side: Int,
        encoding: ImageEncoding,
        maxBytes: Int,
    ): EncodedImage? {
        crops += Crop(
            uri,
            spec,
            side,
            encoding,
            maxBytes,
        )
        return image
    }

    override suspend fun fitWithin(
        uri: String,
        maxSide: Int,
        encoding: ImageEncoding,
        maxBytes: Int,
    ): EncodedImage? {
        fits += Fit(
            uri,
            maxSide,
            encoding,
            maxBytes,
        )
        return image
    }

    override fun newCameraUri(): String = "content://camera/${++cameraUriCount}"
}
