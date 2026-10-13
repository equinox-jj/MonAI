package com.djtech.monai.feature.quickadd.domain.parser

import org.junit.Assert.assertEquals
import org.junit.Assert.assertNull
import org.junit.Test
import java.time.LocalDate

class DateParserTest {

    // Saturday 10 October 2026.
    private val today = LocalDate.of(2026, 10, 10)

    private fun date(text: String) = DateParser.find(text, today)?.date

    @Test
    fun `reads today and yesterday in both languages`() {
        assertEquals(today, date("kopi hari ini"))
        assertEquals(today, date("tadi pagi sarapan"))
        assertEquals(today, date("lunch today"))
        assertEquals(today.minusDays(1), date("makan kemarin"))
        assertEquals(today.minusDays(1), date("makan kmrn"))
        assertEquals(today.minusDays(1), date("dinner yesterday"))
        assertEquals(today.minusDays(2), date("kemarin lusa"))
        assertEquals(today.minusDays(3), date("3 hari lalu"))
    }

    @Test
    fun `a weekday means the latest one, before today when it says last`() {
        assertEquals(LocalDate.of(2026, 10, 5), date("bensin senin lalu"))
        assertEquals(LocalDate.of(2026, 10, 9), date("nonton jumat"))
        assertEquals(LocalDate.of(2026, 10, 5), date("fuel last monday"))
        assertEquals(LocalDate.of(2026, 10, 3), date("sabtu lalu"))
        assertEquals(today, date("sabtu"))
    }

    @Test
    fun `a day of the month is the latest one that is not in the future`() {
        assertEquals(LocalDate.of(2026, 10, 5), date("listrik tgl 5"))
        assertEquals(LocalDate.of(2026, 9, 25), date("sewa tanggal 25"))
        assertEquals(LocalDate.of(2026, 9, 3), date("bayar 3/9"))
        assertEquals(LocalDate.of(2026, 8, 17), date("17 agustus"))
        assertEquals(LocalDate.of(2025, 12, 24), date("24 des"))
    }

    @Test
    fun `reports the matched characters`() {
        val match = DateParser.find("makan siang kemarin", today)!!

        assertEquals("kemarin", "makan siang kemarin".substring(match.range))
    }

    @Test
    fun `no date words means no match`() {
        assertNull(date("makan siang 35rb"))
        assertNull(date("tgl 31 feb"))
    }
}
