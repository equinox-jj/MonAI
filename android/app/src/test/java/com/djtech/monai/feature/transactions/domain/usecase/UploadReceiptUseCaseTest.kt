package com.djtech.monai.feature.transactions.domain.usecase

import com.djtech.monai.core.common.result.Outcome
import com.djtech.monai.core.media.FakeImageProcessor
import com.djtech.monai.core.media.ImageEncoding
import com.djtech.monai.feature.transactions.domain.model.ReceiptUpload
import com.djtech.monai.feature.transactions.domain.model.TransactionError
import com.djtech.monai.feature.transactions.domain.repository.FakeTransactionRepository
import kotlinx.coroutines.flow.toList
import kotlinx.coroutines.test.runTest
import org.junit.Assert.assertEquals
import org.junit.Test

class UploadReceiptUseCaseTest {

    private val repository = FakeTransactionRepository()
    private val images = FakeImageProcessor()
    private val upload = UploadReceiptUseCase(repository, images)

    @Test
    fun `shrinks the photo to a lossy WebP under the limit and uploads it`() = runTest {
        val steps = upload("content://photo").toList()

        assertEquals(
            FakeImageProcessor.Fit("content://photo", 2000, ImageEncoding.WEBP_LOSSY, 4_500_000),
            images.fits.single(),
        )
        assertEquals(listOf(images.image), repository.uploadedImages)
        assertEquals(ReceiptUpload.Done(Outcome.Success("receipts-pending/key.webp")), steps.last())
    }

    @Test
    fun `a photo that can't be read uploads nothing`() = runTest {
        images.image = null

        assertEquals(
            listOf(ReceiptUpload.Done(Outcome.Failure(TransactionError.PhotoUnsupported))),
            upload("content://photo").toList(),
        )
        assertEquals(emptyList<Any>(), repository.uploadedImages)
    }
}
