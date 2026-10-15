package com.djtech.monai.core.common.format

import androidx.compose.ui.text.AnnotatedString
import org.junit.Assert.assertEquals
import org.junit.Test

class RupiahVisualTransformationTest {

    private fun transform(digits: String) = RupiahVisualTransformation.filter(AnnotatedString(digits))

    @Test
    fun `shows digits grouped after Rp`() {
        assertEquals("Rp 5", transform("5").text.text)
        assertEquals("Rp 1.250.000", transform("1250000").text.text)
    }

    @Test
    fun `empty text stays empty so the placeholder shows`() {
        assertEquals("", transform("").text.text)
    }

    @Test
    fun `caret after the last digit maps to the end of the shown text`() {
        val mapping = transform("1250000").offsetMapping
        assertEquals("Rp 1.250.000".length, mapping.originalToTransformed(7))
        assertEquals(7, mapping.transformedToOriginal("Rp 1.250.000".length))
    }

    @Test
    fun `caret skips the prefix and the dots`() {
        val mapping = transform("1250000").offsetMapping
        assertEquals(3, mapping.originalToTransformed(0))
        assertEquals(4, mapping.originalToTransformed(1)) // "Rp 1|.250.000"
        assertEquals(6, mapping.originalToTransformed(2)) // "Rp 1.2|50.000"
        assertEquals(0, mapping.transformedToOriginal(1))
        assertEquals(1, mapping.transformedToOriginal(5)) // "Rp 1.|250.000"
        assertEquals(4, mapping.transformedToOriginal(9)) // "Rp 1.250.|000"
    }
}
