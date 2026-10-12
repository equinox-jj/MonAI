package com.djtech.monai.feature.reports.domain.usecase

import com.djtech.monai.core.model.OCTOBER
import com.djtech.monai.core.model.report
import com.djtech.monai.feature.reports.domain.repository.FakeReportRepository
import kotlinx.coroutines.flow.first
import kotlinx.coroutines.test.runTest
import org.junit.Assert.assertEquals
import org.junit.Assert.assertNull
import org.junit.Test

class ObserveMonthlyReportUseCaseTest {

    private val observeReport = ObserveMonthlyReportUseCase(FakeReportRepository(report()))

    @Test
    fun `emits the month's cached report, or null before it is fetched`() = runTest {
        assertEquals(report(), observeReport(OCTOBER).first())
        assertNull(observeReport(OCTOBER.plusMonths(1)).first())
    }
}
