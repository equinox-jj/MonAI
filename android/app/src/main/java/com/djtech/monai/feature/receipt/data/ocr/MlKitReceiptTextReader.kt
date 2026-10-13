package com.djtech.monai.feature.receipt.data.ocr

import android.content.Context
import androidx.core.net.toUri
import com.djtech.monai.core.common.log.ErrorLogger
import com.djtech.monai.feature.receipt.domain.ocr.ReceiptTextReader
import com.google.mlkit.vision.common.InputImage
import com.google.mlkit.vision.text.TextRecognition
import com.google.mlkit.vision.text.latin.TextRecognizerOptions
import dagger.hilt.android.qualifiers.ApplicationContext
import kotlinx.coroutines.suspendCancellableCoroutine
import java.io.IOException
import javax.inject.Inject
import javax.inject.Singleton
import kotlin.coroutines.resume

/** ML Kit's bundled Latin recognizer: works offline, with no model download on first use. */
@Singleton
class MlKitReceiptTextReader @Inject constructor(
    @ApplicationContext private val context: Context,
    private val errorLogger: ErrorLogger,
) : ReceiptTextReader {

    private val recognizer by lazy { TextRecognition.getClient(TextRecognizerOptions.DEFAULT_OPTIONS) }

    override suspend fun read(uri: String): String? {
        val image = try {
            // Applies the photo's EXIF rotation, so sideways shots read the right way up.
            InputImage.fromFilePath(context, uri.toUri())
        } catch (e: IOException) {
            errorLogger.log("Opening a receipt photo failed", e)
            return null
        }
        return suspendCancellableCoroutine { continuation ->
            recognizer.process(image)
                .addOnSuccessListener { continuation.resume(it.text.ifBlank { null }) }
                .addOnFailureListener {
                    errorLogger.log("Reading receipt text failed", it)
                    continuation.resume(null)
                }
        }
    }
}
