package com.djtech.monai.feature.transactions.domain.usecase

import com.djtech.monai.core.common.result.Outcome
import com.djtech.monai.core.media.FakeImageProcessor
import com.djtech.monai.core.model.transaction
import com.djtech.monai.feature.transactions.domain.model.ReceiptUpload
import com.djtech.monai.feature.transactions.domain.model.TransactionError
import com.djtech.monai.feature.transactions.domain.repository.FakeTransactionRepository
import kotlinx.coroutines.flow.toList
import kotlinx.coroutines.test.runTest
import org.junit.Assert.assertEquals
import org.junit.Assert.assertTrue
import org.junit.Test

class AttachReceiptUseCaseTest {

    private val repository = FakeTransactionRepository(listOf(transaction("t1")))
    private val attach = AttachReceiptUseCase(UploadReceiptUseCase(repository, FakeImageProcessor()), repository)

    @Test
    fun `reports upload progress, then links the key to the transaction`() = runTest {
        val steps = attach("t1", "content://photo").toList()

        assertEquals(listOf(ReceiptUpload.Progress(0.5f), ReceiptUpload.Progress(1f)), steps.dropLast(1))
        val done = steps.last() as ReceiptUpload.Done
        assertTrue((done.result as Outcome.Success).data.receiptUrl != null)
        assertEquals(listOf("t1" to "receipts-pending/key.webp"), repository.attached)
    }

    @Test
    fun `a failed upload attaches nothing`() = runTest {
        repository.uploadResult = Outcome.Failure(TransactionError.Network)

        assertEquals(
            ReceiptUpload.Done(Outcome.Failure(TransactionError.Network)),
            attach("t1", "content://photo").toList().last(),
        )
        assertEquals(emptyList<Any>(), repository.attached)
    }
}
