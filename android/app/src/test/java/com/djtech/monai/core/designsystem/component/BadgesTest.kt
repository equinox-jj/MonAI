package com.djtech.monai.core.designsystem.component

import org.junit.Assert.assertEquals
import org.junit.Assert.assertNotEquals
import org.junit.Test

class BadgesTest {

    private val photo = "https://files.monai.id/expense-private/avatars/u1/3f2a.webp"

    @Test
    fun `two signatures of the same photo share a cache key`() {
        val first = "$photo?X-Amz-Date=20261016T010000Z&X-Amz-Signature=aaa"
        val refreshed = "$photo?X-Amz-Date=20261016T010500Z&X-Amz-Signature=bbb"

        assertEquals(avatarCacheKey(first), avatarCacheKey(refreshed))
    }

    @Test
    fun `a new photo gets a new cache key`() {
        val replaced = "https://files.monai.id/expense-private/avatars/u1/9c1d.webp?X-Amz-Signature=aaa"

        assertNotEquals(avatarCacheKey("$photo?X-Amz-Signature=aaa"), avatarCacheKey(replaced))
    }

    @Test
    fun `a url without a query is its own key`() {
        assertEquals(photo, avatarCacheKey(photo))
    }
}
