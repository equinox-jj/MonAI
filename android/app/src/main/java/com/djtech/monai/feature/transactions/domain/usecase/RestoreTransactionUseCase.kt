package com.djtech.monai.feature.transactions.domain.usecase

import com.djtech.monai.core.common.result.Outcome
import com.djtech.monai.core.model.Transaction
import com.djtech.monai.feature.transactions.domain.model.TransactionResult
import com.djtech.monai.feature.transactions.domain.repository.TransactionRepository
import java.time.YearMonth
import javax.inject.Inject

/** Undoes a delete and refreshes the totals it changes. */
class RestoreTransactionUseCase @Inject constructor(
    private val transactionRepository: TransactionRepository,
    private val refreshDependents: RefreshTransactionDependentsUseCase,
) {
    suspend operator fun invoke(id: String): TransactionResult<Transaction> {
        val result = transactionRepository.restoreTransaction(id)
        if (result is Outcome.Success) refreshDependents(setOf(YearMonth.from(result.data.date)))
        return result
    }
}
