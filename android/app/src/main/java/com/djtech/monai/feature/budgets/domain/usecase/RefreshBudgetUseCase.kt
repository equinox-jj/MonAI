package com.djtech.monai.feature.budgets.domain.usecase

import com.djtech.monai.feature.budgets.domain.model.BudgetResult
import com.djtech.monai.feature.budgets.domain.repository.BudgetRepository
import java.time.YearMonth
import javax.inject.Inject

/** Fetches [month]'s budget into the cache; a month without one clears it. */
class RefreshBudgetUseCase @Inject constructor(private val budgetRepository: BudgetRepository) {
    suspend operator fun invoke(month: YearMonth): BudgetResult<Unit> = budgetRepository.refreshBudget(month)
}
