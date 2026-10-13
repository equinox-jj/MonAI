package com.djtech.monai.core.media

import android.content.Context
import android.graphics.Bitmap
import android.graphics.BitmapFactory
import android.graphics.Matrix
import android.net.Uri
import android.os.Build
import androidx.compose.ui.graphics.ImageBitmap
import androidx.compose.ui.graphics.asImageBitmap
import androidx.core.content.FileProvider
import androidx.core.graphics.scale
import androidx.core.net.toUri
import androidx.exifinterface.media.ExifInterface
import com.djtech.monai.core.common.dispatcher.Dispatcher
import com.djtech.monai.core.common.dispatcher.MonAIDispatcher
import com.djtech.monai.core.common.log.ErrorLogger
import dagger.hilt.android.qualifiers.ApplicationContext
import kotlinx.coroutines.CoroutineDispatcher
import kotlinx.coroutines.withContext
import java.io.ByteArrayOutputStream
import java.io.File
import java.util.UUID
import javax.inject.Inject
import kotlin.coroutines.cancellation.CancellationException
import kotlin.math.max
import kotlin.math.roundToInt

/** Decodes with [BitmapFactory] and re-encodes to WebP, which writes no EXIF. */
class AndroidImageProcessor @Inject constructor(
    @ApplicationContext private val context: Context,
    @Dispatcher(MonAIDispatcher.IO) private val ioDispatcher: CoroutineDispatcher,
    private val errorLogger: ErrorLogger,
) : ImageProcessor {

    override suspend fun loadPreview(uri: String, maxSide: Int): ImageBitmap? = safely {
        decodeUpright(uri.toUri(), maxSide)?.asImageBitmap()
    }

    override suspend fun cropSquare(
        uri: String,
        spec: CropSpec,
        side: Int,
        encoding: ImageEncoding,
        maxBytes: Int,
    ): EncodedImage? = safely {
        // Decoding a little larger than the output keeps zoomed crops sharp without loading a 50 MP photo.
        val source = decodeUpright(uri.toUri(), side * MAX_ZOOM_DECODE) ?: return@safely null
        val turned = source.rotated(spec.quarterTurns)
        val rect = cropRect(turned.width, turned.height, spec)
        val square = Bitmap.createBitmap(
            turned,
            rect.left,
            rect.top,
            rect.size,
            rect.size,
        )
        val scaled = square.scale(side, side)
        encode(scaled, encoding, maxBytes)
    }

    override suspend fun fitWithin(
        uri: String,
        maxSide: Int,
        encoding: ImageEncoding,
        maxBytes: Int,
    ): EncodedImage? = safely {
        val bitmap = decodeUpright(uri.toUri(), maxSide) ?: return@safely null
        encode(bitmap.scaledToFit(maxSide), encoding, maxBytes)
    }

    override fun newCameraUri(): String {
        val dir = File(context.cacheDir, CAMERA_DIR).apply { mkdirs() }
        val file = File(dir, "${UUID.randomUUID()}.jpg")
        return FileProvider.getUriForFile(context, "${context.packageName}.fileprovider", file).toString()
    }

    private suspend fun <T> safely(block: suspend () -> T?): T? = withContext(ioDispatcher) {
        try {
            block()
        } catch (e: CancellationException) {
            throw e
        } catch (e: Exception) {
            errorLogger.log("Processing an image failed", e)
            null
        } catch (e: OutOfMemoryError) {
            errorLogger.log("Image too large to process", e)
            null
        }
    }

    /** Decoded at the smallest power-of-two sample that keeps [minSide] pixels, then turned upright. */
    private fun decodeUpright(uri: Uri, minSide: Int): Bitmap? {
        val resolver = context.contentResolver
        val bounds = BitmapFactory.Options().apply { inJustDecodeBounds = true }
        // A bounds-only decode always returns null; the size lands in [bounds].
        val boundsStream = resolver.openInputStream(uri) ?: return null
        boundsStream.use { BitmapFactory.decodeStream(it, null, bounds) }
        if (bounds.outWidth <= 0 || bounds.outHeight <= 0) return null

        var sample = 1
        while (max(bounds.outWidth, bounds.outHeight) / (sample * 2) >= minSide) sample *= 2
        val options = BitmapFactory.Options().apply { inSampleSize = sample }
        val bitmap = resolver.openInputStream(uri)?.use { BitmapFactory.decodeStream(it, null, options) } ?: return null

        val orientation = resolver.openInputStream(uri)?.use {
            ExifInterface(it).getAttributeInt(ExifInterface.TAG_ORIENTATION, ExifInterface.ORIENTATION_NORMAL)
        } ?: ExifInterface.ORIENTATION_NORMAL
        return bitmap.oriented(orientation)
    }

    /** Lowers the quality until it fits [maxBytes]; lossless images are only shrunk. */
    private fun encode(bitmap: Bitmap, encoding: ImageEncoding, maxBytes: Int): EncodedImage? {
        var current = bitmap
        repeat(MAX_ATTEMPTS) {
            for (quality in QUALITIES) {
                val bytes = current.compress(encoding, quality)
                if (bytes.size <= maxBytes) return EncodedImage(bytes, WEBP)
                if (encoding == ImageEncoding.WEBP_LOSSLESS) break
            }
            current = current.scaledToFit((max(current.width, current.height) * SHRINK).roundToInt())
        }
        return null
    }

    private companion object {
        const val CAMERA_DIR = "camera"
        const val WEBP = "image/webp"
        const val MAX_ZOOM_DECODE = 3
        const val MAX_ATTEMPTS = 4
        const val SHRINK = 0.75f
        val QUALITIES = listOf(90, 80, 70, 60)
    }
}

@Suppress("DEPRECATION")
private fun Bitmap.compress(encoding: ImageEncoding, quality: Int): ByteArray {
    val format = when {
        Build.VERSION.SDK_INT < Build.VERSION_CODES.R -> Bitmap.CompressFormat.WEBP
        encoding == ImageEncoding.WEBP_LOSSY -> Bitmap.CompressFormat.WEBP_LOSSY
        else -> Bitmap.CompressFormat.WEBP_LOSSLESS
    }
    // Before API 30 plain WEBP is lossless only at quality 100.
    val legacyLossless = Build.VERSION.SDK_INT < Build.VERSION_CODES.R && encoding == ImageEncoding.WEBP_LOSSLESS
    val q = if (legacyLossless) 100 else quality
    return ByteArrayOutputStream().use { out ->
        compress(format, q, out)
        out.toByteArray()
    }
}

private fun Bitmap.scaledToFit(maxSide: Int): Bitmap {
    val longest = max(width, height)
    if (longest <= maxSide) return this
    val ratio = maxSide.toFloat() / longest
    return scale(
        (width * ratio).roundToInt().coerceAtLeast(1),
        (height * ratio).roundToInt().coerceAtLeast(1),
    )
}

/** Turned [quarterTurns] times counterclockwise. */
private fun Bitmap.rotated(quarterTurns: Int): Bitmap {
    val turns = quarterTurns.mod(4)
    if (turns == 0) return this
    val matrix = Matrix().apply { postRotate(-90f * turns) }
    return Bitmap.createBitmap(
        this,
        0,
        0,
        width,
        height,
        matrix,
        true,
    )
}

private fun Bitmap.oriented(orientation: Int): Bitmap {
    val matrix = Matrix()
    when (orientation) {
        ExifInterface.ORIENTATION_ROTATE_90 -> matrix.postRotate(90f)
        ExifInterface.ORIENTATION_ROTATE_180 -> matrix.postRotate(180f)
        ExifInterface.ORIENTATION_ROTATE_270 -> matrix.postRotate(270f)
        ExifInterface.ORIENTATION_FLIP_HORIZONTAL -> matrix.postScale(-1f, 1f)
        ExifInterface.ORIENTATION_FLIP_VERTICAL -> matrix.postScale(1f, -1f)
        ExifInterface.ORIENTATION_TRANSPOSE -> matrix.apply { postRotate(90f); postScale(-1f, 1f) }
        ExifInterface.ORIENTATION_TRANSVERSE -> matrix.apply { postRotate(270f); postScale(-1f, 1f) }
        else -> return this
    }
    return Bitmap.createBitmap(
        this,
        0,
        0,
        width,
        height,
        matrix,
        true,
    )
}
