package com.djtech.monai.feature.transactions.domain.usecase

import com.djtech.monai.core.common.result.Outcome
import com.djtech.monai.core.media.ImageEncoding
import com.djtech.monai.core.media.ImageProcessor
import com.djtech.monai.feature.transactions.domain.model.ReceiptUpload
import com.djtech.monai.feature.transactions.domain.model.TransactionError
import com.djtech.monai.feature.transactions.domain.repository.TransactionRepository
import kotlinx.coroutines.flow.Flow
import kotlinx.coroutines.flow.emitAll
import kotlinx.coroutines.flow.flow
import javax.inject.Inject

/**
 * Shrinks the receipt photo at [uri] to a WebP that keeps small print readable (dropping location
 * and camera details) and uploads it, ending with its receipt key.
 */
class UploadReceiptUseCase @Inject constructor(
    private val transactionRepository: TransactionRepository,
    private val imageProcessor: ImageProcessor,
) {
    operator fun invoke(uri: String): Flow<ReceiptUpload<String>> = flow {
        val image = imageProcessor.fitWithin(
            uri,
            RECEIPT_MAX_SIDE,
            ImageEncoding.WEBP_LOSSY,
            MAX_RECEIPT_BYTES,
        )
        if (image == null) {
            emit(ReceiptUpload.Done(Outcome.Failure(TransactionError.PhotoUnsupported)))
        } else {
            emitAll(transactionRepository.uploadReceipt(image))
        }
    }

    companion object {
        const val RECEIPT_MAX_SIDE = 2000

        /** Under the API's 5 MB limit, leaving room for the multipart envelope. */
        const val MAX_RECEIPT_BYTES = 4_500_000
    }
}
