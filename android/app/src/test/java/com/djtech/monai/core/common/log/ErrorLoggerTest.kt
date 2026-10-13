package com.djtech.monai.core.common.log

import com.djtech.monai.core.common.result.Outcome
import org.junit.Assert.assertEquals
import org.junit.Assert.assertTrue
import org.junit.Test
import java.io.IOException
import kotlin.coroutines.cancellation.CancellationException

class ErrorLoggerTest {

    private val logger = RecordingErrorLogger()

    @Test
    fun `runLogged returns the block's value without logging`() {
        val outcome = logger.runLogged("Caching failed", "unexpected") { 42 }

        assertEquals(Outcome.Success(42), outcome)
        assertTrue(logger.errors.isEmpty())
    }

    @Test
    fun `runLogged logs an exception and returns the given error`() {
        val error = IOException("disk full")

        val outcome = logger.runLogged<Int, String>("Caching failed", "unexpected") { throw error }

        assertEquals(Outcome.Failure("unexpected"), outcome)
        assertEquals(listOf(error), logger.errors)
    }

    @Test
    fun `runLogged rethrows cancellation without logging`() {
        try {
            logger.runLogged("Caching failed", "unexpected") { throw CancellationException("cancelled") }
        } catch (_: CancellationException) {
            assertTrue(logger.errors.isEmpty())
            return
        }
        throw AssertionError("cancellation was swallowed")
    }
}
