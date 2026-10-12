package com.djtech.monai.core.database

import org.junit.Assert.assertEquals
import org.junit.Assert.assertNull
import org.junit.Test

class FtsQueryTest {

    @Test
    fun `prefix matches every term`() {
        assertEquals("kopi*", toFtsMatchQuery("kopi"))
        assertEquals("kopi* ken*", toFtsMatchQuery("  kopi   ken "))
    }

    @Test
    fun `returns null when there is nothing to search`() {
        assertNull(toFtsMatchQuery(""))
        assertNull(toFtsMatchQuery("   "))
        assertNull(toFtsMatchQuery("\"* - ()"))
    }

    @Test
    fun `strips FTS syntax so user input cannot break the query`() {
        assertEquals("kopi* susu*", toFtsMatchQuery("\"kopi\" -susu*"))
        assertEquals("a* b*", toFtsMatchQuery("a:(b)"))
    }

    @Test
    fun `drops operator keywords`() {
        assertEquals("kopi* teh*", toFtsMatchQuery("kopi OR teh"))
        assertEquals("kopi*", toFtsMatchQuery("NOT kopi NEAR"))
    }

    @Test
    fun `keeps letters outside ASCII`() {
        assertEquals("café*", toFtsMatchQuery("café"))
    }
}
