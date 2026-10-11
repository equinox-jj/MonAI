package com.djtech.monai.core.common.format

import org.junit.Assert.assertEquals
import org.junit.Assert.assertNull
import org.junit.Test

class AmountInputTest {

    @Test
    fun `parses raw and formatted input`() {
        assertEquals(35_000L, parseAmount("35000"))
        assertEquals(35_000L, parseAmount("Rp 35.000"))
        assertEquals(0L, parseAmount("0"))
    }

    @Test
    fun `returns null when there are no digits`() {
        assertNull(parseAmount(""))
        assertNull(parseAmount("Rp "))
    }

    @Test
    fun `accepts the max and rejects anything above it`() {
        assertEquals(MAX_AMOUNT, parseAmount("999.999.999.999"))
        assertNull(parseAmount("1.000.000.000.000"))
        assertNull(parseAmount("99999999999999999999999"))
    }

    @Test
    fun `leading zeros do not count toward the max`() {
        assertEquals(5L, parseAmount("0000000000000005"))
    }

    @Test
    fun `appendDigit shifts the value left`() {
        assertEquals(3L, appendDigit(0, 3))
        assertEquals(35L, appendDigit(3, 5))
        assertEquals(350L, appendDigit(35, 0))
    }

    @Test
    fun `appendDigit ignores a digit that would pass the max`() {
        assertEquals(MAX_AMOUNT, appendDigit(MAX_AMOUNT, 9))
        assertEquals(100_000_000_000L, appendDigit(100_000_000_000L, 0))
    }

    @Test(expected = IllegalArgumentException::class)
    fun `appendDigit rejects non-digits`() {
        appendDigit(1, 10)
    }

    @Test
    fun `deleteDigit drops the last digit`() {
        assertEquals(3L, deleteDigit(35))
        assertEquals(0L, deleteDigit(3))
        assertEquals(0L, deleteDigit(0))
    }
}
