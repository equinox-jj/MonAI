package com.djtech.monai.core.database

import com.djtech.monai.core.database.dao.MonthlyReportDao
import com.djtech.monai.core.database.entity.MonthlyReportEntity
import com.djtech.monai.core.database.entity.MonthlyReportWithCategories
import com.djtech.monai.core.database.entity.ReportCategoryEntity
import kotlinx.coroutines.flow.Flow
import kotlinx.coroutines.flow.MutableStateFlow
import kotlinx.coroutines.flow.combine
import kotlinx.coroutines.flow.map
import java.time.YearMonth

/** In-memory [MonthlyReportDao]. [replace] is the interface's own default, so it runs on these writes. */
class FakeMonthlyReportDao : MonthlyReportDao {
    private val reports = MutableStateFlow<Map<YearMonth, MonthlyReportEntity>>(emptyMap())
    private val categories = MutableStateFlow<List<ReportCategoryEntity>>(emptyList())

    /** When set, every write throws it, like a database that cannot be written. */
    var failure: Exception? = null

    override fun observe(month: YearMonth): Flow<MonthlyReportWithCategories?> =
        combine(reports, categories) { all, rows ->
            all[month]?.let { report -> MonthlyReportWithCategories(report, rows.filter { it.month == month }) }
        }

    override fun observeBetween(from: YearMonth, to: YearMonth): Flow<List<MonthlyReportEntity>> =
        reports.map { all -> all.values.filter { it.month in from..to }.sortedBy { it.month } }

    override suspend fun upsertReport(report: MonthlyReportEntity) {
        failure?.let { throw it }
        reports.value += report.month to report
    }

    override suspend fun insertCategories(categories: List<ReportCategoryEntity>) {
        failure?.let { throw it }
        this.categories.value += categories
    }

    override suspend fun deleteCategories(month: YearMonth) {
        failure?.let { throw it }
        categories.value = categories.value.filterNot { it.month == month }
    }

    override suspend fun delete(month: YearMonth) {
        failure?.let { throw it }
        reports.value -= month
        deleteCategories(month)
    }
}
