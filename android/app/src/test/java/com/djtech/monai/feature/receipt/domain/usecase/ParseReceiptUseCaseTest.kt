package com.djtech.monai.feature.receipt.domain.usecase

import com.djtech.monai.core.common.result.Outcome
import com.djtech.monai.core.model.receiptDraft
import com.djtech.monai.feature.receipt.domain.repository.FakeReceiptRepository
import com.djtech.monai.feature.transactions.domain.usecase.testClock
import kotlinx.coroutines.test.runTest
import org.junit.Assert.assertEquals
import org.junit.Test

class ParseReceiptUseCaseTest {

    private val repository = FakeReceiptRepository()
    private val parse = ParseReceiptUseCase(repository, testClock())

    @Test
    fun `sends the OCR text, cut to the API's limit`() = runTest {
        assertEquals(Outcome.Success(receiptDraft()), parse("x".repeat(6000)))
        assertEquals(5000, repository.texts.single().length)
    }
}
