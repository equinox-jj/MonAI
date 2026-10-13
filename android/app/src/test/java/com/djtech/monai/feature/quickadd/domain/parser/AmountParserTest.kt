package com.djtech.monai.feature.quickadd.domain.parser

import org.junit.Assert.assertEquals
import org.junit.Assert.assertTrue
import org.junit.Test

class AmountParserTest {

    private fun amounts(text: String) = AmountParser.findAll(text).map { it.amount }

    @Test
    fun `reads rupiah suffixes`() {
        assertEquals(listOf(35_000L), amounts("makan 35rb"))
        assertEquals(listOf(35_000L), amounts("makan 35k"))
        assertEquals(listOf(35_000L), amounts("makan 35 ribu"))
        assertEquals(listOf(2_000_000L), amounts("gaji 2 juta"))
        assertEquals(listOf(3_000_000L), amounts("laptop 3jt"))
    }

    @Test
    fun `a dot or comma between groups of three is a thousands separator`() {
        assertEquals(listOf(1_500L), amounts("parkir 1.500"))
        assertEquals(listOf(35_000L), amounts("kopi 35.000"))
        assertEquals(listOf(2_500_000L), amounts("sewa 2.500.000"))
        assertEquals(listOf(35_000L), amounts("kopi 35,000"))
    }

    @Test
    fun `a decimal before a suffix scales`() {
        assertEquals(listOf(1_500_000L), amounts("hp 1,5jt"))
        assertEquals(listOf(2_500_000L), amounts("hp 2.5 juta"))
        assertEquals(listOf(12_500L), amounts("roti 12,5rb"))
    }

    @Test
    fun `reads the rp prefix as part of the amount`() {
        val match = AmountParser.findAll("kopi rp 35.000").single()

        assertEquals(35_000L, match.amount)
        assertEquals("rp 35.000", "kopi rp 35.000".substring(match.range))
    }

    @Test
    fun `reads slang amounts`() {
        assertEquals(listOf(500L), amounts("parkir gopek"))
        assertEquals(listOf(1_000L), amounts("permen seceng"))
        assertEquals(listOf(5_000L), amounts("parkir goceng"))
        assertEquals(listOf(10_000L), amounts("es teh ceban"))
    }

    @Test
    fun `explicit amounts are confident and bare small numbers are not`() {
        assertTrue(AmountParser.findAll("kopi 25rb").single().confidence >= 0.9)
        assertTrue(AmountParser.findAll("kopi 25000").single().confidence >= 0.7)
        assertTrue(AmountParser.findAll("kopi 25").single().confidence < 0.7)
    }

    @Test
    fun `finds every amount in order`() {
        assertEquals(listOf(25_000L, 5_000L), amounts("kopi 25rb sama parkir 5rb"))
    }

    @Test
    fun `ignores numbers inside words and amounts past the limit`() {
        assertEquals(emptyList<Long>(), amounts("beli h2o"))
        assertEquals(emptyList<Long>(), amounts("9999999999999"))
    }
}
