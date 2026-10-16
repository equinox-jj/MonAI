package com.djtech.monai.feature.transactions.domain.usecase

import com.djtech.monai.core.common.result.Outcome
import com.djtech.monai.core.common.result.flatMap
import com.djtech.monai.core.model.Transaction
import com.djtech.monai.feature.transactions.domain.model.TransactionError
import com.djtech.monai.feature.transactions.domain.model.TransactionResult
import com.djtech.monai.feature.transactions.domain.repository.TransactionRepository
import kotlinx.coroutines.flow.firstOrNull
import javax.inject.Inject

/** One transaction, from the cache or else fetched into it; NotFound when the server doesn't have it either. */
class GetTransactionUseCase @Inject constructor(private val transactionRepository: TransactionRepository) {
    suspend operator fun invoke(id: String): TransactionResult<Transaction> {
        cached(id)?.let { return Outcome.Success(it) }
        return transactionRepository.refreshTransaction(id).flatMap {
            cached(id)?.let { Outcome.Success(it) } ?: Outcome.Failure(TransactionError.NotFound)
        }
    }

    private suspend fun cached(id: String): Transaction? = transactionRepository.observeTransaction(id).firstOrNull()
}
