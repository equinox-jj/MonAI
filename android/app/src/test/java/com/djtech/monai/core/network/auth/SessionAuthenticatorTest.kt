package com.djtech.monai.core.network.auth

import mockwebserver3.MockResponse
import mockwebserver3.MockWebServer
import okhttp3.OkHttpClient
import okhttp3.Request
import org.junit.After
import org.junit.Assert.assertEquals
import org.junit.Before
import org.junit.Test

class SessionAuthenticatorTest {

    private val server = MockWebServer()
    private val rejectedTokens = mutableListOf<String>()

    private val client = OkHttpClient.Builder()
        .authenticator(SessionAuthenticator { rejectedTokens += it })
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
    fun `401 on an authenticated request ends the session without retrying`() {
        server.enqueue(MockResponse(code = 401))

        val code = execute(
            Request.Builder()
                .url(server.url("/me"))
                .header("Authorization", "Bearer expired")
                .build(),
        )

        assertEquals(401, code)
        assertEquals(listOf("expired"), rejectedTokens)
        assertEquals(1, server.requestCount)
    }

    @Test
    fun `401 on an anonymous request does not end the session`() {
        // Login with a wrong password returns 401 invalid_credentials.
        server.enqueue(MockResponse(code = 401))

        val code = execute(Request.Builder().url(server.url("/auth/login")).build())

        assertEquals(401, code)
        assertEquals(emptyList<String>(), rejectedTokens)
        assertEquals(1, server.requestCount)
    }

    private fun execute(request: Request): Int =
        client.newCall(request).execute().use { it.code }
}
