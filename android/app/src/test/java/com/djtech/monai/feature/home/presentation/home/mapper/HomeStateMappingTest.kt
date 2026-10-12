package com.djtech.monai.feature.home.presentation.home.mapper

import org.junit.Assert.assertEquals
import org.junit.Test

class HomeStateMappingTest {

    @Test
    fun `a short first word is the monogram`() {
        assertEquals("BCA", walletMonogram("BCA Tabungan"))
        assertEquals("OVO", walletMonogram("ovo"))
    }

    @Test
    fun `otherwise the capitals of a single word`() {
        assertEquals("GP", walletMonogram("GoPay"))
        assertEquals("SP", walletMonogram("ShopeePay"))
    }

    @Test
    fun `otherwise the first letters of the first two words`() {
        assertEquals("BJ", walletMonogram("Bank Jago"))
        assertEquals("CA", walletMonogram("Cash"))
        assertEquals("", walletMonogram("  "))
    }
}
