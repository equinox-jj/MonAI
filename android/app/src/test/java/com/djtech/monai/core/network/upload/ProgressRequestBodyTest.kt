package com.djtech.monai.core.network.upload

import okhttp3.MediaType.Companion.toMediaType
import okio.Buffer
import org.junit.Assert.assertArrayEquals
import org.junit.Assert.assertEquals
import org.junit.Test

class ProgressRequestBodyTest {

    @Test
    fun `writes every byte and ends at full progress`() {
        val bytes = ByteArray(20_000) { it.toByte() }
        val progress = mutableListOf<Float>()
        val sink = Buffer()

        ProgressRequestBody(bytes, "image/webp".toMediaType(), progress::add).writeTo(sink)

        assertArrayEquals(bytes, sink.readByteArray())
        // 8 KiB chunks: 8192, 16384, 20000.
        assertEquals(3, progress.size)
        assertEquals(1f, progress.last())
        assertEquals(progress.sorted(), progress)
    }

    @Test
    fun `an empty body reports done`() {
        val progress = mutableListOf<Float>()

        ProgressRequestBody(ByteArray(0), "image/webp".toMediaType(), progress::add).writeTo(Buffer())

        assertEquals(listOf(1f), progress)
    }

    @Test
    fun `the part is named file and keeps the type`() {
        val part = filePart(byteArrayOf(1, 2), "image/webp")

        assertEquals("form-data; name=\"file\"; filename=\"file.webp\"", part.headers?.get("Content-Disposition"))
        assertEquals("image/webp".toMediaType(), part.body.contentType())
    }
}
