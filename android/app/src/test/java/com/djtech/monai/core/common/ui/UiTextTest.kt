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

    @Test
    fun `plurals compare by id, count and args`() {
        assertEquals(UiText.Plural(1, 2, 2), UiText.Plural(1, 2, 2))
        assertEquals(UiText.Plural(1, 2, 2).hashCode(), UiText.Plural(1, 2, 2).hashCode())
        assertNotEquals(UiText.Plural(1, 2, 2), UiText.Plural(1, 3, 2))
        assertNotEquals(UiText.Plural(1, 2, 2), UiText.Plural(1, 2, 3))
    }
}
