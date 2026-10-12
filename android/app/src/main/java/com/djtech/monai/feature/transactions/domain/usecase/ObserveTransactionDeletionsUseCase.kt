package com.djtech.monai.feature.transactions.domain.usecase

import com.djtech.monai.core.model.Transaction
import com.djtech.monai.feature.transactions.domain.repository.TransactionRepository
import kotlinx.coroutines.flow.Flow
import javax.inject.Inject

/** Each transaction as it is deleted, from any screen, so it can be offered for undo. */
class ObserveTransactionDeletionsUseCase @Inject constructor(private val transactionRepository: TransactionRepository) {
    operator fun invoke(): Flow<Transaction> = transactionRepository.deletions
}
