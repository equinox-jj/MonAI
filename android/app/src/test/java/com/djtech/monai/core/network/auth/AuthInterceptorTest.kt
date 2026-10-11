package com.djtech.monai.core.network.auth

import mockwebserver3.MockResponse
import mockwebserver3.MockWebServer
import okhttp3.OkHttpClient
import okhttp3.Request
import org.junit.After
import org.junit.Assert.assertEquals
import org.junit.Assert.assertNull
import org.junit.Before
import org.junit.Test

class AuthInterceptorTest {

    private val server = MockWebServer()
    private var token: String? = null

    private val client = OkHttpClient.Builder()
        .addInterceptor(AuthInterceptor { token })
        .build()

    @Before
    fun setUp() {
        server.start()
        server.enqueue(MockResponse(code = 200))
    }

    @After
    fun tearDown() {
        server.close()
    }

    @Test
    fun `adds bearer header when a token is stored`() {
        token = "abc.def.ghi"

        execute(Request.Builder().url(server.url("/me")).build())

        assertEquals("Bearer abc.def.ghi", server.takeRequest().headers["Authorization"])
    }

    @Test
    fun `sends no header when there is no token`() {
        token = null

        execute(Request.Builder().url(server.url("/me")).build())

        assertNull(server.takeRequest().headers["Authorization"])
    }

    @Test
    fun `sends no header when the token is blank`() {
        token = "  "

        execute(Request.Builder().url(server.url("/me")).build())

        assertNull(server.takeRequest().headers["Authorization"])
    }

    @Test
    fun `keeps an Authorization header the request already has`() {
        token = "stored"

        execute(
            Request.Builder()
                .url(server.url("/me"))
                .header("Authorization", "Bearer explicit")
                .build(),
        )

        assertEquals("Bearer explicit", server.takeRequest().headers["Authorization"])
    }

    private fun execute(request: Request) {
        client.newCall(request).execute().close()
    }
}
