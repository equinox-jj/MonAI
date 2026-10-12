package com.djtech.monai.core.network

import com.djtech.monai.core.common.log.ErrorLogger
import com.djtech.monai.core.common.result.Outcome
import com.djtech.monai.core.network.model.ApiResponse
import javax.inject.Inject
import kotlin.coroutines.cancellation.CancellationException

/**
 * Runs a Retrofit call and returns an [ApiResult] instead of throwing.
 *
 * ```
 * apiCaller.call { meApi.getMe() }.map { it.toDomain() }
 * ```
 */
class ApiCaller @Inject constructor(
    private val errorMapper: ApiErrorMapper,
    private val errorLogger: ErrorLogger,
) {

    /** Unwraps `data` from the success envelope. */
    suspend fun <T> call(block: suspend () -> ApiResponse<T>): ApiResult<T> =
        callRaw { block().data }

    /** For responses whose envelope the caller needs, e.g. [com.djtech.monai.core.network.model.PagedResponse]. */
    suspend fun <T> callRaw(block: suspend () -> T): ApiResult<T> = try {
        Outcome.Success(block())
    } catch (e: CancellationException) {
        throw e
    } catch (e: Exception) {
        val error = errorMapper.map(e)
        // Offline and HTTP errors are expected; anything else is a bug or a contract mismatch.
        if (error is ApiError.Unknown) errorLogger.log("Unexpected API failure", e)
        Outcome.Failure(error)
    }
}
