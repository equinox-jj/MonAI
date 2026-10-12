package com.djtech.monai.core.common.ui

import org.junit.Assert.assertEquals
import org.junit.Assert.assertNotEquals
import org.junit.Test

class UiTextTest {

    @Test
    fun `resources with the same id and args are equal`() {
        assertEquals(UiText.Resource(1, 8, "a"), UiText.Resource(1, 8, "a"))
        assertEquals(UiText.Resource(1, 8, "a").hashCode(), UiText.Resource(1, 8, "a").hashCode())
    }

    @Test
    fun `resources differing in id or args are not equal`() {
        assertNotEquals(UiText.Resource(1), UiText.Resource(2))
        assertNotEquals(UiText.Resource(1, 8), UiText.Resource(1, 9))
    }
}
