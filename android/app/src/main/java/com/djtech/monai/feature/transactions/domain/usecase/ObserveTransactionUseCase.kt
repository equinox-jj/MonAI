package com.djtech.monai.feature.transactions.domain.usecase

import com.djtech.monai.core.model.Transaction
import com.djtech.monai.feature.transactions.domain.repository.TransactionRepository
import kotlinx.coroutines.flow.Flow
import javax.inject.Inject

/** One cached transaction; null when it isn't cached. */
class ObserveTransactionUseCase @Inject constructor(private val transactionRepository: TransactionRepository) {
    operator fun invoke(id: String): Flow<Transaction?> = transactionRepository.observeTransaction(id)
}
