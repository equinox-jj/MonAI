package com.djtech.monai.feature.transactions.domain.usecase

import com.djtech.monai.core.common.result.Outcome
import com.djtech.monai.core.common.time.AppClock
import com.djtech.monai.core.model.Transaction
import com.djtech.monai.feature.transactions.domain.model.ReceiptUpload
import com.djtech.monai.feature.transactions.domain.model.TransactionError
import com.djtech.monai.feature.transactions.domain.model.TransactionInput
import com.djtech.monai.feature.transactions.domain.validation.normalized
import com.djtech.monai.feature.transactions.domain.validation.validate
import kotlinx.coroutines.flow.Flow
import kotlinx.coroutines.flow.emitAll
import kotlinx.coroutines.flow.flow
import javax.inject.Inject

/**
 * Saves a transaction with the receipt photo at [photoUri]: checks [input] first so a bad form
 * uploads nothing, then uploads the photo and creates the transaction with its key.
 */
class CreateTransactionWithReceiptUseCase @Inject constructor(
    private val uploadReceipt: UploadReceiptUseCase,
    private val createTransaction: CreateTransactionUseCase,
    private val clock: AppClock,
) {
    operator fun invoke(input: TransactionInput, photoUri: String): Flow<ReceiptUpload<Transaction>> = flow {
        val errors = input.normalized().validate(clock.today())
        if (errors.isNotEmpty()) {
            emit(ReceiptUpload.Done(Outcome.Failure(TransactionError.InvalidFields(errors))))
            return@flow
        }
        emitAll(uploadReceipt(photoUri).thenWithKey { createTransaction(input.copy(receiptKey = it)) })
    }
}
