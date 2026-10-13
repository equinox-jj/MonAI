package com.djtech.monai.feature.budgets.domain.usecase

import com.djtech.monai.core.common.format.MAX_AMOUNT
import com.djtech.monai.core.common.result.Outcome
import com.djtech.monai.feature.budgets.domain.model.BudgetError
import com.djtech.monai.feature.budgets.domain.model.BudgetResult
import com.djtech.monai.feature.budgets.domain.repository.BudgetRepository
import java.time.YearMonth
import javax.inject.Inject

/** Sets or changes [month]'s spending limit; a limit outside 1..[MAX_AMOUNT] fails without a request. */
class SetBudgetUseCase @Inject constructor(private val budgetRepository: BudgetRepository) {

    suspend operator fun invoke(month: YearMonth, limitAmount: Long): BudgetResult<Unit> =
        if (limitAmount in 1..MAX_AMOUNT) {
            budgetRepository.setBudget(month, limitAmount)
        } else {
            Outcome.Failure(BudgetError.InvalidLimit)
        }
}
