package com.djtech.monai.core.network.logging

import mockwebserver3.MockResponse
import mockwebserver3.MockWebServer
import okhttp3.Headers.Companion.headersOf
import okhttp3.OkHttpClient
import okhttp3.Request
import org.junit.After
import org.junit.Assert.assertEquals
import org.junit.Assert.assertTrue
import org.junit.Before
import org.junit.Test

class ResponseBodyLoggingInterceptorTest {

    private val server = MockWebServer()
    private val logs = mutableListOf<String>()

    private val client = OkHttpClient.Builder()
        .addInterceptor(ResponseBodyLoggingInterceptor { logs += it })
        .build()

    @Before
    fun setUp() {
        server.start()
    }

    @After
    fun tearDown() {
        server.close()
    }

    @Test
    fun `logs the status, url and json body of the response`() {
        server.enqueue(jsonResponse(code = 200, body = """{"data":{"id":"w1"}}"""))

        execute("/wallets")

        assertEquals(1, logs.size)
        assertTrue(logs.single().contains("<-- 200 GET ${server.url("/wallets")}"))
        assertTrue(logs.single().contains("""{"data":{"id":"w1"}}"""))
    }

    @Test
    fun `logs error response bodies`() {
        server.enqueue(jsonResponse(code = 422, body = """{"error":{"code":"validation_failed"}}"""))

        execute("/transactions")

        assertTrue(logs.single().contains("<-- 422"))
        assertTrue(logs.single().contains("validation_failed"))
    }

    @Test
    fun `leaves the body readable for the caller`() {
        server.enqueue(jsonResponse(code = 200, body = """{"data":[]}"""))

        val body = client.newCall(request("/budgets")).execute().use { it.body.string() }

        assertEquals("""{"data":[]}""", body)
    }

    @Test
    fun `omits binary bodies`() {
        server.enqueue(
            MockResponse(
                code = 200,
                headers = headersOf("Content-Type", "image/jpeg"),
                body = "ÿØÿ",
            ),
        )

        execute("/receipt.jpg")

        assertTrue(logs.single().contains("binary"))
        assertTrue(!logs.single().contains("ÿØ"))
    }

    private fun jsonResponse(code: Int, body: String) = MockResponse(
        code = code,
        headers = headersOf("Content-Type", "application/json"),
        body = body,
    )

    private fun request(path: String) = Request.Builder().url(server.url(path)).build()

    private fun execute(path: String) {
        client.newCall(request(path)).execute().close()
    }
}
