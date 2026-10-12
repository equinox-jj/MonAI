package com.djtech.monai.feature.reports.domain.usecase

import com.djtech.monai.core.model.MonthlyReport
import com.djtech.monai.feature.reports.domain.repository.ReportRepository
import kotlinx.coroutines.flow.Flow
import java.time.YearMonth
import javax.inject.Inject

/** [month]'s cached report; null until it has been fetched. */
class ObserveMonthlyReportUseCase @Inject constructor(private val reportRepository: ReportRepository) {
    operator fun invoke(month: YearMonth): Flow<MonthlyReport?> = reportRepository.observeMonthlyReport(month)
}
