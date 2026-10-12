package com.djtech.monai.core.database.dao

import androidx.room3.Dao
import androidx.room3.Insert
import androidx.room3.Query
import androidx.room3.Transaction
import androidx.room3.Upsert
import com.djtech.monai.core.database.entity.MonthlyReportEntity
import com.djtech.monai.core.database.entity.MonthlyReportWithCategories
import com.djtech.monai.core.database.entity.ReportCategoryEntity
import kotlinx.coroutines.flow.Flow
import java.time.YearMonth

@Dao
interface MonthlyReportDao {

    @Transaction
    @Query("SELECT * FROM monthly_reports WHERE month = :month")
    fun observe(month: YearMonth): Flow<MonthlyReportWithCategories?>

    /** Reports cached for the months from [from] to [to], without their breakdowns. */
    @Query("SELECT * FROM monthly_reports WHERE month BETWEEN :from AND :to ORDER BY month")
    fun observeBetween(from: YearMonth, to: YearMonth): Flow<List<MonthlyReportEntity>>

    @Upsert
    suspend fun upsertReport(report: MonthlyReportEntity)

    @Insert
    suspend fun insertCategories(categories: List<ReportCategoryEntity>)

    @Query("DELETE FROM report_categories WHERE month = :month")
    suspend fun deleteCategories(month: YearMonth)

    @Query("DELETE FROM monthly_reports WHERE month = :month")
    suspend fun delete(month: YearMonth)

    /** Replaces a month's report and its whole breakdown. */
    @Transaction
    suspend fun replace(report: MonthlyReportEntity, categories: List<ReportCategoryEntity>) {
        upsertReport(report)
        deleteCategories(report.month)
        insertCategories(categories)
    }
}
