package com.djtech.monai.feature.budgets.domain.repository

import com.djtech.monai.core.common.result.Outcome
import com.djtech.monai.core.model.Budget
import com.djtech.monai.feature.budgets.domain.model.BudgetResult
import kotlinx.coroutines.flow.Flow
import kotlinx.coroutines.flow.MutableStateFlow
import kotlinx.coroutines.flow.map
import java.time.YearMonth

/** Serves [budgets] as the cache, by month, and records each refreshed month. */
class FakeBudgetRepository(vararg budgets: Budget) : BudgetRepository {
    val budgets = MutableStateFlow(budgets.associateBy(Budget::month))
    var refreshResult: BudgetResult<Unit> = Outcome.Success(Unit)
    val refreshedMonths = mutableListOf<YearMonth>()

    override fun observeBudget(month: YearMonth): Flow<Budget?> = budgets.map { it[month] }

    override suspend fun refreshBudget(month: YearMonth): BudgetResult<Unit> {
        refreshedMonths += month
        return refreshResult
    }
}
