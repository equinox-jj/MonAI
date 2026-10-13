package com.djtech.monai.feature.budgets.domain.repository

import com.djtech.monai.core.model.Budget
import com.djtech.monai.feature.budgets.domain.model.BudgetResult
import kotlinx.coroutines.flow.Flow
import java.time.YearMonth

/** Monthly budgets read from the local cache; [refreshBudget] fills it from the API. */
interface BudgetRepository {

    /** [month]'s cached budget; null when none is set or it hasn't been fetched yet. */
    fun observeBudget(month: YearMonth): Flow<Budget?>

    /** Fetches [month]'s budget. A month without one succeeds and clears any cached budget. */
    suspend fun refreshBudget(month: YearMonth): BudgetResult<Unit>

    /** Sets or changes [month]'s limit (rupiah) and caches the budget the server returns. */
    suspend fun setBudget(month: YearMonth, limitAmount: Long): BudgetResult<Unit>

    /** Removes [month]'s budget. One that is already gone counts as removed. */
    suspend fun deleteBudget(month: YearMonth): BudgetResult<Unit>
}
