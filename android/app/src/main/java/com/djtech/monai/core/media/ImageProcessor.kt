package com.djtech.monai.core.media

import androidx.compose.ui.graphics.ImageBitmap

/** An encoded image ready to upload. */
class EncodedImage(val bytes: ByteArray, val mimeType: String)

/** Which encoding to produce; both drop EXIF, so location and camera details never leave the phone. */
enum class ImageEncoding { WEBP_LOSSY, WEBP_LOSSLESS }

/**
 * Reads photos the user picked (content or file URIs, as strings) and re-encodes them for upload.
 * Every function returns null when the image can't be read or squeezed under the byte limit.
 */
interface ImageProcessor {

    /** The photo upright (EXIF orientation applied), its longest side at most [maxSide]. */
    suspend fun loadPreview(uri: String, maxSide: Int): ImageBitmap?

    /** The square [spec] frames, scaled to [side] × [side]. */
    suspend fun cropSquare(
        uri: String,
        spec: CropSpec,
        side: Int,
        encoding: ImageEncoding,
        maxBytes: Int,
    ): EncodedImage?

    /** The whole image, scaled down to fit [maxSide] when larger. */
    suspend fun fitWithin(
        uri: String,
        maxSide: Int,
        encoding: ImageEncoding,
        maxBytes: Int,
    ): EncodedImage?

    /** A new URI the camera can write a photo to. */
    fun newCameraUri(): String
}
