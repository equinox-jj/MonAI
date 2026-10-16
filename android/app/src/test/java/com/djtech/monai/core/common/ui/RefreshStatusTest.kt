package com.djtech.monai.core.common.ui

import org.junit.Assert.assertEquals
import org.junit.Assert.assertFalse
import org.junit.Assert.assertNull
import org.junit.Assert.assertTrue
import org.junit.Test

class RefreshStatusTest {

    private val idle = RefreshStatus<String>()

    @Test
    fun `shows the skeleton with nothing cached until the first refresh answers`() {
        assertTrue(idle.isLoading(hasCache = false))
        assertTrue(idle.started().isLoading(hasCache = false))
        assertFalse(idle.started().finished(null).isLoading(hasCache = false))
        assertFalse(idle.started().finished("offline").isLoading(hasCache = false))
    }

    @Test
    fun `never shows the skeleton over cached content`() {
        assertFalse(idle.isLoading(hasCache = true))
        assertFalse(idle.started().isLoading(hasCache = true))
    }

    @Test
    fun `shows the skeleton again while a retry runs with nothing cached`() {
        val retrying = idle.started().finished("offline").started()

        assertTrue(retrying.isLoading(hasCache = false))
        assertNull(retrying.loadFailure(hasCache = false))
    }

    @Test
    fun `reports a failure only with nothing cached`() {
        val failed = idle.started().finished("offline")

        assertEquals("offline", failed.loadFailure(hasCache = false))
        assertNull(failed.loadFailure(hasCache = true))
        assertNull(idle.started().finished(null).loadFailure(hasCache = false))
    }

    @Test
    fun `spins for a refresh the user asked for, over cached content`() {
        assertTrue(idle.started(userInitiated = true).isRefreshing(hasCache = true))
        assertFalse(idle.started(userInitiated = false).isRefreshing(hasCache = true))
        assertFalse(idle.started(userInitiated = true).isRefreshing(hasCache = false))
        assertFalse(idle.started(userInitiated = true).finished(null).isRefreshing(hasCache = true))
    }
}
