package com.djtech.monai.core.common.time

import org.junit.Assert.assertEquals
import org.junit.Assert.assertFalse
import org.junit.Assert.assertNull
import org.junit.Assert.assertTrue
import org.junit.Test
import java.time.Instant
import java.time.LocalDate
import java.time.YearMonth

class YearMonthsTest {

    @Test
    fun `round-trips the API month format`() {
        assertEquals("2026-03", YearMonth.of(2026, 3).toApiString())
        assertEquals(YearMonth.of(2026, 3), "2026-03".toYearMonthOrNull())
    }

    @Test
    fun `invalid month strings return null`() {
        assertNull("".toYearMonthOrNull())
        assertNull("2026-13".toYearMonthOrNull())
        assertNull("2026-3".toYearMonthOrNull())
        assertNull("2026-03-01".toYearMonthOrNull())
    }

    @Test
    fun `future check uses today in the clock's zone`() {
        // 17:30 UTC on 31 Oct is 00:30 on 1 Nov in Jakarta.
        val clock = FixedAppClock(Instant.parse("2026-10-31T17:30:00Z"))

        assertFalse(LocalDate.of(2026, 11, 1).isFutureIn(clock))
        assertFalse(LocalDate.of(2026, 10, 31).isFutureIn(clock))
        assertTrue(LocalDate.of(2026, 11, 2).isFutureIn(clock))
    }
}
