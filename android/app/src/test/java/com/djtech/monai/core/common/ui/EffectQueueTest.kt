package com.djtech.monai.core.common.ui

import kotlinx.coroutines.flow.take
import kotlinx.coroutines.flow.toList
import kotlinx.coroutines.test.runTest
import org.junit.Assert.assertEquals
import org.junit.Test

class EffectQueueTest {

    @Test
    fun `keeps effects sent before anyone collects, in order`() = runTest {
        val queue = EffectQueue<Int>()

        queue.send(1)
        queue.send(2)
        queue.send(3)

        assertEquals(listOf(1, 2, 3), queue.flow.take(3).toList())
    }

    @Test
    fun `hands each effect to one collector only`() = runTest {
        val queue = EffectQueue<String>()
        queue.send("close")

        assertEquals(listOf("close"), queue.flow.take(1).toList())
        queue.send("message")
        assertEquals(listOf("message"), queue.flow.take(1).toList())
    }
}
