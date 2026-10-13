package com.djtech.monai.feature.quickadd.domain.parser

import org.junit.Assert.assertEquals
import org.junit.Test

class PhraseSplitterTest {

    private fun split(text: String) = PhraseSplitter.split(text) { AmountParser.findAll(it).isNotEmpty() }

    @Test
    fun `one part per amount`() {
        assertEquals(listOf("kopi 25rb", "parkir 5rb kmrn"), split("kopi 25rb sama parkir 5rb kmrn"))
        assertEquals(listOf("kopi 25rb", "roti 10rb"), split("kopi 25rb, roti 10rb"))
    }

    @Test
    fun `a part without an amount joins its neighbour`() {
        assertEquals(listOf("kopi 25rb kemarin", "roti 10rb"), split("kopi 25rb, kemarin; roti 10rb"))
        assertEquals(listOf("kemarin kopi 25rb", "roti 10rb"), split("kemarin, kopi 25rb, roti 10rb"))
    }

    @Test
    fun `a phrase with one amount is not split`() {
        assertEquals(listOf("nasi dan ayam 30rb"), split("nasi dan ayam 30rb"))
        assertEquals(listOf("hp 1,5jt"), split("hp 1,5jt"))
    }
}
