package com.djtech.monai.core.network.upload

import okhttp3.MediaType
import okhttp3.MediaType.Companion.toMediaType
import okhttp3.MultipartBody
import okhttp3.RequestBody
import okio.BufferedSink

/**
 * Writes [bytes] in chunks and reports how much has been sent, 0..1, after each one.
 * A retried request writes again from the start, so progress may go back to 0.
 */
class ProgressRequestBody(
    private val bytes: ByteArray,
    private val mediaType: MediaType,
    private val onProgress: (Float) -> Unit,
) : RequestBody() {

    override fun contentType(): MediaType = mediaType

    override fun contentLength(): Long = bytes.size.toLong()

    override fun writeTo(sink: BufferedSink) {
        if (bytes.isEmpty()) {
            onProgress(1f)
            return
        }
        var written = 0
        while (written < bytes.size) {
            val count = minOf(CHUNK, bytes.size - written)
            sink.write(bytes, written, count)
            sink.flush()
            written += count
            onProgress(written.toFloat() / bytes.size)
        }
    }

    private companion object {
        const val CHUNK = 8 * 1024
    }
}

/** The `file` part every upload endpoint takes, named after its type (`file.webp`). */
fun filePart(
    bytes: ByteArray,
    mimeType: String,
    onProgress: (Float) -> Unit = {},
): MultipartBody.Part {
    val extension = mimeType.substringAfter('/', "bin")
    return MultipartBody.Part.createFormData(
        "file",
        "file.$extension",
        ProgressRequestBody(bytes, mimeType.toMediaType(), onProgress),
    )
}
