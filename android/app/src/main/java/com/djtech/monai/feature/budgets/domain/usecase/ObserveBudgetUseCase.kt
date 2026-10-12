package com.djtech.monai.feature.budgets.domain.usecase

import com.djtech.monai.core.model.Budget
import com.djtech.monai.feature.budgets.domain.repository.BudgetRepository
import kotlinx.coroutines.flow.Flow
import java.time.YearMonth
import javax.inject.Inject

/** [month]'s cached budget; null when it has none or it hasn't been fetched. */
class ObserveBudgetUseCase @Inject constructor(private val budgetRepository: BudgetRepository) {
    operator fun invoke(month: YearMonth): Flow<Budget?> = budgetRepository.observeBudget(month)
}
