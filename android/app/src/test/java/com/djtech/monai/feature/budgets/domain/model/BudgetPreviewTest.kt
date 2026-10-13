package com.djtech.monai.feature.budgets.domain.model

import com.djtech.monai.core.model.BudgetStatus
import org.junit.Assert.assertEquals
import org.junit.Assert.assertNull
import org.junit.Test

class BudgetPreviewTest {

    @Test
    fun `under 80 percent is on track`() {
        val preview = BudgetPreview.of(spent = 790_000, limit = 1_000_000)

        val expected = BudgetPreview(
            spent = 790_000,
            limit = 1_000_000,
            remaining = 210_000,
            percent = 79,
            status = BudgetStatus.OK,
        )
        assertEquals(expected, preview)
    }

    @Test
    fun `80 percent is a warning`() {
        assertEquals(BudgetStatus.WARNING, BudgetPreview.of(spent = 800_000, limit = 1_000_000)?.status)
    }

    @Test
    fun `exactly 100 percent is still a warning`() {
        val preview = BudgetPreview.of(spent = 1_000_000, limit = 1_000_000)

        assertEquals(BudgetStatus.WARNING, preview?.status)
        assertEquals(0L, preview?.remaining)
    }

    @Test
    fun `above 100 percent is exceeded with a negative remainder`() {
        val preview = BudgetPreview.of(spent = 1_010_000, limit = 1_000_000)

        assertEquals(BudgetStatus.EXCEEDED, preview?.status)
        assertEquals(101, preview?.percent)
        assertEquals(-10_000L, preview?.remaining)
    }

    @Test
    fun `percent is rounded down`() {
        assertEquals(80, BudgetPreview.of(spent = 2_415_000, limit = 3_000_000)?.percent)
    }

    @Test
    fun `no preview without a limit`() {
        assertNull(BudgetPreview.of(spent = 100, limit = 0))
    }
}
