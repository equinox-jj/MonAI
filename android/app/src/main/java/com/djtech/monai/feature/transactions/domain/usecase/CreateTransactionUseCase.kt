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
import java.time.YearMonth
import javax.inject.Inject

/** Validates [TransactionInput] on the device, saves it, then refreshes the totals it changes. */
class CreateTransactionUseCase @Inject constructor(
    private val transactionRepository: TransactionRepository,
    private val refreshDependents: RefreshTransactionDependentsUseCase,
    private val clock: AppClock,
) {
    suspend operator fun invoke(input: TransactionInput): TransactionResult<Transaction> {
        val normalized = input.normalized()
        val errors = normalized.validate(clock.today())
        if (errors.isNotEmpty()) return Outcome.Failure(TransactionError.InvalidFields(errors))
        val result = transactionRepository.createTransaction(normalized)
        if (result is Outcome.Success) refreshDependents(setOf(YearMonth.from(result.data.date)))
        return result
    }
}
