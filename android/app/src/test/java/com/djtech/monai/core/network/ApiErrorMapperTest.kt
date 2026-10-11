package com.djtech.monai.core.network

import kotlinx.serialization.SerializationException
import okhttp3.MediaType.Companion.toMediaType
import okhttp3.ResponseBody.Companion.toResponseBody
import org.junit.Assert.assertEquals
import org.junit.Assert.assertSame
import org.junit.Test
import retrofit2.HttpException
import retrofit2.Response
import java.io.IOException

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

        assertEquals(ApiError.Http(404, "not_found", "Resource not found", emptyList()), error)
    }

    @Test
    fun `falls back to the generic code for the status when the body is not the envelope`() {
        val error = mapper.map(httpException(502, "<html>Bad Gateway</html>"))

        assertEquals(ApiError.Http(502, "internal_error", "", emptyList()), error)
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
    fun `maps an IOException to a network error`() {
        assertSame(ApiError.Network, mapper.map(IOException("timeout")))
    }

    @Test
    fun `maps anything else to an unknown error`() {
        val cause = SerializationException("bad body")

        assertEquals(ApiError.Unknown(cause), mapper.map(cause))
    }

    private fun httpException(status: Int, body: String) = HttpException(
        Response.error<Any>(status, body.toResponseBody("application/json".toMediaType())),
    )
}
