package com.djtech.monai.feature.reports.domain.repository

import com.djtech.monai.core.model.MonthlyReport
import com.djtech.monai.feature.reports.domain.model.ReportResult
import kotlinx.coroutines.flow.Flow
import java.time.YearMonth

/** Monthly reports read from the local cache; [refreshMonthlyReport] fills it from the API. */
interface ReportRepository {

    /** The cached report for [month]; null until it has been fetched once. */
    fun observeMonthlyReport(month: YearMonth): Flow<MonthlyReport?>

    /** Fetches [month]'s report and replaces the cached one, breakdown included. */
    suspend fun refreshMonthlyReport(month: YearMonth): ReportResult<Unit>
}
