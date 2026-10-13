package com.djtech.monai.feature.receipt.domain.usecase

import com.djtech.monai.feature.receipt.domain.ocr.FakeReceiptTextReader
import kotlinx.coroutines.test.runTest
import org.junit.Assert.assertEquals
import org.junit.Assert.assertNull
import org.junit.Test

class ReadReceiptTextUseCaseTest {

    private val reader = FakeReceiptTextReader()
    private val read = ReadReceiptTextUseCase(reader)

    @Test
    fun `returns the trimmed text`() = runTest {
        reader.text = "  TOTAL 10.000 \n"

        assertEquals("TOTAL 10.000", read("content://photo"))
        assertEquals(listOf("content://photo"), reader.uris)
    }

    @Test
    fun `blank text counts as none`() = runTest {
        reader.text = " \n "

        assertNull(read("content://photo"))
    }
}
