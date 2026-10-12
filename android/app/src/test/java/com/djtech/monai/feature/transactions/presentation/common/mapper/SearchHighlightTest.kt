package com.djtech.monai.feature.transactions.presentation.common.mapper

import androidx.compose.ui.graphics.Color
import org.junit.Assert.assertEquals
import org.junit.Assert.assertFalse
import org.junit.Assert.assertTrue
import org.junit.Test

class SearchHighlightTest {

    @Test
    fun `keeps the whole text and marks every match of every word, ignoring case`() {
        val text = "Kopi susu dan kopi pagi".highlighted("kopi pagi", Color.Yellow)

        assertEquals("Kopi susu dan kopi pagi", text.text)
        assertEquals(listOf(0..3, 14..17, 19..22), text.spanStyles.map { it.start until it.end })
    }

    @Test
    fun `no query or no match leaves the text plain`() {
        assertEquals(0, "Kopi susu".highlighted(null, Color.Yellow).spanStyles.size)
        assertEquals(0, "Kopi susu".highlighted("teh", Color.Yellow).spanStyles.size)
    }

    @Test
    fun `matchesSearch looks for any word of the query`() {
        assertTrue("Warung Kopi Pak Min".matchesSearch("pagi kopi"))
        assertFalse("Warung Kopi".matchesSearch("teh"))
    }
}
