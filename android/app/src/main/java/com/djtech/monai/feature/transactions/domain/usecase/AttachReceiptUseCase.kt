package com.djtech.monai.feature.transactions.domain.usecase

import com.djtech.monai.core.model.Transaction
import com.djtech.monai.feature.transactions.domain.model.ReceiptUpload
import com.djtech.monai.feature.transactions.domain.repository.TransactionRepository
import kotlinx.coroutines.flow.Flow
import javax.inject.Inject

/** Uploads the photo at [uri] and links it to transaction [id], adding or replacing its receipt. */
class AttachReceiptUseCase @Inject constructor(
    private val uploadReceipt: UploadReceiptUseCase,
    private val transactionRepository: TransactionRepository,
) {
    operator fun invoke(id: String, uri: String): Flow<ReceiptUpload<Transaction>> =
        uploadReceipt(uri).thenWithKey { transactionRepository.attachReceipt(id, it) }
}
