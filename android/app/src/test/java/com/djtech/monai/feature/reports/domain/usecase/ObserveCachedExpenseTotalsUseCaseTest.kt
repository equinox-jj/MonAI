package com.djtech.monai.feature.reports.domain.usecase

import com.djtech.monai.core.model.OCTOBER
import com.djtech.monai.core.model.report
import com.djtech.monai.feature.reports.domain.repository.FakeReportRepository
import kotlinx.coroutines.flow.first
import kotlinx.coroutines.test.runTest
import org.junit.Assert.assertEquals
import org.junit.Test

class ObserveCachedExpenseTotalsUseCaseTest {

    @Test
    fun `emits the expense total of each cached month of the year`() = runTest {
        val repository = FakeReportRepository(report(expense = 2_415_000), report(month = OCTOBER.minusYears(1)))

        assertEquals(mapOf(OCTOBER to 2_415_000L), ObserveCachedExpenseTotalsUseCase(repository)(2026).first())
    }
}
