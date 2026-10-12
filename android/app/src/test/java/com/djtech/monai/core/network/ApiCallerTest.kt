package com.djtech.monai.core.network

import com.djtech.monai.core.common.log.RecordingErrorLogger
import com.djtech.monai.core.common.result.Outcome
import com.djtech.monai.core.network.model.ApiResponse
import kotlinx.coroutines.test.runTest
import okhttp3.MediaType.Companion.toMediaType
import okhttp3.ResponseBody.Companion.toResponseBody
import org.junit.Assert.assertEquals
import org.junit.Assert.assertTrue
import org.junit.Test
import retrofit2.HttpException
import retrofit2.Response
import java.io.IOException
import kotlin.coroutines.cancellation.CancellationException

class ApiCallerTest {

    private val errorLogger = RecordingErrorLogger()
    private val caller = ApiCaller(ApiErrorMapper(NetworkJson), errorLogger)

    @Test
    fun `returns the data of a successful call`() = runTest {
        val result = caller.call { ApiResponse(success = true, message = "OK", data = 42) }

        assertEquals(Outcome.Success(42), result)
    }

    @Test
    fun `returns the mapped error of a failed call`() = runTest {
        val body = """{"success":false,"message":"Too many requests","data":null,"error":{"code":"rate_limited"}}"""

        val result = caller.call<Int> {
            throw HttpException(Response.error<Any>(429, body.toResponseBody("application/json".toMediaType())))
        }

        assertEquals(
            Outcome.Failure(
                ApiError.Http(
                    429,
                    "rate_limited",
                    "Too many requests",
                    emptyList(),
                ),
            ),
            result,
        )
    }

    @Test
    fun `returns a network error when the connection fails`() = runTest {
        val result = caller.call<Int> { throw IOException("no route") }

        assertEquals(Outcome.Failure(ApiError.Network), result)
    }

    @Test
    fun `an unexpected failure is logged with its cause`() = runTest {
        val cause = IllegalStateException("bad payload")

        val result = caller.call<Int> { throw cause }

        assertEquals(Outcome.Failure(ApiError.Unknown(cause)), result)
        assertEquals(listOf(cause), errorLogger.errors)
    }

    @Test
    fun `expected failures are not logged`() = runTest {
        caller.call<Int> { throw IOException("offline") }
        caller.call<Int> {
            throw HttpException(Response.error<Any>(404, "".toResponseBody("application/json".toMediaType())))
        }

        assertTrue(errorLogger.errors.isEmpty())
    }

    @Test(expected = CancellationException::class)
    fun `rethrows cancellation`() = runTest {
        caller.call<Int> { throw CancellationException("cancelled") }
    }
}
