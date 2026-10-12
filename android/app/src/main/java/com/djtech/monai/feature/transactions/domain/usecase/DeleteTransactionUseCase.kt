package com.djtech.monai.feature.transactions.domain.usecase

import com.djtech.monai.core.common.result.Outcome
import com.djtech.monai.core.common.result.map
import com.djtech.monai.feature.transactions.domain.model.TransactionResult
import com.djtech.monai.feature.transactions.domain.repository.TransactionRepository
import java.time.YearMonth
import javax.inject.Inject

/** Deletes a transaction (it can be restored for a while) and refreshes the totals it changes. */
class DeleteTransactionUseCase @Inject constructor(
    private val transactionRepository: TransactionRepository,
    private val refreshDependents: RefreshTransactionDependentsUseCase,
) {
    suspend operator fun invoke(id: String): TransactionResult<Unit> {
        val result = transactionRepository.deleteTransaction(id)
        if (result is Outcome.Success) {
            refreshDependents(setOfNotNull(result.data?.date?.let(YearMonth::from)))
        }
        return result.map { }
    }
}
