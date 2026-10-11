package com.djtech.monai.core.network

import com.djtech.monai.core.network.model.ErrorResponse
import kotlinx.serialization.SerializationException
import kotlinx.serialization.json.Json
import kotlinx.serialization.json.JsonPrimitive
import retrofit2.HttpException
import java.io.IOException
import javax.inject.Inject

/** Turns whatever a Retrofit call threw into an [ApiError]. */
class ApiErrorMapper @Inject constructor(
    private val json: Json,
) {
    fun map(throwable: Throwable): ApiError = when (throwable) {
        is HttpException -> fromHttp(throwable)
        is IOException -> ApiError.Network
        else -> ApiError.Unknown(throwable)
    }

    private fun fromHttp(e: HttpException): ApiError.Http {
        val status = e.code()
        val body = parseBody(e) ?: return ApiError.Http(
            status,
            fallbackCode(status),
            "",
            emptyList(),
        )

        return ApiError.Http(
            status = status,
            code = body.error.code,
            message = body.message,
            fields = body.error.fields.map { field ->
                FieldError(
                    field = field.field,
                    code = field.code,
                    message = field.message,
                    params = field.params.orEmpty().mapValues { (_, value) ->
                        (value as? JsonPrimitive)?.content ?: value.toString()
                    },
                )
            },
        )
    }

    // A proxy or load balancer can answer with HTML or an empty body.
    private fun parseBody(e: HttpException): ErrorResponse? {
        val raw = e.response()?.errorBody()?.string().orEmpty()
        if (raw.isBlank()) return null
        return try {
            json.decodeFromString<ErrorResponse>(raw)
        } catch (_: SerializationException) {
            null
        } catch (_: IllegalArgumentException) {
            null
        }
    }

    // Mirrors the generic codes the backend uses for each status.
    private fun fallbackCode(status: Int): String = when (status) {
        400 -> "invalid_request"
        401 -> "unauthorized"
        403 -> "forbidden"
        404 -> "not_found"
        409 -> "conflict"
        422 -> "validation_failed"
        429 -> "rate_limited"
        503 -> "service_unavailable"
        in 500..599 -> "internal_error"
        else -> "unknown"
    }
}
