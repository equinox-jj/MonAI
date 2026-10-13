package com.djtech.monai.feature.reports.presentation.report.mapper

import com.djtech.monai.core.model.OCTOBER
import com.djtech.monai.core.model.breakdown
import com.djtech.monai.core.model.report
import com.djtech.monai.feature.reports.presentation.report.model.CategoryChange
import com.djtech.monai.feature.reports.presentation.report.model.ExpenseComparison
import com.djtech.monai.feature.reports.presentation.report.model.ReportTotals
import com.djtech.monai.feature.reports.presentation.report.model.Trend
import org.junit.Assert.assertEquals
import org.junit.Assert.assertNull
import org.junit.Test

class ReportStateMappingTest {

    @Test
    fun `totals carry the month's figures and a rounded comparison with the month before`() {
        val totals = report(income = 8_500_000, expense = 2_415_000, expenseChangePercent = -10.4).toTotals()

        assertEquals(
            ReportTotals(
                income = 8_500_000,
                expense = 2_415_000,
                net = 6_085_000,
                comparison = ExpenseComparison(10, Trend.LESS, OCTOBER.minusMonths(1)),
            ),
            totals,
        )
    }

    @Test
    fun `more spending than the month before is a rise`() {
        assertEquals(Trend.MORE, report(expenseChangePercent = 11.0).toTotals().comparison?.trend)
    }

    @Test
    fun `a change that rounds to zero reads as the same`() {
        val comparison = report(expenseChangePercent = -0.4).toTotals().comparison

        assertEquals(0, comparison?.percent)
        assertEquals(Trend.SAME, comparison?.trend)
    }

    @Test
    fun `no comparison when the month before had no expenses`() {
        assertNull(report(expenseChangePercent = null).toTotals().comparison)
    }

    @Test
    fun `a category row keeps its figures and its change against the month before`() {
        val row = breakdown("food", amount = 865_000, share = 35.8).copy(changePercent = -5.2).toRow()

        assertEquals("food", row.categoryId)
        assertEquals(865_000L, row.amount)
        assertEquals(35.8, row.sharePercent, 0.0)
        assertEquals(CategoryChange(5, Trend.LESS), row.change)
    }

    @Test
    fun `a category new this month has no change`() {
        assertNull(breakdown("food", amount = 865_000, share = 100.0).toRow().change)
    }
}
