package com.djtech.monai.feature.reports.data.repository

import com.djtech.monai.core.common.log.ErrorLogger
import com.djtech.monai.core.common.log.runLogged
import com.djtech.monai.core.common.result.flatMap
import com.djtech.monai.core.common.result.mapError
import com.djtech.monai.core.common.time.toApiString
import com.djtech.monai.core.database.dao.MonthlyReportDao
import com.djtech.monai.core.database.entity.asEntity
import com.djtech.monai.core.database.entity.asModel
import com.djtech.monai.core.database.entity.categoryEntities
import com.djtech.monai.core.model.MonthlyReport
import com.djtech.monai.core.network.ApiCaller
import com.djtech.monai.core.network.ApiError
import com.djtech.monai.feature.reports.data.mapper.asModel
import com.djtech.monai.feature.reports.data.mapper.toReportError
import com.djtech.monai.feature.reports.data.remote.ReportApiService
import com.djtech.monai.feature.reports.domain.model.ReportError
import com.djtech.monai.feature.reports.domain.model.ReportResult
import com.djtech.monai.feature.reports.domain.repository.ReportRepository
import kotlinx.coroutines.flow.Flow
import kotlinx.coroutines.flow.map
import java.time.YearMonth
import javax.inject.Inject
import javax.inject.Singleton

@Singleton
class ApiReportRepository @Inject constructor(
    private val reportApiService: ReportApiService,
    private val apiCaller: ApiCaller,
    private val monthlyReportDao: MonthlyReportDao,
    private val errorLogger: ErrorLogger,
) : ReportRepository {

    override fun observeMonthlyReport(month: YearMonth): Flow<MonthlyReport?> =
        monthlyReportDao.observe(month).map { it?.asModel() }

    override fun observeCachedExpenseTotals(year: Int): Flow<Map<YearMonth, Long>> =
        monthlyReportDao.observeBetween(YearMonth.of(year, 1), YearMonth.of(year, 12))
            .map { reports -> reports.associate { it.month to it.expenseTotal } }

    // Mapped inside the call, so a value that fails to parse becomes an error, not an exception.
    override suspend fun refreshMonthlyReport(month: YearMonth): ReportResult<Unit> =
        apiCaller.callRaw { reportApiService.getMonthlyReport(month.toApiString()).data.asModel() }
            .mapError(ApiError::toReportError)
            .flatMap { report ->
                errorLogger.runLogged("Caching the monthly report failed", ReportError.Unexpected) {
                    monthlyReportDao.replace(report.asEntity(), report.categoryEntities())
                }
            }
}
