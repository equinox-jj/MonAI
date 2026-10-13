package com.djtech.monai.core.media

import android.content.Context
import android.graphics.Bitmap
import android.graphics.BitmapFactory
import android.graphics.Color
import androidx.core.net.toUri
import androidx.test.core.app.ApplicationProvider
import androidx.test.ext.junit.runners.AndroidJUnit4
import com.djtech.monai.core.common.log.ErrorLogger
import kotlinx.coroutines.Dispatchers
import kotlinx.coroutines.test.runTest
import org.junit.Assert.assertEquals
import org.junit.Assert.assertNotNull
import org.junit.Assert.assertNull
import org.junit.Assert.assertTrue
import org.junit.Test
import org.junit.runner.RunWith

@RunWith(AndroidJUnit4::class)
class AndroidImageProcessorTest {

    private val context = ApplicationProvider.getApplicationContext<Context>()
    private val errors = mutableListOf<Throwable>()
    private val processor = AndroidImageProcessor(
        context,
        Dispatchers.IO,
        object : ErrorLogger {
            override fun log(message: String, error: Throwable) {
                errors += error
            }
        },
    )

    @Test
    fun loadsAPhotoWrittenToTheCameraUri() = runTest {
        val uri = processor.newCameraUri()
        writeJpeg(uri, width = 400, height = 300)

        val preview = processor.loadPreview(uri, maxSide = 2048)

        assertNotNull(preview)
        assertEquals(400, preview!!.width)
        assertEquals(300, preview.height)
        assertTrue(errors.isEmpty())
    }

    @Test
    fun cropsASquareWebp() = runTest {
        val uri = processor.newCameraUri()
        writeJpeg(uri, width = 400, height = 300)

        val image = processor.cropSquare(
            uri,
            CropSpec(),
            side = 128,
            encoding = ImageEncoding.WEBP_LOSSY,
            maxBytes = 2 * 1024 * 1024,
        )

        assertNotNull(image)
        assertEquals("image/webp", image!!.mimeType)
        val decoded = BitmapFactory.decodeByteArray(image.bytes, 0, image.bytes.size)
        assertEquals(128, decoded.width)
        assertEquals(128, decoded.height)
    }

    @Test
    fun anEmptyFileIsNotAnImage() = runTest {
        val uri = processor.newCameraUri()
        context.contentResolver.openOutputStream(uri.toUri())!!.use { }

        assertNull(processor.loadPreview(uri, maxSide = 2048))
    }

    private fun writeJpeg(uri: String, width: Int, height: Int) {
        val bitmap = Bitmap.createBitmap(width, height, Bitmap.Config.ARGB_8888).apply { eraseColor(Color.RED) }
        context.contentResolver.openOutputStream(uri.toUri())!!.use {
            bitmap.compress(Bitmap.CompressFormat.JPEG, 90, it)
        }
    }
}
