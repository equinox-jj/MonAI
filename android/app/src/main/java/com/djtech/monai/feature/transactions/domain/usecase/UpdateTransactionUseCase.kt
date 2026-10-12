package com.djtech.monai.feature.transactions.domain.usecase

import com.djtech.monai.core.common.result.Outcome
import com.djtech.monai.core.common.time.AppClock
import com.djtech.monai.core.model.Transaction
import com.djtech.monai.feature.transactions.domain.model.TransactionError
import com.djtech.monai.feature.transactions.domain.model.TransactionInput
import com.djtech.monai.feature.transactions.domain.model.TransactionResult
import com.djtech.monai.feature.transactions.domain.repository.TransactionRepository
import com.djtech.monai.feature.transactions.domain.validation.normalized
import com.djtech.monai.feature.transactions.domain.validation.validate
import kotlinx.coroutines.flow.first
import java.time.YearMonth
import javax.inject.Inject

/**
 * Validates and saves an edit, then refreshes the totals it changes: those of the month it left
 * too, when the date moved to another month.
 */
class UpdateTransactionUseCase @Inject constructor(
    private val transactionRepository: TransactionRepository,
    private val refreshDependents: RefreshTransactionDependentsUseCase,
    private val clock: AppClock,
) {
    suspend operator fun invoke(id: String, input: TransactionInput): TransactionResult<Transaction> {
        val normalized = input.normalized()
        val errors = normalized.validate(clock.today())
        if (errors.isNotEmpty()) return Outcome.Failure(TransactionError.InvalidFields(errors))
        val before = transactionRepository.observeTransaction(id).first()
        val result = transactionRepository.updateTransaction(id, normalized)
        if (result is Outcome.Success) {
            refreshDependents(setOfNotNull(before?.date, result.data.date).map(YearMonth::from).toSet())
        }
        return result
    }
}
