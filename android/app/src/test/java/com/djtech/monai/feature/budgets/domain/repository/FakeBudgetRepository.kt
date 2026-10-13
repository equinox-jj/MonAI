package com.djtech.monai.feature.budgets.domain.repository

import com.djtech.monai.core.common.result.Outcome
import com.djtech.monai.core.model.Budget
import com.djtech.monai.core.model.BudgetStatus
import com.djtech.monai.feature.budgets.domain.model.BudgetResult
import kotlinx.coroutines.flow.Flow
import kotlinx.coroutines.flow.MutableStateFlow
import kotlinx.coroutines.flow.map
import kotlinx.coroutines.flow.update
import java.time.YearMonth

/**
 * Serves [budgets] as the cache, by month, and records each refreshed, set and deleted month.
 * A successful set or delete changes the cache the way the real repository does.
 */
class FakeBudgetRepository(vararg budgets: Budget) : BudgetRepository {
    val budgets = MutableStateFlow(budgets.associateBy(Budget::month))
    var refreshResult: BudgetResult<Unit> = Outcome.Success(Unit)
    var setResult: BudgetResult<Unit> = Outcome.Success(Unit)
    var deleteResult: BudgetResult<Unit> = Outcome.Success(Unit)
    val refreshedMonths = mutableListOf<YearMonth>()
    val setBudgets = mutableListOf<Pair<YearMonth, Long>>()
    val deletedMonths = mutableListOf<YearMonth>()

    override fun observeBudget(month: YearMonth): Flow<Budget?> = budgets.map { it[month] }

    override suspend fun refreshBudget(month: YearMonth): BudgetResult<Unit> {
        refreshedMonths += month
        return refreshResult
    }

    override suspend fun setBudget(month: YearMonth, limitAmount: Long): BudgetResult<Unit> {
        setBudgets += month to limitAmount
        if (setResult is Outcome.Success) {
            budgets.update { cached ->
                val spent = cached[month]?.spent ?: 0
                val budget = Budget(
                    month = month,
                    limitAmount = limitAmount,
                    spent = spent,
                    remaining = limitAmount - spent,
                    progressPercent = 0.0,
                    status = BudgetStatus.OK,
                )
                cached + (month to budget)
            }
        }
        return setResult
    }

    override suspend fun deleteBudget(month: YearMonth): BudgetResult<Unit> {
        deletedMonths += month
        if (deleteResult is Outcome.Success) budgets.update { it - month }
        return deleteResult
    }
}
