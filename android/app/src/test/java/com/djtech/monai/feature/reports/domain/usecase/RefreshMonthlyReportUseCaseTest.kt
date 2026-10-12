package com.djtech.monai.feature.reports.domain.usecase

import com.djtech.monai.core.common.result.Outcome
import com.djtech.monai.core.model.OCTOBER
import com.djtech.monai.feature.reports.domain.model.ReportError
import com.djtech.monai.feature.reports.domain.repository.FakeReportRepository
import kotlinx.coroutines.test.runTest
import org.junit.Assert.assertEquals
import org.junit.Test

class RefreshMonthlyReportUseCaseTest {

    private val repository = FakeReportRepository()
    private val refreshReport = RefreshMonthlyReportUseCase(repository)

    @Test
    fun `refreshes the month through the repository and returns its result`() = runTest {
        repository.refreshResult = Outcome.Failure(ReportError.Network)

        assertEquals(Outcome.Failure(ReportError.Network), refreshReport(OCTOBER))
        assertEquals(listOf(OCTOBER), repository.refreshedMonths)
    }
}
