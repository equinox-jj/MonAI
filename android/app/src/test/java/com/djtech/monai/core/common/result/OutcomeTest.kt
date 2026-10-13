package com.djtech.monai.core.common.result

import kotlinx.coroutines.delay
import kotlinx.coroutines.test.runTest
import org.junit.Assert.assertEquals
import org.junit.Assert.assertSame
import org.junit.Assert.fail
import org.junit.Test
import java.io.IOException
import kotlin.coroutines.cancellation.CancellationException

class OutcomeTest {

    @Test
    fun `map transforms the data of a success`() {
        val outcome: Outcome<Int, String> = Outcome.Success(2)

        assertEquals(Outcome.Success(4), outcome.map { it * 2 })
    }

    @Test
    fun `map leaves a failure untouched without running the transform`() {
        val outcome: Outcome<Int, String> = Outcome.Failure("boom")

        assertEquals(Outcome.Failure("boom"), outcome.map<Int, String, Int> { fail("transform ran"); it })
    }

    @Test
    fun `mapError transforms the error of a failure`() {
        val outcome: Outcome<Int, String> = Outcome.Failure("boom")

        assertEquals(Outcome.Failure(4), outcome.mapError { it.length })
    }

    @Test
    fun `mapError leaves a success untouched without running the transform`() {
        val outcome: Outcome<Int, String> = Outcome.Success(2)

        assertEquals(Outcome.Success(2), outcome.mapError<Int, String, Int> { fail("transform ran"); 0 })
    }

    @Test
    fun `flatMap chains a success into the next outcome`() {
        val outcome: Outcome<Int, String> = Outcome.Success(2)

        assertEquals(Outcome.Failure("odd"), outcome.flatMap { Outcome.Failure("odd") })
        assertEquals(Outcome.Success(4), outcome.flatMap { Outcome.Success(it * 2) })
    }

    @Test
    fun `flatMap leaves a failure untouched without running the transform`() {
        val outcome: Outcome<Int, String> = Outcome.Failure("boom")

        assertEquals(
            Outcome.Failure("boom"),
            outcome.flatMap<Int, String, Int> { fail("transform ran"); Outcome.Success(it) },
        )
    }

    @Test
    fun `getOrElse returns the data of a success without running the fallback`() {
        val outcome: Outcome<Int, String> = Outcome.Success(2)

        assertEquals(2, outcome.getOrElse { fail("fallback ran"); 0 })
    }

    @Test
    fun `getOrElse returns the fallback for a failure's error`() {
        val outcome: Outcome<Int, String> = Outcome.Failure("boom")

        assertEquals(4, outcome.getOrElse { it.length })
    }

    @Test
    fun `catching returns the block's value as a success`() = runTest {
        // A suspend call inside the block: repositories wrap DAO writes this way.
        val outcome = catching {
            delay(1)
            42
        }

        assertEquals(Outcome.Success(42), outcome)
    }

    @Test
    fun `catching returns a thrown exception as a failure`() {
        val error = IOException("disk full")

        val outcome = catching<Int> { throw error }

        assertSame(error, (outcome as Outcome.Failure<*>).error)
    }

    @Test(expected = CancellationException::class)
    fun `catching rethrows cancellation`() {
        catching { throw CancellationException("cancelled") }
    }
}
