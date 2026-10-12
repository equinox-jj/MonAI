package com.djtech.monai.feature.reports.domain.usecase

import com.djtech.monai.feature.reports.domain.model.ReportResult
import com.djtech.monai.feature.reports.domain.repository.ReportRepository
import java.time.YearMonth
import javax.inject.Inject

/** Fetches [month]'s report, breakdown included, into the cache. */
class RefreshMonthlyReportUseCase @Inject constructor(private val reportRepository: ReportRepository) {
    suspend operator fun invoke(month: YearMonth): ReportResult<Unit> = reportRepository.refreshMonthlyReport(month)
}
