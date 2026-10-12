package com.djtech.monai.core.database

import org.junit.Assert.assertEquals
import org.junit.Assert.assertNull
import org.junit.Test
import java.time.Instant
import java.time.LocalDate
import java.time.YearMonth

class ConvertersTest {

    private val converters = Converters()

    @Test
    fun `round trips an instant with millisecond precision`() {
        val instant = Instant.parse("2026-10-12T03:15:30.123Z")

        assertEquals(instant, converters.toInstant(converters.fromInstant(instant)))
    }

    @Test
    fun `stores dates as sortable ISO text`() {
        val date = LocalDate.of(2026, 1, 5)

        assertEquals("2026-01-05", converters.fromLocalDate(date))
        assertEquals(date, converters.toLocalDate("2026-01-05"))
    }

    @Test
    fun `stores months as yyyy-MM`() {
        val month = YearMonth.of(2026, 3)

        assertEquals("2026-03", converters.fromYearMonth(month))
        assertEquals(month, converters.toYearMonth("2026-03"))
    }

    @Test
    fun `round trips string lists as JSON`() {
        val aliases = listOf("gopay", "gpay", "go-pay")

        assertEquals(aliases, converters.toStringList(converters.fromStringList(aliases)))
        val empty = converters.toStringList(converters.fromStringList(emptyList()))
        assertEquals(emptyList<String>(), empty)
    }

    @Test
    fun `passes nulls through`() {
        assertNull(converters.fromInstant(null))
        assertNull(converters.toInstant(null))
        assertNull(converters.fromLocalDate(null))
        assertNull(converters.toLocalDate(null))
        assertNull(converters.fromYearMonth(null))
        assertNull(converters.toYearMonth(null))
    }
}
