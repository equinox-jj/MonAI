package com.djtech.monai.core.common.format

import org.junit.Assert.assertEquals
import org.junit.Test

class RupiahTest {

    @Test
    fun `formats with dot grouping and a space after Rp`() {
        assertEquals("Rp 0", formatRupiah(0))
        assertEquals("Rp 950", formatRupiah(950))
        assertEquals("Rp 35.000", formatRupiah(35_000))
        assertEquals("Rp 8.500.000", formatRupiah(8_500_000))
        assertEquals("Rp 999.999.999.999", formatRupiah(999_999_999_999))
    }

    @Test
    fun `negative amounts get a minus sign`() {
        assertEquals("−Rp 120.000", formatRupiah(-120_000))
    }

    @Test
    fun `signed formatting uses the given sign, not the amount's`() {
        assertEquals("−Rp 35.000", formatRupiahSigned(35_000, MoneySign.Negative))
        assertEquals("+Rp 8.500.000", formatRupiahSigned(8_500_000, MoneySign.Positive))
        assertEquals("Rp 500.000", formatRupiahSigned(500_000, MoneySign.None))
        assertEquals("−Rp 35.000", formatRupiahSigned(-35_000, MoneySign.Negative))
    }

    @Test
    fun `thousands has no currency prefix`() {
        assertEquals("0", formatThousands(0))
        assertEquals("35.000", formatThousands(35_000))
        assertEquals("1.234.567", formatThousands(1_234_567))
    }

    @Test
    fun `compact keeps small amounts whole`() {
        assertEquals("Rp 0", formatRupiahCompact(0))
        assertEquals("Rp 999", formatRupiahCompact(999))
    }

    @Test
    fun `compact switches unit at each boundary`() {
        assertEquals("Rp 1 rb", formatRupiahCompact(1_000))
        assertEquals("Rp 35 rb", formatRupiahCompact(35_000))
        assertEquals("Rp 999,9 rb", formatRupiahCompact(999_999))
        assertEquals("Rp 1 jt", formatRupiahCompact(1_000_000))
        assertEquals("Rp 3 jt", formatRupiahCompact(3_000_000))
        assertEquals("Rp 1,5 jt", formatRupiahCompact(1_500_000))
        assertEquals("Rp 2 M", formatRupiahCompact(2_000_000_000))
        assertEquals("Rp 1 T", formatRupiahCompact(1_000_000_000_000))
    }

    @Test
    fun `compact truncates instead of rounding up into the next unit`() {
        assertEquals("Rp 1,2 jt", formatRupiahCompact(1_299_999))
    }

    @Test
    fun `compact keeps the minus sign`() {
        assertEquals("−Rp 1,5 jt", formatRupiahCompact(-1_500_000))
    }
}
