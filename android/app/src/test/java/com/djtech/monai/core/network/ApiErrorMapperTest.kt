package com.djtech.monai.core.network

import kotlinx.serialization.SerializationException
import okhttp3.Headers
import okhttp3.MediaType.Companion.toMediaType
import okhttp3.Protocol
import okhttp3.Request
import okhttp3.ResponseBody.Companion.toResponseBody
import org.junit.Assert.assertEquals
import org.junit.Assert.assertNull
import org.junit.Assert.assertSame
import org.junit.Test
import retrofit2.HttpException
import retrofit2.Response
import java.io.IOException
import kotlin.time.Duration.Companion.seconds

class ApiErrorMapperTest {

    private val mapper = ApiErrorMapper(NetworkJson)

    @Test
    fun `maps the error envelope to an Http error with its fields`() {
        val body = """
            {
              "success": false,
              "message": "Some fields are invalid",
              "data": null,
              "error": {
                "code": "validation_failed",
                "fields": [
                  {"field": "amount", "code": "min", "message": "must be greater than 0", "params": {"min": 1}}
                ]
              }
            }
        """.trimIndent()

        val error = mapper.map(httpException(422, body))

        assertEquals(
            ApiError.Http(
                status = 422,
                code = "validation_failed",
                message = "Some fields are invalid",
                fields = listOf(
                    FieldError(
                        field = "amount",
                        code = "min",
                        message = "must be greater than 0",
                        params = mapOf("min" to "1"),
                    ),
                ),
            ),
            error,
        )
    }

    @Test
    fun `maps an error without fields to an empty field list`() {
        val body = """
            {"success": false, "message": "Resource not found", "data": null, "error": {"code": "not_found"}}
        """.trimIndent()

        val error = mapper.map(httpException(404, body))

        assertEquals(
            ApiError.Http(
                404,
                "not_found",
                "Resource not found",
                emptyList(),
            ),
            error,
        )
    }

    @Test
    fun `falls back to the generic code for the status when the body is not the envelope`() {
        val error = mapper.map(httpException(502, "<html>Bad Gateway</html>"))

        assertEquals(
            ApiError.Http(
                502,
                "internal_error",
                "",
                emptyList(),
            ),
            error,
        )
    }

    @Test
    fun `falls back to the generic code for common 4xx statuses`() {
        val codes = mapOf(
            400 to "invalid_request",
            401 to "unauthorized",
            403 to "forbidden",
            404 to "not_found",
            409 to "conflict",
            422 to "validation_failed",
            429 to "rate_limited",
            503 to "service_unavailable",
            418 to "unknown",
        )

        codes.forEach { (status, code) ->
            assertEquals(code, (mapper.map(httpException(status, "")) as ApiError.Http).code)
        }
    }

    @Test
    fun `reads how long to wait from a Retry-After header in seconds`() {
        val error = mapper.map(httpException(429, "", Headers.headersOf("Retry-After", "120"))) as ApiError.Http

        assertEquals(120.seconds, error.retryAfter)
    }

    @Test
    fun `a missing or unreadable Retry-After gives no wait`() {
        // The backend only sends seconds; the HTTP-date form is not read.
        val headers = listOf(
            Headers.headersOf(),
            Headers.headersOf("Retry-After", "Wed, 21 Oct 2026 07:28:00 GMT"),
            Headers.headersOf("Retry-After", "-5"),
        )

        headers.forEach { headers ->
            assertNull("$headers", (mapper.map(httpException(429, "", headers)) as ApiError.Http).retryAfter)
        }
    }

    @Test
    fun `maps an IOException to a network error`() {
        assertSame(ApiError.Network, mapper.map(IOException("timeout")))
    }

    @Test
    fun `maps anything else to an unknown error`() {
        val cause = SerializationException("bad body")

        assertEquals(ApiError.Unknown(cause), mapper.map(cause))
    }

    private fun httpException(status: Int, body: String, headers: Headers = Headers.headersOf()) = HttpException(
        Response.error<Any>(
            body.toResponseBody("application/json".toMediaType()),
            okhttp3.Response.Builder()
                .code(status)
                .message("Error")
                .protocol(Protocol.HTTP_1_1)
                .request(Request.Builder().url("http://localhost/").build())
                .headers(headers)
                .build(),
        ),
    )
}
