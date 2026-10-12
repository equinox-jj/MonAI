package com.djtech.monai.feature.reports.domain.repository

import com.djtech.monai.core.common.result.Outcome
import com.djtech.monai.core.model.MonthlyReport
import com.djtech.monai.feature.reports.domain.model.ReportResult
import kotlinx.coroutines.flow.Flow
import kotlinx.coroutines.flow.MutableStateFlow
import kotlinx.coroutines.flow.map
import java.time.YearMonth

/** Serves [reports] as the cache, by month, and records each refreshed month. */
class FakeReportRepository(vararg reports: MonthlyReport) : ReportRepository {
    val reports = MutableStateFlow(reports.associateBy(MonthlyReport::month))
    var refreshResult: ReportResult<Unit> = Outcome.Success(Unit)
    val refreshedMonths = mutableListOf<YearMonth>()

    override fun observeMonthlyReport(month: YearMonth): Flow<MonthlyReport?> = reports.map { it[month] }

    override fun observeCachedExpenseTotals(year: Int): Flow<Map<YearMonth, Long>> = reports.map { all ->
        all.filterKeys { it.year == year }.mapValues { it.value.expenseTotal }
    }

    override suspend fun refreshMonthlyReport(month: YearMonth): ReportResult<Unit> {
        refreshedMonths += month
        return refreshResult
    }
}
