package com.djtech.monai.core.database.dao

import androidx.room3.Dao
import androidx.room3.Query
import androidx.room3.Upsert
import com.djtech.monai.core.database.entity.BudgetEntity
import kotlinx.coroutines.flow.Flow
import java.time.YearMonth

@Dao
interface BudgetDao {

    @Query("SELECT * FROM budgets WHERE month = :month")
    fun observe(month: YearMonth): Flow<BudgetEntity?>

    @Upsert
    suspend fun upsert(budget: BudgetEntity)

    @Query("DELETE FROM budgets WHERE month = :month")
    suspend fun delete(month: YearMonth)
}
