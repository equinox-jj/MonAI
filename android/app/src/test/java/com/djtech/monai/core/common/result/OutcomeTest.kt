package com.djtech.monai.core.common.result

import org.junit.Assert.assertEquals
import org.junit.Assert.fail
import org.junit.Test

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
}
