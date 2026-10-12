package com.djtech.monai.core.database

import com.djtech.monai.core.database.dao.BudgetDao
import com.djtech.monai.core.database.entity.BudgetEntity
import kotlinx.coroutines.flow.Flow
import kotlinx.coroutines.flow.MutableStateFlow
import kotlinx.coroutines.flow.map
import java.time.YearMonth

class FakeBudgetDao(initial: List<BudgetEntity> = emptyList()) : BudgetDao {
    private val rows = MutableStateFlow(initial.associateBy { it.month })

    /** When set, every write throws it, like a database that cannot be written. */
    var failure: Exception? = null

    val budgets: List<BudgetEntity> get() = rows.value.values.sortedBy { it.month }

    override fun observe(month: YearMonth): Flow<BudgetEntity?> = rows.map { it[month] }

    override suspend fun upsert(budget: BudgetEntity) {
        failure?.let { throw it }
        rows.value += budget.month to budget
    }

    override suspend fun delete(month: YearMonth) {
        failure?.let { throw it }
        rows.value -= month
    }
}
