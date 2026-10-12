package com.djtech.monai.core.network

import kotlin.time.Duration

/** Why an API call failed. Repositories map these to their own domain errors. */
sealed interface ApiError {

    /**
     * The server answered with an error status. [code] is the API's stable
     * machine-readable code (`validation_failed`, `wallet_has_transactions`, …);
     * [message] is the server's English fallback and may be empty.
     */
    data class Http(
        val status: Int,
        val code: String,
        val message: String,
        val fields: List<FieldError>,
        val retryAfter: Duration? = null,
    ) : ApiError

    /** No response: offline, DNS failure, timeout, connection reset. */
    data object Network : ApiError

    /** Anything else, e.g. a success body that could not be parsed. */
    data class Unknown(val cause: Throwable) : ApiError
}

/** One invalid field of a `validation_failed` or `conflict` error. */
data class FieldError(
    val field: String,
    val code: String,
    val message: String,
    val params: Map<String, String> = emptyMap(),
)
