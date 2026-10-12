package com.djtech.monai.feature.reports.data.repository

import com.djtech.monai.core.common.log.ErrorLogger
import com.djtech.monai.core.common.result.Outcome
import com.djtech.monai.core.common.time.toApiString
import com.djtech.monai.core.database.dao.MonthlyReportDao
import com.djtech.monai.core.database.entity.asEntity
import com.djtech.monai.core.database.entity.asModel
import com.djtech.monai.core.database.entity.categoryEntities
import com.djtech.monai.core.model.MonthlyReport
import com.djtech.monai.core.network.ApiCaller
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
import kotlin.coroutines.cancellation.CancellationException

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

    override suspend fun refreshMonthlyReport(month: YearMonth): ReportResult<Unit> {
        // Mapped inside the call, so a value that fails to parse becomes an error, not an exception.
        val result = apiCaller.callRaw { reportApiService.getMonthlyReport(month.toApiString()).data.asModel() }
        return when (result) {
            is Outcome.Success -> cache(result.data)
            is Outcome.Failure -> Outcome.Failure(result.error.toReportError())
        }
    }

    // ApiCaller covers network failures; this keeps a failed cache write from throwing too.
    private suspend fun cache(report: MonthlyReport): ReportResult<Unit> = try {
        monthlyReportDao.replace(report.asEntity(), report.categoryEntities())
        Outcome.Success(Unit)
    } catch (e: CancellationException) {
        throw e
    } catch (e: Exception) {
        errorLogger.log("Caching the monthly report failed", e)
        Outcome.Failure(ReportError.Unexpected)
    }
}
