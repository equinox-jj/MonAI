package com.djtech.monai.feature.transactions.domain.usecase

import com.djtech.monai.core.common.result.Outcome
import com.djtech.monai.core.media.FakeImageProcessor
import com.djtech.monai.core.model.TransactionSource
import com.djtech.monai.feature.transactions.domain.model.ReceiptUpload
import com.djtech.monai.feature.transactions.domain.model.TransactionError
import com.djtech.monai.feature.transactions.domain.model.TransactionField
import com.djtech.monai.feature.transactions.domain.model.TransactionFieldError
import com.djtech.monai.feature.transactions.domain.model.TransactionFieldIssue
import com.djtech.monai.feature.transactions.domain.repository.FakeTransactionRepository
import kotlinx.coroutines.flow.toList
import kotlinx.coroutines.test.runTest
import org.junit.Assert.assertEquals
import org.junit.Assert.assertTrue
import org.junit.Test

class CreateTransactionWithReceiptUseCaseTest {

    private val repository = FakeTransactionRepository()
    private val images = FakeImageProcessor()
    private val save = CreateTransactionWithReceiptUseCase(
        UploadReceiptUseCase(repository, images),
        CreateTransactionUseCase(repository, DependentRepositories().refreshDependents, testClock()),
        testClock(),
    )

    @Test
    fun `uploads the photo, then creates the transaction with its key`() = runTest {
        val input = expenseInput().copy(source = TransactionSource.RECEIPT, merchant = "Toko Sumber Rejeki")

        val last = save(input, "content://photo").toList().last()

        assertTrue((last as ReceiptUpload.Done).result is Outcome.Success)
        assertEquals(listOf(input.copy(receiptKey = "receipts-pending/key.webp")), repository.created)
    }

    @Test
    fun `an invalid form uploads nothing`() = runTest {
        val steps = save(expenseInput(amount = 0), "content://photo").toList()

        assertEquals(
            listOf(
                ReceiptUpload.Done(
                    Outcome.Failure(
                        TransactionError.InvalidFields(
                            listOf(TransactionFieldError(TransactionField.AMOUNT, TransactionFieldIssue.REQUIRED)),
                        ),
                    ),
                ),
            ),
            steps,
        )
        assertEquals(emptyList<Any>(), images.fits)
    }
}
