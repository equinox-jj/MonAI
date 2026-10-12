package com.djtech.monai.feature.transactions.domain.usecase

import com.djtech.monai.feature.transactions.domain.model.TransactionResult
import com.djtech.monai.feature.transactions.domain.repository.TransactionRepository
import javax.inject.Inject

/** Fetches one transaction into the cache; fails with NotFound when it is gone. */
class RefreshTransactionUseCase @Inject constructor(private val transactionRepository: TransactionRepository) {
    suspend operator fun invoke(id: String): TransactionResult<Unit> = transactionRepository.refreshTransaction(id)
}
