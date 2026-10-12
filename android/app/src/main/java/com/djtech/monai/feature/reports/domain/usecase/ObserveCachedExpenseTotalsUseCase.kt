package com.djtech.monai.feature.reports.domain.usecase

import com.djtech.monai.feature.reports.domain.repository.ReportRepository
import kotlinx.coroutines.flow.Flow
import java.time.YearMonth
import javax.inject.Inject

/** What was spent in each month of [year] whose report is cached. Never fetches. */
class ObserveCachedExpenseTotalsUseCase @Inject constructor(private val reportRepository: ReportRepository) {
    operator fun invoke(year: Int): Flow<Map<YearMonth, Long>> = reportRepository.observeCachedExpenseTotals(year)
}
