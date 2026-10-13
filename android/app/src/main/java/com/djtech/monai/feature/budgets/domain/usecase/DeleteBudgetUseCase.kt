package com.djtech.monai.feature.budgets.domain.usecase

import com.djtech.monai.feature.budgets.domain.model.BudgetResult
import com.djtech.monai.feature.budgets.domain.repository.BudgetRepository
import java.time.YearMonth
import javax.inject.Inject

/** Removes [month]'s budget. */
class DeleteBudgetUseCase @Inject constructor(private val budgetRepository: BudgetRepository) {
    suspend operator fun invoke(month: YearMonth): BudgetResult<Unit> = budgetRepository.deleteBudget(month)
}
